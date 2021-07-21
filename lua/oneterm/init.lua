local vim = vim
local main = require 'oneterm.main'
local utils = require 'oneterm.utils'

function default()
  return main{}
end

function files()
  return main {
    cmd = "rg --files --hidden ." .. utils.build_ignore_rg(vim.g.oneterm_ignore)
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
    preview = 'bat --color=always -H{-1} -r{-1}: $(echo {-3} | tr -d \\")',
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
    preview = 'bat --color=always -H{2} -r{2}: ${1}',
    delimiter = ':',
    output_format = '+{2} {1}'
  }
end

function blines()
  local file = vim.fn.expand("%")
  return main {
    cmd = function()
      local lines = ""
      for nr,line in pairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
        lines = lines .. nr .. ":" .. line .. "\n"
      end
      return lines
    end,
    preview = 'bat --color=always -H{1} -r{1}:' .. file,
    delimiter = ':',
    output_format = '+{1} ' .. file
  }
end

function ag()
  return main {
    cmd = "ag --nobreak --noheading '.+' ." .. utils.build_ignore_ag(vim.g.oneterm_ignore),
    preview = 'bat --color=always -H{2} -r{2}: {1}',
    delimiter = ':',
    output_format = '+{2} {1}'
  }
end

function rg()
  return main {
    cmd = "rg --hidden -n ." .. utils.build_ignore_rg(vim.g.oneterm_ignore),
    preview = 'bat --color=always -H{2} -r{2}: {1}',
    delimiter = ":",
    output_format = "+{2} {1}"
  }
end

function commits()
  return main {
    cmd = "git log --oneline --color",
    preview = "git show --pretty='\\%Cred\\%H\\%n\\%Cblue\\%an\\%n\\%Cgreen\\%s' --color {1}",
    output_format = ""
  }
end

function bcommits()
  return main {
    cmd = "git log --oneline --color -- " .. vim.fn.expand("%"),
    preview = "git show --pretty='\\%Cred\\%H\\%n\\%Cblue\\%an\\%n\\%Cgreen\\%s' --color --rotate-to=" .. vim.fn.expand("%") .. " {1}",
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
      return utils.lsp {
      	  query = 'textDocument/references',
	  type = 'locations'
	}
    end,
    preview = "bat -H{2} -r{2}: {1} --color=always",
    output_format = "+{2} {1}"
  }
end

function symbols()
  return main {
    cmd = function()
      return utils.lsp {
          query = 'textDocument/documentSymbol',
	  type = 'symbols'
	}
    end,
    preview = "bat -H{2} -r{2}: {1} --color=always",
    output_format = "+{2} {1}"
  }
end

function ws_symbols()
  return main {
    cmd = function()
      return utils.lsp {
          query = 'workspace/symbol',
	  type = 'symbols'
	}
    end,
    preview = "bat -H {2} -r{2}: {1} --color=always",
    output_format = "+{2} {1}"
  }
end

function gitui()
  return main {
    cmd = "gitui && git push && true",
    matcher = "true"
  }
end

function git()
  return main {
    cmd = "lazygit && true",
    matcher = "true"
  }
end

function ranger()
  local tmp = utils.gettmp()
  return main {
    cmd = "ranger --choosefile="..tmp.."/fztermranger && true",
    matcher = 'echo "edit $(cat '..tmp..'/fztermranger)"'
  }
end

function make()
  return main {
    cmd = vim.o.makeprg .. " -qp | awk -F':' '/^[a-zA-Z0-9][^$\\#\\/\\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}'",
    matcher = "fzf | xargs " .. vim.o.makeprg .. " && echo 'press any key to continue' && read && echo 'edit!'"
  }
end

function yanks()
  local tmp = utils.gettmp()
  return main {
    cmd = "cat " .. tmp .. "/onetermyanks",
    matcher = "fzf --bind 'ctrl-p:execute(echo r !echo {})+abort,ctrl-y:execute(echo let @+={})+abort,enter:execute(echo r !echo {})+abort' --tac"
  }
end

function branches()
  return main {
    cmd = "git branch",
    matcher = "fzf --ansi | xargs git switch; echo 'edit!'",
  }
end

function term()
  return main {
    buf = vim.g.oneterm_term_buf,
    cmd = (os.getenv("SHELL") or "bash") .. " && true",
    persist = true,
    maps = {
      {'t', '<Esc>', '<C-\\><C-n>:q<CR>'}
    }
  }
end

function oldfiles()
  return main {
    cmd = function()
      return utils.build_from_list(vim.v.oldfiles)
    end
  }
end

function history()
  return main {
    cmd = function()
      local N = vim.fn.histnr(":")
      local l = {}
      for i = 1,N do
        l[i] = vim.fn.histget(":", i)
      end
      return utils.build_from_list(l)
    end,
    matcher = "fzf --tac"
  }
end

function snippets()
  return main {
    cmd = function()
      return utils.build_from_table(vim.fn["UltiSnips#SnippetsInCurrentScope"](1))
    end,
    matcher = [[fzf --tac --bind "enter:execute(echo execute \"\\\"normal! a\"{1}\"\<C-r>=UltiSnips\#ExpandSnippet()\<CR>\\\"\")+abort"]],
    separator = "\t"
  }
end

function sessions()
  return main {
    cmd = "find " .. vim.g.oneterm_sessions_path .. " -name '*.vim'",
    matcher = "fzf | sed 's/\\%/\\\\\\%/g;s/\\(.*\\)/:source \\1/'"
  }
end


return {
  default = default,
  files = files,
  git_files = git_files,
  buffers = buffers,
  lines = lines,
  blines = blines,
  ag = ag,
  rg = rg,
  commits = commits,
  bcommits = bcommits,
  files_or_git_files = files_or_git_files,
  references = references,
  symbols = symbols,
  ws_symbols = ws_symbols,
  git = git,
  gitui = gitui,
  ranger = ranger,
  make = make,
  yanks = yanks,
  branches = branches,
  term = term,
  oldfiles = oldfiles,
  history = history,
  snippets = snippets,
  sessions = sessions
}
