" TODO: clean the code
" - public functions:
"   matchingChars#InsertSomething("(")
"   matchingChars#RemoveSomething("(")
"

" Inserting

fun! matchingChars#InsertLeft(paren)
    let lf_ch = a:paren
    let rg_ch = get(s:matchingChars, lf_ch, '@')

    let [_, ln, cl, _] = getpos('.')
    let line = getline(ln)

    if (line[cl - 1] == '"' || line[cl - 1] == "'")
        return lf_ch
    endif

    return lf_ch . rg_ch . "\<left>"
endfun

fun! matchingChars#InsertRight(paren)
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

    if s:is_inside_quotes(a:quote)
        return '\' . a:quote
    endif

    return a:quote . a:quote . "\<left>"
endfun

fun! s:line_left_part()
    return strpart(getline('.'), col('.') - 1)
endfun

fun! s:line_right_part()
    return strpart(getline('.'), 0, col('.') - 1)
endfun

fun! s:nr_non_escaped_quotes(line, quote)
    let line = substitute(a:line, '\\' . a:quote, '', 'g')
    let line = substitute(line, '[^\' . a:quote . ']', '', 'g')
    return strlen(line)
endfun

fun! s:is_inside_quotes(quote)
    let lf_nr = s:nr_non_escaped_quotes(s:line_left_part(), a:quote)
    let rg_nr = s:nr_non_escaped_quotes(s:line_right_part(), a:quote)

    return (lf_nr % 2 == 1) && rg_nr > 0
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

