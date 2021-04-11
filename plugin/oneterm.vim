function! Compl(ArgLead, CmdLine, CursorPos)
  return "files\n 
        \git_files\n
        \files_or_git_files\n
        \ag\n
        \rg\n
        \references\n
        \symbols
        \"
endfunction

com! -nargs=1 -complete=custom,Compl OneTerm lua require'oneterm'["<args>"]()
