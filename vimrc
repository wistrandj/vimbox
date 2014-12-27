" === Variables ===============================================================
filetype plugin indent on
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
     " this can be swapped on/off with keys "\hc"
let s:hlcol80 = matchadd('DiffChange', '\%81v', 100)
set cursorline
set display=lastline
set lazyredraw      " don't redraw while macro execution
set list            " show ws as visible char
set listchars=tab:>\ ,trail:·
set noshowmode
set scrolloff=2     " Keep a few lines always visible around cursor
" set showbreak=\
set splitright
set ttyfast
set wildmenu
set wildmode=list:longest,full
if has("gui_running")
    colorscheme molokai
endif

set laststatus=2
set statusline=%!statusline#StatusLineFunction()

" Colours
hi StatusLineNC ctermfg=6
hi MatchParen ctermbg=6 ctermfg=0
hi VertSplit cterm=none
hi Folded ctermfg=6 ctermbg=8
    " Swap statusline color when in insert mode
" autocmd InsertEnter * hi StatusLine ctermfg=6
" autocmd InsertLeave * hi StatusLine ctermfg=7
autocmd InsertEnter * echohl StatusLineNC | echo "-- INSERT --" | echohl None
autocmd InsertLeave * echo ""

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
set incsearch

set nojoinspaces

set wildignore=*.o,*.obj,*.class

set path=.,./include/,/usr/include,/opt/include/

" === Mappings ================================================================
" Windows, buffers and tabs
nnoremap <leader>T :tabnew<CR>
nnoremap <leader>ta :tabprev<CR>
nnoremap <leader>tw :tabnext<CR>
nnoremap <leader>tc :tabclose<CR>

nnoremap \e :e#<CR>
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
noremap , ;
noremap ; ,
" noremap j gj
" noremap k gk
map ö [
map ä ]
map Ö {
map Ä }

" Search
nnoremap <leader>h :set hls<CR>*#
nnoremap <leader>H :set nohls<CR>

" Fold
nnoremap <Space> za

" Visual
vnoremap > >gv
vnoremap < <gv

" Insert & delete
nnoremap S i_<Esc>r
nnoremap <expr> X (col('.') == col('$') - 1) ? 'x' : 'xh'

" Make the previous word UPPER CASE
inoremap <C-u> <esc>hviwUel

" Toggle line numbers
nnoremap <F9> :set invnu<CR>

" Align with Tabular plugin
vnoremap <leader>ta :Tabular /

" Invert hilight of column 80
nnoremap \hc :call InvHLcol80()<CR>
fun! InvHLcol80()
    if s:hlcol80 == -1
        let s:hlcol80 = matchadd('DiffChange', '\%81v', 100)
    else
        call matchdelete(s:hlcol80)
        let s:hlcol80 = -1
    endif
endfun

" Add quotes/parens/brackets till the end of line
nnoremap gs' i'<ESC>A'<ESC>
nnoremap gs" i"<ESC>A"<ESC>
nnoremap gs( i(<ESC>A)<ESC>%
nnoremap gs) i(<ESC>A)<ESC>%
nnoremap gs[ i[<ESC>A]<ESC>%
nnoremap gs] i[<ESC>A]<ESC>%
nnoremap gs{ i{<ESC>A}<ESC>%
nnoremap gs} i{<ESC>A}<ESC>%

" === Plugins and filetypes ===================================================
" Use pathogen to manage plugins
    " TODO Try Vundle instead of Pathogen
"           runtime bundle/pathogen/autoload/pathogen.vim
"           call pathogen#infect()
set rtp+=~/.vim/bundle/Vundle
call vundle#begin()
    Plugin 'a'
    Plugin 'asynccommand'
    Plugin 'autotag'
    Plugin 'ctrlp.vim'
    Plugin 'easymotion'
    Plugin 'fugitive'
    Plugin 'gundo'
    Plugin 'L9'
    Plugin 'mystuff'
    Plugin 'mytypes'
    Plugin 'nerdcommenter'
    Plugin 'nerdtree'
    " Plugin 'pathogen'
    Plugin 'rainbowparenthesis'
    Plugin 'repeat'
    Plugin 'scratch'
    Plugin 'snipmate'
    Plugin 'surround'
    Plugin 'syntastic'
    Plugin 'tabular'
    Plugin 'taglist'
    Plugin 'Vundle'
call vundle#end()

let g:gundo_prefer_python3 = 1

nnoremap <F5> :SyntasticCheck<CR>
let g:syntastic_cpp_config_file = 'syntastic_config'
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
let s:pkg = system('pkg-config --cflags gtkmm-3.0')
" let g:syntastic_c_check_header = 1
" let g:syntastic_c_include_dirs = ['/opt/include/a']
let g:syntastic_cpp_checkers = ['gcc']
let g:syntastic_cpp_compiler_options = '-I/usr/include/gtkmm-3.0'

" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *memo set ft=memo
autocmd BufNewFile,BufRead kirjat set ft=kirjat
autocmd BufNewFile,BufRead *.scl set ft=scala
autocmd BufRead *.tab set ft=tab

" CtrlP
nnoremap +r :CtrlPClearCache<CR>

nnoremap \t :TlistToggle<CR>
nnoremap \s :Scratch<CR>

" NERDtree
let NERDTreeDirArrows = 0
nnoremap \N :NERDTreeToggle<CR>

" Easymotion
    " Hide unneeded easymotion-shortcuts behind ++
map ++ <Plug>(easymotion-prefix)
nmap <leader>f ++f
nmap <leader>F ++F

" === Initialize ==============================================================
" Clear registers
let s:a = "abcdefghijklmnopqrstuvxwxyz0123456789\""
for i in range(0, len(s:a) - 1)
    exe 'let @' . s:a[i] . '= ""'
endfor
