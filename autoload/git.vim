" TEMP
comm! Update call <SID>update_status()
comm! Test call <SID>echo_status()

function! Raw()
    for key in keys(s:status)
        echo printf("%s: %s", key, string(s:status[key]))
    endfor
endfunction
comm! Raw call Raw()

" === Variables ===============================================================

let s:git_available = 0
let s:git_folder = ""
let s:git_folder_searched = 0
let s:git_branch = ""

let s:status = {}
function! s:reset_status()
    let s:status = {'modified': [], 'untracked': [], 'new': [], 'deleted': []}
endfunction
call s:reset_status()
au BufWritePost * silent! call s:update_status()

" === Public Functions ========================================================

function! git#status()
    call s:echo_status()
endfunction

function! s:echo_file_list(key, list, color)
    let len = len(a:list)
    echo printf('%s: ', a:key)

    for i in range(0, len - 2)
        exe "echohl " . a:color
        echon a:list[i]
        echohl None
        echon ', '
    endfor

    exe "echohl " . a:color
    echon printf('%s', a:list[len - 1])
    echohl None
endfunction

function! s:echo_status()
    let colors = {
        \'modified'  : 'MoreMsg',
        \'untracked' : 'Linenr',
        \'new'       : 'Comment',
        \'deleted'   : 'WarningMsg'}

    for key in keys(s:status)
        let list = s:status[key]
        if !empty(list)
            call s:echo_file_list(key, list, colors[key])
        endif
    endfor
endfunction

function! git#commit()
    call s:echo_status()
    let msg = input("Commit message: ")
    echo system('git commit -am "'. msg . '"')
endfunction

function! git#git_available()
    return git#find_git_folder() != ""
endfunction

function! git#get_current_branch()
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
endfunction

function! git#find_git_folder()
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
endfunction

" === private =================================================================

function! s:git_porcelain_type(type)
    if len(a:type) < 2
        return ''
    endif

    if a:type[0] == '?'
        return 'untracked'
    elseif a:type[0] == 'A'
        return 'new'
    elseif a:type[1] == 'M'
        return 'modified'
    elseif a:type[1] == 'D'
        return 'deleted'
    endif

    echoerr 'Git (git_porcelain_type): Invalid type ' . a:type
    return ''
endfunction

function! s:update_status()
    call s:reset_status()
    let output = system("git status --porcelain")

    for line in split(output, '\n')
        let type = strpart(line, 0, 2)
        let file = strpart(line, 3)

        let key = s:git_porcelain_type(type)
        if !empty(key)
            let files = s:status[key]
            call insert(files, file, len(files))
        endif
    endfor
endfunction
call s:update_status()

function! s:do_search()
    let path = getcwd()
    while path != ""
        if s:has_git_folder(path)
            return path . "/.git"
        else
            let path = s:extract_parent_folder(path)
        endif
    endwhile

    return ""
endfunction

function! s:has_git_folder(path)
    return isdirectory(a:path . "/.git")
endfunction

function! s:extract_parent_folder(path)
    return substitute(a:path, '\/[^\/]\+$', '', '')
endfunction
