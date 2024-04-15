#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <Functions>

if not A_IsAdmin
    {
       Run("*RunAs `"" A_ScriptFullPath "`"")  ; Requires v1.0.92.01+
       ExitApp()
    }
    ; REMOVED: #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
    ; #Warn  ; Enable warnings to assist with detecting common errors.
    SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
    SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
    #SingleInstance Force
    
    #HotIf WinActive("ahk_class CabinetWClass")
    ^+m::
    { ; V1toV2: Added bracket
        newFileHere()
        return
    } ; V1toV2: Added bracket in the end
    #HotIf
    
    newFileHere(){
    WinHWND := WinActive()
    For win in ComObject("Shell.Application").Windows
        If (win.HWND = WinHWND) {
            dir := SubStr(win.LocationURL, 9) ; remove "file:///"
            dir := RegExReplace(dir, "%20", " ")
            Break
        }
    
    file := dir . "/NewFile.md"
    if FileExist(file)
    {
        MsgBox("NewFile.md already exists")
        return
    }
    FileAppend("", file)  ; create new file
    }