#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\Lib\Paths.ahk
; Sets up default Browser
;! Doesnt run ps1 correctly
; try FileDelete(Setup_Requirements "\DefaultBrowserPath.txt")
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

Run("Hotkeys.ahk")
; RunWait("Hotkeys.ahk")
Sleep(1000)
FileCreateShortcut(A_ScriptDir "\Hotkeys.ahk", A_Startup "\Hotkeys.lnk")

; Sleep(1000)
; FileCreateShortcut(A_ScriptDir "\Hotkeys.ahk", A_Startup "\Hotkeys.lnk")
; Result_HotkeyLord := MsgBox("Do ?","Setup","0x1000 YN")

Result := MsgBox("Do you want to setup advanced hotkeys?","Setup","0x1000 YN")
If Result == "Yes" {
Result := MsgBox("Do you want to set Alt + G as a hotkey for searching up selected text in browser??","Setup","0x1000 YN")
if Result == "Yes" {
    FileAppend
(
    "`n 
    ;-----------------------------------------------------------------------------------------
    ; Alt + G => Searches Selected Text
    !g::Search.SelectedText()
    ;-----------------------------------------------------------------------------------------

    "
    
),A_ScriptDir "\Hotkeys.ahk"
Run("Hotkeys.ahk")
}

Result := MsgBox("Do you want to set Ctrl + Alt + Y (or Z) as a hotkey for a popup searchbar for Youtube?","Setup","0x1000 YN")
if Result == "Yes" {
    FileAppend
    (
        "`n 
        ;-----------------------------------------------------------------------------------------
        ; Ctrl + Alt + Z or Ctrl + Alt + Y => Searchbar for Youtube
        ^!z::
        ^!y:: ; Youtube Search
        {
        DurationOfAppearance := 20
        GuiOptions := `"AlwaysOnTop -caption Border`"
        Font := `"Consolas`"
        FontOptions := `"s17 q5`"
        FontColor := `"ffffff`"
        BGColor := `"3a0000`"
        Width := 800
        Height := 50
        
        EditBoxOptions := `"-E0x200 -VScroll Center `" `"W`" Width `" h`" (Height - 5)
        PositionAndSize := `"W`" Width `"H`" Height `"y20`"
        myGui := Gui(GuiOptions)
        myGui.BackColor := BGColor   
        myGui.SetFont(FontOptions `" c`" FontColor, Font) 
        global Input := myGui.Add(`"Edit`", `"Background`" BGColor `" `" EditBoxOptions) ; Adds an Input(Edit) Box in GUI
        global WinID := `"ahk_id `" myGui.Hwnd ; Saving Window handle for destroying GUI
        myGui.Show(PositionAndSize)
        
        ;Input Handling  and Gui's Destruction
        Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
            global Input
            input := Input.Value
            myGui.Destroy()
            if shouldContinue = true {
                if input == `"`"
                    return
                else
                    Search.YT(input)
            }
        }
        ; If Input Bar exists or is active the following hotkeys will do certain actions
        HotIfWinExist(WinID) 
            Hotkey(`"Escape`",Destruction,`"On`")
            ; Hotkey(`"RControl`",Destruction,`"On`")
            Hotkey(`"LButton`",Destruction,`"On`")
            Hotkey(`"Enter`",Destruction.Bind(,true),`"On`")
            Hotkey(`"^+/`",Destruction,`"On`")
            Hotkey(`"RControl`",Destruction,`"On`")
            Hotkey(`"NumpadEnter`",Destruction,`"On`")
        SetTimer () => myGui.Destroy(), -(DurationOfAppearance * 1000)
        }
        
        "
        
),A_ScriptDir "\Hotkeys.ahk"
Run("Hotkeys.ahk")
}
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