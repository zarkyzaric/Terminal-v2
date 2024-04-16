#Requires AutoHotkey v2.0

Run("Hotkeys.ahk"), Sleep(1)
FileCreateShortcut(A_ScriptDir "\Hotkeys.ahk", A_Startup "\Hotkeys.lnk")
Run("notepad.exe " A_ScriptDir "\Lib\Paths.ahk")
M := MsgBox.Bind(,"Setup","0x1000 O")
; M("Setup is all done!`nNow press Ctrl + Alt + T to start your terminal.")
; M("Try typing something like:`n`"s Why are carrot so good?`"",)
; M("Now try to translate.`nEx: `"t polyglot`"")
; M("After that try typing:`n `"docs`" or `"documents`"`nin your terminal.")
; M("and try:`n`"pics`" or `"pictures`".")
; M("You are now free to explore all of the commands in `My_Commands.ahk` and most importantly... add your OWN!")
; M("Protip: if you are not a programmer simply open `My_Commands.ahk` as a text file, syntax on how to create your own shortcuts and commands in provided in ``README.md``, ENJOY!")