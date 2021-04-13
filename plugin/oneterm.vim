function! Compl(ArgLead, CmdLine, CursorPos)
  return "files\n 
        \git_files\n
        \files_or_git_files\n
        \buffers\n
        \lines\n
        \blines\n
        \ag\n
        \rg\n
        \commits\n
        \references\n
        \symbols\n
        \ws_symbols\n
        \git\n
        \ranger
        \"
endfunction

function! Oneterm_cmd(...)
  if a:0 > 0
    call luaeval("require'oneterm'['" . a:1 . "']()")
  else
    lua require'oneterm'.default()
  endif
endfunction


com! -nargs=? -complete=custom,Compl OneTerm call Oneterm_cmd(<f-args>)
