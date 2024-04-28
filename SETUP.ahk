#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\Lib\Paths.ahk
; Sets up default Browser
;! Doesnt run ps1 correctly
; Run('"powershell.exe "' Setup_Requirements '"\Get_Defaults.ps1"')
; ; Default_Browser := FileRead(Setup_Requirements "\DefaultBrowserPath.txt")
; F := FileOpen(Setup_Requirements "\DefaultBrowserPath.txt","r")
; Default_Browser := F.ReadLine()
; F.Close()
; FileAppend
; (
;     "`n Default_Browser := '" Default_Browser "'"
; ),Lib "\Paths.ahk"

Run("Hotkeys.ahk")
RunWait("Hotkeys.ahk")
Sleep(1000)
FileCreateShortcut(A_ScriptDir "\Hotkeys.ahk", A_Startup "\Hotkeys.lnk")




MsgBox("Do you want to see tutorial?")
M := MsgBox.Bind(,"Setup","0x1000 O")
M("Setup is all done!`nNow press Ctrl + Alt + T to start your terminal.")
M("Try typing something like:`n`"s Why are carrot so good?`"",)
M("Now try to translate.`nEx: `"t polyglot`"")
M("After that try typing:`n `"docs`" or `"documents`"`nin your terminal.")
M("and try:`n`"pics`" or `"pictures`".")
M("You are now free to explore all of the commands in `My_Commands.ahk` and most importantly... add your OWN!")
M("Protip: if you are not a programmer simply open `My_Commands.ahk` as a text file, syntax on how to create your own shortcuts and commands is provided in ``README.md``, ENJOY!")