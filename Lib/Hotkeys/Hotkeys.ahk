#Requires AutoHotkey v2.0 
#SingleInstance Force
#ErrorStdOut
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
^!q::Run(Terminal)
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
; ^!+j::
; {
;     Send("^l")
;     input := Get.SelectedText()
;     CMD("cd " A_ScriptDir "\Lib\Automation & python yt_bg.py `"" input "`"" " & exit")

; }

; ^!p::Run (Lib "\Tools\GetPath.ahk")




; --------------------------------------------------------------------------------
Run(A_ScriptDir "\Lib\Command_Maker.ahk")

#Requires AutoHotkey v2.0+
#Include %A_ScriptDir%\Lib\All.ahk


;-----------------------------------------------------------------------------------------
; Alt + G => Searches Selected Text
!g::Search.SelectedText()
;-----------------------------------------------------------------------------------------



;-----------------------------------------------------------------------------------------
; Ctrl + Alt + Z or Ctrl + Alt + Y => Searchbar for Youtube
^!z::
^!y:: ; Youtube Search
{
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption Border"
Font := "Consolas"
FontOptions := "s17 q5"
FontColor := "ffffff"
BGColor := "3a0000"
Width := 800
Height := 50

EditBoxOptions := "-E0x200 -VScroll Center " "W" Width " h" (Height - 5)
PositionAndSize := "W" Width "H" Height "y20"
myGui := Gui(GuiOptions)
myGui.BackColor := BGColor
myGui.SetFont(FontOptions " c" FontColor, Font)
global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := "ahk_id " myGui.Hwnd ; Saving Window handle for destroying GUI
myGui.Show(PositionAndSize)

;Input Handling  and Gui's Destruction
Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    input := Input.Value
    myGui.Destroy()
    if shouldContinue = true {
        if input == ""
            return
        else
            Search.YT(input)
    }
}
; If Input Bar exists or is active the following hotkeys will do certain actions
HotIfWinExist(WinID)
    Hotkey("Escape",Destruction,"On")
    ; Hotkey("RControl",Destruction,"On")
    Hotkey("LButton",Destruction,"On")
    Hotkey("Enter",Destruction.Bind(,true),"On")
    Hotkey("^+/",Destruction,"On")
    Hotkey("RControl",Destruction,"On")
    Hotkey("NumpadEnter",Destruction,"On")
SetTimer () => myGui.Destroy(), -(DurationOfAppearance * 1000)
}

