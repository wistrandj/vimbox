if xplugin#Has('godlygeek/tabular')
    vnoremap <leader>ta :Tabular /
endif

if xplugin#Has('tpope/vim-surround')
    let g:surround_no_insert_mappings = 1
endif

if xplugin#Has('kien/ctrlp.vim')
    comm! CR :CtrlPClearCache
    au! FileWritePost :CtrlPClearCache
    let g:ctrlp_clear_cache_on_exit = 1
    let g:ctrlp_custom_ignore = {'dir': '\C\<target\>\|node_modules\|env'}
endif

if xplugin#Has('mtth/scratch.vim')
    comm! SC Scratch
    comm! SCS split | Scratch
    comm! SCV vsplit | Scratch
endif

if xplugin#Has('scrooloose/nerdtree')
    let g:NERDTreeStatusline = '---'
    let g:NERDTreeDirArrows = 0
    let g:NERDTreeIgnore = exists('g:NERDTreeIgnore') ? g:NERDTreeIgnore : []
    call insert(NERDTreeIgnore, '\.pyc')
    call insert(NERDTreeIgnore, '__init__\.py')
    nnoremap <leader>n :NERDTreeToggle<CR>
endif

if xplugin#Has('airblade/git-gutter')
    let g:gitgutter_map_keys = 0
    let g:gitgutter_realtime = 0
    let g:gitgutter_highlight_lines = 0
    nnoremap <leader>pg :GitGutterSignsToggle<CR>
endif

if xplugin#Has('vim-syntastic/syntastic')
    let g:syntastic_cpp_compiler_options = ' -std=c++11'
endif

if xplugin#Has('junegunn/fzf')
    nnoremap <c-p> :Files<CR>
    imap <c-x><c-f> <plug>(fzf-complete-path)
endif

