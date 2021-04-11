local vim = vim

return function(a)
  -- build matcher and pass on to 'term.open'
  local output_format = a.output_format or "{}"
  local default_matcher = "fzf -m --bind 'ctrl-x:execute(echo split " .. output_format .. ")+abort,enter:execute(echo edit " .. output_format .. ")+abort,esc:abort' --preview "
  local default_preview = "bat --color=always -n {}"
  local delimiter = ""
  if a.delimiter ~= nil then
    delimiter = " -d '" .. a.delimiter .. "'"
  end
  local full_default_matcher = default_matcher .. "'" .. (a.preview or default_preview) .. "'" .. delimiter
  local matcher = full_default_matcher or a.matcher
  return require'oneterm.term'.open({
    cmd = a.cmd,
    matcher = matcher,
  })
end
