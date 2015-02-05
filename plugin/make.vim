" === Log stuff ===============================================================
" TODO: remove Loggin stuff
let s:log = []
function! Log(...)
    if a:0 == 0
        let cnt = 1
        for line in s:log
            echo cnt . ") " . line
            let cnt+=1
        endfor
        return
    else
        call insert(s:log, a:1, len(s:log))
    endif
endfunction
command! -nargs=? Log call Log(<args>)
command! CL let s:log = []

" === Get errors ==============================================================

function! GetErrors()
    let s:copy_values = ['bufnr', 'lnum', 'col', 'text']
    let list = getqflist()
    let out = []

    for elem in list
        if !elem['valid']
            continue
        endif

        let new_elem = {}
        for val in s:copy_values
            let new_elem[val] = elem[val]
        endfor

        call insert(out, new_elem, len(out))
    endfor

    return out
endfunction

function! FilterBufferErrors(errlist, ...)
    let nr = bufnr('.')
    if (a:0 > 0)
        let nr = a:1
    endif
    let local = filter(a:errlist, 'v:val["bufnr"] == ' . nr)

    return local
endfunction

function! ErrorsByBuffer(errlist)
    let dict = {}
    for err in a:errlist
        let buf = err['bufnr']
        if !has_key(dict, string(buf))
            let dict[buf] = []
        endif

        let err2 = copy(err)
        unlet err2['bufnr']
        call insert(dict[buf], err2, len(dict[buf]))
    endfor

    return dict
endfunction

function! ClearErrors()
    call clearmatches()
endfunction

function! FixSemicolonError(err)
    if a:err['text'] !~ "expected .;. before"
        return
    endif

    let nr = a:err['lnum']
    let line = getline(nr)
    let col = a:err['col']

    if strpart(line, 0, col) =~ "^ *"
        let a:err['lnum'] = nr - 1
        let a:err['col'] = len(getline(nr - 1))
    endif
endfunction

function! GetColor(err)
    if a:err['text'] =~ "^ warning"
        return 'WildMenu'
    endif

    return 'ErrorMsg'
endfunction

" === Highlighting ============================================================

let s:error_list = {}
let s:hlmode_is_on = 0

function! HLSingleError(err)
    call FixSemicolonError(a:err)
    let line = a:err['lnum']
    let col = a:err['col']
    let color = GetColor(a:err)

    call matchaddpos(color, [[line, col, 1]])
endfunction

function! HLErrorsInBuffer(buf, errlist)
    if (bufnr('.') != a:buf)
        exe "buffer " . a:buf
    endif

    for err in a:errlist
        call HLSingleError(err)
    endfor
endfunction

function! HLErrors()
    let savecursor = getcurpos()
    let errs = GetErrors()
    let berrs = ErrorsByBuffer(errs)
    call SetHLMode(berrs)

    call setpos('.', savecursor)
    call EnterBuffer()
endfunction

function! SetHLMode(newerrors)
    if !empty(a:newerrors)
        call SetHLModeOn(a:newerrors)
    else
        call SetHLModeOff()
    endif
endfunction

function! SetHLModeOn(newerrors)
    if !s:hlmode_is_on
        augroup MakeHLMode
            au!
            au BufEnter * call EnterBuffer()
            au BufLeave * call LeaveBuffer()
        augroup END
    endif

    let s:error_list = a:newerrors
    let s:hlmode_is_on = 1
endfunction

function! SetHLModeOff()
    if s:hlmode_is_on
        augroup MakeHLMode
            au!
        augroup END
    endif

    let s:error_list = {}
    let s:hlmode_is_on = 0
    let s:nr_errors = 0
    let s:nr_errors_fixed = 0
endfunction

function! EnterBuffer()
    let buf = bufnr('%')
    if !s:hlmode_is_on || !has_key(s:error_list, buf) || buf == -1
        return
    endif

    let errs = s:error_list[buf]
    call HLErrorsInBuffer(buf, errs)
endfunction

function! LeaveBuffer()
    call clearmatches()
endfunction

" === Error bar ===============================================================

let s:nr_errors = 0
let s:nr_errors_fixed = 0
comm! MF call PrintErrorInfo()

function! Nr2float(nr)
    return 0.0 + a:nr
endfunction

function! SetNrErrors(nrerrors)
    if a:nrerrors == 0
        let s:nr_errors_fixed = s:nr_errors
    elseif a:nrerrors >= s:nr_errors
        let s:nr_errors = a:nrerrors
        let s:nr_errors_fixed = 0
    else
        let s:nr_errors_fixed = s:nr_errors - a:nrerrors
    endif
endfunction

function! BarDimension()
    let width = 20
    let n = width
    if (s:nr_errors > 0 && s:nr_errors_fixed < s:nr_errors)
        let f = Nr2float(s:nr_errors_fixed) / s:nr_errors
        let n = float2nr(width * f)
    endif
    return [n, width - n]
endfunction

function! StatuslineErrorInfo()
    if s:nr_errors == 0
        return ""
    endif
    let [n, e] = BarDimension()
    let msg1 = "%#GoodColor#" . repeat('#', n) . "%*"
    let msg2 = "%#BadColor#" . repeat('#', e) . "%*"
    return "Errors: " . msg1 . msg2 . " (" . s:nr_errors_fixed . "/" . s:nr_errors . ")"
endfunction

" === Running make ============================================================

function! BeforeMake()
    call ClearErrors()
endfunction

function! AfterMake()
    call HLErrors()
endfunction

au QuickfixCmdPre * call BeforeMake()
au QuickfixCmdPost * call AfterMake()

" TODO: Add a highlight group maybe?
" XXX: background color is hardcoded as the same as the statusline's
hi GoodColor ctermfg=DarkGreen ctermbg=White
hi BadColor ctermfg=DarkRed ctermbg=White

call statusline#CustomText(function("StatuslineErrorInfo"))
