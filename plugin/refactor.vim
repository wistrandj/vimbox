
fun! Test()
    call RefactorStart("abc", "")
    call RefactorDo("abc", "XYZ")
endfun

nnoremap <leader><leader>t :call Test()<CR>

fun! RefactorStart(word1, word2)
    call OutputText(system("grep -Rn " . a:word1))
endfun

fun! RefactorDo(word1, word2)
    let dict = s:ReadRefactoringFromOutput()
    call s:RefactorByDict(dict, a:word1, a:word2)
endfun


" -----------------------------------------------------------------------------

fun! s:ReadFileName(line)
    let a = substitute(a:line, ":.*", "", "")
    return a
endfun

fun! s:ReadLineNumber(line)
    let a = substitute(a:line, "[^:]*:", "", "")
    let a = substitute(a:line, ":[^:]*", "", "")
    return str2nr(a)
endfun

fun! s:ReadRefactoringFromOutput()
    let dict = {}

    call SwitchToOutputWindow()
    for i in range(1, line('$'))
        let path = s:ReadFileName(getline(i))
        let linenr = s:ReadLineNumber(getline(i))

        if !filereadable(path)
            echoerr "Couldn't find file " . path
            continue
        endif

        if has_key(dict, path)
            call add(dict[path], linenr)
        else
            let dict[path] = [linenr]
        endif
    endfor
    wincmd p

    return dict
endfun
fun! s:RefactorByDict(dict, word1, word2)
    for path in keys(a:dict)
        call s:RefactorFile(path, a:word1, a:word2, a:dict[path])
    endfor
endfun

fun! s:RefactorFile(path, word1, word2, linenrs)
    call sort(a:linenrs)
    let filelines = readfile(a:path)

    for nr in a:linenrs
        let filelines[nr] = substitute(filelines[nr], a:word1, a:word2, "g")
    endfor

    call writefile(filelines, a:path)
endfun
