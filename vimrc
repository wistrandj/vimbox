" === Custom mappings =========================================================

set tags+=$HOME/java/tags

let g:vimrc_sign_counter = 1001
hi _signhl ctermfg=blue ctermfg=red
sign define tmpsign text=>> texthl=_signhl

nnoremap <F7> :call      <SID>SetSign(line('.',   line('.')))<CR>
vnoremap <F7> <ESC>:call <SID>SetSign(line("'<"), line("'>"))<CR>

comm!          SyntaxItem :echo <SID>GetSyntaxItemUnderCursor()
comm! -nargs=1 Pretty call <SID>PrettyPrint_list(eval(<f-args>))

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
autocmd BufRead help set readonly

" View
set nohlsearch
set display=lastline
set lazyredraw      " don't redraw while macro execution
set list            " show ws as visible char
set listchars=tab:>\ ,trail:·
set noshowmode
set scrolloff=2     " Keep a few lines always visible around cursor
set breakindent
set showbreak=^
set splitright
set wildmenu
set wildmode=list:longest,full
set conceallevel=2
set nowrap
if has("gui_running")
    colorscheme molokai
endif
colorscheme elflord " This seems to clear all hilights
hi SignColumn ctermbg=darkgreen
hi Folded ctermfg=White ctermbg=Black


set laststatus=2
set statusline=%!statusline#StatusLineFunction()

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
set ignorecase      " Don't care about case in searches
set smartcase
set incsearch
set matchpairs+=<:>

set wildignore+=cscope.out,a.out

set nojoinspaces
set wildignore=*.o,*.obj,*.class
set path=.,./include/,/usr/include,/usr/local/include/,/opt/include/

" Backup and viminfo
" 'directory' sets the location for swap files
set directory=/tmp/
" set viminfo=h,f1,:100,'100,<50,s10,n~/.vimtrash/viminfo
set nobackup
" set backup
" set backupdir=~/.vimtrash,/tmp
" set backupskip=~/,~/bin,~/doc,~/dl/,~/doc,~/src
" set writebackup
" TODO allow backups and swap files only in ~/,~/bin,... etc. folders

" === Mappings ================================================================
" Windows, buffers and tabs
nnoremap <leader>T :tabnew<CR>
nnoremap <leader>ta :tabprev<CR>
nnoremap <leader>tw :tabnext<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>

nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>

" Files and external programs
nnoremap <F1> :so $MYVIMRC<CR>
let g:vim_default_source = expand('<sfile>')
nnoremap <F1> :echo g:vim_default_source<CR>
nnoremap <Leader>w :update<CR>
inoremap <C-x><C-o> <C-x><C-o><C-p>

" Escaping and moving cursor
" inoremap kj <Esc>l
noremap , ;
noremap ; ,
noremap j gj
noremap k gk
map ö [
map ä ]
map Ö {
map Ä }
nn gj :call <SID>JumpInView(0.75)<CR>
nn gk :call <SID>JumpInView(0.25)<CR>
nnoremap ` ``
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-b> <S-left>
cnoremap <c-f> <S-right>

nnoremap vi<TAB> :call <SID>SelectIndention()<CR>

nnoremap gd= :s/ *=.*//<CR>
nnoremap d= ^d/=\s*\zs<CR>

nnoremap g/ :call hls_obj.push()<CR>
nnoremap g\ :call hls_obj.clear()<CR>
nnoremap g* :let @/='\<' . expand('<cword>') . '\>' <bar> call hls_obj.push()<CR>
nnoremap <leader><space> :set invhls<CR>

" Complete menu
inoremap <expr> <c-j> pumvisible() ? '<c-o>' : '<c-x><c-o>'
inoremap <expr> <c-k> pumvisible() ? '<c-p>' : '<c-x><c-p>'

" Fold
nnoremap <Space> za

" Visual
vnoremap > >gv
vnoremap < <gv

" Insert & delete
nnoremap S i_<Esc>r
function! s:ReplaceToInsertMode()
    return (mode() == 'R') ? "\<ESC>a" : "\<ESC>lR"
endfunction
inoremap <expr> <c-l> <SID>ReplaceToInsertMode()

" Make the previous word UPPER CASE
inoremap <C-u> <esc>hviwUel

" Align with Tabular plugin
vnoremap <leader>ta :Tabular /

" Add quotes/parens/brackets till the end of line
nnoremap gs' i'<ESC>A'<ESC>
nnoremap gs" i"<ESC>A"<ESC>
nnoremap gs( i(<ESC>A)<ESC>%
nnoremap gs) i(<ESC>A)<ESC>%
nnoremap gs[ i[<ESC>A]<ESC>%
nnoremap gs] i[<ESC>A]<ESC>%
nnoremap gs{ i{<ESC>A}<ESC>%
nnoremap gs} i{<ESC>A}<ESC>%

" My git
nnoremap <F8> :call git#commit()<CR>
nnoremap <F9> :call git#status()<CR>


" === Plugins and filetypes ===================================================
set rtp+=~/.vim/bundle/Vundle.vim/
" let g:EasyMotion_do_mapping = 0
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    if !empty(system("which git"))
        Plugin 'airblade/vim-gitgutter'
    endif
    Plugin 'MarcWeber/vim-addon-mw-utils' " Dependency for snipmate
    Plugin 'tomtom/tlib_vim'              " Dependency for snipmate
    Plugin 'honza/vim-snippets'           " Dependency for snipmate
    Plugin 'garbas/vim-snipmate'

    Plugin 'godlygeek/tabular'
    Plugin 'kien/ctrlp.vim'
    Plugin 'mtth/scratch.vim'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'scrooloose/nerdtree'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-surround'

    " Optional
    Plugin 'davidhalter/jedi-vim'
    Plugin 'vim-scripts/OmniCppComplete'

    " My plugins
    Plugin 'jasu0/VimBox-rc'
    Plugin 'jasu0/Z'
    " Plugin 'jasu0/makefix'
    " Plugin 'jasu0/viewtag'
    " Plugin 'jasu0/touchtags'
call vundle#end()
filetype plugin indent on

" Surround
let g:surround_no_insert_mappings = 1

" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *memo set ft=memo
autocmd BufNewFile,BufRead kirjat set ft=kirjat
autocmd BufNewFile,BufRead *.scl set ft=scala
autocmd BufRead *.tab set ft=tab

" CtrlP
comm! CR :CtrlPClearCache
au! FileWritePost :CtrlPClearCache
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_custom_ignore = {'dir': '\C\<target\>'}

" Scratch buffer
comm! SC Scratch
comm! SCS split | Scratch
comm! SCV vsplit | Scratch

" NERDtree
if !exists("NERDTreeIgnore")
    let NERDTreeIgnore = ['\.pyc', '__init__\.py']
else
    call insert(NERDTreeIgnore, '\.pyc')
    call insert(NERDTreeIgnore, '__init__\.py')
endif
let NERDTreeDirArrows = 0
nnoremap <leader>sn :NERDTreeToggle<CR>

" GitGutter
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0
let g:gitgutter_highlight_lines = 0
nnoremap <leader>pg :GitGutterSignsToggle<CR>

" Syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11'


" === Functions ===============================================================

" Select lines around based on indentation level
" TODO: when vi<TAB> is pressed multiple times/mode() == 'v'
"       => Choose more lines
"
function! s:SelectIndention()
    " Select lines around based on indentation
    let uppernr = search('\(^\s*$\)\@!', 'bWnc')
    let lowernr = search('\(^\s*$\)\@!', 'Wnc')
    let upper = len(substitute(getline(uppernr), '\S.*$', '', ''))
    let lower = len(substitute(getline(lowernr), '\S.*$', '', ''))
    let spaces = max([upper, lower])
    if (spaces == 0)
        return
    endif
    let pattern = printf('^\( \{%d\}\)\@!' . '\&' . '^\(\s*$\)\@!', spaces)
    let p1 = search(pattern, 'bWn')
    let p2 = search(pattern, 'Wn')
    let p1 = (p1 != 0) ? p1 + 1 : 1
    let p2 = (p2 != 0) ? p2 - 1 : line('$')
    call feedkeys(p1 < p2 ? printf('%dGV%dj', p1, p2 - p1) : 'V')
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

" *** Debugging ***

function! s:GetSyntaxItemUnderCursor()
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction

function! s:PrettyString(str, depth, newline)
    let space = printf('%' . a:depth . 's', '')
    " let text = (type(a:str) == type("")) ? a:str : string(a:str)
    let text = a:str
    if a:newline
        echo space . text
    else
        echon space . text
    endif
endfunction

function! s:PrettyPrint_aux(ds, depth)
    if (a:depth > 16) | return | endif
    let true = 1
    let false = 0
    let T = type(a:ds)
    if (T == type({}))
        let maxkey = max(map(copy(keys(a:ds)), 'len(string(v:val))'))
        for key in keys(a:ds)
            call s:PrettyString(printf('%-' . maxkey. 's', key . ':'), a:depth, true)
            call s:PrettyPrint_aux(a:ds[key], a:depth + 4)
        endfor
    elseif (T == type([]))
        if (len(a:ds) > 6)
            echo '['
            echon string(a:ds[0])
            echon string(a:ds[1])
            echon string(a:ds[2])
            echon '..., '
            echon string(a:ds[-3])
            echon string(a:ds[-2])
            echon string(a:ds[-1])
            echo ']'
        else
            echo string(a:ds)
        endif
    elseif (T == type(""))
        let s = substitute(a:ds, '\n', '\\n', 'g')
        if len(s) > 50
            echon string(s[:47]) . '...'
        else
            echon string(s)
        endif
    else
        echon string(a:ds)
    endif
endfunction

function! s:PrettyPrint_list(args)
    if (type(a:args) == type([]) && !empty(a:args) && type(a:args[0]) == type({}))
        for arg in a:args
            call s:PrettyPrint_aux(arg, 0)
            echo "----------------------------------------"
        endfor
    else
        call s:PrettyPrint_aux(a:args, 0)
    endif
endfunction


" Leave signs on lines between `lft` and ´rgh´
"
function! s:SetSign(lft, rgh)
    for i in range(a:lft, a:rgh)
        let id = g:vimrc_sign_counter
        let g:vimrc_sign_counter = g:vimrc_sign_counter + 1
        let cmd = printf('sign place %d line=%d name=tmpsign file=%s', id, i, expand('%:p'))
        exe cmd
    endfor
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


" === Initialize ==============================================================
" Clear registers
let s:a = "abcdefghijklmnopqrstuvxwxyz0123456789\""
for i in range(0, len(s:a) - 1)
    exe 'let @' . s:a[i] . '= ""'
endfor
unlet s:a

" hls_obj
call hls_obj.init()
