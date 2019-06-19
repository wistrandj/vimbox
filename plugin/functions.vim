" QuickPaste: use gp/ or gp? to paste the next or previous line that matches
" argument
"
function s:QuickPaste(mode, search)
    let mode = (a:mode == '/') ? 'n' : 'bn'
    let nr = search(a:search, mode)
    call append('.', getline(nr))
    normal! j==$k
endfunction

command -nargs=* QuickPaste :call <SID>QuickPaste(<f-args>)


" Select lines around based on indentation level
"
function s:SelectIndention()
    let uppernr = search('\(^\s*$\)\@!', 'Wncb')
    let lowernr = search('\(^\s*$\)\@!', 'Wnc')
    let upper = len(substitute(getline(uppernr), '\S.*$', '', ''))
    let lower = len(substitute(getline(lowernr), '\S.*$', '', ''))
    let spaces = max([upper, lower])
    if (spaces == 0)
        return 'Vip'
    endif
    let pattern = printf('^\(\s\{,%d\}\)\S', spaces - 1)
    let p1 = search(pattern, 'Wnb')
    let p2 = search(pattern, 'Wn')
    let p1 = (p1 != 0) ? p1 + 1 : 1
    let p2 = (p2 != 0) ? p2 - 1 : line('$')
    return (p1 < p2 ? printf('%dGV%dj', p1, p2 - p1) : 'V')
endfunction

nmap <expr> <Plug>VimboxSelectIndention <SID>SelectIndention()
omap <Plug>VimboxSelectIndentionOperator :<C-U>exe ":normal! " . <SID>SelectIndention()<CR>


" Move and jump the cursor on screen to (f%) of the current screen
" Mapped for gj and gk
"
function s:JumpInView(f)
    let top = line('w0') + &scrolloff
    let bottom = line('w$') - &scrolloff
    let line = top + float2nr(a:f * (bottom - top))
    let pos = getcurpos()
    let pos[1] = line
    call setpos('.', pos)
endfunction

nmap <Plug>VimboxJumpInViewFwd :call <SID>JumpInView(0.75)<CR>
nmap <Plug>VimboxJumpInViewBck :call <SID>JumpInView(0.25)<CR>


" Hilight words with colors
"
nmap <Plug>VimboxHlsobjSearch :call hls_obj.push()<CR>
nmap <Plug>VimboxHlsobjClear :call hls_obj.clear()<CR>
nmap <Plug>VimboxHlsobjStar :let @/='\<' . expand('<cword>') . '\>' <bar> call hls_obj.push()<CR>

let hls_obj = {}
let hls_obj.colors = ['darkgreen', 'darkred', 'darkcyan', 'darkblue']

function! hls_obj.push()
    let bufid = bufnr('%')
    if !has_key(self.buffer_synids, bufid)
        let self.buffer_synids[bufid] = repeat([-1], len(self.colors))
        let self.buffer_id[bufid] = 0
    endif
    let buffer = self.buffer_synids[bufid]
    let id = self.buffer_id[bufid]
    if (buffer[id] > 0)
        call matchdelete(buffer[id])
    endif
    let buffer[id] = matchadd(self.names[id], getreg('/'))
    let self.buffer_id[bufid] = (id + 1) % len(self.colors)
endfunction
function! hls_obj.clear()
    let @/=''
    let bufid = bufnr('%')
    if !has_key(self.buffer_synids, bufid)
        return
    endif
    let b = self.buffer_synids[bufid]
    for i in range(len(b))
        if (b[i] > 0)
            call matchdelete(b[i])
        endif
    endfor
    unlet self.buffer_synids[bufid]
    unlet self.buffer_id[bufid]
endfunction
function! hls_obj.init()
    let self.index = 0
    let self.names = copy(self.colors)
    let self.buffer_id = {}
    let self.buffer_synids = {}
    call map(self.names, 'printf("HLS_vivi_%s", v:val)')
    for i in range(len(self.colors))
        let color = self.colors[i]
        let name = self.names[i]
        exe 'hi ' . name . ' cterm=reverse ctermfg=' . color
    endfor
endfunction

call hls_obj.init()


" Change current line's comment to long format (========)
"
function! s:ToggleCommentSeparator()
    let line = getline('.')
    if line =~ "^.*=== .* =*$"
        let line = substitute(line, '^\(\s*\S*\)\s*=== \(.*\) =*$', '\1 \2', '')
    else
        let comment = substitute(line, '^\([^ ]*\).*', '\1', '')
        let txt = substitute(line, '^[^ ]* *\(.*\) *$', '\1', '')
        let len = len(comment) + len(txt) + 1
        let line = comment . ' === ' . txt . ' ' . repeat('=', 79 - len - 5)
    endif

    call setline('.', line)
endfunction

nmap <Plug>VimboxCommentSeparator :call <SID>ToggleCommentSeparator()<CR>


" Hilight found search term with underline
"
if exists('*matchaddpos')

hi HLnext cterm=underline
let s:hilighted = -1
function! s:HLnext(arg)
    if (a:arg)
        if (s:hilighted >= 1)
            call matchdelete(s:hilighted)
        endif
        augroup HLnext
            au!
            au CursorMoved,InsertEnter,WinLeave,TabLeave * call <SID>HLnext(0)
        augroup END
        let s:hilighted = matchaddpos('HLnext', [line('.')])
    else
        call matchdelete(s:hilighted)
        let s:hilighted = -1
        augroup HLnext
            au!
        augroup END
    endif
endfunction

nnoremap <silent> <Plug>VimboxHLnextFwd n:call <SID>HLnext(1)<CR>
nnoremap <silent> <Plug>VimboxHLnextBck N:call <SID>HLnext(1)<CR>

endif


" Select with visual block everything that has same char as current one
"
function! s:ExpandVisualBlock()
    " FIXME
    let col = col('.')
    let char = escape(getline('.')[col - 1], '.*')
    let pat = printf('^\(^$\|.\{%d\}%s\)\@!', col - 1, char)
    let s = search(pat, 'Wcnb') + 1
    let e = search(pat, 'Wcn') - 1
    call feedkeys(printf("%dG%d|\<C-V>%dG%d|", s, col, e, col))
endfunction

nnoremap <Plug>VimboxExpandVisualBlock :call <SID>ExpandVisualBlock()<CR>


" Minimize visible window
"
function s:minimizeVisibleWindow(direction)
    let onlyOneWindow = (winnr('$') < 2)
    let wincmdConfig = { 'H': [50, '|'], 'L': [50, '|'], 'J': [10, '_'], 'K': [10, '_'] }
    let cmd = wincmdConfig[a:direction]
    let cmd = cmd[0] . 'wincmd ' . cmd[1]
    if onlyOneWindow
        return
    endif
    exe "wincmd " . a:direction
    exe cmd
endfunction


nnoremap <silent> <Plug>VimboxMinimizeWindowH :call <SID>minimizeVisibleWindow('H')<CR>
nnoremap <silent> <Plug>VimboxMinimizeWindowL :call <SID>minimizeVisibleWindow('L')<CR>
nnoremap <silent> <Plug>VimboxMinimizeWindowJ :call <SID>minimizeVisibleWindow('J')<CR>
nnoremap <silent> <Plug>VimboxMinimizeWindowK :call <SID>minimizeVisibleWindow('K')<CR>


" Snapshots - save current version of this file as temporary file against
" which you can compare future changes.
"
let s:snapshots_location='/tmp'
function! s:snapshot_location()
    let path = expand('%:p')
    if !empty(path)
        let hashed_path = systemlist('echo "%s" | md5sum | tr -s " " | cut -f1 -d" "')[0]
        let absolute_path = s:snapshots_location . '/' . hashed_path
        return absolute_path
    else
        return ''
    endif
endfunction

function! CreateSnapshot()
    let snapshot = s:snapshot_location()
    if !empty(snapshot)
        call writefile(getline(1,'$'), snapshot)
    endif
endfunction

function! CompareToSnapshot()
    let snapshot = s:snapshot_location()
    let diff = systemlist(printf('diff -aur %s %s', snapshot, expand('%:p')))
    echo join(diff, "\n")
endfunction


" Show some indentation settings. Might be helpful when
"
function! ShowIndentationOptions()
    echo printf('autoindent:  %s', &autoindent)
    echo printf('smartindent: %s', &smartindent)
    echo printf('cindent:     %s', &cindent)
    echo printf('  cindent: %s', &cindent)
    echo printf('  cinkeys: %s', &cinkeys)
    echo printf('  cinoptions: %s', &cinoptions)
    echo printf('  cinwords: %s', &cinwords)
    echo printf('indentexpr:  %s', &indentexpr)
endfunction

