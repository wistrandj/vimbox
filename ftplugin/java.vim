
if exists("s:loaded")
    finish
endif | let s:loaded = 1

setlocal makeprg=mvn\ -q\ -e

" Maven error format
setlocal errorformat=
     \[ERROR\]\ %f:[%l\\,%v]\ %m,
     \%-G%.%#INFO%.%#,
     \%-G%.%#at\ org%.junit%.%#,
     \%-G%.%#at\ org%.apache%.%#,
     \%-G%.%#at\ org%.codehouse%.%#,
     \%-G%.%#at\ sun%.reflect%.%#,
     \%-G%.%#at\ java%.lang%.%#,
     \%-G%.%$,
     \%+G%.%#at\ %m(%f:%l)

