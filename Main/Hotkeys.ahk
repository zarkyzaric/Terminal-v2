;{
#Requires AutoHotkey v2.0 
#SingleInstance Force
#Include <Functions>
#Include <Paths>

/* GUIDE AND REMINDER

;? HOTSTRINGS
b
:*:hotstring:: ; Activates without {Space} (Right away when it's typed)

::hotstring:: ; Activates with {Space}:


;? HOTKEYS
Karakteri koji se pišu umesto dugmića:
# - Win
! - Alt
+ - Shift
Primeri:

*/
; Ctrl + Backspace => Deletes last word
^Backspace::SendInput("^+{Left}{Backspace}") ; Fixes Ctrl+Backspace to delete previous word


; Ctrl + Alt + D => Time and Date popup Window
^!d::Tool.Clock()

;Alt + G => Searches Selected Text
!g::Search.SelectedText()

; Ctrl + \ pr RCtrl => Runs the Terminal
^vkE2:: 
RControl::Run(AHK.Main "\Terminal.ahk") 



#HotIf WinActive("ahk_class WorkerW")
F7:: ; Show/Hide Desktop Icons when desktop is active
{
    MouseMove(982 , 1023)
    Sleep(1)
    SendIn("{RButton}",0.002)
    SendIn("{Down}",0.002)
    SendIn("{Right}",0.002)
    Loop 5 {
        SendIn("{Down}",0.002)
    }
    SendIn("{Enter}",0.001)
}
#HotIf

; Ctrl + Alt + G => Inputbar for ChatGPT
^!g::
{
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption +Border"
Font := "Consolas",FontOptions := "s17 q5",FontColor := "d7f4eb"
BGColor := "1b644e"
Width := 800,Height := 50

EditBoxOptions := "-E0x200 -VScroll Center x0 " "W" Width " h" (Height - 5)
PositionAndSize := "W" Width "H" Height "y20"
myGui := Gui(GuiOptions)
myGui.BackColor := BGColor   
myGui.SetFont(FontOptions " c" FontColor, Font) 
global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := myGui.Hwnd
myGui.Show(PositionAndSize)

;Input Handling  and Gui's Destruction
Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    input := Input.Value
    myGui.Destroy()
    if input == "" 
        return
    else if shouldContinue = true {
        Search.GPT(input)
        return
    }
; If Input Bar exists or is active the following hotkeys will do certain actions
HotIfWinExist("ahk_id " WinID) 
    Hotkey("Escape",Destruction,"On")  
    Hotkey("RControl",Destruction,"On")
    Hotkey("LButton",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up
    HotIfWinActive("ahk_id " WinID)
    Hotkey("Enter",Destruction.Bind(,true),"On") ; adds {Enter} hotkey if user wants to send value into execution
    Hotkey("^+/",Destruction,"On")
    Hotkey("RControl",Destruction,"On")
 
Hotkey("^!g",Destruction,"On")

SetTimer () => myGui.Destroy(), -(DurationOfAppearance * 1000)
}
}

^+/:: ; Searchbar
{
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption -Border"
Font := "Consolas",FontOptions := "s17 q5",FontColor := "ffffcc"
BGColor := "331a00"
Width := 800,Height := 50
EditBoxOptions := "-E0x200 -VScroll Center x0 " "W" Width " h" (Height - 5)
PositionAndSize := "W" Width "H" Height "y20"

myGui := Gui(GuiOptions)
myGui.BackColor := BGColor   
myGui.SetFont(FontOptions " c" FontColor, Font) 
global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := myGui.Hwnd ; Saving Window handle for destroying GUI
myGui.Show(PositionAndSize)

;Input Handling  and Gui's Destruction
Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    input := Input.Value
    myGui.Destroy()
    if input == ""
        return
    else if shouldContinue = true {
        Search.Browser(input)
        return
    }
HotIfWinExist("ahk_id " WinID) 
    Hotkey("Escape",Destruction,"On")  
    Hotkey("RControl",Destruction,"On")
    Hotkey("LButton",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up
    HotIfWinActive("ahk_id " WinID)
    Hotkey("Enter",Destruction.Bind(,true),"On") ; adds {Enter} hotkey if user wants to send value into execution
    Hotkey("^+/",Destruction,"On")
    Hotkey("RControl",Destruction,"On")

SetTimer () => myGui.Destroy(), -(DurationOfAppearance * 1000)
}
}

; Ctrl + Alt + Z or Ctrl + Alt + Y => Searchbar for Youtube
^!z::
^!y:: ; Youtube Search
{

;?_______________________________Gui_Design_________________________________________________
;*__________________CUSTOMIZE______________________________________________________________
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption Border"
Font := "Consolas"
FontOptions := "s17 q5"
FontColor := "ffffff"
BGColor := "3a0000"
Width := 800
Height := 50

;*________________Gui_Object(Appearance)______________________________________________________________________

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





