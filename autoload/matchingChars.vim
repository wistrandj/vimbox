let s:matchingChars = {'(': ')', '[': ']', '{': '}'}
let s:parens = ['(', ')', '[', ']', '{', '}']

fun! s:strind(str, ch)
    for i in range(0, len(a:str))
        if (a:str[i] == a:ch) | return i | endif
    endfor

    return -1
endfun

fun! s:is_paren(ch)
    return -1 != index(s:parens, a:ch)
endfun

fun! s:is_quote(ch)
    return a:ch == '"' || a:ch == "'"
endfun

fun! s:matching_char(ch)
    let match = get(s:matchingChars, a:ch, '@')
    if (match != '@')
        return match
    else if a:ch == '"' || a:ch == "'"
        return a:ch
    endif

    throw "s:matching_char: Invalid character " . a.ch
endfun

" === Insert parens ===========================================================

fun! matchingChars#InsertLeft(paren)
    let lf_ch = a:paren
    let rg_ch = s:matching_char(lf_ch)

    let [_, ln, cl, _] = getpos('.')
    let line = getline(ln)
    let prev_ch = line[cl - 2]

    if cl < len(line) || (s:is_quote(line[cl - 2]))
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

" === Insert quotes ===========================================================

fun! matchingChars#InsertQuote(quote)
    let line = getline('.')
    let char = strpart(line, col(".") - 1, 1)
    if (char == a:quote)
        return "\<right>"
    endif

    if s:is_inside_quotes(a:quote)
        return '\' . a:quote
    elseif s:is_imbalanced_quotes(a:quote)
        return a:quote
    endif

    return a:quote . a:quote . "\<left>"
endfun

fun! s:line_left_part()
    return strpart(getline('.'), 0, col('.') - 1)
endfun

fun! s:line_right_part()
    return strpart(getline('.'), col('.') - 1)
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

fun! s:is_imbalanced_quotes(quote)
    let lf_nr = s:nr_non_escaped_quotes(s:line_left_part(), a:quote)
    let rg_nr = s:nr_non_escaped_quotes(s:line_right_part(), a:quote)

    return (lf_nr % 2) + (rg_nr % 2) == 1
endfun

" === Remove parens ===========================================================

fun! s:RemoveParenthesis(left)
    let ch = strpart(getline('.'), col('.') - 2, 2)
    if len(ch) == 2
        if s:is_paren(ch[0]) && ch[1] == s:matching_char(ch[0])
            return "\<right>\<BS>\<BS>"
        endif
    endif

    return "\<BS>"
endfun

" === Remove quotes ===========================================================

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

" === Remove parens and quotes ================================================

fun! matchingChars#RemoveSomething()
    let ch = strpart(getline('.'), col('.')-2, 1)
    if ch == '(' || ch == '[' || ch == '{'
        return s:RemoveParenthesis(ch)
    elseif ch == "\"" || ch == "\'"
        return s:RemoveQuotes(ch)
    endif
    return "\<BS>"
endfun

