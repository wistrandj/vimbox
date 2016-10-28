

let s:conffile = "$HOME/.vim_abbrev"

function! ReadConfigFile(file, pwd)
    for line in readfile(file)
        let [path, mode, keys, vals] = split(line, ':')
        if (pwd =~ file)
            exe mode."abbrev ".keys." ".vals
        endif
    endfor
endfunction

function! SaveAbbrevs(file)
    redir @b
    iabbrev
    let output = split(getreg("b"), '\n')
    let pwd=getcwd('.')
    for line in output
        let [mode, keys, vals] = split(line)
    endfor
endfunction
