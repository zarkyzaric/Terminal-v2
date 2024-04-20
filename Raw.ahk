#Requires Autohotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk

OnError HideError
; i := Integer("cause_error")

Run('outlook.exe','notepad.exe')

HideError(exception, mode) {
    MultiRun('outlook.exe','notepad.exe')
    ; return true
    ExitApp()
}
