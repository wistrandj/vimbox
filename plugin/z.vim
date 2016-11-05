let s:num_buffer=repeat([0], 4)
function! SetQuickBuffer(nr)
    let s:num_buffer[a:nr - 1] = bufnr('%')
    echo "Set to " . a:nr
endfunction

function! QuickPaste(mode, search)
    if (a:mode == '/')
        let nr = search(a:search, 'n')
    elseif (a:mode == '?')
        let nr = search(a:search, 'bn')
    endif
    call append('.', getline(nr))
    normal! j==$k
endfunction
comm! -nargs=* QuickPaste :call QuickPaste(<f-args>)
nnoremap gp/ :QuickPaste / 
nnoremap gp? :QuickPaste ? 

nnoremap <C-f><C-j>1 :call SetQuickBuffer(1)<CR>
nnoremap <C-f><C-j>2 :call SetQuickBuffer(2)<CR>
nnoremap <C-f><C-j>3 :call SetQuickBuffer(3)<CR>
nnoremap <C-f><C-j>4 :call SetQuickBuffer(4)<CR>

nnoremap <C-f>1 :exe ":buffer " . s:num_buffer[0]<CR>
nnoremap <C-f>2 :exe ":buffer " . s:num_buffer[1]<CR>
nnoremap <C-f>3 :exe ":buffer " . s:num_buffer[2]<CR>
nnoremap <C-f>4 :exe ":buffer " . s:num_buffer[3]<CR>

