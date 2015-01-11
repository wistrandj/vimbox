" === Mappings ================================================================
if filereadable("project.vim")
    source project.vim
endif

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

" Scroll past a paragraph with <C-y> and <C-e>
let s:scroll_max = 10
let s:scroll_min = 3
nnoremap <c-y> :call <SID>scroll_block(-1)<CR>j
nnoremap <c-e> :call <SID>scroll_block(1)<CR>
function! s:find_blank_line(linenr, lines, by, times)
    let nr = a:linenr
    let i = 0

    while (i < a:times && 1 < nr && nr < a:lines)
        if getline(nr) =~ "^\s*$"
            return nr
        endif
        let nr += a:by
        let i += 1
    endwhile
    return nr
endfunction
function! s:scroll_block(dir)
    " NOTE: quotes or ' with \<C-y> ?
    let winedge = line('w0')
    let key = "\<C-y>"
    if (a:dir > 0)
        let key = "\<C-e>"
        let winedge = line('w$')
    endif

    let blank = s:find_blank_line(winedge + a:dir, line('$'), a:dir, s:scroll_max)
    let diff = abs(blank - winedge)
    let diff = (diff < s:scroll_min) ? s:scroll_min : diff
    let diff = (diff > s:scroll_max) ? s:scroll_max : diff

    exe "normal! " . diff . key
endfunction

" Create a separator comment
command! Sep call <SID>MakeCommentSeparator()
function! s:MakeCommentSeparator()
    let comment = substitute(getline('.'), '^\([^ ]*\).*', '\1', '')
    let txt = substitute(getline('.'), '^[^ ]* *\(.*\) *$', '\1', '')
    let len = len(comment) + len(txt) + 1
    let line = comment . ' === ' . txt . ' ' . repeat('=', 79 - len - 5)
    call setline('.', line)
endfunction

" Change current directory to the file location
command! Cdh exe "cd " . expand("%:p:h")

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

" High light words when searching
nn <silent> n n:call <SID>HLnext()<CR>
nn <silent> N N:call <SID>HLnext()<CR>
function! s:HLnext()
    let pattern = '\c\%#'.@/
    let key = matchadd('ErrorMsg', pattern, 101)
    redraw
    sleep 70m
    call matchdelete(key)
    redraw
endfunction

" Expand visual block to consecutive lines with same char on same col
    " FIXME: snaps always (?) the the first non-ws character of the line
    " TODO: Could this check indentation level
nn <leader>v :call <SID>expand_visual_block()<CR>
function! s:evb_is_char_at(line, col, ch)
    return a:ch == getline(a:line)[a:col]
endfunction
function! s:evb_find_range(linenr, col, dir)
    if a:linenr < 1 || line('$') < a:linenr
        echoerr "s:find_line_with_diff...: Invalid arguments"
    endif

    let i = a:linenr
    let ch =  getline(a:linenr)[a:col]

    while s:evb_is_char_at(i, a:col, ch)
        let i += a:dir
    endwhile
    return i - a:dir
endfunction
function! s:expand_visual_block_range(linenr, col)
    let a = s:evb_find_range(a:linenr, a:col, -1)
    let b = s:evb_find_range(a:linenr, a:col, 1)
    return [a, b]
endfunction
function! s:expand_visual_block()
    let linenr = line('.')
    let col = col('.')
    let [a,b] = s:expand_visual_block_range(linenr, col)
    exe "norm! \<C-v>" . a . "Go" . b . "G"
endfunction

" === Autoload ================================================================
" Output
nnoremap \O :call output#toggle()<CR>

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

" Refactor
" Does these work?
command! -nargs=? Rename :call <SID>mygrep('*', <f-args>)
command! RenameA :call ()
function! s:mygrep(filepattern, ...)
    if a:0 == 0
        let word = expand("<cword>")
    else
        let word = a:1
    endif
    call refactor#grep(word, a:filepattern)
endfunction

