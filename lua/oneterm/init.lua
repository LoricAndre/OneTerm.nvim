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
    preview = 'bat --color=always -r{-1}: $(echo {-3} | tr -d \\")',
    output_format = '\\\\#{1}'
  }
end

function lines()
  return main {
    cmd = function()
      lines = ""
      for _,buf in pairs(vim.api.nvim_list_bufs()) do
        file = vim.fn.expand("#" .. buf)
        for nr,line in pairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
          lines = lines .. file .. ":" .. nr .. ":" .. line .. "\n"
        end
      end
      return lines
    end,
    preview = 'bat --color=always -r{2}: ${1}',
    delimiter = ':',
    output_format = '+{2} {1}'
  }
end

function blines()
  return main {
    cmd = function()
      lines = ""
      for nr,line in pairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        lines = lines .. nr .. ":" .. line .. "\n"
      end
    end,
    preview = 'bat --color=always -r{2}: ${1}',
    delimiter = ':',
    output_format = '+{1} ' .. vim.fn.expand("%")
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

function git()
  return main {
    cmd = "gitui && git push",
    matcher = "true"
  }
end

function ranger()
  return main {
    cmd = "ranger --choosefile=/tmp/fztermranger && true",
    matcher = 'echo "edit $(cat /tmp/fztermranger)"'
  }
end

return {
  files = files,
  git_files = git_files,
  buffers = buffers,
  lines = lines,
  blines = blines,
  ag = ag,
  rg = rg,
  commits = commits,
  files_or_git_files = files_or_git_files,
  references = references,
  symbols = symbols,
  ws_symbols = ws_symbols,
  git = git,
  ranger = ranger
}
