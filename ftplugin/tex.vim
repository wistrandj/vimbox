" MyStuff: tex plugin
"

" Ignore `overfull \hbox` errors with makefix
" fun! s:IgnoreOverfullHboxErrors(err)
"     if a:err['text'] =~ "Overfull"
"         echom "Ignoring an error with text " . a:err['text']
"         let a:err['remove'] = 1
"     endif
" endfun
" au VimEnter * call MakefixCustomFunction(function("s:IgnoreOverfullHboxErrors"))


set tw=80
let s:pdf_file = ""
compiler tex

function! AddBlockAroundSelection() range
    " FIXME
    let name = input("\\block: ")
    exe "normal! gvd"
    exe "normal! i\\begin{" . name . "}\r"
    exe "normal! i\\end{" . name . "}"
    exe "normal! kp"
endfunction

vnoremap <buffer> <leader>be :call AddBlockAroundSelection()<CR>

function! OpenZathura()
    if (!filereadable(s:pdf_file))
        let found = split(system('find -name "*pdf" -maxdepth 2'))

        if empty(found)
            echoerr "Couldn't find PDF file"
            return
        elseif len(found)
            echom "Multiple PDF files! Choosing the first one"
        endif

        let s:pdf_file = found[0]
    endif

    call system("zathura " . s:pdf_file . " &")
endfunction

inoremap $ $$<left>

nnoremap <buffer> <expr> <leader>mr OpenZathura()
nnoremap <buffer> <leader>mc :silent make<CR>
au QuickFixCmdPost <buffer> redraw!

" Bold/italic words
nnoremap <buffer> <leader>bf i{\bf<space><esc>ea}<esc>
vnoremap <buffer> <leader>bf <esc>`>a}<esc>`<i{\bf<space><esc>

nnoremap <buffer> <leader>it i{\it<space><esc>ea}<esc>
vnoremap <buffer> <leader>it <esc>`>a}<esc>`<i{\it<space><esc>

" Folding
nnoremap <buffer> <leader>1f A %{{{1<esc>
nnoremap <buffer> <leader>2f A %{{{2<esc>
nnoremap <buffer> <leader>3f A %{{{3<esc>

nnoremap <buffer> <leader>1F A %}}}1<esc>
nnoremap <buffer> <leader>2F A %}}}2<esc>
nnoremap <buffer> <leader>3F A %}}}3<esc>

vnoremap <buffer> <leader>1f <esc>'<A %{{{1<esc>'>A %}}}1<esc>
vnoremap <buffer> <leader>2f <esc>'<A %{{{2<esc>'>A %}}}2<esc>
vnoremap <buffer> <leader>3f <esc>'<A %{{{3<esc>'>A %}}}3<esc>
