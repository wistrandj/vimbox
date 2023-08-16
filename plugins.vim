XPlugin 'VundleVim/Vundle.vim'

XPlugin 'godlygeek/tabular'
XPlugin 'scrooloose/nerdcommenter'
XPlugin 'scrooloose/nerdtree'
XPlugin 'tpope/vim-repeat'
XPlugin 'tpope/vim-surround'

" XPlugin 'wistrandj/vimbox'

if !empty(system("which fzf"))
    XPlugin 'junegunn/fzf'
    XPlugin 'junegunn/fzf.vim'
else
    XPlugin 'kien/ctrlp.vim'
endif

if v:true
    " Snipmate depends on vim-addon-mw-utils and tlib_vim. It does not contain
    " any snippets by default. They recommend to use 'honza/vim-snippets' to
    " include some common snippets for various languages.
    XPlugin 'MarcWeber/vim-addon-mw-utils'
    XPlugin 'tomtom/tlib_vim'
    " Note: SnipMate complains about deprecating legacy parser.
    " This options sets it to use new parser.
    let g:snipMate = { 'snippet_version' : 1 }
    XPlugin 'garbas/vim-snipmate'
endif

if v:false
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

    if !empty(system("which git"))
        XPlugin 'airblade/vim-gitgutter'
    endif

endif
