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
command! Syntax call <SID>PythonMinimalSyntax()

function ShowPythonFunctions()
    global/\C^def/#
endfunction

function ShowPythonMethods()
    global/\C\s*def/#
endfunction


hi _python_keyword_1 ctermfg=yellow
hi _python_keyword_2 ctermfg=darkyellow
hi _python_string ctermfg=red
hi _python_comment ctermfg=magenta

function s:PythonMinimalSyntax()
    syntax off
    syn match _python_string "'[^']*'"
    syn match _python_string '"[^"]*"'
    syn match _python_string '"""'
    syn match _python_string "'''"
    syn match _python_comment '#.*$'
    syn match _python_comment '@[a-zA-Z][a-zA-Z0-9]*'
    syn keyword _python_keyword_1 def class
    syn keyword _python_keyword_2 if elif else while for in not import from as lambda return break continue try except
endfunction

