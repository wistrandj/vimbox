hi _type ctermfg=cyan
syn match _type "\<[A-Z][A-Za-z0-9]*\>\ze[^\.]"
syn match _type "\<[A-Z][A-Za-z0-9]*\>\ze$"

hi _functioncall ctermfg=blue
syn match _functioncall "\<[a-z][A-Za-z0-9]*\>\ze("

" EasyMock
hi _easymock ctermfg=gray
syn match _easymock "EasyMock"
syn match _easymock "EasyMock\.expect\w*"
syn match _easymock "andReturn"
syn match _easymock "andThrow"
