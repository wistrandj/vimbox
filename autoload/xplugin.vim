if exists('s:loaded')
    echom "Trying to load"
    finish
endif | let s:loaded = 1

let s:LoadedPlugins = {}

function xplugin#Load(plugin)
    let s:LoadedPlugins[a:plugin] = 1
    let cmd = printf("Plugin '%s'", a:plugin)
    exe cmd
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

let s:VimboxPath = expand('<sfile>:p:h:h')
function xplugin#VimboxPath()
    return s:VimboxPath
endfunction

