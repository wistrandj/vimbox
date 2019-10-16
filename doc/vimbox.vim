*vimbox.vim*	For Vim version 7.3	Last change: 2010 June 4

                                 VIMBOX MANUAL
1. Description                                              |vimbox-description|
2. Commands                                                 |vimbox-commands|
3. Mappings                                                 |vimbox-mappings|
4. Commands in vimrc                                        |vimbox-commands|
5. Autoload modules                                         |vimbox-autoload|
6. To do                                                    |vimbox-todo|

================================================================================
1. DESCRIPTION~
                                                            *vimbox-description*

Tell about:

    - $HOME/.vimrc - This can be used as standalone
    - $HOME/.vimrc.local
    - $HOME/.vimrc.plugins

Write help:

    - How to use tags with vim and :Tag command
    - ...

================================================================================
2. COMMANDS~
                                                               *vimbox-commands*

Commands that Vimbox provides

    - Sign
    - UndoWhile
    - Snap
    - SyntaxItem
    - Pretty

================================================================================
3. MAPPINGS~
                                                               *vimbox-mappings*

Mappings that Vimbox provides

    - <F9>  Show git status


================================================================================
4. Commands in vimrc
                                                               *vimbox-commands*

:Snapw
:Snap

Save a temporary snapshot of current buffer (:Snapw) and later compare the 'diff'
to it after modifications. Each buffer can have at most one snapshot. Command
md5sum is required.

:UndoWhile <pattern>

Execute undo (or hit the key 'u') while the given pattern exists in the document.
Helps to see what modifications the user did after certain point.

:UndoWhileNot <pattern>

Execute undo (or hit the key 'u') while the pattern does *not* exists in the
document.


================================================================================
5. Autoload modules
                                                               *vimbox-autoload*

5.1 autoload/info.vim

This module provides an helper command `Info`. It's purpose is to act as a
general command that shows some information about the current vim, it's
configuration and anything that cannot be in static help files.

Command:

    - :Info <title>

    This command provides autocompletion for all titles.

Functions:

    - info#Register(title, func)


5.2 autoload/sign.vim

Provides a command to place signs on the buffer. It has different colors for
to convey positive, negative or informatic signs.

Command:

    - :Sign <info|good|bad>

    Set a sign on current line in this buffer.

    - :Sign <delete|clear>

    Delete a sign on current line or clear all signs in current buffer.


5.3 autoload/debug.vim

Provides miscellaneous debugging functionionality for vim.

Command:

    - :SyntaxItem

    Show the highlight group under cursor.

    - Pretty <variable>

    Pretty structure of the vim variable. Helpful for printing contents of a
    dictionary or lists.

5.4 autoload.git.vim

Provides git status command

Command:

    - :Git

    Show git status with simple interface.

================================================================================
6. TODO~
                                                                   *vimbox-todo*

List of small things

    - In $HOME/.vimrc.local you cannot call for example GitGutterDisable or
      any other plugin commands.

Write documentation for modules in autoload folder.

    - debug.vim
    - git.vim
    - info.vim
    - parenthesis.vim
    - sign.vim
    - statusline.vim
    - xplugin.vim


 vim:tw=78:ts=8:ft=help:norl:

