if !exists('g:z_java')
    let g:z_java = 1
else
    finish
endif

ia sout System.out.println();<LEFT><LEFT>
ia eamo EasyMock
ia pw PowerMock
ia epel expectLastCall()
ia cmo createMock
ia ane andReturn

inoremap <c-g>n <ESC>^yW$A = new <c-r>"<BS>();
inoremap <c-g>pn <ESC>^yW$A = PowerMock.createMock(<c-r>"<BS>.class);
inoremap <c-g>en <ESC>^yW$A = EasyMock.createMock(<c-r>"<BS>.class);

function! GlobSelection(search)
    let files = split(glob(a:search))
    if len(files) == 0
        return ''
    elseif len(files) == 1
        return files[0]
    else
        let i = 1
        for file in files
            echo printf("%2d) %s", i, file)
            let i = i + 1
        endfor
        let sel = input("Select file. ")
        try
            return files[sel-1]
        endtry
    endif

endfunction

function! FindPackageByClassName(search)
    let file = GlobSelection(a:search)
    if empty(file) || !filereadable(file)
        return ''
    endif

    for line in readfile(file)
        if (line =~ "^package")
            return substitute(line, '^package *\(.*\);$', '\1', '')
        endif
    endfor
    return ''
endfunction

function! DoImport(class)
    let s = '**/'.a:class.'.java'
    let pkg = FindPackageByClassName(s)
    let line = printf('import %s.%s;', pkg, a:class)
    if empty(pkg)
        echo 'Package not found'
        return
    endif
    if search(line, 'n') > 0
        echo "Already imported"
        return
    endif

    let ln = search('^import ', 'n')
    call append(ln, line)
endfunction

nnoremap <F3> :call DoImport(expand("<cword>"))<CR>

function! GetPackage()
    let pwd=expand("%:p")
    let s = substitute(pwd, '.*/src/\(.*\)/\w*\.java', '\1', '')
    let s = substitute(s, '/', '.', 'g')
    return s
endfunction

function! GetClass()
    let ln = search('^\w.*class *\(\w*\)', 'n')
    return substitute(getline(ln), '^\w.*class *\(\w*\).*', '\1', '')
    l
endfunction

function! TestFilepath()
    let p=expand("%:p")
    let s=substitute(p, '/src/', '/src-test/', '')
    return substitute(s, '\.java$', 'Test.java', '')
endfunction

let s:tmpl= expand("<sfile>:h:h").'/extra/javatest-template.java'
let s:tmpl2= expand("<sfile>:h:h").'/extra/javatest-request.java'

function! CreateTestFile(...)
    let tmpl = s:tmpl
    if (a:0 == 1 && a:1 == '-r')
        let tmpl = s:tmpl2
    endif

    let lines = readfile(tmpl)
    let lines2 = []
    let pack = GetPackage()
    let class = GetClass()
    let path = TestFilepath()

    for ln in lines
        let l = substitute(ln, '${package}', pack, 'g')
        let l = substitute(l, '${class}', class, 'g')
        call insert(lines2, l, len(lines2))
    endfor

    exe "sp " path
    if !filereadable(path)
        call append(0, lines2)
    endif
endfunction


comm! -nargs=? MkTest call CreateTestFile(<f-args>)
