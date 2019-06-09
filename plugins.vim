XPlugin 'VundleVim/Vundle.vim'

XPlugin 'godlygeek/tabular'
XPlugin 'mtth/scratch.vim'
XPlugin 'scrooloose/nerdcommenter'
XPlugin 'scrooloose/nerdtree'
XPlugin 'tpope/vim-repeat'
XPlugin 'tpope/vim-surround'

XPlugin 'jasu0/Z'

if !empty(system("which fzf"))
    XPlugin 'junegunn/fzf'
    XPlugin 'junegunn/fzf.vim'
else
    XPlugin 'kien/ctrlp.vim'
endif

if 1
    XPlugin 'MarcWeber/vim-addon-mw-utils'
    XPlugin 'tomtom/tlib_vim'
    XPlugin 'honza/vim-snippets'
    XPlugin 'garbas/vim-snipmate'
endif

if !empty(system("which git"))
    XPlugin 'airblade/vim-gitgutter'
endif

if 0
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
