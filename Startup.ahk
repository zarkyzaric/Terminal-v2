#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk


Sleep(100)

Run(Startup "\Daily.ahk"),Sleep(500)
Run(Hotkeys "\Hotkeys.ahk"),Sleep(500)
Run(Hotkeys "\HotKeyLord.ahk"),Sleep(500)
Run(Automation "\daily.py"),Sleep(500)
Run(Hotstrings "\Custom_AutoCorrect.ahk"),Sleep(1)

; Run(Automation "\filename_cleaner.py"),Sleep(3000)

; Run(A_ScriptDir "\Lib\Tools\GetPath.ahk")

; Script for killing unessessary background programs
; Run(A_ScriptDir "\Lib\Automation\taskkiller.bat")

; This script sorts all your downloads:
; .mp3 in MUSIC folder; .mp4 in VIDEOS folder; .docx .pdf in DOCUMENTS folder, and so on...
; Run(A_ScriptDir "\Lib\Automation\sort_downloads.bat")
ExitApp