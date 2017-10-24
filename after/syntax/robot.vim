hi RobotTitle ctermfg=green
hi RobotTest ctermfg=darkmagenta
hi RobotVariable ctermfg=darkcyan

syntax match RobotTitle "^\*\*\* .*\*\*\*$"
syntax match RobotTest "^\w.*"
syntax match RobotVariable "\${\?\w*\>}\?"
