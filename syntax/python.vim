syn match _python_string "'[^']*'"
syn match _python_string '"[^"]*"'
syn match _python_string '"""'
syn match _python_string "'''"
syn match _python_comment '#.*$'
syn match _python_comment '@[a-zA-Z][a-zA-Z0-9]*'
syn keyword _python_keyword_1 def class
syn keyword _python_keyword_2 if elif else while for in not import from as lambda return break continue try except
