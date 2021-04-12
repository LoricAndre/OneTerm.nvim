local vim = vim
local main = require 'oneterm.main'


function files()
  return main {
    cmd = "rg --files --hidden ."
  }
end

function git_files()
  return main {
    cmd = "git ls-files"
  }
end

function buffers()
  return main {
    cmd = function()
      return vim.api.nvim_exec("ls", true)
    end,
    preview = 'bat --color=always -r{-1}: $(echo {-3} | tr -d \")',
    output_format = '#{1}'
  }
end

function ag()
  return main {
    cmd = "ag --nobreak --noheading '.+' .",
    preview = 'ag --color -n -C 8 -Q -- {-1} {1}',
    delimiter = ':',
    output_format = '+{2} {1}'
  }
end

function rg()
  return main {
    cmd = "rg --hidden -n .",
    preview = 'rg -C 10 --color=always -F -- {-1} {1}',
    delimiter = ":",
    output_format = "+{2} {1}"
  }
end

function commits()
  return main {
    cmd = "git log --pretty=oneline",
    preview = "git show --pretty='\\%Cred\\%H\\%n\\%Cblue\\%an\\%n\\%Cgreen\\%s' {1}",
    output_format = ""
  }
end

function files_or_git_files()
  if vim.fn.isdirectory('.git') == 1 then
    return require'oneterm'.git_files()
  else
    return require'oneterm'.files()
  end
end

function references()
  return main {
    cmd = function()
      return require'oneterm.utils'.lsp {
      	  query = 'textDocument/references',
	  type = 'locations'
	}
    end,
    preview = "bat --highlight-line {2} -r{2}: {1} --color=always"
  }
end

function symbols()
  return main {
    cmd = function()
      return require'oneterm.utils'.lsp {
          query = 'textDocument/documentSymbol',
	  type = 'symbols'
	}
    end,
    preview = "bat --highlight-line {2} -r{2}: {1} --color=always"
  }
end

function ws_symbols()
  return main {
    cmd = function()
      return require'oneterm.utils'.lsp {
          query = 'workspace/symbol',
	  type = 'symbols'
	}
    end,
    preview = "bat --highlight-line {2} -r{2}: {1} --color=always"
  }
end

return {
  files = files,
  git_files = git_files,
  buffers = buffers,
  ag = ag,
  rg = rg,
  commits = commits,
  files_or_git_files = files_or_git_files,
  references = references,
  symbols = symbols,
  ws_symbols = ws_symbols
}
