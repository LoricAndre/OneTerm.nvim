```
                                                                                                 
      # ###                             /###           /                                         
    /  /###                            /  ############/                                          
   /  /  ###                          /     #########                                            
  /  ##   ###                         #     /  #                                                 
 /  ###    ###                         ##  /  ##                                                 
##   ##     ## ###  /###       /##        /  ###            /##    ###  /###    ### /### /###    
##   ##     ##  ###/ #### /   / ###      ##   ##           / ###    ###/ #### /  ##/ ###/ /##  / 
##   ##     ##   ##   ###/   /   ###     ##   ##          /   ###    ##   ###/    ##  ###/ ###/  
##   ##     ##   ##    ##   ##    ###    ##   ##         ##    ###   ##           ##   ##   ##   
##   ##     ##   ##    ##   ########     ##   ##         ########    ##           ##   ##   ##   
 ##  ##     ##   ##    ##   #######       ##  ##         #######     ##           ##   ##   ##   
  ## #      /    ##    ##   ##             ## #      /   ##          ##           ##   ##   ##   
   ###     /     ##    ##   ####    /       ###     /    ####    /   ##           ##   ##   ##   
    ######/      ###   ###   ######/         ######/      ######/    ###          ###  ###  ###  
      ###         ###   ###   #####            ###         #####      ###          ###  ###  ### 
                                                                                                 
                                                                                                 

```

One terminal plugin to rule them all (eventually).

[![asciicast](https://asciinema.org/a/NVAvLZA5p2mUvv8emxTWOD79o.svg)](https://asciinema.org/a/NVAvLZA5p2mUvv8emxTWOD79o)
## Introduction
This is my second take at a [neovim](https://neovim.io) plugin using the terminal (first was https://github.com/LoricAndre/fzterm.nvim). <br>
I dropped the first one because it quickly became a mess and creating another one was faster than refactoring the first one.<br>
This does not mean that I'll drop support for this one though, since it is well better designed (for reference, adding a new command now takes little knowledge of lua and only a little bit of tinkering, but with fzterm it was quite the fight).<br>
Main difference you'll see with fzterm is the way it is configured and the fact that you can now open files in a new split/tab.

## Requirements
The base framework is using neovim nightly features, so you need to be using the latest nightly release.<br>
Most commands require [fzf](https://github.com/junegunn/fzf). `files` and `rg` require [ripgrep](https://github.com/BurntSushi/ripgrep), `ag` requires [the silver searcher](https://github.com/ggreer/the_silver_searcher) and`ranger` requires, well, [ranger](https://github.com/ranger/ranger). `git` uses [gitui](https://github.com/extrawurst/gitui).<br>
Credits to all the devs of those projects :heart:.

## Usage
Install the plugin using your favorite package manager (or whatever way you deem best). Then, all you have to do is type `:OneTerm <Tab>` and browse through the commands.

## Implemented commands
 - empty : default fzf command, defined by `$FZF_DEFAULT_COMMAND`
 - `files` : list files using ripgrep
 - `git_files` : list files using `git ls-files`
 - `files_or_git_files` : list files using either method above based on the presence of a `.git` dir in nvim's current `pwd`.
 - `buffers` : list vim buffers
 - `lines` : show lines of all active buffers
 - `blines` : show lines from current buffer
 - `ag` : find lines in files using the silver searcher
 - `rg` : find lines in files using ripgrep
 - `commits` : browse git log (nothing special happens on exit)
 - `references` : browse (and jump to) references of the keyword under the cursor using neovim's built-in lsp
 - `symbols` : browse (and jump to) lsp symbols in the current file
 - `ws_symbols` : same as `symbols` but for the entire workspace
 - `git` : open gitui and push changes on exit (gitui's push feature isn't working for me, I'd love feedback on this)
 - `ranger` : open ranger and edit selected file
 - `make` : list makefile targets and run selected
 - `yanks` : list yank history and paste it at the cursor on `<CR>` or `<C-p>`, yank to `+` register on `<C-y>`
 - `branches` : list git branches and switch to selected
 - `term` : open a floating terminal. When calling the command again, the same terminal instance will reopen unless you exit the shell.

## Configuration
OneTerm's window is configurable using the following variables. You can set them using either `let g:var` from vimscript or `vim.g.var` from lua.
 - `oneterm_width` and `oneterm_height` set the width and height ratios. These should be set to numbers between 0 (for no window) and 1 (window fills the editor)
 - `oneterm_x_pos` and `oneterm_y_pos` set the position of the center of the window, these are ratios and should be set to numbers between 0 and 1, (0, 0) meaning top right and (1, 1) bottom left
 - `oneterm_yank` needs to be set to true to be able to use the yank command !
 - `oneterm_ignore` is an array of gitignore-type patterns
 - `oneterm_fzf_prompt` is the prompt used by fzf in oneterm
 - `oneterm_options` is a dictionary/table of window options, see `:help nvim_open_win` for details

## Using the framework
Each of the commands calls the same lua function, accessible using `lua require('oneterm').main(arg_object)`.<br>
`arg_object` should be an object, with the following keys :
 - `cmd` (required) : this can be either a string, representing a shell command `"git ls-files"` for example or a lua function, like `function() return vim.api.nvim_exec("ls", true) end`
 - `preview` (optional, defaults to `"bat --color=always -n {}"`) : this is a string containing the `--preview` argument for fzf (see `man fzf` for more details)
 - `matcher` (optional, defaults to `fzf` with args) : this can be set to replace fzf with any other matcher, or `xargs echo` to just use the result of `cmd`
 - `delimiter` (optional, defaults to awk-style) : this can be used to set fzf's field delimiter (see `man fzf`) for details
 - `output_format` (optional, defaults to `"{}"`)this is a string, using fzf-style argument-replacement

The way this function works is very simple : if `cmd` is a function, it is ran and writes its output to "/tmp/onetermcmd" (or windows' temp dir), then opens a terminal reading from this file and piping it to `matcher` (after having built it) then writing the output to "/tmp/oneterm". If `cmd` is a string, the terminal is opened, running the command inside and piping to the rest of the treatment. 
Check [init.lua](https://github.com/LoricAndre/oneterm/blob/main/lua/oneterm/init.lua) for examples

## TODO
 - [ ] Add new commands :
    - [x] default for use with `$FZF_DEFAULT_COMMAND`
    - [x] lines for lines in all loaded buffers
    - [x] blines for lines in current buffer
    - [x] branches for git branches (and checkout)
    - [x] Yanks
    - [x] Makefile targets
    - [ ] Add anything you might need [here](https://github.com/LoricAndre/oneterm/issues/2)
- [x] Add a way to ignore files, e.g. for `files`, `rg` and `ag`
- [x] Add configuration for prompt & other visual aspects, including border in latest version.




