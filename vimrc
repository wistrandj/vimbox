" SECTION Variables
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

" Files
set confirm " FIXME what's the alternative?
set noswapfile
set nobackup
set autowrite

" View
set list            " show ws as visible char
set listchars=tab:>\ ,trail:~
set splitright
set lazyredraw      " don't redraw while macro execution
set scrolloff=2     " Keep a few lines always visible around cursor
set relativenumber
set wildmenu
set wildmode=list:longest,full
set showmode
set showbreak=\
set display=lastline

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

" ENDSECTION
" SECTION Mappings
"

" Change habits by unmapping stuff
imap <esc> <esc>
cmap <esc> <nop>
map <leader><leader> <nop>
map <leader><leader><leader> <nop>

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
nnoremap <Leader>xp :r!xsel -p<CR>
vnoremap <Leader>xi :w !xsel -pi<CR>

" Escaping and moving cursor
inoremap kj <Esc>l
noremap , ;
noremap ; ,
noremap j gj
noremap k gk
noremap <C-y> 3<C-y>
noremap <C-e> 3<C-e>

" Use scandinavian keys for something useful
noremap ö [
noremap ä ]

noremap Ö {
noremap Ä }

" Search
nnoremap <leader>hw :set invhls<CR>*#

" Fold
nnoremap <Space> za

" Macros and Commands
nnoremap Q @q
nnoremap <leader>q q:

" Visual
vnoremap > >gv
vnoremap < <gv
nnoremap <leader>v `[v`]

inoremap vvw <esc>bve
inoremap vvW <esc>BvE
inoremap vve <esc>`[v`]
inoremap vvl <esc>^v$h

" Insert
nnoremap s i_<Esc>r
nnoremap <leader>j yyp

" Replace with empty line
nnoremap dl ddko<esc>
nnoremap cl :s/.*//<CR>i

" Align with Tabular plugin
vnoremap <Leader>ta :Tabular /

" ENDSECTION
" SECTION Plugins and filetypes
"

let g:gundo_prefer_python3 = 1

" Use pathogen to manage plugins
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

let g:clang_periodic_quickfix = 1

nnoremap <Leader>sc :Scratch<CR>

" NERDtree
nnoremap <leader>p :NERDTreeToggle<CR>

" FuzzyFinder
nnoremap <leader>ff  :FufFile **/<CR>
autocmd FileType fuf noremap <buffer> <C-c> <Esc>

" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *memo set ft=memo
autocmd BufNewFile,BufRead kirjat set ft=kirjat
autocmd BufNewFile,BufRead *.scl set ft=scala

" ENDSECTION
