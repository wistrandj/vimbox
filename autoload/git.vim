
" if exists("g:mystuff_git_loaded")
"     finish
" endif
" let g:mystuff_git_loaded = 1


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
