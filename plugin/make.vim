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
"
" FIXME
"  * Error markes are moved if you switch buffer

" === Get errors ==============================================================

function! s:SortErrorsByBuffer(errors)
    let out = {}
    for err in a:errors
        let buf = string(err['bufnr'])
        unlet err['bufnr']
        call s:FixSemicolonError(err)
        let buferrors = get(out, buf, [])

        call insert(buferrors, err, len(buferrors))
        let out[buf] = buferrors
    endfor

    return out
endfunction

function! GetErrors()
    let copy_values = {'bufnr':1, 'lnum':1, 'col':1, 'text':1}
    let list = getqflist()
    call filter(list, 'v:val["valid"] != 0')
    for err in list
        call filter(err, 'has_key(copy_values, v:key)')
    endfor
    return s:SortErrorsByBuffer(list)
endfunction

function! ClearErrors()
    call clearmatches()
endfunction

function! s:FixSemicolonError(err)
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
let s:hlmode_status = 0

function! HLSingleError(err)
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
    let berrs = GetErrors()
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

function! s:CountErrors(errors)
    let size = 0
    for buferrors in keys(a:errors)
        let size += len(a:errors[buferrors])
    endfor
    return size
endfunction

function! SetHLModeOn(newerrors)
    if !s:hlmode_status
        augroup MakeHLMode
            au!
            au BufEnter * call EnterBuffer()
            au BufLeave * call LeaveBuffer()
        augroup END
    endif

    let s:error_list = a:newerrors
    let s:hlmode_status = 1
    call SetNrErrors(s:CountErrors(a:newerrors))
endfunction

function! SetHLModeOff()
    if s:hlmode_status
        augroup MakeHLMode
            au!
        augroup END
    endif

    let s:error_list = {}
    let s:hlmode_status = 0
    let s:nr_errors = 0
    let s:nr_errors_fixed = 0
endfunction

function! EnterBuffer()
    let buf = bufnr('%')
    if !s:hlmode_status || !has_key(s:error_list, buf) || buf == -1
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

fun! PrintErrorInfo()
    return string(s:nr_errors) . "/" . string(s:nr_errors_fixed)
endfun

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

nn <F1> "/home/jasu/.vim/bundle/mystuff/plugin/make.vim"
