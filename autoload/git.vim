" === Variables ===============================================================

let s:git_available = 1
let s:branch = ''
let s:colors = {
    \'modified'  : 'MoreMsg',
    \'untracked' : 'Linenr',
    \'new'       : 'Comment',
    \'deleted'   : 'WarningMsg'}

let s:status = {}
function! s:reset_status()
    let s:status = {'modified': [], 'untracked': [], 'new': [], 'deleted': []}
endfunction
call s:reset_status()
au BufWritePost,ShellCmdPost * silent! call s:update_status()

" === Public Functions ========================================================

function! git#status()
    call s:echo_status()
endfunction

function! git#statusline()
    if !s:git_available
        return ''
    endif

    let s = ''
    let s .= (len(s:status['modified']) > 0)  ? '*' : ''
    let s .= (len(s:status['untracked']) > 0) ? '+' : ''
    let s .= (len(s:status['new']) > 0)       ? '+' : ''
    let s .= (len(s:status['deleted']) > 0)   ? '-' : ''
    return printf('[%s%s]', s:branch, s)
endfunction

" === private =================================================================

function! s:echo_file_list(key, list, color)
    if len(list) == 0 | return | endif

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

function! s:echo_file_list_long(key, list, color)
    if len(a:list) == 0 | return | endif

    let initlen = len(a:key) + 2
    let init = repeat(' ', initlen)

    echo printf('%s: ', a:key)
    exe 'echohl ' . a:color
    echon a:list[0]
    echohl None

    for i in range(1, len(a:list) - 1)
        exe "echohl " . a:color
        echo printf('%s%s', init, a:list[i])
        echohl None
    endfor
endfunction
function! s:echo_status()
    let changes = 0

    for key in keys(s:status)
        let list = s:status[key]
        if !empty(list)
            let changes = 1
            call s:echo_file_list_long(key, list, s:colors[key])
        endif
    endfor

    if !changes
        echo 'You have not done anything 8-)'
    endif
endfunction

function! s:git_porcelain_type(type)
    if len(a:type) < 2
        return ''
    endif

    if a:type[0] == '?'
        return 'untracked'
    elseif a:type[1] == 'M'
        return 'modified'
    elseif a:type[1] == 'D'
        return 'deleted'
    else
        return 'new'
    endif
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
    call s:update_branch()

    if v:shell_error != 0
        let s:git_available = 0
        return
    endif

    call s:update_files()
endfunction

call s:update_status()
