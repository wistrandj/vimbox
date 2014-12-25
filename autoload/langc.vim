if !exists(g:cext)
    let g:cext = 'c'
    let g:hext = 'h'
endif

" === Public ==================================================================

fun! langc#init_header_source(name)
    call s:create_and_init_file(a:name, "header")
    call s:create_and_init_file(a:name, "source")
endfun

fun! langc#alternate_file()
    return s:alternate_file()
endfun


" === Common private functions ================================================

fun! s:is_header_file(filename)
    return (-1 != match(a:filename, '\.h'))
endfun

fun! s:alternate_file()
    let ext = expand("%:e")
    let file = expand("%:t:r")

    if ext =~ 'h\(pp\)\?'     | let ext = 'c'
    elseif ext =~ 'c\(pp\)\?' | let ext = 'h'
    endif

    let file = file   . '.' . ext
    let cmd = 'find -regex ".*' . file . '\(pp\)?"'
    let files = split(system(cmd))
    if len(files) == 0   | return "" |
    elseif len(file) > 1 | echo "Multiple matches"
    endif

    return files[0]
endfun

" === Creation of a C file ====================================================

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

fun! s:create_and_init_file(name, type)
    let path=""
    let contents=[]

    if a:type == "header"
        let contents = s:empty_header(a:name)
        let path = s:include_folder_location() . a:name . g:hext
    elseif a:type == "source"
        let contents = s:empty_source(a:name)
        let path = s:source_folder_location() . a:name . g:cext
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
    let postfix = '_' . toupper(g:hext)

    let macro = s:strip_folders(toupper(a:name)) . postfix
    let lst1 = ['#ifndef ' . macro, '#define ' . macro]
    let lst2 = ['', '', '#endif // ' . macro]
    return extend(lst1, lst2)
endfun

fun! s:empty_source(name)
    let header = s:change_file_extension(a:name, g:hext)
    let header = s:strip_folders(a:name)
    return ['#include "' . header . g:hext . '"', '', '']
endfun
