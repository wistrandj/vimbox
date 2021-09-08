" Assuming this file is early in loadpath, setting this
" buffer variable prevents default HTML plugins from loading.

let b:current_syntax = 'html'

hi html_comment ctermfg=darkred
hi html_bold ctermfg=green

" CSS Comments
syn match html_comment '\/\/.*'
syn region html_comment
            \ keepend
            \ start='\/\*'
            \ end='\*\/'

" HTML comments
syn match html_comment '<!--.*-->'

