" Module to open the filetype's snippet file quickly.
"

let s:vimbox_snippets_folder = expand('$HOME') . '/.vim/bundle/vimbox/snippets'

if !isdirectory(s:vimbox_snippets_folder)
    " echom 'No snippets folder ' . s:vimbox_snippets_folder
    finish
endif

function s:OpenSnippetsTemplate()
    " @Idea: Add an autocommand for this new buffer to load new snippets if
    " the plugin does not handle it.
    let filetype = &filetype
    let snippet_file = s:vimbox_snippets_folder . '/' . filetype . '.snippets'
    let new_file = v:false

    if !filereadable(snippet_file)
        let new_file = v:true
    endif

    wincmd s
    execute 'edit ' . snippet_file
    wincmd K
    resize 15

    if new_file
        echom 'New snippet file for filetype ' . filetype
    endif
endfunction

command Temp call <SID>OpenSnippetsTemplate()

