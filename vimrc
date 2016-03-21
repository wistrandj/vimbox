" === Variables ===============================================================
filetype off " for V_undle
syntax on

" Use these keys for mappings
map - <nop>
map + <nop>
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
" set t_Co=8
set confirm
set hidden
set autowrite
autocmd BufRead help set readonly

" View
set display=lastline
set lazyredraw      " don't redraw while macro execution
set list            " show ws as visible char
set listchars=tab:>\ ,trail:·
set noshowmode
set scrolloff=2     " Keep a few lines always visible around cursor
set breakindent
set showbreak=^
set splitright
" set ttyfast
set wildmenu
set wildmode=list:longest,full
set conceallevel=2
if has("gui_running")
    colorscheme molokai
endif

set laststatus=2
set statusline=%!statusline#StatusLineFunction()

set showmatch
set matchtime=2

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
nnoremap <CR> ``

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
function! s:JumpInView(f)
    let top = line('w0') + &scrolloff
    let bottom = line('w$') - &scrolloff
    let line = top + float2nr(a:f * (bottom - top))
    let pos = getcurpos()
    let pos[1] = line
    call setpos('.', pos)
endfunction
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
nnoremap <C-g> g;

" Search and replace
nnoremap <leader><space> :set invhls<CR>
function! s:Gstar()
    let s = '\<' . expand("<cword>") . '\>'
    let s = fnameescape(s)
    exe 'let @/ = "' . s . '"'
    set hls
endfunction
nnoremap g* :call <SID>Gstar()<CR>
function! s:ReplaceWord(type)
    let pat = escape(tolower(expand(a:type)), '*+/')
    call feedkeys(':%s/\<' . pat . '\>/')
endfunction
nnoremap cgw :call <SID>ReplaceWord('<cword>')<CR>
nnoremap cgW :call <SID>ReplaceWord('<cWORD>')<CR>

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

" Make the previous word UPPER CASE
inoremap <C-u> <esc>hviwUel

" Toggle line numbers
nnoremap <F9> :set invnumber<CR>

" Align with Tabular plugin
vnoremap <leader>ta :Tabular /

" Invert hilight of column 80
nnoremap \hc :call InvHLcol80()<CR>
function! InvHLcol80()
    if exists("s:hlcol80")
        call matchdelete(s:hlcol80)
        unlet s:hlcol80
    else
        let s:hlcol80 = matchadd('DiffChange', '\%81v', 100)
    endif
endfunction

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
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
    Plugin 'Vundle'
    Plugin 'a'
    Plugin 'ctrlp.vim'
    Plugin 'Gundo'
    Plugin 'L9'
    Plugin 'nerdtree'
    Plugin 'nerdcommenter'
    Plugin 'repeat'
    Plugin 'scratch'
    Plugin 'snipMate'
    Plugin 'surround'
    Plugin 'tabular'
    Plugin 'gitgutter'
    " Plugin 'syntastic'
    Plugin 'OmniCppComplete'
    Plugin 'neomake'
    " Plugin 'vim-autotags'

    " My plugins
    Plugin 'makefix'
    Plugin 'marks'
    Plugin 'vimbox'
    Plugin 'mytypes'
    Plugin 'ass-inspector'
    Plugin 'viewtag'
    Plugin 'vic'
    Plugin 'touchtags'
    Plugin 'mycolors'
    Plugin 'Z'
call vundle#end()
filetype plugin indent on

" Makefix
let g:makefix_highlight = 0
au BufRead *.tex call makefix#CustomFunction(function('makefix#misc#LatexNoOverfullHbox'))

" Surround
let g:surround_no_insert_mappings = 1

" Ggundo
let g:gundo_prefer_python3 = 1
nnoremap <leader>pG :GundoToggle<CR>

" Filetypes
autocmd BufNewFile,BufRead *.story set ft=groovy
autocmd BufNewFile,BufRead *memo set ft=memo
autocmd BufNewFile,BufRead kirjat set ft=kirjat
autocmd BufNewFile,BufRead *.scl set ft=scala
autocmd BufRead *.tab set ft=tab

" CtrlP
comm! CR :CtrlPClearCache
au! FileWritePost :CtrlPClearCache

" Scratch buffer
comm! SC Scratch
comm! SCS split | Scratch
comm! SCV vsplit | Scratch

" NERDtree
let NERDTreeDirArrows = 0
nnoremap <leader>sn :NERDTreeToggle<CR>

" GitGutter
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0
let g:gitgutter_highlight_lines = 0
nnoremap <leader>pg :GitGutterSignsToggle<CR>

" Syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11'

" Ass-inspector
nnoremap <leader>as :call Ass_ShowAssembly()<CR>

" === Initialize ==============================================================
" Clear registers
let s:a = "abcdefghijklmnopqrstuvxwxyz0123456789\""
for i in range(0, len(s:a) - 1)
    exe 'let @' . s:a[i] . '= ""'
endfor

" FIXME Where these should be put? SignColumn hilight doesn't seem to be
" working
colorscheme elflord
hi SignColumn ctermbg=Black
hi Folded ctermfg=White ctermbg=Black


" === Debugging ===============================================================

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
comm! -nargs=1 Pretty call s:PrettyPrint_list(eval(<f-args>))

