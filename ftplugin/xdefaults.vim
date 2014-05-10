
autocmd VimLeave <buffer> call UpdateSettings()
fun! UpdateSettings()
    call system("xrdb -all ~/.Xresources")
    echo "Settings reloaded"
endfun

