local vim = vim

function getopts()
    -- Window geometry
    local editor_width = vim.api.nvim_get_option('columns')
    local editor_height = vim.api.nvim_get_option('lines')
    local margin_top = vim.g.oneterm_margin_top or {[false] = 0.75}
    local margin_left = vim.g.oneterm_margin_left or {[false] = 0.5}
    local width = vim.g.oneterm_width or {[false] = 0.5}
    local height = vim.g.oneterm_height or {[false] = 0.5}
    local win_width = math.floor(editor_width * width[false])
    local win_height = math.floor(editor_height * height[false])
    local margin_top = math.floor((editor_height - win_height) * margin_top[false] * 2)
    local margin_left = math.floor((editor_width - win_width) * margin_left[false] * 2)
    local opt = {
      relative = 'editor',
      row = margin_top,
      col = margin_left,
      width = win_width,
      height = win_height,
      style = 'minimal'
    }
    for k,v in pairs(vim.g.oneterm_options or {}) do
      opt[k] = v
    end
    return opt
end

function gettmp()
  local tmp = "/tmp"
  if vim.fn.has("win32") == 1 then
    tmp = vim.env.TEMP or "/temp"
  end
  return tmp
end
function unpack_lsp(a)
  local items
  if a.type == "symbols" then
    items = vim.lsp.util.symbols_to_items(a.res.result, 0)
  else
    items = vim.lsp.util.locations_to_items(a.res.result, 0)
  end
  return items
end

function lsp(a)
  local params = vim.lsp.util.make_position_params()
  params.query = ""
  params.context = {includeDeclaration = true}
  local timeout = 10000
  local symbols = vim.lsp.buf_request_sync(0, a.query, params, timeout)
  local return_value = ""
  for _, res in pairs(symbols) do
    local valid, items = pcall(unpack_lsp,
        {res = res, type = a.type})
    if not valid then
      print("LSP Error. ", items)
      items = {}
    end
    for _, symbol in pairs(items) do
    if not string.match(symbol.text, "<Anonymous>$") then
      	return_value = return_value .. symbol.filename .. " " .. symbol.lnum .. " " .. symbol.text .. "\n"
      end
    end
  end
  return return_value
end

function init_yank()
  return vim.api.nvim_exec([[
    augroup Oneterm
      au!
      au TextYankPost * redir! >> ]] .. gettmp() .. [[/onetermyanks | echo v:event.regcontents[0] | redir end
    augroup END
  ]], true)
end

function build_ignore_rg(t)
  local res = ""
  for _,f in pairs(t or {}) do
    res = res .. " --ignore-file <(echo '" .. f .. "')"
  end
  return res
end

function build_ignore_ag(t)
  local res = ""
  for _,f in pairs(t or {}) do
    res = res .. " -p <(echo '" .. f .. "')"
  end
  return res

end

return {
  getopts = getopts,
  gettmp = gettmp,
  lsp = lsp,
  init_yank = init_yank,
  build_ignore_ag = build_ignore_ag,
  build_ignore_rg = build_ignore_rg
}
