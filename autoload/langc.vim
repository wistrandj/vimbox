
let s:src_folder = ''

fun! langc#find_src_folder()
    if s:src_folder != ''
        return s:src_folder
    elseif isdirectory('src')
        let s:src_folder = 'src/'
    endif

    return s:src_folder
endfun

fun! langc#init_header(name)
    let path = langc#find_src_folder() . name . '.h'
    let macro = substitute(toupper(a:name . "_H"), '.*/', '', 'g')
    let lines = ['#ifndef ' . macro, '#define ' . macro,
    \             '', '', '', '#endif // ' . macro]
    call s:init_file(path, lines)
endfun

fun! langc#init_source(name)
    let path = langc#find_src_folder() . a:name . '.c'
    let hpath = a:name . '.h'
    let clines = ['#include "' . hpath . '"', '', '']
    call s:init_file(path, lines)
endfun

fun! langc#init_header_source(name)
    call langc#init_header(a:name)
    call langc#init_source(a:name)
endfun

fun! s:init_file(path, lines)
    if s:source_file_exists_and_not_empty(a:path)
        echoerr a:path. " already exists"
        return
    endif

    call writefile(a:lines, a:path)
endfun

fun! s:source_file_exists_and_not_empty(file)
    if !filereadable(a:file)
        return 0
    else
        return !empty(readfile(a:file))
    endif
endfun
