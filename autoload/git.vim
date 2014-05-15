
" === Variables ===============================================================

let s:git_available = 0
let s:git_folder = ""
let s:git_folder_searched = 0
let s:git_branch = ""

" === Public Functions ========================================================

fun! git#status()
    echo system("git status")
endfun

fun! git#commit()
    " XXX: Does not show newly added files
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

fun! git#git_available()
    return git#find_git_folder() != ""
endfun

fun! git#get_current_branch()
    if !empty(s:git_branch)
        return s:git_branch
    elseif s:git_folder_searched
        " We have already tried to search the file
        return ''
    endif

    let headfile = git#find_git_folder() . "/HEAD"

    if filereadable(headfile)
        let line = readfile(headfile)[0]
        let s:git_branch = substitute(line, '.*\/', '', 'g')
        return s:git_branch
    else
        return ""
    endif
endfun

fun! git#find_git_folder()
    if s:git_folder_searched
        return s:git_folder
    endif

    let s:git_folder_searched = 1

    let res = s:do_search()
    if res != ""
        let s:git_available = 1
        let s:git_folder = res
    endif

    return res
endfun

" === private =================================================================

fun! s:do_search()
    let path = getcwd()
    while path != ""
        if s:has_git_folder(path)
            return path . "/.git"
        else
            let path = s:extract_parent_folder(path)
        endif
    endwhile

    return ""
endfun

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
