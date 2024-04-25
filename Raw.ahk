#Requires Autohotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk

FileGen
(
"
#Requires AutoHotkey v2.0
Run 'notepad' "
),"new.ahk"