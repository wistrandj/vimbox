" Vertical insert mode

" TODO
"  BS -> go line above, replace key
"  C-R -> go line below, replace previously deleted key
"  STOP to last line

function! s:Forward(direction)
    if (a:direction == "down")
        normal! j
    else
        normal! k
    endif
endfunction
function! s:Backward(direction)
    if (a:direction == "down")
        normal! k
    else
        normal! j
    endif
endfunction

let s:charMap = {}
let s:direction = "down"

" Basic features
function! SetChar(key)
    exe 'normal! r' . nr2char(a:key)
endfunction
function! PutChar(key)
    let line = getline('.')
    let prevChar = char2nr(line[col('.')])
    let s:charMap[getline('.')] = [prevChar, a:key]
    call SetChar(a:key)
    call s:Forward(s:direction)
endfunction
function! Backspace()
    call s:Backward(s:direction)
    let [prev, new] = s:charMap[line('.')]
    call SetChar(a:key)
endfunction
function! UndoBackspace()
    if (!has_key(s:charMap, line('.') + 1))
        return
    endif
    call s:Forward(s:direction)
    let [prev, new] = s:charMap[line('.')]
    call SetChar(a:key)
endfunction

" User-Interface
function! s:HilightColumn(group, column, from, to)
    let [from, to] = [a:from, a:to]
    let to = a:to
    let from = (a:to - a:from > 8) ? a:to - 8 : a:from

    let pos_list = map(sort(range(from, to)), '[v:val, a:column, 1]')
    return matchaddpos(a:group, pos_list)
endfunction
function! s:HilightColumn_VerticalR(group1, group2, startline)
    let [_, line, col, _] = getpos('.')
    """""""""""" let id1 = s:HilightColumn(a:group1, col, a:startline, line)
    let id2 =  matchaddpos(a:group2, [[line, col, 1]])
    redraw
    """""""""""" call matchdelete(id1)
    call matchdelete(id2)
endfunction
function! s:VerticalR(direction)
    let [group1, group2] = ['ErrorMsg', 'StatusLine']
    let startline = line('.')
    let startcol = col('.')
    call s:HilightColumn_VerticalR(group1, group2, startline)

    try
        while (col('.') == startcol)
            let key = getchar()
            if (key == "\<ESC>")
                break
            elseif (key == "\<BS>")
                call s:Backward(a:direction)
            elseif (key == 18) " <C-r>
                " TODO
            else
                exe 'normal! r' . nr2char(key)
                call s:Forward(a:direction)
            endif
            call s:HilightColumn_VerticalR(group1, group2, startline)
        endwhile
    finally
        redraw!
    endtry
endfunction

nnoremap <leader>R :call <SID>VerticalR("down")<CR>
nnoremap gR :call <SID>VerticalR("up")<CR>

"    v->a = x01;
"    v->y = x01;
"    v->x = x01;
