" This module gives a feature to save a snapshot of a file and compare with diff
" current buffer to the snapshot. The file must have been saved as file
" beforehand.


" Location for saved snapshots. Each snapshots will have the name of hashed full
" path.
let s:snapshots_location = '/tmp'
let s:unique_pid_of_vim_process = getpid()
let s:buffer_counter = 1

" This module uses following buffer-local variables
" let b:unique_id = 0
" let b:snapshot_file = ''
" let b:temporary_file = ''


" Location of the snapshot for given buffer
function! s:snapshot_location(buffer_hash)
    return printf('%s/vimbox.snap.%s', s:snapshots_location, a:buffer_hash)
endfunction

" Location of temporary file that is used to diff to snapshot
function! s:temporary_location(buffer_hash)
    return printf('%s/vimbox.diff.%s', s:snapshots_location, a:buffer_hash)
endfunction


" Get absolute path of a given buffer. Throw if buffer doesn't have a file.
function! s:buffer_filepath(buffer_nr)
    if !bufexists(a:buffer_nr)
        throw 'Bug: Buffer does not exists'
    endif

    " @Note: This is an idiotic way to get filepath to another buffer. Find
    " out if there's a real function to get it.
    " @Note: Changing the buffer with the command 'buffer %d', if the buffer
    " has a file attached to it, the file is written again. Auto-writing might
    " be an settining in vim.
    " @Todo: Find out how to disable auto-write.
    let current_buffer = bufnr()
    let change_another_buffer = printf('buffer %d', a:buffer_nr)
    let change_current_buffer = printf('buffer %d', current_buffer)
    exec change_another_buffer
    let path = expand('%:p')
    exec change_current_buffer
    return path
endfunction


" Hash that represent the buffer uniquely. Can be used as filename for snapshots. If the buffer
" is saved to a file, it will stay the same after re-starting vim.
function! s:buffer_hash(buffer_nr)
    if exists('b:unique_id')
        return b:unique_id
    endif

    let path = s:buffer_filepath(a:buffer_nr)
    let no_filepath = empty(path)

    if no_filepath
        " If the buffer doesn't have a file, create the hash from vim PID and
        " a running counter. Not persistent after vim closes.
        let b:unique_id = s:hash(printf('%s-%s', s:unique_pid_of_vim_process, s:buffer_counter))
        let s:buffer_counter = s:buffer_counter + 1
    else
        " Persistent for closing vim.
        let b:unique_id = s:hash(printf(path))
    endif

    return b:unique_id
endfunction


" Md5sum for strings
function! s:hash(input)
    let cmd = printf('echo "%s" | md5 | tr -s " " | cut -f1 -d" "', a:input)
    return systemlist(cmd)[0]
endfunction


function! CreateSnapshot()
    let buffer_hash = s:buffer_hash(bufnr())
    let snapshot_path = s:snapshot_location(buffer_hash)
    call writefile(getline(1,'$'), snapshot_path)
endfunction


function! CompareToSnapshot()
    let buffer_hash = s:buffer_hash(bufnr())
    let snapshot_path = s:snapshot_location(buffer_hash)
    let temporary_path = s:temporary_location(buffer_hash)

    if filereadable(snapshot_path)
        call writefile(getline(1,'$'), temporary_path)

        let diff = systemlist(printf('diff -aur %s %s', snapshot_path, temporary_path))
        echo join(diff, "\n")
        " @Todo: remove file in temporary_path here
    else
        echo 'No snapshots'
    endif
endfunction

