
" FIXME: there doesn't match with function declaration or implementation
" syn match Identifier "^[a-zA-Z].\{-}\zs[_a-zA-Z][_a-zA-Z0-9]*\ze("
" syn match Identifier "\(^ \|=\)\@!.\{-}\zs[a-zA-Z_][a-zA-Z0-9_]*\ze("

syn match Identifier "[_a-zA-Z0-9]\+\ze("
