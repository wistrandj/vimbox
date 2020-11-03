if exists('s:loaded')
    finish
endif | let s:loaded = 1

setlocal autoindent
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4

iabbrev improt import

command! Funcs call ShowPythonFunctions()
command! Methods call ShowPythonMethods()

function ShowPythonFunctions()
    global/\C^def/#
endfunction

function ShowPythonMethods()
    global/\C\s*def/#
endfunction


