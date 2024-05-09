#Requires Autohotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk

colours := {red: 0xFF0000, blue: 0x0000FF, green: 0x00FF00}
; The above expression could be used directly in place of "colours" below:
s := ""
for k, v in colours.OwnProps()
    s .= k "=" v "`n"
MsgBox s