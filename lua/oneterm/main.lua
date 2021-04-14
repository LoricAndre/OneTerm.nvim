local vim = vim

return function(a)
  -- build matcher and pass on to 'term.open'
  local output_format = a.output_format or "{}"
  local default_matcher = "fzf --ansi -m --bind 'ctrl-x:execute(echo split " .. output_format 
    .. ")+abort,enter:execute(echo edit " .. output_format 
    .. ")+abort,esc:abort,ctrl-v:execute(echo vsplit " .. output_format 
    .. ")+abort,ctrl-t:execute(echo tabnew " .. output_format .. ")+abort'"
  if vim.g.oneterm_fzf_prompt then
    default_matcher = default_matcher .. " --preview '" .. vim.g.oneterm_fzf_prompt .. "'"
  end
  local default_preview = "bat --color=always -n {}"
  local delimiter = ""
  if a.delimiter ~= nil then
    delimiter = " -d '" .. a.delimiter .. "'"
  end
  local full_default_matcher = default_matcher .. "'" .. (a.preview or default_preview) .. "'" .. delimiter
  local matcher = a.matcher or full_default_matcher
  local cmd = a.cmd
  if type(cmd) == "function" then
    local tmp = require'oneterm.utils'.gettmp()
    local f = io.open(tmp .. "/onetermcmd", "w")
    f:write(a.cmd())
    f:close()
    cmd = "cat " .. tmp .. "/onetermcmd"
  end
  return require'oneterm.term'.open({
    cmd = cmd,
    matcher = matcher,
  })
end
