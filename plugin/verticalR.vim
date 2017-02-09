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

" User-Interface
function! s:HilightColumn_VerticalR(group1, group2, startline)
    if exists('*matchaddpos')

    let [_, line, col, _] = getpos('.')
    let id2 = matchaddpos(a:group2, [[line, col, 1]])
    redraw
    call matchdelete(id2)

    endif
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

nmap <Plug>VerticalRDown :call <SID>VerticalR("down")<CR>
nmap <Plug>VerticalRUp :call <SID>VerticalR("up")<CR>
