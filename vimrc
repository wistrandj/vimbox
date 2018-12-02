
" === Variables ===============================================================
filetype off " for V_undle
syntax on

" Use these keys for mappings
let mapleader = "-"

" Environment
let $VIMHOME = $HOME . "/.vim/"
let $MYSTUFF = $VIMHOME . "bundle/mystuff/"

" Misc
" set nocompatible
set history=100
set backspace=indent,start
set completeopt+=menuone

" Files
set confirm
set hidden
set autowrite
set wildmode=longest,list
autocmd BufRead help set readonly
autocmd BufRead *.jsm set ft=javascript

" View
set nohlsearch
set display=lastline
set lazyredraw      " don't redraw while macro execution
set list            " show ws as visible char
set listchars=tab:>\ ,trail:·
set noshowmode
set scrolloff=2     " Keep a few lines always visible around cursor
if exists('&breakindent')
    set breakindent
endif
set showbreak=^
set splitright
set wildmenu
set wildmode=list:longest,full
set conceallevel=2
set nowrap
if has("gui_running")
    colorscheme desert
else
    colorscheme elflord " This seems to clear all hilights
endif
hi SignColumn ctermbg=darkgreen
hi Folded ctermfg=White ctermbg=Black
hi Search cterm=reverse ctermfg=Black ctermbg=DarkYellow
set hlsearch


set laststatus=2

set showmatch
set matchtime=2
set ttimeoutlen=10 "ms
" `ttimeoutlen` is to quickly escape

" Indent
set autoindent
set smartindent
set shiftround
set nocindent

" Tabs
set expandtab       " tabs = spaces
set tabstop=4       " autoindent with spaces
set shiftwidth=4
set softtabstop=4   " backspace removes spaces

" Patterns
set synmaxcol=800   " Do not match patterns for long lines
set gdefault        " s///g always
set ignorecase
set smartcase
set incsearch
set matchpairs+=<:>

set nojoinspaces
set wildignore+=*.o,*.obj,*.class
set wildignore+=cscope.out,a.out,*.pyc
set wildignore+=*.gif,*.jpg,*.JPG,*.pdf,*.png
set path=.,./include/,/usr/include,/usr/local/include/,/opt/include/

" Backup and viminfo
" --- Location for backup and swap files
set directory=/tmp
set nobackup

" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *.scl set ft=scala
autocmd BufNewFile,BufRead Jenkinsfile* set ft=groovy


" === Mappings ================================================================

" Files, Windows, buffers and tabs
"
let g:vim_default_source = expand('<sfile>')
nnoremap <leader>T :tabnew<CR>
nnoremap <leader>ta :tabprev<CR>
nnoremap <leader>tw :tabnext<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>

nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>

nnoremap <F1> :so $MYVIMRC<CR>
nnoremap <F1> :echo g:vim_default_source<CR>
nnoremap <Leader>w :update<CR>
inoremap <C-x><C-o> <C-x><C-o><C-p>
command! -nargs=* Tag call ShowTag(<f-args>)

" Escaping and moving cursor
"
noremap ö [
noremap ä ]
noremap Ö {
noremap Ä }
noremap , ;
noremap ; ,
noremap j gj
noremap k gk
nnoremap ` ``
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-b> <S-left>
cnoremap <c-f> <S-right>
nnoremap gj :call <SID>JumpInView(0.75)<CR>
nnoremap gk :call <SID>JumpInView(0.25)<CR>

nnoremap <silent> <c-w>gh :call <SID>minimizeVisibleWindow('H')<CR>
nnoremap <silent> <c-w>gl :call <SID>minimizeVisibleWindow('L')<CR>
nnoremap <silent> <c-w>gj :call <SID>minimizeVisibleWindow('J')<CR>
nnoremap <silent> <c-w>gk :call <SID>minimizeVisibleWindow('K')<CR>


" Visual
"
vnoremap > >gv
vnoremap < <gv
nnoremap <leader>v :call <SID>expand_visual_block()<CR>
nnoremap <expr> vi<TAB> <SID>SelectIndention()
onoremap i<TAB> :<C-U>exe ":normal! " . <SID>SelectIndention()<CR>


" Colors
"
if exists('*matchaddpos')
nnoremap <silent> n n:call <SID>HLnext(1)<CR>
nnoremap <silent> N N:call <SID>HLnext(1)<CR>
endif
nnoremap g/ :call hls_obj.push()<CR>
nnoremap g\ :call hls_obj.clear()<CR>
nnoremap g* :let @/='\<' . expand('<cword>') . '\>' <bar> call hls_obj.push()<CR>
nnoremap <leader><space> :set invhls<CR>



" Insert & delete
"
nnoremap S i_<Esc>r
function! s:ReplaceToInsertMode()
    return (mode() == 'R') ? "\<ESC>a" : "\<ESC>lR"
endfunction
inoremap <expr> <c-l> <SID>ReplaceToInsertMode()
nnoremap <leader>S :call <SID>ToggleCommentSeparator()<CR>
onoremap = :<C-U>normal! ^vf=gE<CR>
onoremap g= :<C-U>normal! ^f=wv$h<CR>

command! -nargs=* QuickPaste :call <SID>QuickPaste(<f-args>)
nnoremap gp/ :QuickPaste / 
nnoremap gp? :QuickPaste ? 
nmap <leader>R <Plug>VerticalRDown

inoremap {<CR>  {<CR>}<ESC>O
" --- Insert brackets around v:count lines
exe "vmap g} S}i <left>"
" --- Delete brackets around AND the if/while/for-stuff prepending
nmap gda} ?{<CR>d^ds}
" --- Move everything away from current block
nmap gd} ?{<CR>i<CR><CR><ESC>ds}<<kk:s/ *$//<CR>jA<TAB>


" Misc
"
inoremap <expr> <c-j> pumvisible() ? '<c-o>' : '<c-x><c-o>'
inoremap <expr> <c-k> pumvisible() ? '<c-p>' : '<c-x><c-p>'
nnoremap <Space> za
" --- Make the previous word UPPER CASE
inoremap <C-u> <esc>hviwUel
" --- Align with Tabular plugin
vnoremap <leader>ta :Tabular /
" --- Add quotes/parens/brackets till the end of line
nnoremap gs' i'<ESC>A'<ESC>
nnoremap gs" i"<ESC>A"<ESC>
nnoremap gs( i(<ESC>A)<ESC>%
nnoremap gs) i(<ESC>A)<ESC>%
nnoremap gs[ i[<ESC>A]<ESC>%
nnoremap gs] i[<ESC>A]<ESC>%
nnoremap gs{ i{<ESC>A}<ESC>%
nnoremap gs} i{<ESC>A}<ESC>%
onoremap F   :<C-U>normal! 0f(hvB<CR>

comm! Snapw call s:create_snapshot()
comm! Snap call s:compare_to_snapshot()

" === Plugins and filetypes ===================================================
set rtp+=$HOME/.vim/bundle/Vundle.vim/
command! -nargs=1 XPlugin call XPlugin(<args>)
let b:pluginlist = []
let b:DisabledPlugins = 0
function! XPlugin(pluginname)
    call insert(b:pluginlist, a:pluginname)
    exe printf("Plugin '%s'", a:pluginname)
endfunction

function! HasPlugin(pluginname)
    return index(b:pluginlist, a:pluginname) >= 0
endfunction

call vundle#begin()
    XPlugin 'VundleVim/Vundle.vim'

    XPlugin 'godlygeek/tabular'
    XPlugin 'kien/ctrlp.vim'
    XPlugin 'mtth/scratch.vim'
    XPlugin 'scrooloose/nerdcommenter'
    XPlugin 'scrooloose/nerdtree'
    XPlugin 'tpope/vim-repeat'
    XPlugin 'tpope/vim-surround'

    XPlugin 'jasu0/vimbox'
    XPlugin 'jasu0/Z'

    if 1
        XPlugin 'MarcWeber/vim-addon-mw-utils'
        XPlugin 'tomtom/tlib_vim'
        XPlugin 'honza/vim-snippets'
        XPlugin 'garbas/vim-snipmate'
    endif

    if !empty(system("which git"))
        XPlugin 'airblade/vim-gitgutter'
    endif

    if b:DisabledPlugins
        if has('conceal') && has('python3') || has('python')
            " requires: pip install jedi
            let g:jedi#completions_command = "<C-Space>"
            let g:jedi#popup_on_dot = 0
            XPlugin 'davidhalter/jedi-vim'
        endif

        if has('python3') && has('timers')
            " requires: pip3 install neovim
            let g:deoplete#enable_at_startup = 1
            XPlugin 'roxma/nvim-yarp'
            XPlugin 'roxma/vim-hug-neovim-rpc'
            XPlugin 'Shougo/deoplete.nvim'
        endif

        if has('python3') || has('python')
            XPlugin 'Valloric/YouCompleteMe'
        endif
    endif

call vundle#end()
filetype plugin indent on

if HasPlugin('tpope/vim-surround')
    let g:surround_no_insert_mappings = 1
endif

if HasPlugin('kien/ctrlp.vim')
    comm! CR :CtrlPClearCache
    au! FileWritePost :CtrlPClearCache
    let g:ctrlp_clear_cache_on_exit = 1
    let g:ctrlp_custom_ignore = {'dir': '\C\<target\>\|node_modules\|env'}
endif

if HasPlugin('mtth/scratch.vim')
    comm! SC Scratch
    comm! SCS split | Scratch
    comm! SCV vsplit | Scratch
endif


if HasPlugin('scrooloose/nerdtree')
    let g:NERDTreeStatusline = '---'
    let g:NERDTreeDirArrows = 0
    let g:NERDTreeIgnore = exists('g:NERDTreeIgnore') ? g:NERDTreeIgnore : []
    call insert(NERDTreeIgnore, '\.pyc')
    call insert(NERDTreeIgnore, '__init__\.py')
    nnoremap <leader>sn :NERDTreeToggle<CR>
endif

if HasPlugin('airblade/git-gutter')
    let g:gitgutter_map_keys = 0
    let g:gitgutter_realtime = 0
    let g:gitgutter_highlight_lines = 0
    nnoremap <leader>pg :GitGutterSignsToggle<CR>
endif

if HasPlugin('vim-syntastic/syntastic')
    let g:syntastic_cpp_compiler_options = ' -std=c++11'
endif


delcommand XPlugin
delfunction XPlugin
delfunction HasPlugin


" === Functions ===============================================================

" Select lines around based on indentation level
"
function! s:SelectIndention()
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

" Move and jump the cursor on screen to (f%) of the current screen
" Mapped for gj and gk
"
function! s:JumpInView(f)
    let top = line('w0') + &scrolloff
    let bottom = line('w$') - &scrolloff
    let line = top + float2nr(a:f * (bottom - top))
    let pos = getcurpos()
    let pos[1] = line
    call setpos('.', pos)
endfunction


" Hilight words with colors
"
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

" ONCE: Find ´tags´ tags in parent folders
" 
function! s:ScanTags()
    let path = getcwd()
    while !empty(path)
        let tags = split(glob(path . '/*tags'))
        let path = substitute(path, '\/[^\/]*$', '', '')
        for t in tags
            exe "set tags+=" . t
        endfor
    endwhile
endfunction

" QuickPaste: use gp/ or gp? to paste a line that matches argument
"
function! s:QuickPaste(mode, search)
    let mode = (a:mode == '/') ? 'n' : 'bn'
    let nr = search(a:search, mode)
    call append('.', getline(nr))
    normal! j==$k
endfunction

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

endif


" Select with visual block everything that has same char as current one
"
function! s:expand_visual_block()
    let col = col('.')
    let char = escape(getline('.')[col - 1], '.*')
    let pat = printf('^\(^$\|.\{%d\}%s\)\@!', col - 1, char)
    let s = search(pat, 'Wcnb') + 1
    let e = search(pat, 'Wcn') - 1
    call feedkeys(printf("%dG%d|\<C-V>%dG%d|", s, col, e, col))
endfunction

" Tags
"
function! ShowTag(filter, ...)
    let tags = taglist(a:filter)
    for exp in a:000
        call filter(tags, 'v:val["name"] =~ exp')
    endfor
    for tag in tags
        echo tag["name"]
        if has_key(tag, "signature")
            echohl String
            echon tag["signature"]
            echohl NONE
        endif
    endfor
endfunction


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

function! s:create_snapshot()
    let snapshot = s:snapshot_location()
    if !empty(snapshot)
        call writefile(getline(1,'$'), snapshot)
    endif
endfunction

function! s:compare_to_snapshot()
    let snapshot = s:snapshot_location()
    let diff = systemlist(printf('diff -aur %s %s', snapshot, expand('%:p')))
    echo join(diff, "\n")
endfunction


" === Initialize ==============================================================

call hls_obj.init()
call <SID>ScanTags()

if vimbox#really_loaded()
    set statusline=%!statusline#StatusLineFunction()
    inoremap <expr> " parenthesis#InsertQuote("\"")
    inoremap <expr> ) parenthesis#InsertOrSkip(')')
    inoremap <expr> ] parenthesis#InsertOrSkip(']')
    inoremap <expr> } parenthesis#InsertOrSkip('}')
    inoremap <expr> <BS> parenthesis#Backspace()
    nnoremap g{ :<C-U>call parenthesis#InsertBrackets(v:count1)<CR> 
    nnoremap <F8> :call git#commit()<CR>
    nnoremap <F9> :call git#status()<CR>

    comm!          SyntaxItem :echo debug#GetSyntaxItemUnderCursor()
    comm! -nargs=1 Pretty call debug#PrettyPrint_list(eval(<f-args>))

    nnoremap <F7> :call      sign#SetRange(line('.'),   line('.'))<CR>
    vnoremap <F7> <ESC>:call sign#SetRange(line("'<"), line("'>"))<CR>
    command! -nargs=1 SetSign :call sign#SetLine(<f-args>)
endif

if filereadable(glob('$HOME/.vimrc.local'))
    exe 'source ' . glob('$HOME/.vimrc.local')
endif
