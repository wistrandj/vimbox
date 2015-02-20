" TEMP
comm! Update call <SID>update_status()
comm! Test call <SID>echo_status()

function! Raw()
    echo "statusline: " . s:build_statusline_info()
    for key in keys(s:status)
        echo printf("%s: %s", key, string(s:status[key]))
    endfor
endfunction
comm! Raw call Raw()

" === Variables ===============================================================

let s:git_available = 0
let s:git_folder = ''
let s:git_folder_searched = 0
let s:branch = ''

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
function! git#commit()
    call s:echo_status()
    let msg = input("Commit message: ")
    echo system('git commit -am "'. msg . '"')
endfunction

function! git#git_available()
    return git#find_git_folder() != ''
endfunction
function! git#find_git_folder()
    if s:git_folder_searched
        return s:git_folder
    endif

    let s:git_folder_searched = 1

    let res = s:do_search()
    if res != ''
        let s:git_available = 1
        let s:git_folder = res
    endif

    return res
endfunction

function! s:build_statusline_info()
    let d = len(s:status['deleted'])
    let m = len(s:status['modified'])
    let n = len(s:status['new'])
    let u = len(s:status['untracked'])

    if (d + m + n + u == 0)
        return ''
    endif

    let s = printf('-%d/+%d/%dm (%d)', d, n, m, u)
    let s = substitute(s, '\(-0\(\/\)\?\)\|\(+0\(\/\)\)', '', 'g')
    let s = substitute(s, '\(0m\)\|\( (0)\)', '', 'g')
    let s = substitute(s, '\/$', '', '')

    return s
endfunction
function! git#statusline()
    let info = s:build_statusline_info()
    return printf('[G: %s %s]', s:branch, info)
endfunction

" === private =================================================================

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
function! s:update_files()
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
function! s:update_branch()
    let branches = system('git branch --no-color')
    for line in split(branches, '\n')
        if (line[0] != '*') | continue | endif

        let s:branch = strpart(line, 2)
    endfor
endfunction
function! s:update_status()
    call s:update_files()
    call s:update_branch()
endfunction

call s:update_status()

function! s:do_search()
    let path = getcwd()
    while path != ''
        if s:has_git_folder(path)
            return path . "/.git"
        else
            let path = s:extract_parent_folder(path)
        endif
    endwhile

    return ''
endfunction

function! s:has_git_folder(path)
    return isdirectory(a:path . "/.git")
endfunction

function! s:extract_parent_folder(path)
    return substitute(a:path, '\/[^\/]\+$', '', '')
endfunction
