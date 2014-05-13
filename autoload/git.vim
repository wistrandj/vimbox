
" if exists("g:mystuff_git_loaded")
"     finish
" endif
" let g:mystuff_git_loaded = 1

fun! git#status()
    echo system("git status")
endfun

fun! git#commit()
    let untracked = s:untracked_files()
    let modified = s:modified_files()

    if len(untracked) > 0
        let msg = 'Working tree has untracked files'
        call s:echo_coloured_file_list(msg, untracked, "String")
    endif

    if len(modified) == 0
        echo "Tracked files are up to date!"
        return
    endif

    let msg = "Modified files"
    call s:echo_coloured_file_list(msg, modified, "Question")
    let msg = input("Commit message: ")
    echo system('git commit -am "'. msg . '"')
endfun

fun! git#get_current_branch(gitpath)
    let headfile = a:gitpath . "/HEAD"
    let line = readfile(headfile)[0]
    return substitute(line, '.*\/', '', 'g')
endfun

fun! git#find_git_folder()
    let path = getcwd()
    while path != ""
        if s:has_git_folder(path)
            return path . "/.git"
        else
            let path = s:extract_parent_folder(path)
        endif
    endwhile

    throw "MyStuff/Git: no git folder"
endfun

" === private =================================================================

fun! s:echo_colour(msg, colour)
    exe "echohl " . a:colour
    echo a:msg
    echohl None
endfun
fun! s:echon_colour(msg, colour)
    exe "echohl " . a:colour
    echon a:msg
    echohl None
endfun

fun! s:echo_coloured_file_list(msg, files, colour)
    echon a:msg . ": "

    for i in range(0, len(a:files) - 1)
        call s:echon_colour(a:files[i], a:colour)
        if (i < len(a:files) - 1)
            echon ', '
        else
            echo ""
        endif
    endfor
endfun

fun! s:untracked_files()
    return s:ls_files('--others')
endfun

fun! s:modified_files()
    return s:ls_files('--modified')
endfun

fun! s:ls_files(options)
    let files = system('git ls-files --exclude-standard ' . a:options)
    return split(files, '\n')
endfun

fun! s:has_git_folder(path)
    return isdirectory(a:path . "/.git")
endfun

fun! s:extract_parent_folder(path)
    return substitute(a:path, '\/[^\/]\+$', '', '')
endfun
