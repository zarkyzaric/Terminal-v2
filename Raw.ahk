#Requires Autohotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk

OnError HideError
; i := Integer("cause_error")

Run(turninto.batch("2"))

HideError(exception, mode) {
    MultiRun(turninto.batch("2"))
    ; return true
    ExitApp()
}
