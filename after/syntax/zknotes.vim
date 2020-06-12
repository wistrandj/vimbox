
hi _code ctermfg=grey
hi _hashed_title ctermfg=green
hi _hashed_title_2 ctermfg=cyan
hi _link_line ctermfg=blue
hi link _link_in_text _link_line
hi _first_line_date ctermfg=white
hi _link_to_other_file cterm=underline


syn clear

" syn match _code '^\s\s*[^-].*$'
syn match _hashed_title '^#[^#]*$'
syn match _hashed_title_2 '^##.*$'
syn match _link_line '^\[.*\]:.*$'
syn match _link_in_text '\[.*\](.*)'
syn match _link_to_other_file '@[0-9]\+\([a-z][0-9]*\)*'

syn match _first_line_date '\%1l[0-9]\{4\}-[0-9][0-9]-[0-9][0-9]'



