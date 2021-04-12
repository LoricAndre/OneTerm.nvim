local vim = vim

function getopts()
    -- Window geometry
    local editor_width = vim.api.nvim_get_option('columns')
    local editor_height = vim.api.nvim_get_option('lines')
    local win_width = math.floor(vim.g.fzterm_width or editor_width * (vim.g.fzterm_width_ratio or 0.75))
    local win_height = math.floor(vim.g.fzterm_height or editor_height * (vim.g.fzterm_height_ratio or 0.5))
    local margin_top = math.floor((editor_height - win_height) * (vim.g.fzterm_margin_top or 0.25) * 2)
    local margin_left = math.floor((editor_width - win_width) * (vim.g.fzterm_margin_left or 0.25) * 2)
    local opt = {
      relative = 'editor',
      row = margin_top,
      col = margin_left,
      width = win_width,
      height = win_height,
      style = 'minimal'
    }
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
      print("res", return_value)
      if not string.match(symbol.text, "<Anonymous>$") then
      	return_value = return_value .. symbol.filename .. " " .. symbol.lnum .. " " .. symbol.text .. "\n"
      end
    end
  end
  return return_value
end

return {
  getopts = getopts,
  gettmp = gettmp,
  lsp = lsp
}
