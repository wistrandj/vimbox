if exists('s:loaded')
    finish
endif | let s:loaded = 1

command! Funcs call ShowPythonFunctions()
command! Methods call ShowPythonMethods()

function ShowPythonFunctions()
    global/\C^def/#
endfunction

function ShowPythonMethods()
    global/\C\s*def/#
endfunction

