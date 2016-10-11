" Guard
if exists("g:java_loaded")
    finish
endif
let g:java_loaded = 1

nnoremap <leader><leader>r :set ft=java<CR>

" Public interface: mappings and commands
set makeprg=mvn\ -q\ -e
command! Init call s:InitClassOrTest()
command! Mktest call s:MakeTestFile()

ia E Exception
ia eamo EasyMock
ia cemo createMock
ia epe expect
ia epel expectLastcall
ia sse assertEquals();<LEFT><LEFT>
ia sss assertSame();<LEFT><LEFT>
ia sst assertTrue();<LEFT><LEFT>
ia ssf assertFalse();<LEFT><LEFT>

nnoremap <buffer> <leader>mr :!mvn exec:java -Dexec.mainClass=ohtu.laskin.Main<CR>
nnoremap <buffer> <leader>mm :call JavaClean()<CR>
nnoremap <buffer> <leader>mi :call JavaIntegrationTest()<CR>
nnoremap <buffer> <leader>mc :call JavaCompile()<CR>
nnoremap <buffer> <leader>mC :call JavaCobertura()<CR>
nnoremap <buffer> <leader>mt :call JavaTest()<CR>

" ------------------------------------------------------------------------------

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

fun! GetDefaultPackage()
    let files=split(system("find src/main/ -name '*.java'"))
    if empty(files)
        return ""
    endif
    let first = files[0]
    return substitute(first, "\/[^\/]*", "", "")
endfun

" Private functions
fun! s:InitClassOrTest()
    " Initialize the current empty file from templates.
    if !s:IsEmptyFile()
        return
    endif

    let file = expand("%")

    if stridx(file, "Test\.java") >= 0
        let template = "javatest"
    elseif stridx(file, "\.java") >= 0
        let template = "javaNewClass"
    else
        echoerr "This file may not be a java file"
        return
    endif

    let path = expand("%:p")
    exe "0r ~/.vim/templates/" . template
    exe "%s/#PACKAGE/" . s:GetPackageFromPath(path)
    exe "%s/#CLASS\/" . s:GetClassFromPath(path)
endfun

fun! s:MakeTestFile()
    " Create and initialize a test file for current java-file. The test file
    " is named ClassTest.java and it is placed in test/java/PKGPATH/.
    let path = expand("%")
    if stridx(path, "Test.java") >= 0 || stridx(path, ".java") == -1
        echoerr "You won't want to make test file for this one:" . path
        return
    endif

    let testpath = substitute(path, "src/main/", "src/test/", "")
    let testpath = substitute(testpath, "\.java$", "Test.java", "")
    exe "n " . testpath
    if empty(glob(expand("%:p:h")))
        " Folder doesn't exists
        call mkdir(expand("%:p:h"), "p")
    endif
    call InitClassOrTest()
endfun

fun! s:GetPathFromPackageAndClass(pkg, class)
    " Return a path to given class
    "   pkg = ohtu.laskin
    "   class = Main
    "   => src/main/ohtu/laskin/Main.java
    let rest = substitute(a:pkg, "\\.", "\/", "g")
    return "src/main/" . rest . "/" . a:class . ".java"
endfun

fun! s:GetPackageFromPath(path)
    let pkg = substitute(a:path, ".*/java/", "", "g")
    let pkg = substitute(pkg, "\/[^/]*$", "", "")
    return substitute(pkg, "/", ".", "g")
endfun

fun! s:GetClassFromPath(path)
    let class = substitute(a:path, ".*/", "", "")
    return substitute(class, "\.java$", "", "")
endfun

fun! s:IsEmptyFile()
    return line('$') == 1 && len(line('$')) == 1
endfun

" ------------------------------------------------------------------------------
" MAVEN functionality
" - depends on VIM plugin AsyncCommand

fun! JavaTest()
    :AsyncMake test
    echo "Testing..."
endfun

fun! JavaClean()
    " FIXME make AsyncCommand to print DONE when it's done
    let clean_cmd = &makeprg . " clean"
    call asynccommand#run(clean_cmd)
    echo "Cleaning..."
endfun

fun! JavaCompile()
    :AsyncMake compile
    echo "Compiling..."
endfun

fun! JavaCobertura()
    call asynccommand#run("mvn cobertura:cobertura; luakit target/site/cobertura/index.html")
    echo "Calculating line coverage"
    " TODO open the target site in luakit
endfun

fun! JavaIntegrationTest()
    " With current output it's not clear if there is any errors
    :AsyncMake integration-test
    echo "Running integration-tests"
endfun
