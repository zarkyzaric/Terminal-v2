#Requires AutoHotkey v2.0
#SingleInstance Force

Sleep(10*1000)
FileDelete("History.txt"),FileAppend("[End of Command History]`n","History.txt")

; This script sorts all your downloads:
; .mp3 in MUSIC folder; .mp4 in VIDEOS folder; .docx .pdf in DOCUMENTS folder, and so on...
; Run(A_ScriptDir "\Lib\Automation\sort_downloads.bat")

; Script for killing unessessary background programs
; Run(A_ScriptDir "\Lib\Automation\taskkiller.bat")


ExitApp