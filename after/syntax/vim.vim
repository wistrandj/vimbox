syntax region vimFoldFunc
\    start="function"
\    end="endfunction"
\    keepend
\    transparent
\    fold

set foldmethod=syntax

set foldtext=MyFoldText()
function! MyFoldText()
  let line = foldtext()
  let sub = substitute(line, ' SECTION', '', 'g')
  return v:folddashes . sub
endfunction
