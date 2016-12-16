function! jbox#ReadTags(taglist)
    echom ">>> jbox#ReadTags"
    let M = {}
    let M.fields = []
    let M.methods = []
    let M.classes = []
    let M.packages = []

    let NAME = ''
    let VISIBILITY = 'public'
    let TYPE = ''
    let FILE = ''
    let STATIC = ''
    let CLASS = ''
    let SIGNATURE = ''
    let IMPLEMENTS = ''
    let EXTENDS = ''
    let SUBTYPES = ''

    let P_FIELD=[NAME, FILE, VISIBILITY, TYPE, CLASS]
    let P_METHOD=[NAME, FILE, VISIBILITY, TYPE, CLASS, SIGNATURE]
    let P_CLASS=[NAME, FILE]
    let P_PACKAGE=[NAME, FILE]

    for tag in a:taglist
        if tag.filename[-5:] != '.java'
            continue
        endif

        let k = tag.kind
        if (k == 'f')
            let m = copy(P_FIELD)
            let m[0] = tag.name
            let m[1] = tag.filename
            let m[2] = substitute(tag.cmd, '.*\(private\|protected\|public\)\|.*', '\1', '')
            let m[3] = substitute(tag.cmd, '.*\(\s*\|const\|final\|static\|volatile\|private\|protected\|public\|synchronized\|transient\)\s*\(\w*\>\)\|.*\|.*', '\2', '')
            if has_key(tag, 'class') | let m[4] = tag.class | endif
            call insert(M.fields, m)
        elseif (k == 'm')
            let m = copy(P_METHOD)
            let m[0] = tag.name
            let m[1] = tag.filename
            let m[2] = substitute(tag.cmd, '.*\(private\|protected\|public\)\|.*', '\1', '')
            let m[3] = substitute(tag.cmd, '.*\(\s*\|const\|final\|static\|volatile\|private\|protected\|public\|synchronized\|transient\)\s*\(\w*\>\)\|.*\|.*', '\2', '')
            if has_key(tag, 'class') | let m[4] = tag.class | endif
            if has_key(tag, 'signature') | let m[5] = tag.signature | endif
            call insert(M.methods, m)
        elseif (k == 'c')
            let m = copy(P_CLASS)
            let m[0] = tag.name
            let m[1] = tag.filename
            call insert(M.classes, m)
        elseif (k == 'p')
            let m = copy(P_PACKAGE)
            let m[0] = tag.name
            let m[1] = tag.filename
            call insert(M.packages, m)
        endif
    endfor

    echom ">>> jbox#ReadTags (end)"
    return M
endfunction

function! jbox#ProcessM(M)
    echom ">>> jbox#ProcessM"
    let M = a:M
    let N = {}
    let file2package = {}
    let N.class2packages = {}
    let N.package2classes = {}
    let N.pkgclass2fields = {}

    echom ">>> >>> build package index"
    for package in M.packages
        let file2package[package[1]] = package[0]
    endfor
    echom ">>> >>> build class index"
    for class in M.classes
        let name = class[0]
        if has_key(file2package, class[1])
            let pkg = file2package[class[1]]
        else
            let pkg = substitute(class[1][:-6], '\/', '.', 'g')
        endif

        while 1
            if !has_key(N.package2classes, pkg)
                let N.package2classes[pkg] = [name]
            else
                call insert(N.package2classes[pkg], name)
            endif
            if !has_key(N.class2packages, name)
                let N.class2packages[name] = [pkg]
            else
                call insert(N.class2packages[name], pkg)
            endif

            if (name =~# '\.')
                let pkg = pkg . '.' . substitute(name, '\..*', '', '')
                let name = substitute(name, '[^\.]*\.', '', '')
            else
                break
            endif
        endwhile
    endfor

    let NAME = ''
    let VISIBILITY = ''
    let TYPE = ''
    let SIGNATURE = ''

    let P_FIELD=[NAME, VISIBILITY, TYPE]
    let P_METHOD=[NAME, VISIBILITY, TYPE, SIGNATURE]

    echom ">>> >>> build field index"
    for field in M.fields
        " (line 53 from function)Here's an error:  key not present in dictionary
        if !has_key(file2package, field[1])
            continue
        endif
        let pkg = file2package[field[1]]
        let class = field[4]
        let pkgclass = pkg . '.' . class

        let newField = copy(P_FIELD)
        let newField[0] = field[0]
        let newField[1] = field[2]
        let newField[2] = field[3]
        if has_key(N.pkgclass2fields, pkgclass)
            call insert(N.pkgclass2fields[pkgclass], newField)
        else
            let N.pkgclass2fields[pkgclass] = newField
        endif
    endfor

    echom ">>> >>> build method index"
    for field in M.methods
        if !has_key(file2package, field[1])
            continue
        endif
        let pkg = file2package[field[1]]
        let class = field[4]
        let pkgclass = pkg . '.' . class

        let newField = copy(P_METHOD)
        let newField[0] = field[0]
        let newField[1] = field[2]
        let newField[2] = field[3]
        let newField[3] = field[5]
        if has_key(N.pkgclass2fields, pkgclass)
            call insert(N.pkgclass2fields[pkgclass], newField)
        else
            let N.pkgclass2fields[pkgclass] = newField
        endif
    endfor

    echom ">>> jbox#ProcessM (end)"
    return N
endfunction

function jbox#j()
    let tags = taglist('.*')
    let M = jbox#ReadTags(tags)
    return jbox#ProcessM(M)
endfunction
