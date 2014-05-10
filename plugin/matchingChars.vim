inoremap <expr> ( matchingChars#InsertLeftParenthesis("(")
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<esc>ko

inoremap <expr> ) matchingChars#InsertRightParenthesis(")")
inoremap <expr> ] matchingChars#InsertRightParenthesis("]")
inoremap <expr> } matchingChars#InsertRightParenthesis("}")

inoremap <expr> " matchingChars#InsertQuote("\"")
" inoremap <expr> ' matchingChars#InsertQuote("\'")

imap <expr> <BS> matchingChars#RemoveSomething()
