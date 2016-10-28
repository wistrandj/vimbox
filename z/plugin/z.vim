
let g:num_buffer=repeat([0], 4)
function! SetQuickBuffer(nr)
    let g:num_buffer[a:nr - 1] = bufnr('%')
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

nnoremap <C-f>1 :exe ":buffer " . g:num_buffer[0]<CR>
nnoremap <C-f>2 :exe ":buffer " . g:num_buffer[1]<CR>
nnoremap <C-f>3 :exe ":buffer " . g:num_buffer[2]<CR>
nnoremap <C-f>4 :exe ":buffer " . g:num_buffer[3]<CR>

function! OpenPath()
    let path = GetPath(getreg("*"))
    let path = substitute(path, '.$', '', '') . '.java'
    let line = substitute(getreg("*"), '.*:\(\d\+\))', '\1', '')
    let line = substitute(line, '.$', '', '')
    let files = split(glob('**/' . path), '\n')
    echom '>>>>' . path
    if len(files) == 0
        echo "No files"
    elseif len(files) == 1
        exe "edit " . files[0]
        exe "normal! " . line . "G"
    else
        echo "There are many files..."
        exe "edit " . files[0]
        exe "normal! " . line . "G"
    endif
endfunction

function! OpenPathRemote()
    normal! "*yy
    call system('vim --servername DEV --remote-send ":call OpenPath()<CR>"')
endfunction

function! GetPath(path)
    let path = a:path
    let path = substitute(path, '^\tat ', '', '')
    let path = substitute(path, '\.\w*(.*)', '', '')
    let path = substitute(path, '\.', '\/', 'g')
    return path
endfunction

function DoAU()
    set ft=log
endfunction

au BufEnter errors.log call DoAU()

nnoremap <F8> :call OpenPathRemote()<CR>
nnoremap <F9> :call OpenPath()<CR>
