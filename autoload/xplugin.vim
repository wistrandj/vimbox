if exists('s:loaded')
    echom "Trying to load"
    finish
endif | let s:loaded = 1

let s:VimboxPath = expand('<sfile>:p:h:h')
let s:LoadedPlugins = {}

" NOTE: This is a dummy function that can be used in a try-catch block. It
" tells if Vimbox plugin has been loaded either by setting
"
"   set rtp+=$HOME/.vim/bundle/vimbox/
"
" or by plugin manager.
function xplugin#Available()
    return 1
endfunction

function xplugin#Load(plugin)
    if getenv('VIMBOX_NO_PLUGINS') == v:null
        let s:LoadedPlugins[a:plugin] = 1
        let cmd = printf("Plugin '%s'", a:plugin)
        exe cmd
    else
        " Do not load any plugins when this env var is defined.
        silent echom '(VIMBOX) Skipping loading ' . a:plugin
    endif
endfunction

function xplugin#Has(plugin)
    return has_key(s:LoadedPlugins, a:plugin)
endfunction

function xplugin#Source(source)
    if filereadable(a:source) && !empty(a:source)
        let cmd = printf("source %s", a:source)
        exe cmd
    endif
endfunction

function xplugin#VimboxPath()
    return s:VimboxPath
endfunction

