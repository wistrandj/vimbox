" This module adds a possibility to highlight too long lines and set automatic
" wrapping for it. There is a command to set the document text width
"
"   :Document <wide,tiny,off>
"
" and an exposed mapping to cycle through them
"
"   <Plug>CycleTextWidths
"

" Improvement idea: This module is only used with zknotes and should not be
" used ever with any source code. Set vim to recognise any lines starting with
" four whitespaces as comments, and set 'formatoptions' to not wrap those
" lines.
" See: help formatoptions and fo-table

hi right_margin_highlight ctermbg=red

" Positive number that is Currently used 'matchadd' id, or -1 if not used.
let b:margin_match_id = -1

" Currently used width of the document
let b:current_margin_type = 'off'


" This script file is executed only for the first buffer so the buffer
" variables are not defined any other buffer. This function makes sure
" that they are defined.
function s:DefineVariables()
    if !exists('b:margin_match_id')
        let b:margin_match_id = -1
    endif
    if !exists('b:current_margin_type')
        let b:current_margin_type = 'off'
    endif
endfunction


" Set a marker on too long lines, which determined byt the given argument.
" @param a:size = Either 'wide', 'tiny' or 'off' 
"
function! s:TextDocumentWidth(size)
    call <SID>DefineVariables()

    if b:margin_match_id != -1
        call matchdelete(b:margin_match_id)
        let b:margin_match_id = -1
    endif

    if a:size == 'tiny'
        setlocal textwidth=60
        let b:margin_match_id = matchadd('right_margin_highlight', '^.\{60\}\zs.\ze')
        let b:current_margin_type = a:size
    elseif a:size == 'wide'
        setlocal textwidth=80
        let b:margin_match_id = matchadd('right_margin_highlight', '^.\{80\}\zs.\ze')
        let b:current_margin_type = a:size
    elseif a:size == 'off'
        setlocal textwidth=0
        let b:current_margin_type = a:size
    endif
endfunction


" Command completion function for <SID>TextDocumentWidth.
" @Return a list of possible arguments
function! s:TextDocumentWidth_completion(ArgLead, CmdLine, CursorPos)
    return join(['wide', 'tiny', 'off'], "\n")
endfunction


" Cycle through all text widths.
"
function! s:CycleTextWidths()
    call <SID>DefineVariables()

    let options = ['wide', 'tiny', 'off']
    let current_index = index(options, b:current_margin_type)
    let next_index = (current_index + 1) % len(options)
    let b:current_margin_type = options[next_index]

    echom 'Document width set to ' . b:current_margin_type
    call <SID>TextDocumentWidth(b:current_margin_type)
endfunction


" Expose apping for vimrc. This has to be mapped with 'nmap' instead of
" 'nnoremap'. No idea why.
" Example usage: nmap <CR> <Plug>CycleTextWidths
nmap <expr> <Plug>CycleTextWidths <SID>CycleTextWidths()

" Expose a command for setting different text widths
command! -nargs=1 -complete=custom,<SID>TextDocumentWidth_completion Document call <SID>TextDocumentWidth(<f-args>)

" For each new buffer, define buffer local variables for this module.
autocmd BufNew,BufNewFile * call <SID>DefineVariables()

