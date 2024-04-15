;{Header
#Requires Autohotkey v2.0
#SingleInstance Force

;Gui Design

myGui := Gui("AlwaysOnTop -caption",)
myGui.BackColor := "ffd703"
myGui.SetFont("s30 q5 c2e1e1e","Consolas")
global Input := myGui.Add("Edit", "Backgroundffd703 -E0x200 -VScroll  Center w200 h50 Limit15")
global WinID := myGui.Hwnd
myGui.Show("y350")

;Input Handle and Gui's Destruction

Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    if Input.Value == ""{
        myGui.Destroy()
        ExitApp()
        return
    }
    else if shouldContinue = true {
        Terminal_ShareX(Input.Value)
    }
    myGui.Destroy()
    ExitApp()
    HotIfWinExist("ahk_id " WinID)
    ; Hotkey("Escape","Off")
    ; Hotkey("Enter","Off")
}
HotIfWinExist("ahk_id " WinID), Hotkey("Escape",Destruction,"On")
HotIfWinActive("ahk_id " WinID), Hotkey("Enter",Destruction.Bind(,true),"On")

;}

Terminal_ShareX(Input) {

    if Input==""{
        return
    }
    ; FUNCTIONS:

    inspect() => Send("^!+{F7}")
    picker() => Send("^!+{F8}")
    scs() => Send("^!+{F6}")
    main() => Send("^!+{F1}")
    folder() => Send("^!+{F4}")
    recording() => Send("^!+{F9}")

    static ShareX := Map(
    
    "i", () => inspect(),
    "s", () => scs(),
    "scs", () => scs(),
    "screenshot", () => scs(),
    "insp", () => inspect(),
    "inspect", () => inspect(),
    "p", () => picker(),
    "pick", () => picker(),
    "picker", () => picker(),
    "scs", () => scs(),
    "m", () => main(),
    "main", () => main(),
    "f", () => folder(),
    "folder", () => folder(),
    "r", () => recording(),
    "rec", () => recording(),
    "record", () => recording(),
    
    )

    if !(ShareX.Has(Input))
        return
    for key in ShareX{
        if (StrCompare(key,Input) == 0){
                ShareX[key]()
                return
            }
    }
}

