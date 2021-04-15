local vim = vim
local utils = require'oneterm.utils'

function open(a)
  local opt = utils.getopts()
  local tmp = utils.gettmp()
  local cmd = a.cmd or ""
  if cmd ~= "" then
    cmd = cmd .. " | "
  end
  -- create terminal
  local term_cmd = ":term " .. cmd .. a.matcher .. " | tee " .. tmp .. "/oneterm"
  local buf = a.buf or vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opt)
  persist = a.persist or false
  print(persist)
  if persist then
    print(buf, " will be persistant")
    vim.g.oneterm_term_buf = buf
  end
  vim.cmd(term_cmd)
  vim.cmd(":start") -- Enter insert mode
  local close_cmd = string.format(":au TermClose <buffer> :lua require'oneterm.term'.close{win=%d, buf=%d, persist=%s}", win, buf, persist) -- pass window and buffer handles
  vim.cmd(close_cmd)
end
function close(a)
  vim.api.nvim_win_close(a.win, true)
  if not a.persist and vim.api.nvim_buf_is_valid(a.buf) then
    print("deleting buf n°", a.buf)
    vim.api.nvim_buf_delete(a.buf, {force = true})
  end
  local tmp = utils.gettmp()
  vim.defer_fn(function() return vim.cmd(":source " .. tmp .. "/oneterm") end, 10)
end

return {
  open = open,
  close = close
}
