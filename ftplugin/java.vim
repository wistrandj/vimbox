call matchadd("_warn", ")$")

set omnifunc=javabox#JavaInsertCompletion
inoremap <buffer> <C-x>j <C-R>=javabox#JavaInsertCompletion()<CR>
nnoremap <buffer> <leader><leader>r :set ft=java<CR>
nnoremap <buffer> <F5> :edit<CR>

" Public interface: mappings and commands
setlocal makeprg=mvn\ -q\ -e

ia <buffer> E Exception
ia <buffer> eamo EasyMock
ia <buffer> cemo createMock
ia <buffer> ecemo EasyMock.createMock
ia <buffer> epe expect
ia <buffer> eepel expectLastCall
ia <buffer> sse assertEquals();<LEFT><LEFT>
ia <buffer> sss assertSame();<LEFT><LEFT>
ia <buffer> sst assertTrue();<LEFT><LEFT>
ia <buffer> ssf assertFalse();<LEFT><LEFT>
ia <buffer> pwane PowerMock.expectLastCall().andReturn(
ia <buffer> epel expectLastCall()

nnoremap <buffer> <leader>mr :!mvn exec:java -Dexec.mainClass=ohtu.laskin.Main<CR>
nnoremap <buffer> <leader>mm :call JavaClean()<CR>
nnoremap <buffer> <leader>mi :call JavaIntegrationTest()<CR>
nnoremap <buffer> <leader>mc :call JavaCompile()<CR>
nnoremap <buffer> <leader>mC :call JavaCobertura()<CR>
nnoremap <buffer> <leader>mt :call JavaTest()<CR>

if exists("s:loaded")
    finish
endif | let s:loaded = 1

command Init call s:InitClassOrTest()
command Mktest call s:MakeTestFile()
command -narg=1 -complete=file Add :call javabox#Cmd_AddJarFileToIndex(<f-args>)
command -narg=1 PKG :echo javabox#Cmd_GetPackage(<f-args>)
command -narg=1 ATT :echo javabox#Cmd_GetAttributes(<f-args>)

let s:indexFile = expand('$HOME/.vimskel/java_index/index.dat')
command SaveIndex :echo javabox#Cmd_SaveIndex(s:indexFile)
command LoadIndex :echo javabox#Cmd_LoadIndex(s:indexFile)


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


function GetDefaultPackage()
    let files=split(system("find src/main/ -name '*.java'"))
    if empty(files)
        return ""
    endif
    let first = files[0]
    return substitute(first, "\/[^\/]*", "", "")
endfunction

" Private functions
function s:InitClassOrTest()
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
endfunction

function s:MakeTestFile()
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
endfunction

function s:GetPathFromPackageAndClass(pkg, class)
    " Return a path to given class
    "   pkg = ohtu.laskin
    "   class = Main
    "   => src/main/ohtu/laskin/Main.java
    let rest = substitute(a:pkg, "\\.", "\/", "g")
    return "src/main/" . rest . "/" . a:class . ".java"
endfunction

function s:GetPackageFromPath(path)
    let pkg = substitute(a:path, ".*/java/", "", "g")
    let pkg = substitute(pkg, "\/[^/]*$", "", "")
    return substitute(pkg, "/", ".", "g")
endfunction

function s:GetClassFromPath(path)
    let class = substitute(a:path, ".*/", "", "")
    return substitute(class, "\.java$", "", "")
endfunction

function s:IsEmptyFile()
    return line('$') == 1 && len(line('$')) == 1
endfunction

" ------------------------------------------------------------------------------
" MAVEN functionality
" - depends on VIM plugin AsyncCommand

function JavaTest()
    :AsyncMake test
    echo "Testing..."
endfunction

function JavaClean()
    " FIXME make AsyncCommand to print DONE when it's done
    let clean_cmd = &makeprg . " clean"
    call asynccommand#run(clean_cmd)
    echo "Cleaning..."
endfunction

function JavaCompile()
    :AsyncMake compile
    echo "Compiling..."
endfunction

function JavaCobertura()
    call asynccommand#run("mvn cobertura:cobertura; luakit target/site/cobertura/index.html")
    echo "Calculating line coverage"
    " TODO open the target site in luakit
endfunction

function JavaIntegrationTest()
    " With current output it's not clear if there is any errors
    :AsyncMake integration-test
    echo "Running integration-tests"
endfunction
