#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include %A_ScriptDir%\Lib\Setup_Requirements\Setups.ahk

; Sets up default Browser
;! Doesnt run ps1 correctly
; try FileDelete(Setup_Requirements "\DefaultBrowserPath.txt")

FileAppend
(
    "`n This_ProjectDir := '" A_ScriptDir "'"
),Lib "\Paths.ahk"
; FileAppend
; (
;     "`n^!h::Run(This_ProjectDir `"\Lib\Append.ahk`"),Send(`"^!h`")"
; ), A_ScriptDir "\Hotkeys.ahk"

FileAppend("",Setup_Requirements "\DefaultBrowserPath.txt")
Run(Setup_Requirements "\Get_Defaults.ps1")
F := FileOpen(Setup_Requirements "\DefaultBrowserPath.txt","r")
; Default_Browser := FileRead(Setup_Requirements "\DefaultBrowserPath.txt")
Default_Browser := F.ReadLine()
; MsgBox Default_Browser
F.Close()
FileAppend
(
    "`n Default_Browser := '" Default_Browser "'"
),Lib "\Paths.ahk"

Run(Hotkeys "\Hotkeys.ahk")
FileAppend
(
    "`n 
#Requires AutoHotkey v2.0+
#Include %A_ScriptDir%\Lib\All.ahk
    "
),Hotkeys "\Hotkeys.ahk"
Run(Hotkeys "\Hotkeys.ahk")
Run(Setup_Requirements "\install_requirements.py")
; RunWait("Hotkeys.ahk")
Sleep(1000)
FileCreateShortcut(A_ScriptDir "\Hotkeys.ahk", A_Startup "\Hotkeys.lnk")
FileCreateShortcut(A_ScriptDir "\Startup.ahk", A_Startup "\Startup.lnk")

Q := MsgBox.Bind(,"Setup","0x1000 YN")
Result := Q("Do you want to setup advanced hotkeys?")
If Result == "Yes" {
if Q("Do you want to setup HotKeyLord Script?") == "Yes"
    FileCreateShortcut(Lib "\HotKeyLord.ahk", A_Startup "\Startup.lnk")
if Q("Do you want to set Alt + G as a hotkey for searching up selected text on web?") == "Yes"
    setup_SearchSelectedText()
if Q("Do you want to set Ctrl + Alt + Y (or Z) as a hotkey for a popup searchbar for Youtube?") == "Yes"
    setup_SearchYoutubePopup()
}






Result := MsgBox("Do you want to see tutorial?","Setup","0x1000 YN")
If Result == "No"
    ExitApp()
M := MsgBox.Bind(,"Setup","0x1000 O")
M("Setup is all done!`nNow press Ctrl + Alt + T to start your terminal.")
M("Try typing something like:`n`"s Why are carrot so good?`"",)
M("Now try to translate.`nEx: `"t polyglot`"")
M("After that try typing:`n `"docs`" or `"documents`"`nin your terminal.")
M("and try:`n`"pics`" or `"pictures`".")
M("You are now free to explore all of the commands in `My_Commands.ahk` and most importantly... add your OWN!")
M("Protip: if you are not a programmer simply open `My_Commands.ahk` as a text file, syntax on how to create your own shortcuts and commands is provided in ``README.md``, ENJOY!")