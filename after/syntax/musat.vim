" Comment
syn match SpecialKey "^#.*$"

" Genres
syn match Statement "^[a-zA-Z0-9 ]*:$"

" Songs
syn match Include " - .*$"ms=s+2

" Artists
syn match Identifier "^    .* -"me=e-2
syn match Identifier "^    [^-]*$"

" Links
syn match Statement "^        [^ ]\{-}\(www\).*$"
