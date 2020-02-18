if exists("b:did_ftplugin") && exists("b:current_ftplugin") && b:current_ftplugin == 'sql'
    finish
else
    " These variables prevents the annoying sql plugin from loading
    let g:loaded_sql_completion = 1
    let b:did_ftplugin = 1
    let b:current_ftplugin = 'sql'
endif

syn keyword sqlType numeric

