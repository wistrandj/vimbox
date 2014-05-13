
" if exists("g:mystuff_git_loaded")
"     finish
" endif
" let g:mystuff_git_loaded = 1

fun! git#status()
    echo system("git status")
endfun

fun! git#commit()
    let untracked = git#untracked_files()
    let modified = git#modified_files()

    if len(untracked) > 0
        echo "Working tree has untracked files: " . join(untracked, ', ')
    endif

    if len(modified)
        echo "Everything's up to date!"
        return
    endif

    let msg = input("Commit message: ")
    echo system('git commit -am "'. msg . '"')
endfun

fun! s:ls_files(options)
    let files = system('git ls-files --exclude-standard' . options)
    return split(files, '\n')
endfun

fun! git#untracked_files()
    return s:ls_files('--others')
endfun

fun! git#modified_files()
    return s:ls_files('--modified')
endfun

fun! git#get_current_branch(gitpath)
    let headfile = a:gitpath . "/HEAD"
    let line = readfile(headfile)[0]
    return substitute(line, '.*\/', '', 'g')
endfun

fun! git#find_git_folder()
    let path = getcwd()
    while path != ""
        if git#has_git_folder(path)
            return path . "/.git"
        else
            let path = git#extract_parent_folder(path)
        endif
    endwhile

    throw "MyStuff/Git: no git folder"
endfun

fun! git#has_git_folder(path)
    return isdirectory(a:path . "/.git")
endfun

fun! git#extract_parent_folder(path)
    return substitute(a:path, '\/[^\/]\+$', '', '')
endfun
