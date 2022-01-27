inoremap <buffer> <expr> > <SID>ClosingAngleBracketInserted()

if exists('s:loaded')
    finish
endif | let s:loaded = 1

if !exists('g:enable_vimbox_html_autoclose')
    " Enable this feature by default.
    let g:enable_vimbox_html_autoclose = 1
endif

if g:enable_vimbox_html_autoclose == 1
    let s:AUTOCLOSED_ELEMENTS = {
        \'body': 1,
        \'div': 1,
        \'script': 1,
        \'title': 1,
    \}
else
    let s:AUTOCLOSED_ELEMENTS = {}
endif


" @Note: These are not used at all. Maybe give a warning
" to the user or write them in documentation somewhere?
let s:NOT_CLOSED_TAGS = [
    \'img', 'input', 'hr', 'area',
    \'link', 'br', 'meta', 'base',
    \'col', 'embed', 'keygen',
    \'param', 'source', 'track', 'wbr'
\]

function s:ClosingAngleBracketInserted()
    " @Todo: Check if this tag is in s:NOT_CLOSED_TAGS and warn the user if it
    " has closing '/' in the tag
    return <SID>AutoInsertClosingTag()
endfunction

function s:AutoInsertClosingTag()
    let NO_MATCH = '>'
    " The text on left side of cursor excluding '>'
    let line = getline('.')[:col('.') - 2]
    " Match the first word inside tag and ignore attributes
    let last_tag = substitute(line, '.*<\(\w\+\)\( [^>]*\)\?', '\1', '')

    if last_tag !~ '^\w\+$' || !has_key(s:AUTOCLOSED_ELEMENTS, last_tag)
        return NO_MATCH
    endif

    let next_closed_tag = search(printf('</%s>', last_tag), 'nW')
    let next_opened_tag = search(printf('<%s', last_tag), 'nW')
    let is_closed = (next_closed_tag > 0)
    let is_opened_before = (next_opened_tag > 0 && (next_closed_tag > next_opened_tag))
    if is_closed && !is_opened_before
        return NO_MATCH
    endif

    return printf('></%s>%s', last_tag, repeat("\<LEFT>", len(last_tag) + 3))
endfunction

function s:EnsureThisTagIsNotClosed()
    " @Todo: Implement here
    return '>'
endfunction

