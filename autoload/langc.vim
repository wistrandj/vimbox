" === Public ==================================================================

fun! langc#find_src_folder()
    if s:src_folder != ''
        return s:src_folder
    elseif isdirectory('src')
        let s:src_folder = 'src/'
    endif

    return s:src_folder
endfun

fun! langc#init_header_with(name, contents)
    let path = langc#find_src_folder() . a:name . '.h'
    let lines = s:make_header_file_contents(a:name, a:contents)
    return s:init_file(path, lines)
endfun
fun! langc#init_source_with(name, contents)
    let path = langc#find_src_folder() . a:name . '.c'
    let lines = s:make_source_file_contents(a:name, a:contents)
    call s:init_file(path, lines)
endfun

fun! langc#init_header_source(name)
    call langc#init_header_with(a:name, [])
    call langc#init_source_with(a:name, [])
endfun

fun! langc#alternate_file()
    let file = expand('%:p')
    if (file[-2:] == '.c')
        return l:file[:-2] . 'h'
    elseif (file[-2:] == '.h')
        return l:file[:-2] . 'c'
    endif

    echoerr 'This is not a C source file'
    throw 1
endfun

" === Private =================================================================

let s:src_folder = ''

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

fun! s:make_header_file_contents(name, contents)
    let macro = substitute(toupper(a:name . "_H"), '.*/', '', 'g')
    let lines1 = ['#ifndef ' . macro, '#define ' . macro, '']
    let lines2 = a:contents
    let lines3 = ['', '#endif // ' . macro]
    return extend(extend(lines1, lines2), lines3)
endfun

fun! s:make_source_file_contents(name, contents)
    let path = langc#find_src_folder() . a:name . '.c'
    let hpath = a:name . '.h'
    let lines = ['#include "' . hpath . '"', '']
    return extend(lines, a:contents)
endfun
