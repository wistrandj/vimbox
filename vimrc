
" === Variables ===============================================================
filetype off " for Vundle
syntax on

" Use these keys for mappings
map - <nop>
map + <nop>
let mapleader = "-"

" Environment
let $VIMHOME = $HOME . "/.vim/"
let $MYSTUFF = $VIMHOME . "bundle/mystuff/"

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
autocmd BufRead help set readonly

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
set conceallevel=2
if has("gui_running")
    colorscheme molokai
endif

set laststatus=2
set statusline=%!statusline#StatusLineFunction()

" Colours
hi SignColumn ctermbg=Darkgrey
hi StatusLineNC ctermfg=6
hi MatchParen ctermbg=6 ctermfg=0
hi VertSplit cterm=none
hi Folded ctermfg=6 ctermbg=8
    " Swap statusline color when in insert mode
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

set path=.,include/,/usr/include,/usr/local/include/,/opt/include/

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
nnoremap <Leader>w :update<CR>
inoremap <C-x><C-o> <C-x><C-o><C-p>

" Escaping and moving cursor
function! s:JumpInView(f)
    let h = winheight(0) - &scrolloff
    let top = line('.') - winline() + &scrolloff
    let bottom = (top + h > line('$')) ? line('$') : top + h
    let line = top + float2nr(a:f * (bottom - top))
    call feedkeys(line . 'G')
endfunction
inoremap kj <Esc>l
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

" Search and replace
nnoremap <F8> :set invhls<CR>
nnoremap g* :set hls<CR>*``
nnoremap g# :set hls<CR>#``
function! s:ReplaceWord(type)
    let pat = escape(tolower(expand(a:type)), '*+/')
    call feedkeys(':%s/' . pat . '/')
endfunction
nnoremap gcw :call <SID>ReplaceWord('<cword>')<CR>
nnoremap gcW :call <SID>ReplaceWord('<cWORD>')<CR>

" Fold
nnoremap <Space> za

" Visual
vnoremap > >gv
vnoremap < <gv

" Insert & delete
nnoremap S i_<Esc>r

" Make the previous word UPPER CASE
inoremap <C-u> <esc>hviwUel

" Toggle line numbers
nnoremap <F9> :set invnumber<CR>

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
set rtp+=~/.vim/bundle/Vundle
call vundle#begin()
    Plugin 'Vundle'
    Plugin 'a'
    " Plugin 'AsyncCommand'
    Plugin 'AutoTag'
    Plugin 'ctrlp.vim'
    Plugin 'fugitive'
    Plugin 'Gundo'
    Plugin 'L9'
    Plugin 'nerdcommenter'
    Plugin 'nerdtree'
    Plugin 'rainbowparenthesis'
    Plugin 'repeat'
    Plugin 'scratch'
    Plugin 'snipMate'
    Plugin 'surround'
    Plugin 'tabular'
    Plugin 'taglist.vim'

    Plugin 'mystuff'
    Plugin 'mytypes'
    Plugin 'makefix'
    Plugin 'marks'
    " Plugin 'vim-airline'
call vundle#end()
filetype plugin indent on

" let g:airline_section_c = "%{MakefixStatusline('airline')}"

let g:gundo_prefer_python3 = 1

" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *memo set ft=memo
autocmd BufNewFile,BufRead kirjat set ft=kirjat
autocmd BufNewFile,BufRead *.scl set ft=scala
autocmd BufRead *.tab set ft=tab

" CtrlP
nnoremap <leader>scc :CtrlPClearCache<CR>

" Scratch buffer
comm! SC Scratch
comm! SCS split | Scratch
comm! SCV vsplit | Scratch

nnoremap <leader>st :TlistToggle<CR>

" NERDtree
let NERDTreeDirArrows = 0
nnoremap <leader>sn :NERDTreeToggle<CR>

" === Initialize ==============================================================
" Clear registers
let s:a = "abcdefghijklmnopqrstuvxwxyz0123456789\""
for i in range(0, len(s:a) - 1)
    exe 'let @' . s:a[i] . '= ""'
endfor
