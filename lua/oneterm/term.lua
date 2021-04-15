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
  local win = vim.api.nvim_open_win(buf, true, opt)
  local buf = a.buf
  if a.buf == nil or not vim.api.nvim_buf_is_valid(a.buf) then
    buf = vim.api.nvim_create_buf(true, true)
    if a.persist then
      vim.g.oneterm_term_buf = buf
    end
    vim.cmd(term_cmd)
  end
  vim.cmd(":start") -- Enter insert mode
  local close_cmd = string.format(":au TermClose <buffer> :lua require'oneterm.term'.close{win=%d, buf=%d, persist=%s}", win, buf, a.persist) -- pass window and buffer handles
  vim.cmd(close_cmd)
end
function close(a)
  if vim.api.nvim_win_is_valid(a.win) then
    vim.api.nvim_win_close(a.win, true)
  end
  if (not a.persist) and vim.api.nvim_buf_is_valid(a.buf) then
    vim.api.nvim_buf_delete(a.buf, {force = true})
  end
  local tmp = utils.gettmp()
  vim.defer_fn(function() return vim.cmd(":source " .. tmp .. "/oneterm") end, 10)
end

return {
  open = open,
  close = close
}
