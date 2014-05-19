
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
    let path = langc#find_src_folder() . a:name . '.h'
    let macro = substitute(toupper(a:name . "_H"), '.*/', '', 'g')
    let lines = ['#ifndef ' . macro, '#define ' . macro,
    \             '', '', '', '#endif // ' . macro]
    call s:init_file(path, lines)
endfun

fun! langc#init_header_with(name, lines)
    " XXX: copy-paste from langc#init_header()
    let path = langc#find_src_folder() . a:name . '.h'
    let macro = substitute(toupper(a:name . "_H"), '.*/', '', 'g')
    let lines1 = ['#ifndef ' . macro, '#define ' . macro, '']
    let lines2 = a:lines
    let lines3 = ['', '#endif // ' . macro]
    let content = extend(extend(lines1, lines2), lines3)
    return s:init_file(path, content)
endfun


fun! langc#init_source(name)
    let path = langc#find_src_folder() . a:name . '.c'
    let hpath = a:name . '.h'
    let lines = ['#include "' . hpath . '"', '', '']
    call s:init_file(path, lines)
endfun

fun! langc#init_header_source(name)
    call langc#init_header(a:name)
    call langc#init_source(a:name)
endfun

fun! s:init_file(path, lines)
    if s:source_file_exists_and_not_empty(a:path)
        echoerr a:path. " already exists"
        return 0
    endif

    call writefile(a:lines, a:path)
    return 1
endfun

fun! s:source_file_exists_and_not_empty(file)
    if !filereadable(a:file)
        return 0
    else
        return !empty(readfile(a:file))
    endif
endfun
