
" TODO
" - partial match: hilavitkutin_width -> hilavitkutin_height

nnoremap <C-g>a :call ReplaceWordUnderCursor()<CR>
nnoremap <C-g><C-g>a :call ReplaceWordUnderCursor()<CR>:call ReplaceWordUnderCursor()<CR>

let s:main_list = {}

let s:SMALL_LETTERS = 1
let s:TITLE_LETTERS = 2
let s:CAPIT_LETTERS = 3
let s:MIXED_LETTERS = 4

function! AddWord(from, to)
    let s:main_list[a:from] = a:to
endfunction

function! s:WordStyle(word)
    if (a:word ==# toupper(a:word))
        return s:CAPIT_LETTERS
    elseif (a:word[0] =~# "^[A-Z]")
        return s:TITLE_LETTERS
    elseif (a:word =~# "[A-Z]")
        return s:MIXED_LETTERS
    endif
    return s:SMALL_LETTERS
endfunction

function! s:SetStyle(word, style)
    if (a:style == s:SMALL_LETTERS || a:style == s:MIXED_LETTERS)
        return a:word
    elseif (a:style == s:TITLE_LETTERS)
        return toupper(a:word[0]) . a:word[1:]
    else
        return toupper(a:word)
    endif
endfunction

function! s:GetWordToReplace(word)
    let small = tolower(a:word)

    if has_key(s:main_list, a:word)
        let w = a:word
    elseif has_key(s:main_list, small)
        let w = small
    else
        let w = ''
    endif

    return empty(w) ? '' : s:SetStyle(s:main_list[w], s:WordStyle(w))
endfunction


function! AddMultipleWords(xs)
    let ln = len(a:xs)
    if ln <= 1
        return
    endif
    for i in range(ln - 1)
        call AddWord(a:xs[i], a:xs[i + 1])
    endfor

    call AddWord(a:xs[ln - 1], a:xs[0])
endfunction

function! MoveCursorToNextReplacableWord()
    let line = getline('.')[col('.'):]
    echo line
    for k in keys(s:main_list)
        if (line =~ printf('\<%s\>', k))
            exe "normal! /\\<".k."\\>\<CR>"
            return 1
        endif
    endfor
    return 0
endfunction

call AddMultipleWords(['x', 'y', 'z'])
call AddMultipleWords(['width', 'height', 'depth'])
call AddMultipleWords(['public', 'private', 'protected'])
call AddMultipleWords(['foo', 'bar', 'baz', 'qux'])
call AddMultipleWords(['assertTrue', 'assertEquals', 'assertSame'])
call AddMultipleWords(['replay', 'verify'])
call AddMultipleWords(['true', 'false'])

function! ReplaceWordUnderCursor()
    let word = expand("<cword>")
    let other = s:GetWordToReplace(word)

    if empty(other) && MoveCursorToNextReplacableWord()
        let word = expand("<cword>")
        let other = s:GetWordToReplace(word)
    endif

    if !empty(other)
        exe "normal! caw" . other
    endif
endfunction
