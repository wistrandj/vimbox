" NOTE: Vundle wants filetype off because ftdetect doesn't get sourced otherwise
filetype off
let g:VimboxLoaded = 1
set rtp+=$HOME/.vim/bundle/vimbox/
set rtp+=$HOME/.vim/bundle/Vundle.vim/
try | call xplugin#Available() | catch | let g:VimboxLoaded = 0 | endtry
command! -nargs=* VimboxL :if g:VimboxLoaded | exe <q-args> | endif


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

" === Plugins =================================================================
call vundle#begin()
    command! -nargs=1 XPlugin call xplugin#Load(<args>)
    call xplugin#Source(xplugin#VimboxPath() . '/plugins.vim')
    call xplugin#Source(glob('$HOME/.vimrc.plugins'))
    delcommand XPlugin
call vundle#end()
filetype plugin indent on

call xplugin#Source(xplugin#VimboxPath() . '/settings.vim')


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
VimboxL nmap gj <Plug>VimboxJumpInViewFwd
VimboxL nmap gk <Plug>VimboxJumpInViewBck

VimboxL nmap <c-w>gh <Plug>VimboxMinimizeWindowH
VimboxL nmap <c-w>gl <Plug>VimboxMinimizeWindowL
VimboxL nmap <c-w>gj <Plug>VimboxMinimizeWindowJ
VimboxL nmap <c-w>gk <Plug>VimboxMinimizeWindowK


" Visual
"
vnoremap > >gv
vnoremap < <gv
VimboxL nmap <leader>v <Plug>VimboxExpandVisualBlock
VimboxL nmap vi<TAB> <Plug>VimboxSelectIndention
VimboxL omap i<TAB> <Plug>VimboxSelectIndentionOperator


" Colors
"
if exists('*matchaddpos')
VimboxL nmap <silent> n <Plug>VimboxHLnextFwd
VimboxL nmap <silent> N <Plug>VimboxHLnextBck
endif
VimboxL nmap g/ <Plug>VimboxHlsobjSearch
VimboxL nmap g\ <Plug>VimboxHlsobjClear
VimboxL nmap g* <Plug>VimboxHlsobjStar
nnoremap <leader><space> :set invhls<CR>



" Insert & delete
"
function! s:ReplaceToInsertMode()
    return (mode() == 'R') ? "\<ESC>a" : "\<ESC>lR"
endfunction
nnoremap Y y$
nnoremap S i_<Esc>r
inoremap <expr> <c-l> <SID>ReplaceToInsertMode()
VimboxL nmap <leader>S <Plug>VimboxCommentSeparator
onoremap = :<C-U>normal! ^vf=gE<CR>
onoremap g= :<C-U>normal! ^f=wv$h<CR>

VimboxL nnoremap gp/ :QuickPaste / 
VimboxL nnoremap gp? :QuickPaste ? 

VimboxL nmap <leader>R <Plug>VerticalRDown

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

VimboxL comm! Snapw call CreateSnapshot()
VimboxL comm! Snap call CompareToSnapshot()

comm -bang -nargs=1 UndoWhile call <SID>UndoWhile(function('<SID>IsThere'), <bang>0, <f-args>)
comm -bang -nargs=1 UndoWhileNot call <SID>UndoWhile(function('<SID>IsNotThere'), <bang>0, <f-args>)

" === Functions ===============================================================

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

" Undo changes while there is/or not a piece of text on buffer
"
function s:IsThere(searchterm)
    return search(a:searchterm) > 0
endfunction

function s:IsNotThere(searchterm)
    return search(a:searchterm) == 0
endfunction

function s:UndoWhile(Stop, quick, searchterm)
    let steps = 0
    while 1
        if !a:Stop(a:searchterm)
            break
        endif
        normal! u
        let steps = steps + 1
        if !a:quick
            sleep 300m
            redraw
        endif
    endwhile
    echo "Stopped after " . steps . " steps"
endfunction


" === Initialize ==============================================================

call <SID>ScanTags()

if g:VimboxLoaded
    set statusline=%!statusline#StatusLineFunction()
    comm! Git      :call git#status()<CR>

    comm!          SyntaxItem :echo debug#GetSyntaxItemUnderCursor()
    comm! -nargs=1 Pretty call debug#PrettyPrint_list(eval(<f-args>))

    command! -nargs=? -range -bang -complete=customlist,sign#CommandCompletion Sign call sign#PlaceCommand(<line1>, <line2>, <bang>0, <f-args>)
endif

if filereadable(glob('$HOME/.vimrc.local'))
    exe 'source ' . glob('$HOME/.vimrc.local')
endif
