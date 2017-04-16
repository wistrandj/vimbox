" Tags
function! ShowTag(filter, ...)
    let tags = taglist(a:filter)
    for exp in a:000
        call filter(tags, 'v:val["name"] =~ exp')
    endfor
    for tag in tags
        echo tag["name"]
        if has_key(tag, "signature")
            echohl String
            echon tag["signature"]
            echohl NONE
        endif
    endfor
endfunction
command! -nargs=* Tag call ShowTag(<f-args>)

" PrintfLine
function! s:PrintfLine(...)
    let fts = {'cpp':'<<', 'lua':'..', 'vim':'.'}
    let plus = has_key(fts, &ft) ? fts[&ft] : '+'
    let quote = "\""
    let items = copy(a:000)
    let line = getline('.')
    for item in items
        if (item =~ "^[\"'].*[\"']$")
            let rep = item[1:len(item)-2]
        " elseif fmt is like "name just before quote: %s"
        else
            let rep = quote.plus.item.plus.quote
        endif
        let line = substitute(line, '%s', rep, '')
    endfor

    if (line =~ plus.quote.quote)
        let line = substitute(line, plus.quote.quote, '', '')
    endif

    call setline(line('.'), line)
endfunction
command! -nargs=* Printf call <SID>PrintfLine(<f-args>)

" Maximize window
function! s:ToggleWindowMaximize()
    if exists('t:maximize_window')
        unlet t:maximize_window
        wincmd =
    else
        let t:maximize_window = 1
        wincmd _
    endif
endfunction
nnoremap <silent> <C-w>_ :call <SID>ToggleWindowMaximize()<CR>

function! s:Autocmd_MaximizeWindow()
    " This function is called on WinEnter
    if exists('t:maximize_window')
        wincmd _
    endif
endfunction
au WinEnter * call <SID>Autocmd_MaximizeWindow()

function! s:ChangeToWindow(nr)
    if winbufnr(a:nr) == -1
        echoerr "No such window as " . a:nr
    endif
    exe a:nr . 'wincmd w'
endfunction
function! s:CloseWindows(nrs)
    let sorted=reverse(sort(a:nrs))
    for win in sorted
        exe win . 'wincmd c'
    endfor
endfunction
function! HideInfoWindows()
    let last = winnr('$')
    let closelist=[]
    for win in range(1, last)
        call <SID>ChangeToWindow(win)
        if !(empty(&buftype))
            call insert(closelist, win)
        endif
    endfor
    call <SID>CloseWindows(closelist)
endfunction
nnoremap <C-w>h :call HideInfoWindows()<CR>

" Git
nnoremap _Gs :call git#status()<CR>
nnoremap _Gc :call git#commit()<CR>

" Open temporary files
command! -nargs=? Tfile call <SID>open_temporary_file(<f-args>)
"   ARG: the optional string argument is used as suffix of the temp file
function! s:open_temporary_file(...)
    let suffix = ''
    let file_name = ''

    if (a:0 > 0)
        let suffix = a:1
    endif

    if exists('g:mystuff_temporary_file')
        exe 'edit ' . g:mystuff_temporary_file . suffix
        return
    endif

    let g:mystuff_temporary_file = tempname()
    exe 'edit ' . g:mystuff_temporary_file . suffix
endfunction

" Expand visual block to consecutive lines with same char on same col
nn <leader>v :call <SID>expand_visual_block()<CR>
