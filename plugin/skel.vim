

let s:skel_folder = expand("$HOME/.vimskel/")
let s:this_folder = expand("<sfile>:h:h") . "/resources/skel/"

function! s:SelectFile(files)
    return a:files[0]
endfunction

function! s:FoldersToSearch(realft)
    let a = printf('%s/%s', s:skel_folder, a:realft)
    let b = printf('%s/%s', s:this_folder, a:realft)
    return [a,b]
endfunction

function! s:FindExistingSkeletonFile(name, ft)
    let dirs = s:FoldersToSearch(a:ft)
    let file = []
    let g = ''
    for f in dirs
        let g = glob(f . '/' . a:name . '*')
        if empty(g)
            continue
        else
            break
        endif
    endfor

    if empty(g)
        return ''
    endif

    return s:SelectFile(split(g))
endfunction

function! s:NewSkeletonFile(name)
    let [realname, realft] = s:Userdata(a:name, &ft)
    let dir = s:skel_folder
    if !empty(realft)
        let dir = printf('%s/%s', s:skel_folder, realft)
    endif

    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif

    exe printf('vsp %s/%s', dir, realname)
endfunction


function! s:ReadSkeletonFile(...)
    let [name, ft] = s:Userdata(a:1, &ft)
    let args = a:000[1:]
    echom "name = " . name
    echom "ft = " . ft
    echom "args = " . string(args)

    let file = s:FindExistingSkeletonFile(name, ft)
    if !empty(file)
        let deleteEmptyline = empty(getline('.'))
        call append('.', s:ReplaceUserArguments(readfile(file), args))
        exe 'set ft='.ft
        if (deleteEmptyline)
            normal! dd
        endif
    endif
endfunction

function! s:Userdata1(name, ft)
    if (a:name =~# '\.[a-z]*$')
        return [a:name, substitute(a:name, '.*\.\([a-z]*\)$', '\1', '')]
    elseif !empty(a:ft)
        return [a:name.'.'.&ft, &ft]
    else
        return [a:name.'.'.a:name, a:name]
    endif
endfunction

function! s:Userdata(name, ft)
    let [name, ft] = s:Userdata1(a:name, a:ft)
    if (ft == 'py')
        let ft = 'python'
    endif
    return [name, ft]
endfunction

comm! -nargs=+ Skel call <SID>ReadSkeletonFile(<f-args>)
comm! -nargs=1 Skeln call <SID>NewSkeletonFile(<f-args>)



" =============================================================================
" === Postprocessing and user arguments =======================================
" =============================================================================

function! s:ReplaceUserArguments(lines, args)
    " XXX Func is not careful if replaced argument returns something with '$'
    let nargs = len(a:args)

    for i in range(len(a:lines))
        let line = a:lines[i]
        if (match(line, '\$') != -1)
            let n = substitute(line, '.*\$\(\d*\).*', '\1', '')
            if (empty(n) || (n-1) > nargs)
                continue
            endif
            let a:lines[i] = substitute(line, '\$'.n, a:args[n-1], '')
        endif
    endfor
    return a:lines
endfunction
