let s:ftplugin_html = printf('%s/html.vim', expand('<sfile>:h'))

if filereadable(s:ftplugin_html)
    exe printf('source %s', s:ftplugin_html)
    let g:VIMBOX_UNCLOSED_ELEMENTS = []
endif
