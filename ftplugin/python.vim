
function ShowPythonFunctions()
    global/\C^def/#
endfunction

function ShowPythonMethods()
    global/\C\s*def/#
endfunction

command! Funcs call ShowPythonFunctions()
command! Methods call ShowPythonMethods()

