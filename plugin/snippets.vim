let s:vimbox_snippets_folder = expand('$HOME') . '/.vim/bundle/vimbox/snippets'

if !isdirectory(s:vimbox_snippets_folder)
    " echom 'No snippets folder ' . s:vimbox_snippets_folder
    finish
endif

function s:OpenSnippetsTemplate(line1, line2)
    " @Idea: Add an autocommand for this new buffer to load new snippets if
    " the plugin does not handle it.
    let filetype = &filetype
    let snippet_file = s:vimbox_snippets_folder . '/' . filetype . '.snippets'
    execute 'edit ' . snippet_file
    if !filereadable(snippet_file)
        echom 'New snippet file for filetype ' . filetype
    endif
endfunction

command Temp call Template()

