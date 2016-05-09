" VerticalR
nmap <leader>R <Plug>VerticalRDown

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
hi HLnext cterm=underline
nn <silent> n n:call <SID>HLnext(1)<CR>
nn <silent> N N:call <SID>HLnext(1)<CR>
let s:hilighted = -1
function! s:HLnext(arg)
    if (a:arg)
        if (s:hilighted >= 1)
            call matchdelete(s:hilighted)
        endif
        augroup HLnext
            au!
            au CursorMoved,InsertEnter,WinLeave,TabLeave * call <SID>HLnext(0)
        augroup END
        let s:hilighted = matchaddpos('HLnext', [line('.')])
    else
        call matchdelete(s:hilighted)
        let s:hilighted = -1
        augroup HLnext
            au!
        augroup END
    endif
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


inoremap <expr> ( matchingChars#InsertParen('(')
inoremap <expr> [ matchingChars#InsertParen('[')
inoremap {<CR>  {<CR>}<ESC>O
inoremap <expr> " matchingChars#InsertQuote("\"")
inoremap <expr> ) matchingChars#InsertOrSkip(')')
inoremap <expr> ] matchingChars#InsertOrSkip(']')
inoremap <expr> } matchingChars#InsertOrSkip('}')
inoremap <expr> <BS> matchingChars#Backspace()

nnoremap g{ :<C-U>call matchingChars#InsertBrackets(v:count1)<CR> 
if exists("g:loaded_surround")
            " Insert brackets around v:count lines
    exe "vmap g} S}i <left>"
            " Delete brackets around AND the if/while/for-stuff prepending
    nmap gda} ?{<CR>d^ds}
            " Move everything away from current block
    nmap gd} ?{<CR>i<CR><CR><ESC>ds}<<kk:s/ *$//<CR>jA<TAB>
endif
