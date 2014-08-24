" file type: Chuck

nn <buffer> <leader>mr :call <SID>play_this_file()<CR>
nn <buffer> <leader>mR :call <SID>play_this_file_background()<CR>
nn <buffer> <leader>mk :call <SID>kill_chuck()<CR>

nn <buffer> <F5> :%!wget $(xsel -p) -O - 2> /dev/null<CR>

command! Numb :%s/^\ze\.[0-9]/0/ | :%s/[^0-9]\zs\ze\.[0-9]/0

fun! s:play_this_file()
    exe "!chuck " . bufname('%')
endfun

fun! s:play_this_file_background()
    exe "!chuck " . bufname('%') . " &> /dev/null&"
endfun

fun! s:kill_chuck()
    exe "!killall chuck"
endfun

