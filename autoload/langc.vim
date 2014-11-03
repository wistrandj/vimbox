
fun! s:strip_folders(path)
    return substitute(a:path, '.*/', '', 'g')
endfun

fun! s:include_folder_location()
    if isdirectory("include/") | return "include/" | endif

    return s:src_folder_location()
endfun

fun! s:source_folder_location()
    if isdirectory("src/")
        return "src/"
    else
        return "./"
    endif
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
        let folder = s:include_folder_location()
        let file = s:change_file_extension(file, 'c')
    elseif s:is_source_file(file)
        let folder = s:source_folder_location
        let file = s:change_file_extension(file, 'h')
    else
        throw "s:alternate_file: " . file . " is not a C file"
    endif

    return folder . file
endfun

" === Public ==================================================================

" fun! langc#find_src_folder()
"     if s:src_folder != ''
"         return s:src_folder
"     elseif isdirectory('src')
"         let s:src_folder = 'src/'
"     endif
" 
"     return s:src_folder
" endfun

fun! langc#init_header_with(name, contents)
    let path = langc#find_src_folder() . a:name . '.h'
    let lines = s:make_header_file_contents(a:name, a:contents)
    return s:create_file(path, lines)
endfun
fun! langc#init_source_with(name, contents)
    let path = langc#find_src_folder() . a:name . '.c'
    let lines = s:make_source_file_contents(a:name, a:contents)
    call s:create_file(path, lines)
endfun

fun! langc#init_header_source(name)
    call langc#init_header_with(a:name, [])
    call langc#init_source_with(a:name, [])
endfun

fun! langc#alternate_file()
    let ext = expand("%:e")
    let head = expand('%:h')
    let filename = expand('%:t:r')

    if ext == 'h' 
        return s:alternate_from_header(head . '/', filename)
    elseif ext == 'c'
        return s:alternate_from_source(head . '/', filename)
    else
        echoerr "This is not a C file"
        throw 1
    endif

endfun

fun! s:alternate_from_header(head, filename)
    if a:head == '.'
        return a:filename . '.c'
    elseif a:head =~ "\\<include\\>"
        let altdir = substitute(a:head, '.*\zs\<include\>', 'src', '')
        return altdir . a:filename . '.c'
    endif

    return a:head . a:filename . '.c'
endfun

fun! s:alternate_from_source(head, filename)
    if a:head == '.'
        return a:filename . '.h'
    elseif a:head =~ "\\<src\\>"
        let altdir = substitute(a:head, '.*\zs\<src\>', 'include', '')
        ec "altdir = " . altdir
        if isdirectory(altdir)
            return altdir . a:filename . '.h'
        endif
    endif

    return a:head . a:filename . '.h'
endfun

" === Private =================================================================

" let s:src_folder = ''

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
        return !empty(readfile(a:file), 0, 1)
    endif
endfun

fun! s:empty_header(name)
    let macro = s:strip_folders(toupper(a:name)) . '_H'
    return
        ['#ifndef ' . macro, '#define ' . macro, '', '', '', '#endif // ' . macro]
endfun

fun! s:empty_source(name)
    let header = s:change_file_extension(a:name, 'h')
    let header = s:strip_folders(a:name)

    return ['#include <' . header . '>', '', '']
endfun

" fun! s:make_header_file_contents(name, contents)
"     let macro = substitute(toupper(a:name . "_H"), '.*/', '', 'g')
"     let lines1 = ['#ifndef ' . macro, '#define ' . macro, '']
"     let lines2 = a:contents
"     let lines3 = ['', '#endif // ' . macro]
"     return extend(extend(lines1, lines2), lines3)
" endfun
" 
" fun! s:make_source_file_contents(name, contents)
"     let path = langc#find_src_folder() . a:name . '.c'
"     let hpath = a:name . '.h'
"     let lines = ['#include "' . hpath . '"', '']
"     return extend(lines, a:contents)
" endfun
