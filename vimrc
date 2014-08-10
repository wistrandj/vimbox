
" === Variables ===============================================================
filetype plugin on
syntax on

" Use these keys for mappings
map - <nop>
map + <nop>
let mapleader = "-"

" Environment
let $VIMHOME = "/home/jasu/.vim/"

" Misc
set nocompatible
set history=100
set backspace=indent,start
" set mouse=a

" Files
set t_Co=8
set confirm
set hidden
set noswapfile
set nobackup
set autowrite

" View
set cursorline
set display=lastline
set lazyredraw      " don't redraw while macro execution
set list            " show ws as visible char
set listchars=tab:>\ ,trail:·
set noshowmode
set scrolloff=2     " Keep a few lines always visible around cursor
set showbreak=\
set splitright
set ttyfast
set wildmenu
set wildmode=list:longest,full

set laststatus=2
set statusline=%!statusline#StatusLineFunction()

" Colours
hi StatusLineNC ctermfg=6
hi MatchParen ctermbg=6 ctermfg=0
hi VertSplit cterm=none
hi Folded ctermfg=6 ctermbg=8
" Folded         xxx term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=LightGrey

set showmatch
set matchtime=2

" Indent
set autoindent
set smartindent
set shiftround

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

set nojoinspaces

set wildignore=*.o,*.obj,*.class

" === Mappings ================================================================
" Windows, buffers and tabs
nnoremap <leader>T :tabnew<CR>
nnoremap <leader>ta :tabprev<CR>
nnoremap <leader>tw :tabnext<CR>
nnoremap <leader>tc :tabclose<CR>

nnoremap <leader>b :ls<CR>:b

nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>

" Files and external programs
nnoremap <F1> :so $MYVIMRC<CR>
nnoremap <Leader>w :update<CR>
inoremap <C-x><C-o> <C-x><C-o><C-p>

" Escaping and moving cursor
inoremap kj <Esc>l
inoremap KJ <Esc>l:echoerr "Caps is ON!"<CR>
inoremap Kj <Esc>l
noremap , ;
noremap ; ,
noremap j gj
noremap k gk
map ö [
map ä ]
map Ö {
map Ä }

" Search
nnoremap <leader>hw :set invhls<CR>*#
nnoremap <leader>hW :set hls<CR>*#

" Fold
nnoremap <Space> za

" Visual
vnoremap > >gv
vnoremap < <gv
nnoremap <leader>v `[v`]

" Insert
nnoremap S i_<Esc>r

" Insert mode CTRL mappings
inoremap <C-u> <esc>hviwUel

" Replace with empty line
nnoremap dl ddko<esc>
nnoremap cl :s/.*//<CR>i

" Align with Tabular plugin
vnoremap <Leader>ta :Tabular /

" === Plugins and filetypes ===================================================
let g:gundo_prefer_python3 = 1
"
" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *memo set ft=memo
autocmd BufNewFile,BufRead kirjat set ft=kirjat
autocmd BufNewFile,BufRead *.scl set ft=scala
autocmd BufRead *.tab set ft=tab

" CtrlP
nnoremap +r :CtrlPClearCache<CR>

" Use pathogen to manage plugins
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

nnoremap +s :Scratch<CR>

" NERDtree
nnoremap +t :NERDTreeToggle<CR>

" Easymotion
    " Hide unneeded easymotion-shortcuts behind ++
map ++ <Plug>(easymotion-prefix)
nmap <leader>f ++f
nmap <leader>F ++F

" YouCompleteMe
"let g:loaded_youcompleteme = 1
"let g:ycm_global_ycm_extra_conf =
    "\ '/home/jasu/.vim/bundle/mystuff/extra/youcompleteme_compiler_info.py'
" set completeopt-=preview
"let g:ycm_add_preview_to_completeopt = 0

" SnipMate
    " SnipMate's default <tab> key is not compatible with YouCompleMe
    " but it's disabled for now
"ino <c-j> <c-r>=TriggerSnippet()<cr>
"snor <c-j> <esc>i<right><c-r>=TriggerSnippet()<cr>

" === Initialize ==============================================================
" Clear registers
let s:a = "abcdefghijklmnopqrstuvxwxyz"
for i in range(0, len(s:a) - 1)
    exe 'let @' . s:a[i] . '= ""'
endfor
