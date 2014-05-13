
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
        echo 'Working tree has untracked files:'
        echo join(untracked, ', ')
    endif

    if len(modified) == 0
        echo "Tracked files are up to date!"
        return
    endif

    echo "Modified files: " . join(modified, ', ')
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

fun! git#echo_coloured_file_list(msg, files, colour, newline)
    let nl = (a:newline) ? '\n' : ''
    echon a:msg . ": " . nl

    for i in range(0, len(a:files) - 1)
        echohl a:colour
        exe "normal! :echon " . a:files[i]
        echohl None
        if (i < len(a:files) - 1)
            echon ', '
        endif
    endfor
    echo "HIIOHOI"
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
