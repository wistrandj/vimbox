if exists('g:loaded_zig')
    finish
endif
let g:loaded_zig = 1

ia xself   const Self = @This()
ia xassert const assert = std.debug.assert
ia xstd    const std = @import("std")

nnoremap <expr> cM Zig__ChangeDirectory_ZigProject()
nnoremap <expr> cm Zig__ChangeDirectory_CurrentFile()

if filereadable('build.zig') && !exists('g:zigproject')
    let g:zigproject = expand('%:p:h')
endif

function Zig__ChangeDirectory_CurrentFile()
    const this_directory = expand('%:p:h')
    echom 'Current directory ' . this_directory
    exec printf('cd ' . this_directory)
endfunction

function Zig__ChangeDirectory_ZigProject()
    if exists('g:zigproject')
        exec printf('cd ' . g:zigproject)
    endif
endfunction
