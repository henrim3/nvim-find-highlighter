" Title:        Neovim Find Highlighter
" Description:  A plugin to highlight occurrences of the character you're searching for.
" Last Change:  19 March 2024
" Maintainer:   henrim3 https://github.com/henrim3

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_nvimfindhighlighter")
    finish
endif
let g:loaded_nvimfindhighlighter = 1

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
let s:lua_rocks_deps_loc =  expand("<sfile>:h:r") . "/../lua/nvim-find-highlighter/deps"
exe "lua package.path = package.path .. ';" . s:lua_rocks_deps_loc . "/lua-?/init.lua'"
