" There are files in specific folders using Zettelkasten naming rules. They
" do not have any extension and so cannot be detected with vim's filetype
" detection. This module checks each file if they match this criteria.


" Files matching the regular (e.g. 184a1...) expression in these folders
" will have the filetype 'zknotes'.
let s:daily_notes_directories = [ expand('/home/$USER/timeline/zk') ]


function s:PersonalNotesAreZknotes()
    let directory = expand('%:p:h')
    let filename = expand('%:t')

    let is_correct_dir = (index(s:daily_notes_directories, directory) >= 0)
    let has_date_number_in_filename = (filename =~ '^[0-9]\+\([a-z][0-9]*\)*$')

    if is_correct_dir && has_date_number_in_filename
        set filetype=zknotes
    endif
endfunction

autocmd BufRead,BufNew,BufNewFile * call s:PersonalNotesAreZknotes()

