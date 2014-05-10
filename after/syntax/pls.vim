
nnoremap --r :set ft=pls<CR>

syn keyword Question [playlist]
syn keyword Constant NumberOfEntries
syn match Statement "File[0-9]\+"
syn match Statement "Title[0-9]\+"

syn match Function "http.*"
" syn match SpecialKey "=.*"me=e+1
