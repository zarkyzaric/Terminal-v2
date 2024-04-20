#Requires Autohotkey v2.0
#SingleInstance Force
#Include <Functions>
#Include <Paths>
#Include <My_Paths>

OnError HideError
i := Integer("cause_error")

HideError(exception, mode) {
    MultiRun(pack.github)
    ; return true
    ExitApp()
}

Run(pack.github)
