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

## Introduction
This is my second take at a [neovim](https://neovim.io) plugin using the terminal (first was https://github.com/LoricAndre/fzterm.nvim). 
I dropped the first one because it quickly became a mess and creating another one was faster than refactoring the first one.
This does not mean that I'll drop support for this one though, since it is well better designed (for reference, adding a new command now takes little knowledge of lua and only a little bit of tinkering, but with fzterm it was quite the fight).
Main difference you'll see with fzterm is the way it is configured and the fact that you can now open files in a new split/tab.

## Requirements
The base framework is using neovim nightly features, so you need to be using the latest nightly release.
Most commands require [fzf](https://github.com/junegunn/fzf). `ranger` requires, well, [ranger](https://github.com/ranger/ranger) and `git` uses [gitui](https://github.com/extrawurst/gitui)
Credits to all the devs of those projects :heart:

## Usage
Install the plugin using your favorite package manager (or whatever way you deem best).
Type `:OneTerm <Tab>` and browse through the commands.

## 
