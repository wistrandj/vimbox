" Public interface: mappings and commands
setlocal makeprg=mvn\ -q\ -e

if exists("s:loaded")
    finish
endif | let s:loaded = 1

" Maven error format
set errorformat=
     \[ERROR\]\ %f:[%l\\,%v]\ %m,
     \%-G%.%#INFO%.%#,
     \%-G%.%#at\ org%.junit%.%#,
     \%-G%.%#at\ org%.apache%.%#,
     \%-G%.%#at\ org%.codehouse%.%#,
     \%-G%.%#at\ sun%.reflect%.%#,
     \%-G%.%#at\ java%.lang%.%#,
     \%-G%.%$,
     \%+G%.%#at\ %m(%f:%l)

