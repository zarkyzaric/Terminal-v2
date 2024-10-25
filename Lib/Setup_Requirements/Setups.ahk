#Requires AutoHotkey v2.0

;TODO A function that checks if you already have that hotkey in your Hotkeys.ahk

setup_SearchSelectedText() {
    FileAppend
    (
        "`n 
        ;-----------------------------------------------------------------------------------------
        ; Alt + G => Searches Selected Text
        !g::Search.SelectedText()
        ;-----------------------------------------------------------------------------------------
        
        "
        
    ),Hotkeys "\Hotkeys.ahk"
}
    
setup_SearchYoutubePopup() {
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
        
),Hotkeys "\Hotkeys.ahk"
}