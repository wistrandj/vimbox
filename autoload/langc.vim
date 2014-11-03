" === Public ==================================================================

fun! langc#init_header_source(name)
    call s:create_and_init_file(a:name, "header")
    call s:create_and_init_file(a:name, "source")
endfun

fun! langc#alternate_file()
    let file = expand("%:t")
    return s:alternate_file(file)
endfun


" === Common private functions ================================================

fun! s:strip_folders(path)
    return substitute(a:path, '.*/', '', 'g')
endfun

fun! s:include_folder_location()
    if isdirectory("include/") | return "include/" | endif
    return s:source_folder_location()
endfun

fun! s:source_folder_location()
    if isdirectory("src/")
        return "src/"
    endif

    return "./"
endfun

fun! s:is_header_file(filename)
    return '.h' == strpart(a:filename, len(a:filename) - 2)
endfun

fun! s:is_source_file(filename)
    return '.c' == strpart(a:filename, len(a:filename) - 2)
endfun

fun! s:change_file_extension(filename, ext)
    return substitute(a:filename, '\.[^\.]*$', '.' . a:ext, '')
endfun

fun! s:alternate_file(...)
    let file = substitute(bufname("%"), '.*/', '', 'g')
    if (a:0 > 0) | let file = a:1 | endif

    if s:is_header_file(file)
        let folder = s:source_folder_location()
        let file = s:change_file_extension(file, 'c')
    elseif s:is_source_file(file)
        let folder = s:include_folder_location()
        let file = s:change_file_extension(file, 'h')
    else
        throw "s:alternate_file: " . file . " is not a C file"
    endif

    return folder . file
endfun

" === Creation of a C file ====================================================

fun! s:create_and_init_file(name, type)
    let path=""
    let contents=[]

    if a:type == "header"
        let contents = s:empty_header(a:name)
        let path = s:include_folder_location() . a:name . '.h'
    elseif a:type == "source"
        let contents = s:empty_source(a:name)
        let path = s:source_folder_location() . a:name . '.c'
    else
        throw "s:init_file: Invalid a:type " . a:type
    endif

    call s:create_file(path, contents)
endfun

fun! s:create_file(path, lines)
    if s:file_exists_and_not_empty(a:path)
        echoerr a:path. " already exists"
        return 0
    endif

    call writefile(a:lines, a:path)
    return 1
endfun

fun! s:file_exists_and_not_empty(file)
    if !filereadable(a:file)
        return 0
    else
        return !empty(readfile(a:file, 0, 1))
    endif
endfun

fun! s:empty_header(name)
    let macro = s:strip_folders(toupper(a:name)) . '_H'
    let lst1 = ['#ifndef ' . macro, '#define ' . macro]
    let lst2 = ['', '', '#endif // ' . macro]
    return extend(lst1, lst2)
endfun

fun! s:empty_source(name)
    let header = s:change_file_extension(a:name, 'h')
    let header = s:strip_folders(a:name)
    return ['#include "' . header . '.h"', '', '']
endfun
