" MyStuff: tex plugin
"

set tw=80

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
    let file = getreg("%")
    let pdf = strpart(file, 0, len(file) - 3) . "pdf"
    call system("zathura " . pdf)
endfunction

nnoremap <buffer> <expr> <leader>mr OpenZathura()
nnoremap <buffer> <leader>mc :make<CR>

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
