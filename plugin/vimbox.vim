" === Mappings ================================================================
if filereadable("project.vim")
    source project.vim
endif

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

" Insert Something
nn <leader>mi <ESC>:call <SID>DropRestBelow()<CR>ka
nn <leader>im <ESC>:call <SID>InsertBelow()<CR>
nmap <leader>mm :call <SID>DropRestBelow()<CR>j-ccka
function! s:DropRestBelow()
    let col = col('.') - 1
    let line = getline('.')
    let init = strpart(line, 0, col)
    let rest = repeat(' ', col) . strpart(line, col)
    call append('.', rest)
    call setline('.', init)
endfunction
function! s:InsertBelow()
    let column = col('.') - 1
    exe "normal! o\<ESC>" . column . "i "
    startinsert!
endfunction

" Create a separator comment
nn <leader>S :call <SID>ToggleCommentSeparator()<CR>
function! s:ToggleCommentSeparator()
    let line = getline('.')
    if line =~ "^.*=== .* =*$"
        let line = substitute(line, '^\(\s*\S*\)\s*=== \(.*\) =*$', '\1 \2', '')
    else
        let comment = substitute(line, '^\([^ ]*\).*', '\1', '')
        let txt = substitute(line, '^[^ ]* *\(.*\) *$', '\1', '')
        let len = len(comment) + len(txt) + 1
        let line = comment . ' === ' . txt . ' ' . repeat('=', 79 - len - 5)
    endif

    call setline('.', line)
endfunction

" Change current directory to the file location
command! CDH exe "cd " . expand("%:p:h")

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

" Hilight words when searching
nn <silent> n n:call <SID>HLnext()<CR>
nn <silent> N N:call <SID>HLnext()<CR>
function! s:HLnext()
    let pattern = '\c\%#'.@/
    let key = matchadd('ErrorMsg', pattern)

    redraw
    sleep 100m
    call matchdelete(key)
    redraw
endfunction

" Expand visual block to consecutive lines with same char on same col
nn <leader>v :call <SID>expand_visual_block()<CR>
function! s:evb_block_range()
    let cl = col('.')
    let pat = '^\(.\{' . (cl - 1) . '\}' . getline('.')[cl - 1] . '\)\@!'

    let a = search(pat, 'Wbn') + 1
    let b = search(pat, 'Wn') - 1

    if b == -1
        let b = line('$')
    endif

    return [a, b]
endfunction
function! s:expand_visual_block()
    let [start, end] = s:evb_block_range()
    let sol=&startofline
    set nostartofline

    exe "normal! " . start . "G\<C-V>" . end . "G"

    if sol
        set startofline
    endif
endfunction

" TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 
" Copied from: http://vim.wikia.com/wiki/Window_zooming_convenience
" function! ToggleMaxWins()
"   if exists('t:windowMax')
"     au! maxCurrWin
"     wincmd =
"     unlet t:windowMax
"   else
"     augroup maxCurrWin
"         " au BufEnter * wincmd _ | wincmd |
"         "
"         " only max it vertically
"         au! WinEnter * if exists('t:windowMax') | wincmd _ | endif
"     augroup END
"     let t:windowMax=1
"     do maxCurrWin WinEnter
"   endif
" endfunction
" nnoremap <C-w>_ :call ToggleMaxWins()<CR>
" function! MaybeMaximizeWindow()
"     if !exists('t:maximize_window')
"         wincmd _
"     endif
" endfunction
" function! SetMaximizeWindowVariable(value)
"     if (val)
"         let t:maximize_window = 1
"     elseif exists('t:maximize_window')
"         unlet t:maximize_window
"     endif
" endfunction
" 
" augroup maxCurrWin
"     au WinEnter * call MaybeMaximizeWindow()
" augroup END
" 
" nnoremap <C-w>_ call SetMaximizeWindowVariable(1) | do maxCurrWin WinEnter
" TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO 

" === Autoload ================================================================
" Runfile
command! Run call runfile#Run()
command! Runout call runfile#RunFileToOutput()

" Matching Chars
" inoremap ( ()<left>
    inoremap <expr> ( matchingChars#InsertLeft('(')
    inoremap <expr> [ matchingChars#InsertLeft('[')
    inoremap <expr> { matchingChars#InsertLeft('{')
    inoremap {<CR> {<CR><CR>}<UP>

inoremap <expr> ) matchingChars#InsertRight(")")
inoremap <expr> ] matchingChars#InsertRight("]")
inoremap <expr> } matchingChars#InsertRight("}")
inoremap <expr> " matchingChars#InsertQuote("\"")
" inoremap <expr> ' matchingChars#InsertQuote("'")

imap <expr> <BS> matchingChars#RemoveSomething()

" TODO See if 'changes' functions in refactor are any useful
comm! -nargs=* Grep call refactor#grep(<f-args>)
