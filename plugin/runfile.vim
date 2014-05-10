
" PLUGIN:
" Runfile plugin allows you to run shell scripts and filter its output easily.
"
" The script can contain vim commands in comments. With these you can filter and
" modify output.
"
" NOTE:
" This depends on Output window plugin
"
" COMMANDS:
" <leader>r     Run current file and echo output
" <leader>R     Run current file and show its output in output window.
"
" AFTER COMMANDS:
" You can write filters, substitutions and other commands to run after the
" script.
"
" #<abc      remove lines with abc
" #>abc      remove lines that don't contain abc
" #s/abc/x   change every abc to x
" #:xxx      run ex command
"
" These commands are run in this order.
"
"
" TODO:
" - hide Run() and RunFileToOutput() methods with s:
" - add a command to insert to the top of the file: "#!/usr/bin/lua"
" - let the user specify comment type
"   - currently this reads after commands from #-comments


" ------------------------------------------------------------------------------
" Public

fun! Run()
    echo s:RunCurrentFile()
endfun

fun! RunFileToOutput()
    " NOTE: depends on outputbuffer.vim
    let out = s:RunCurrentFile()
    call OutputText(out)
    call s:RunAfterCommands()
endfun

" ------------------------------------------------------------------------------
" Private

fun! s:SaveTempFile()
    " TODO make an autocmd to delete created temporary file
    let file = expand("%:p")
    if !filewritable(file)
        let file = tempname()
    endif
    exe "normal! :write! " . file . "\<CR>"
    exe "normal! :file " . file . "\<CR>"
endfun


fun! s:RunCurrentFile()
    call s:SaveTempFile()
    let path = expand("%:p")

    if (!executable(path))
        call system("chmod +x " . path)
    endif

    return system(path)
endfunction

" ------------------------------------------------------------------------------
" After commands

fun! s:RunAfterCommands()
    let cmds = s:GatherAfterCommands("<")
    call s:FilterCommand("g", cmds)

    let cmds = s:GatherAfterCommands(">")
    call s:FilterCommand("v", cmds)

    let cmds = s:GatherAfterCommands("s/")
    call s:Substitute(cmds)

    let cmds = s:GatherAfterCommands(":")
    call s:RunExplicitCommands(cmds)
endfun

fun! s:Substitute(patterns)
    call SwitchToOutputWindow()
    for pat in a:patterns
        silent exe "%s/" . pat
    endfor
    wincmd p
endfun
fun! s:FilterCommand(cmd, patterns)
    call SwitchToOutputWindow()
    for pat in a:patterns
        silent exe a:cmd . "/" . pat . "/d"
    endfor
    wincmd p
endfun

fun! s:RunExplicitCommands(cmds)
    call SwitchToOutputWindow()
    exe "normal! gg0"
    for cmd in a:cmds
        silent exe cmd
    endfor
    wincmd p
endfun

fun! s:GatherAfterCommands(pattern)
    let commands = []
    let metacmd = "substitute(getline('.'), '.*' . a:pattern, '', '')"
    let metacmd = "call insert(commands, " . metacmd . ")"
    silent exe "g/^#" . escape(a:pattern, "/") . "/" . metacmd
    call reverse(commands)
    return commands
endfun

