*vimbox.vim*	For Vim version 7.3	Last change: 2010 June 4

                                 VIMBOX MANUAL
1. Description                                              |vimbox-description|
2. Commands                                                 |vimbox-commands|
3. Mappings                                                 |vimbox-mappings|
4. To do                                                    |vimbox-todo|
5. Autoload                                                 |vimbox-autoload|

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
5. Autoload modules
                                                                   *vimbox-todo*

5.1 autoload/info.vim

This module provides an helper command `Info`. It's purpose is to act as a
general command that shows some information about the current vim, it's
configuration and anything that cannot be in static help files.

Command:

    - :Info <title>

    This command provides autocompletion for all titles.

Functions:

    - info#Register(title, func)

================================================================================
4. TODO~
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

