
comm! Load call UpdateSettings()

comm! Test call TestSettings()
fun! TestSettings()
    call system('nohup urxvt -hold -e bash -c "vim /home/jasu/src/bin/anime/src/common.c" &> /dev/null &')
endfun

autocmd BufWritePost <buffer> silent call UpdateSettings()
autocmd VimLeave <buffer> call UpdateSettings()
fun! UpdateSettings()
    silent call system("xrdb -all ~/.Xresources")
    if v:shell_error
        echoerr "There was an error with .Xdefaults"
    else
        echom "Settings reloaded!"
    endif
endfun

