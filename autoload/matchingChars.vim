" TODO: clean the code
" - public functions:
"   matchingChars#InsertSomething("(")
"   matchingChars#RemoveSomething("(")
"

" Inserting

fun! matchingChars#InsertLeftParenthesis(paren)
    " XXX: this is not in use, delete?
    let matching = get(s:matchingChars, a:paren)
    let numline = line('.')
    let line = strpart(getline('.'), col('.')-1)
            \ . getline(numline+1)
            \ . getline(numline+2)
    " if line =~ "^[^". a:paren . "]*" . matching
    "     return a:paren
    " endif
    return a:paren . matching . "\<left>"
endfun

fun! matchingChars#InsertRightParenthesis(paren)
    " Insert right parenthesis if there is no one under cursor
    let char = strpart(getline("."), col(".") - 1, 1)
    if (char == a:paren)
        return "\<right>"
    endif
    return a:paren
endfun

fun! matchingChars#InsertQuote(quote)
    let char = strpart(getline("."), col(".") - 1, 1)
    if (char == a:quote)
        return "\<right>"
    endif

    let numquotes = s:CountChars(getline('.'), a:quote)
    if numquotes == 0 || numquotes % 2 == 0
        return a:quote . a:quote . "\<left>"
    endif
    return a:quote
endfun

fun! s:CountChars(str, ch)
    let cnt = 0
    for i in range(0, len(a:str))
        if a:str[i] == a:ch
            let cnt += 1
        endif
    endfor
    return cnt
endfun


" Removing

let s:matchingChars = {"(": ")", "[": "]", "{": "}"}

fun! s:RemoveParenthesis(left)
    let numline = line('.')
    let line = strpart(getline(numline), col('.')-2)
           \ . getline(numline + 1)
           \ . getline(numline + 2)
    let matching = get(s:matchingChars, a:left, '@')

    if (line =~ "^" . a:left . " *" . matching)
        return "\<esc>da" . a:left . "a"
    endif
    return "\<BS>"
endfun

fun! s:RemoveQuotes(left)
    let line = strpart(getline('.'), col('.') - 2)
    let leftleft = strpart(getline('.'), col('.')-3, 1)

    if line =~ "^" . a:left . " *" . a:left
        if leftleft == ' '
            " this will not delete a space before the first quote
            return "\<esc>da" . a:left . "a "
        endif
        return "\<esc>da" . a:left . "a"
    endif
    return "\<BS>"
endfun

fun! matchingChars#RemoveSomething()
    let ch = strpart(getline('.'), col('.')-2, 1)
    if ch == '(' || ch == '[' || ch == '{'
        return s:RemoveParenthesis(ch)
    elseif ch == "\"" || ch == "\'"
        return s:RemoveQuotes(ch)
    endif
    return "\<BS>"
endfun

