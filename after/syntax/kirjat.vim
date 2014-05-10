
nnoremap <leader><leader>r :set ft=kirjat<CR>

syn match Constant "^\s\+[A-Z]\+$"
syn match Statement "^[a-z]\+"
syn match MoreMsg "^[a-z]\+ [0-9]\{4\}"
syn match Statement "kesäkuu"
syn match Statement "heinäkuu"

syn match Identifier "    .* -"me=e-2
syn match Include " - .*$"ms=s+2

