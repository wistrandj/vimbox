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

" Vertical insert mode
function! s:HilightColumn(group, column, from, to)
    let [from, to] = [a:from, a:to]
    let to = a:to
    let from = (a:to - a:from > 8) ? a:to - 8 : a:from

    let pos_list = map(range(from, to), '[v:val, a:column, 1]')
    return matchaddpos(a:group, pos_list)
endfunction
function! s:HilightColumn_VerticalR(group1, group2, startline)
    let [_, line, col, _] = getpos('.')
    let id1 = s:HilightColumn(a:group1, col, a:startline, line)
    let id2 =  matchaddpos(a:group2, [[line, col, 1]])
    redraw!
    call matchdelete(id1)
    call matchdelete(id2)
endfunction
function! s:VerticalR()
    let [group1, group2] = ['ErrorMsg', 'StatusLine']
    let [_, startline, _, _] = getpos('.')
    call s:HilightColumn_VerticalR(group1, group2, startline)

    while 1
        let key = getchar()
        if (key == "\<ESC>")
            break
        endif
        exe 'normal! r' . nr2char(key) . 'j'
        call s:HilightColumn_VerticalR(group1, group2, startline)
    endwhile
endfunction
nnoremap <leader>R :call <SID>VerticalR()<CR>

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

" High light words when searching
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

