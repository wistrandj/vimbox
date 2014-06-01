
fun! MoveTo(category)
    let pos = getpos('.')
    call search('%' . a:category)
    normal }P
    call setpos('.', pos)
    normal jzz
endfun

fun! MkMoveMap(category, ...)
    let key = (a:0 > 0) ? a:1 : a:category[0]
    exe "nnoremap <leader>m" . key . " dd:call MoveTo('" . a:category . "')<cr>"
    exe "vnoremap <leader>m" . key . " d:call MoveTo('" . a:category . "')<cr>"
endfun

nnoremap <leader>y :call OpenFirstSearchResult()<CR>

call MkMoveMap('suomi')
call MkMoveMap('rock')
call MkMoveMap('light rock')
call MkMoveMap('classic rock')
call MkMoveMap('hipster')
call MkMoveMap('dance')
call MkMoveMap('slow', 'S')
call MkMoveMap('jrock')
call MkMoveMap('ost')
call MkMoveMap('ipop')
call MkMoveMap('electro')
call MkMoveMap('hiphop', 'H')


fun! OpenYoutube()
    let url = expand("<cWORD>")
    if url =~ 'www'
        call system('luakit ' . url)
    else
        call OpenFirstSearchResult()
    endif
endfun

fun! s:youtube_query_url(query)
    let url = 'http://www.youtube.com/results?search_query='
    let query = substitute(a:query, '[ -]\+', '%20', 'g')
    return url . query
endfun

fun! OpenFirstSearchResult()
    let filterCMD = ' | grep -o "watch?v=[-a-zA-Z0-9]*" | head -n 1'
    let searchURL = s:youtube_query_url(getline('.'))
    let watchURL= 'http://www.youtube.com/watch?v='
    let result = system('wget --quiet -O - ' . searchURL . filterCMD)

    if !empty(result)
        call system('luakit http://www.youtube.com/' . result)
    else
        echo "Couldn't find anything!"
    endif

endfun

fun! SearchYoutube(line)
    let words = split(a:line, ' ')
    let url = 'http://www.youtube.com/results?search_query='
    let query = substitute(join(words), '[ -]\+', '%20', 'g')
    call system('luakit ' . url . query)
endfun
