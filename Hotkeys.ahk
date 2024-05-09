#Requires AutoHotkey v2.0 
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include %A_ScriptDir%\My_Commands.ahk
;?========================================================================
;?========================================================================
;?
;? PLACE THIS SCRIPT'S SHORTCUT IN YOUR STARTUP FOLDER 
;? TO AUTOMATICALLY RUN ON STARTUP
;?
;?========================================================================
;?========================================================================
;-----------------------------------------------------------------------------------------
/* GUIDE AND REMINDER
;-----------------------------------------------------------------------------------------
;? HOTSTRINGS
:*:hotstring:: ; Activates without {Space} (Right away when it's typed)

::hotstring:: ; Activates with {Space}:

;? HOTKEYS
Characters that you write instead of keys:
# - Win
! - Alt
+ - Shift

Examples: ;!
; #d::Send("#m")

*/
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; Ctrl + Alt + T or Ctrl + \ or RCtrl => Runs the Terminal
; ^vkE2:: 
; RControl::
^!t::
RCtrl::Run(Terminal)
; ;-----------------------------------------------------------------------------------------
; ; Ctrl + Backspace => Deletes last word
; ^Backspace::SendInput "^+{Left}{Backspace}" ; Fixes Ctrl+Backspace to delete previous word
; ;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; Ctrl + Alt + D => Time and Date popup Window
^!d::Tool.Clock()
; ^!d:: Send("#!d")
;-----------------------------------------------------------------------------------------

; ^!h::Run(A_ScriptDir "\Lib\Append.ahk"),Send("^!h")
^!+j::
{
    Send("^l")
    input := Get.SelectedText()
    CMD("cd " A_ScriptDir "\Lib\Automation & python yt_bg.py `"" input "`"" " & exit")

}

^!p::Run (Lib . "\Tools\GetPath.ahk")

Run(A_ScriptDir "\Lib\Append.ahk")
