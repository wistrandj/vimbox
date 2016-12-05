let s:TmpFolder = '/tmp/tmpvimfilejar/'

function! javabox#ReadJavaFile(path)
    let package = ''
    let class = substitute(a:path, '.*\/\(\w*\).java', '\1' ,'')
    let attrs = []
    let fmtAttr = ['^\s*\(public\|private\|protected\)[^=(;]*\(\<\w*\>\)\s*\(;\|=\|(\).*', '^\s*\(\S*\)\s*\(\S*\)\(throws.*\)\?$']
    let fmtPackage = '^\s*package\s*\([0-9a-zA-Z\._]*\);$'
    for line in readfile(a:path)
        let found = 0
        for fmt in fmtAttr
            if (line =~# fmt)
                let found = 1
                let att = substitute(line, fmt, '\2', '')
                call insert(attrs, att)
            endif
        endfor
        if empty(package) && !found && (line =~# fmtPackage)
            let package = substitute(line, fmtPackage, '\1', '')
        endif
    endfor

    call sort(attrs)
    return [a:path, package, class, attrs]
endfunction

function! s:ReadJarFile(jarpath)
    " Read a .jar file and return a list of it's contents:
    "     [(file-name, java-package, class-name, attributes-and-methods)]
    " Four-tuple above is just a regular list
    if (a:jarpath[-4:] != '.jar') && !filereadable(a:jarpath)
        return []
    endif

    let name = substitute(a:jarpath, '.*/\(.*\)\.[^\.]*$', '\1', '')
    let tmp = printf("%s/%s", s:TmpFolder, name)
    if !isdirectory(tmp)
        call mkdir(tmp, 'p')
    endif
    call system(printf('unzip %s -d %s', a:jarpath, tmp))

    let ret=[]
    let pkg=''
    let class=''
    let attrs=[]
    for path in split(system(printf("find %s -iname '*.class'", tmp)))
        let pkg1 = substitute(path, printf('%s\/*\(.*\)\/[^\/]*.class', tmp), '\1', '')
        let pkg = substitute(pkg1, '\/', '.', 'g')
        let class1 = substitute(path, '.*\/\([^\/]*\).class', '\1', '')
        let class = substitute(class1, '\$', '.', 'g')
        if (class =~ '\.\d*$')
            continue " Skip anonymous classes
        endif
        let attrs=[]
        let path1 = fnameescape(path)
        for line in split(system(printf('strings %s | grep -v "[^a-zA-Z0-9_ ]" | sed "s/ //g"', path1)))
            call insert(attrs, line)
        endfor
        call reverse(attrs)
        call insert(ret, [a:jarpath, pkg, class, attrs])
    endfor
    return ret
endfunction

" === Index ===================================================================

let s:ClassInfoMeta = {}
let g:Meta = s:ClassInfoMeta
function! s:ClassInfoMeta.new(pkg, class, attributes)
    " info = (pkg, className, attributes)
    let obj = copy(s:ClassInfoMeta)
    call remove(obj, 'new')
    let obj.package = a:pkg
    let obj.class = a:class
    let obj.attributes = a:attributes
    return obj
endfunction

function s:ClassInfoMeta.NewInnerClassOrNil()
    if (self.class =~# '\.')
        let pkg = self.package . '.' . substitute(self.class, '\..*', '', '')
        let class = substitute(self.class, '[^\.]*\.', '', '')
        let attrs = self.attributes
        return s:ClassInfoMeta.new(pkg, class, attrs)
    else
        return 0
    endif
endfunction

let s:IndexMeta = {}
function! s:IndexMeta.new()
    let obj = copy(s:IndexMeta)
    let obj.mainIndex = []
    let obj.byClassName = {}
    call remove(obj, 'new')
    return obj
endfunction

function! s:IndexMeta._AddClassByName(class, info)
    if has_key(self.byClassName, a:class)
        call insert(self.byClassName[a:class], a:info)
    else
        let self.byClassName[a:class] = [a:info]
    endif
endfunction

function! s:IndexMeta.AddClass(pkg, fullClass, attrs)
    let info = s:ClassInfoMeta.new(a:pkg, a:fullClass, a:attrs)
    call insert(self.mainIndex, info)

    let info2 = info
    while type(info2) != type(0)
        call self._AddClassByName(info2.class, info)
        let info2 = info2.NewInnerClassOrNil()
    endwhile
endfunction

function! s:IndexMeta.GetClassInfo(className, package)
    if !has_key(self.byClassName, a:className)
        return []
    endif
    let infos = copy(self.byClassName[a:className])
    if !empty(a:package)
        let fullClassName = a:package .'.'. a:className
        call filter(infos, printf('%s.%s ==# fullClassName', v:val.package, v:val.class))
    endif
    return infos
endfunction

function! s:IndexMeta.GetPackages(className, package)
    let infos = self.GetClassInfo(a:className, a:package)
    return map(infos, 'v:val.package')
endfunction

function! s:IndexMeta.GetAttributes(className, package)
    let infos = self.GetClassInfo(a:className, a:package)
    return map(infos, 'v:val.attributes')
endfunction

function! s:IndexMeta.Save(filepath)
    " Save file as:
    "   org.package.path#Class.Inner#getFoo,setFoo
    "   org.package.path#Class#getFoo,setFoo
    let lines = []
    for info in self.mainIndex
        let pkg = info.package
        let class = info.class
        let attrs = info.attributes
        call insert(lines, join([pkg, class, join(attrs, ',')], '#'))
    endfor
    call writefile(lines, a:filepath)
endfunction

function! s:IndexMeta.Load(filepath)
    for line in readfile(a:filepath)
        let info = split(line, '#')
        if (len(info) < 2)
            echoerr 'Invalid java index file'
            return []
        endif

        let pkg = info[0]
        let class = info[1]
        let attrs = []
        if (len(info) >= 3)
            let attrs = split(info[2], ',')
        endif

        call self.AddClass(pkg, class, attrs)
    endfor
endfunction

" function! s:IndexMeta.OverwriteFrom(index)
"     for info in keys(index.byClassName)
"     endfor
" endfunction

" === Commands ================================================================

let s:Index = s:IndexMeta.new()
let g:Index = s:Index

function! javabox#Cmd_AddJarFileToIndex(jarPath)
    for info in s:ReadJarFile(a:jarPath)
        let [file, pkg, class, attrs] = info
        call s:Index.AddClass(pkg, class, attrs)
    endfor
endfunction

function! javabox#Cmd_AddJarFileToIndexRecursive(path)
    for file in split(system(printf("find %s -iname" '*.jar", a:path)))
        call javabox#Cmd_AddJarFileToIndex(file)
    endfor
endfunction

function! javabox#Cmd_ReadJavaFilesRecursively(path)
    for file in split(system(printf("find %s -iname '*.java'", a:path)))
        let [file, pkg, class, attrs] = javabox#ReadJavaFile(file)
        call s:Index.AddClass(pkg, class, attrs)
    endfor
endfunction

function! javabox#Cmd_GetPackage(className)
    let pkgs = s:Index.GetPackage(a:className)
    if empty(pkgs)
        return []
    endif
    return pkgs[0]
endfunction

function! javabox#Cmd_GetAttributes(className)
    let attrs = s:Index.GetAttributes(a:className, '')
    if empty(attrs)
        return []
    endif
    return attrs[0]
endfunction


function! javabox#Cmd_SaveIndex(path)
    let dir = substitute(a:path, '\/[^\/]*$', '', '')
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif
    call s:Index.Save(a:path)
endfunction

function! javabox#Cmd_LoadIndex(path)
    if !filereadable(a:path)
        return 0
    endif
    call s:Index.Load(a:path)
    return 1
endfunction

" === Competion ===============================================================

function! javabox#FindVariableDeclaration(name)
    " Return type name of variable a:name Eg. 'ArrayList<String>'
    " The a:name is supposed to be also under cursor so search works properly
    let m = ['\(\<\w\+\>\)\s*\<%s\>', '\(\<\w\+\><.*>\)\s*\<%s\>', '(.*\(\<\w\+\>\)\s*\<%s\>)', '(.*\(\<\w\+\><.*>\)\s*\<%s\>)']

    if (a:name == 'this')
        return substitute(expand('%'), '.*\/\(\w*\).java', '\1' ,'')
    endif

    let lineNr = -1
    let realPat = ''
    for pat1 in m
        let pat = printf(pat1, a:name)
        let line = search(pat, 'bnW')
        if (line != 0 && line > lineNr)
            let lineNr = line
            let realPat = pat
        endif
    endfor

    let type = ''
    if lineNr != -1
        let ln = getline(lineNr)
        let type = substitute(ln, '.*'.realPat.'.*', '\1', '')
    endif
    return type
endfunction



function! javabox#JavaInsertCompletion()
    let cword = substitute(getline('.')[:col('.')-2], '.* ', '', 'g')
    let variable = substitute(cword, '\..*', '', 'g')
    let attribute = substitute(cword, '.*\.', '', 'g')
    let type = javabox#FindVariableDeclaration(variable)
    let attrs = javabox#Cmd_GetAttributes(type)

    let completeList = attrs

    if !empty(attribute)
        let completeList = filter(copy(attrs), printf('v:val =~ "^%s"', attribute))
    endif

    call complete(col('.') - len(attribute), completeList)
    return ''
endfunction
