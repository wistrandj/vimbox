function! matchingChars#InsertBrackets(count)
    let pos = getpos('.')
    let toline = line('.') + a:count
    normal! A {
    call append(toline, '}')
    normal! =a}
    call setpos('.', pos)
endfunction

fun! matchingChars#InsertParen(paren)
    let parens = {'(':')', '[':']', '{':'}'}
    let [left, right] = [a:paren, parens[a:paren]]
    let line = getline('.')
    let lline = line[:col('.')-2]
    let rline = line[col('.')-1:]
    let fmt1 = "[^".left."]"
    let fmt2 = "[^".right."]"
    let lopen = len(substitute(lline, fmt1, '', 'g'))
    let lclosed = len(substitute(lline, fmt2, '', 'g'))
    let ropen = len(substitute(rline, fmt1, '', 'g'))
    let rclosed = len(substitute(rline, fmt2, '', 'g'))
    if (rclosed - ropen > lopen - lclosed)
        return left
    end
    return left . right . "\<LEFT>"
endfun

fun! matchingChars#InsertOrSkip(char)
    let ch = strpart(getline('.'), col('.')-1, 1)
    return (ch == a:char) ? "\<RIGHT>" : a:char
endfun

fun! matchingChars#InsertQuote(quote)
    if (&ft == 'vim')
        return a:quote
    end
    let line = getline('.')
    let ch = strpart(line, col('.') - 2, 2)
    let nr = len(substitute(line, '[^'.a:quote.']', '', 'g'))
    if (ch[1] == a:quote)
        return "\<RIGHT>"
    elseif (nr % 2 == 1)
        return a:quote
    endif
    return a:quote . a:quote . "\<LEFT>"
endfun

fun! matchingChars#Backspace()
    let ch = strpart(getline('.'), col('.')-2, 2)
    if (-1 != index(["()", "[]", "{}", '""', "''"], ch))
        return "\<right>\<BS>\<BS>"
    endif
    return "\<BS>"
endfun
