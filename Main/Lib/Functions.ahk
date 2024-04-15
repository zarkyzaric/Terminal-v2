#Requires AutoHotkey v2.0 
#Include Data_Types
#Include %A_ScriptDir%\Paths.ahk

;                  FUNCTIONS:

/*          RUN:             */
; Raw()

MultiOpen(appsArray) {
    numOfApps := appsArray.Length  ; Count of apps in the array
    if (numOfApps = 0) {
        return
    }
    Loop numOfApps {  ; Corrected Loop syntax
        App := appsArray[A_Index]  ; Get the current app from the array
        if (App == "") {
            continue
        }
        Run(App)
        ; Uncomment the next line if you want to display an error message
        ; MsgBox("Error", "An error occurred!", 16)
    }
}
/*          TIME:            */
Wait(sec := 1){ ;, min := 0, h := 0){
    Sleep(sec * 1000) ; + min*60*1000 + h*3600*1000)
}
SendIn(text, sec := 1){
    Sleep(sec * 1000)
    Send(text)
}
RunSend(App,Key, sec := 2) {
    Run(App)
    Sleep(sec*1000)
    Send(Key)
}

/*       HOTKEY FUNC:        */
F11(sec := 1){
    Sleep(sec * 1000)
    Send("{F11}")
}
Minimize(winTitle) {
    WinWait(winTitle)
    WinMinimize(winTitle)
}

; GO THROUGH
GoThrough(Commands,command,input := ""){
    if input != "" {
        properRun2(Commands,command,input){
            Commands[command].Call(input)
            return 1
        }
        thisRun := properRun2.Bind(Commands,command,input)
        for key in Commands{
            if (StrCompare(key,command) == 0) {
                thisRun()
            }
        }
    }
    else {
        properRun(Commands,key){
            IsObject(Commands[key]) ? Commands[key].Call() : Run(Commands[key])
            return 1
        }
        for key in Commands{
            thisRun := properRun.Bind(Commands,key)
            if IsObject(key) {
                Loop key.Length {
                    if (key[A_Index] == command) {
                        thisRun()
                    }
                }
            }
            else if (StrCompare(key,command) == 0) {
                thisRun()
            }
        }
        
    }
    
    return 0
}

UserInputHook(Options := "L1 T2", EndKeys := "{Enter}", CustomOptions := "-Enter"){
    IH := InputHook(Options,EndKeys), IH.Start(), IH.Wait(), userInput := IH.Input
Reason := IH.EndReason
if (Reason == "EndKey")
    return userInput
else 
    return userInput
Send("Enter")
if StrCompare(CustomOptions,"-Enter") > 0 {
    Send("{Enter}")
}
}


/*       KEYBOARD:          */
/*      GUI FUNCTIONS     */
Send_Stroke(t, KeyStroke := "",KeyStroke2 := "") {
    Send(KeyStroke)
    if KeyStroke2 != ""
        Send(KeyStroke2)

}

class Tool {
    static QR() => Run("https://www.qrcode-monkey.com/") 
    static CoordGetter() {
        CoordMode("Mouse", "Screen")
        MouseGetPos(&ScrX, &ScrY)
     
        CoordMode("Mouse", "Window")
        MouseGetPos(&WinX, &WinY)
     
        CoordMode("Mouse", "Client")
        MouseGetPos(&CliX, &CliY)
     
        CoordMode("Pixel", "Screen")
        pixel := PixelGetColor(ScrX, ScrY, "Alt Slow")
     
        g_CrdGet := Gui(, "Coord Getter")
        g_CrdGet.Backcolor := "171717"
        g_CrdGet.SetFont("S30 cC5C5C5", "Consolas")
     
        CrdGet_hwnd := g_CrdGet.hwnd
     
        toClip := (text, *) => A_Clipboard := text
     
        g_CrdGet.Add("Text", , "Screen: ")
           .OnEvent("Click", toClip.Bind(ScrX " " ScrY))
        g_CrdGet.Add("Text", "x+", "x" ScrX " ")
           .OnEvent("Click", toClip.Bind(ScrX))
        g_CrdGet.Add("Text", "x+", "y" ScrY " ")
           .OnEvent("Click", toClip.Bind(ScrY))
        g_CrdGet.Add("Text", "xm", "Window: ")
           .OnEvent("Click", toClip.Bind(WinX " " WinY))
        g_CrdGet.Add("Text", "x+", "x" WinX " ")
           .OnEvent("Click", toClip.Bind(WinX))
        g_CrdGet.Add("Text", "x+", "y" WinY " ")
           .OnEvent("Click", toClip.Bind(WinY))
        g_CrdGet.Add("Text", "xm", "Client: ")
           .OnEvent("Click", toClip.Bind(CliX " " CliY))
        g_CrdGet.Add("Text", "x+", "x" CliX " ")
           .OnEvent("Click", toClip.Bind(CliX))
        g_CrdGet.Add("Text", "x+", "y" CliY " ")
           .OnEvent("Click", toClip.Bind(CliY))
        g_CrdGet.Add("Text", "xm", "Pixel: " pixel)
           .OnEvent("Click", toClip.Bind(pixel))
        g_CrdGet.Add("Text", "xm", "CtrlClick Format")
           .OnEvent("Click", toClip.Bind('"x' CliX " y" CliY '"'))
     
        Destruction := (*) => (
           HotIfWinActive("ahk_id " CrdGet_hwnd),
           Hotkey("Escape", "Off"),
           Hotkey("1", "Off"),
           Hotkey("2", "Off"),
           Hotkey("3", "Off"),
           Hotkey("4", "Off"),
           Hotkey("5", "Off"),
           g_CrdGet.Destroy()
        )
     
        HotIfWinActive("ahk_id " CrdGet_hwnd)
        Hotkey("Escape", Destruction, "On")
        Hotkey("1", toClip.Bind(ScrX " " ScrY), "On")
        Hotkey("2", toClip.Bind(WinX " " WinY), "On")
        Hotkey("3", toClip.Bind(CliX " " CliY), "On")
        Hotkey("4", toClip.Bind(pixel), "On")
        Hotkey("5", toClip.Bind("'x" CliX " y" CliY "'"), "On")
        Hotkey("LButton",Destruction, "On")
        Hotkey("Enter",Destruction, "On")
        Hotkey("Space",Destruction, "On")

        g_CrdGet.OnEvent("Close", Destruction)
     
        g_CrdGet.Show("AutoSize y0 x" A_ScreenWidth / 20 * 13.5)
     }
    static Clock() {

        static clock_hwnd
    
        if IsSet(clock_hwnd) && WinExist(clock_hwnd) {
            ; win_MinMax(clock_hwnd) ;Same thing as the code below, but drier and more reliable. Dependency on Win.ahk (https://github.com/Axlefublr/Main/blob/main/Lib/Win.ahk)
            if WinActive(clock_hwnd)
                WinMinimize(clock_hwnd)
            else
                WinActivate(clock_hwnd)
            return
        }
        
        ;Get the time variables
        clock_Time   := FormatTime(, " HH:mm:ss")
        , clock_Week := FormatTime(, "dddd")
        , clock_Date := FormatTime(, "d MMMM")
    
        ;Create the gui
        g_Clock := Gui("-Border", "Clock")
        g_Clock.BackColor := "171717"
    
        clock_hwnd := g_Clock.hwnd
    
        ;Add text
        g_Clock.SetFont("S40 cC5C5C5", "Consolas")
        g_Clock_Time := g_Clock.Add("Text", "w237 y-20", clock_Time) 
    
        g_Clock.SetFont("S30")
        g_Clock_Week := g_Clock.Add("Text", "w237 y+35 Center", clock_Week)
    
        g_Clock.SetFont("S26")
        g_Clock_Date := g_Clock.Add("Text", "w237 Center", clock_Date)
        
        ;The func obj is separate because we'll need to disable the timer outside of it
        timeCheck := () => (
            g_Clock_Time.Text := FormatTime(, " HH:mm:ss"),
            g_Clock_Week.Text := FormatTime(, "dddd"),
            g_Clock_Date.Text := FormatTime(, "d MMMM")
        )
    
        ;Change the time text every half a second for better accuracy
        SetTimer(timeCheck, 500)
    
        ;Takes care of all the trash
        Destruction := (*) => ( ;the * takes care of the required parameters for hotkey and onevent
            SetTimer(timeCheck, 0), ;Since it references a function object, it can be outside of the settimer's thread
            HotIfWinActive("ahk_id " clock_hwnd),
            Hotkey("Escape", "Off"),    
            g_Clock.Destroy()
        )

        HotIfWinActive("ahk_id " clock_hwnd)
            Hotkey("Escape",Destruction,"On")
            Hotkey("LButton",Destruction,"On")
            Hotkey("Space", Destruction, "On")
            Hotkey("LButton",Destruction, "On")
        g_Clock.OnEvent("Close", Destruction)
        g_Clock.Show("W350 H320 y" A_ScreenHeight / 5 " x" A_ScreenWidth / 2 - 220)
    
    }
}
class Open {
    static VSC(input?) {
        if IsSet(input)
            Run(VSC " " input) ;() => (Send("{LWin}"),SendIn("vs",0.1),SendIn("{Enter}",0.1),SendIn("{LWin}{Up}"))
        else
            Run(VSC) 
    }
    
}
class Search {
    
    static Smart(input) {
        if InStr(input, "http") || InStr(input, "C:\") || (InStr(input,"www.") && InStr(input, ".com"))
            Run(input)
        else
            Search.Browser(input)
    }
    static YT(input) => Run("https://www.youtube.com/results?search_query=" . StrReplace(input, A_Space, "+"))
    static Browser(input) => Run("https://duckduckgo.com/?t=ffab&q=" . StrReplace(input, A_Space, "+") . "&atb=v403-1&ia=web")
    static Meaning(input) => Search.Browser("define " input)
    static Clipboard() => Search.Browser(A_Clipboard)

    static SelectedText(MODE := "") {
        SendMode "Input"
        SetTitleMatchMode 2
    
        OG_Clipboard := ClipboardAll()
        A_Clipboard := ""
        Send "^c"
        ClipWait 2
        ; if ErrorLevel
        ;     return
        if RegExMatch(A_Clipboard, "^[^ ]*\.[^ ]*$")
            Run("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" A_Clipboard)
        else if MODE == "HELP"
            Run(Help), SendIn(A_Clipboard,2), SendIn("{Enter}",0.5) 
        else {
        StrReplace(A_Clipboard,"#","%23")
        StrReplace(A_Clipboard,"&","%26")
            StrReplace(A_Clipboard,"+","%2b")
            StrReplace(A_Clipboard,'"',"%22")
            Search.Browser(A_Clipboard)
        }
        A_Clipboard := OG_Clipboard
        return
    }
    static PasteBin(input) => Run("https://pastebin.com/" input)
    static GPT(input) => (Run("https://chat.openai.com"),SendIn("+{Esc}" input,4),SendIn("{Enter}",2))
    static GitHub(input) => Run("https://github.com/search?q=" StrReplace(input, A_Space, "+") "&type=repositories")
    static Pinterest(input) => Run("https://www.pinterest.com/search/pins/?q=" StrReplace(input, A_Space, "%20") "&rs=typed")
    static Emoji(input) => Run("https://emojipedia.org/search?q=" StrReplace(input, A_Space, "+"))
    static Translate(input) => Run("https://translate.google.com/?sl=en&tl=sr&text=" input "&op=translate")
}

class Raw {
    /*
    */
   static ahk := "Raw.ahk"
   static Run(input) {
        if input == ""
            return
        try FileDelete(Raw.ahk)
        FileAppend
        (
        "#Requires Autohotkey v2.0
        #SingleInstance Force
        #Include %A_ScriptDir%\Lib\Functions.ahk
        #Include %A_ScriptDir%\Lib\Paths.ahk
        #Include My_Commands.ahk`n"
        ),Raw.ahk

        if InStr(input, "c="){ ; A_Clipboard := %Variable or a String%
            FileAppend
            (
            "
            A_Clipboard := " SubStr(input, 3, StrLen(input) - 2) 
            ),Raw.ahk ; SubStr(input, 3, StrLen(input) - 2) ; input.Delete(1,2) 
        }
        else if !InStr(input, " ") || (InStr(input,"\") && !InStr(input, "`n"))  ; PATHS
        { 
            FileAppend
            (
            "Run(" input ")"
            ),Raw.ahk
        }
        ; else if !InStr(input,"'") || !InStr(input,"'")] 
        else if InStr(input, "`n") || InStr(input,'"') || InStr(input,"'"){
            Lines := StrSplit(input,"`n")
            Loop Lines.Length {
                if Lines[A_Index] == "" || Lines[A_Index] == "`n" || Lines[A_Index] == "`t"  {
                    Lines.RemoveAt(A_Index)
                    continue
                }
                ; StrReplace(Lines[A_Index], " ", "(",,,1)
                bracPos := InStr(Lines[A_Index], " ")
                command := SubStr(Lines[A_Index], 1, bracPos - 1)
                input := SubStr(Lines[A_Index], bracPos + 1)
                Lines[A_Index] := command "(" StrReplace(input," ", ",") ")"

                FileAppend
                (
                "`n"
                Lines[A_Index]
                ),Raw.ahk
            }
        }
        else {
            return 0
        }
        Run(Raw.ahk)
        return 1

    }

    static Terminal() {
        {

            ;?________________CUSTOMIZE______________________________________________________________
            ; DurationOfAppearance := 500
            Font := "Consolas", FontSize := "18", FontColor := "ffffff"
            BGColor := "001000"
            Width := 500, Height := 600
            
            ;*________________Gui_Object(Appearance)______________________________________________________________________
            GuiOptions := "AlwaysOnTop -caption Border"
            FontOptions := "q5"
            EditBoxOptions := "-E0x200 -VScroll " "W" Width " h" (Height - 5)
            PositionAndSize := "W" Width "H" Height "y20"
            myGui := Gui(GuiOptions)
            myGui.BackColor := BGColor   
            myGui.SetFont("s" FontSize " " FontOptions " c" FontColor, Font) 
            global Input := myGui.Add("Edit", "Background" BGColor " x10 " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
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
                        Raw.Run(input)
                }
            }

            HotIfWinExist(WinID) 
                Hotkey("Enter",Send_Stroke.Bind(,"{NumpadEnd}{Enter}"),"On")
                Hotkey("+Enter",Destruction.Bind(,True),"On")
                Hotkey("^vkE2",Destruction.Bind(,True),"On")
                Hotkey("Escape",Destruction,"On")
                Hotkey("^w",Destruction,"On")
                
                ; Hotkey("RControl",Destruction,"On")
                ; Hotkey("LButton",Destruction,"On")
                ; Hotkey("NumpadEnter",Destruction.Bind(,True),"On")
            ; SetTimer () => myGui.Destroy(), -(DurationOfAppearance * 1000)
            }
    }
}
class Type {
    static Enter() => Send("{Enter}")    
    static Backspace() => Send("{BS}")
    static Space() => Send(A_Space)
    static Cao() => Send("Caos")
}
class Song {
    static Similar(input) => Run("https://www.chosic.com/playlist-generator/")
}
class Image {
    static Convert(input) => Run("https://convertio.co/" input)
    static RemoveBG() =>((Run("https://www.remove.bg/"),SendIn("^v",4)))
    static Dict := Map(
        "hex",      "https://www.w3schools.com/colors/colors_hex.asp",
        "picker",   "https://www.w3schools.com/colors/colors_picker.asp",
        "mixer",    "https://www.w3schools.com/colors/colors_mixer.asp",
        "converter","https://www.w3schools.com/colors/colors_converter.asp",
        "scheme",   "https://www.w3schools.com/colors/colors_schemes.asp",
        )
    }


class Settings {
    static Theme(N:= 11) => (PowerShell.SystemUsesLightTheme(N // 10),PowerShell.AppsUseLightTheme(N - ((N//10)*10)))
    ; Class Theme {
    ;     static Light(N:= 11) => (PowerShell.SystemUsesLightTheme(N // 10),PowerShell.AppsUseLightTheme(N - ((N//10)*10)))
    ;     static Dark(N := 00) => (PowerShell.SystemUsesLightTheme(N // 10),PowerShell.AppsUseLightTheme(N - ((N//10)*10)))
    ; }
    static Brightness(P) => (PowerShell.SetBrightness(P))
    
}
class OS {
    static ShutdownIn(X,T) => (Sleep(T*1000),Shutdown(X),ExitApp())

    static Shutdown(T) => OS.ShutdownIn(1,T)
    static Logoff(T) => OS.ShutdownIn(0,T)
    static Restart(T) => OS.ShutdownIn(2,T)
    static ForceShutdown(T) => OS.ShutdownIn(4,T)
    static ForceRestart(T) => OS.ShutdownIn(6,T)
    ; static RIP(T) => OS.ShutdownIn(8,T) ; use on your own responsability
}
class PowerShell {
    static Path := "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe"
    static Run(Options) => Run('' PowerShell.Path ' ' Options,,"MIN")
    static AppsUseLightTheme(N) => PowerShell.Run('"New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value "' N '" -Type Dword -Force"')
    static SystemUsesLightTheme(N) => PowerShell.Run('"New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value "' N '" -Type Dword -Force"')
    static SetBrightness(P) => PowerShell.Run('"(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,"' P '")"')
}   

class Get {
    static SelectedText(){ ;!!!
        OG_Clipboard := ClipboardAll()
        A_Clipboard := ""
        Send "^c"
        ClipWait 2
        Selected_Text := A_Clipboard 
        A_Clipboard := OG_Clipboard
        return Selected_Text 
    }
    
    static WallpaperPath() {
    AD_GETWP_BMP := 0
    AD_GETWP_LAST_APPLIED := 0x00000002
    CLSID_ActiveDesktop := "{75048700-EF1F-11D0-9888-006097DEACF9}"
    IID_IActiveDesktop := "{F490EB00-1240-11D1-9888-006097DEACF9}"
    cchWallpaper := 260
    GetWallpaper := 4

    AD := ComObject(CLSID_ActiveDesktop, IID_IActiveDesktop)
    wszWallpaper := Buffer(cchWallpaper * 2)
    ComCall(GetWallpaper, AD, "ptr", wszWallpaper, "uint", cchWallpaper, "uint", AD_GETWP_LAST_APPLIED)
    Wallpaper := StrGet(wszWallpaper, "UTF-16")
    MsgBox "Wallpaper: " Wallpaper
    }
}
    



class Mp3 {
    static URL := "https://yt2k.com/en/youtube-mp3-v2"
    static Download(input := "", mode := ""){
        Run Mp3.URL
        Sleep 1000
        MouseMove  926 , 601 
        MouseClick "left"
        if mode == "LINK" {
            Send(input)
            Goto Rest
        }
        Send(input " audio")
        Rest:
        Sleep 500
        MouseMove  1371 , 615 
        MouseClick "left"
        Sleep 500
        MouseMove  485 , 965
        MouseClick "left"
    } 
}
/*
  Methods in ITaskbarList's VTable:
    IUnknown:
      0 QueryInterface  -- use ComObjQuery instead
      1 AddRef          -- use ObjAddRef instead
      2 Release         -- use ObjRelease instead
    ITaskbarList:
      3 HrInit
      4 AddTab
      5 DeleteTab
      6 ActivateTab
      7 SetActiveAlt
*/
HideFromTaskbar(T){
    IID_ITaskbarList  := "{56FDF342-FD6D-11d0-958A-006097C9A090}"
    CLSID_TaskbarList := "{56FDF344-FD6D-11d0-958A-006097C9A090}"
    
    ; Create the TaskbarList object.
    tbl := ComObject(CLSID_TaskbarList, IID_ITaskbarList)
    
    activeHwnd := WinExist("A")
    
    ComCall(3, tbl)                     ; tbl.HrInit()
    ComCall(5, tbl, "ptr", activeHwnd)  ; tbl.DeleteTab(activeHwnd)
    Sleep T * 1000  
    ComCall(4, tbl, "ptr", activeHwnd)  ; tbl.AddTab(activeHwnd)
    
    ; When finished with the object, simply replace any references with
    ; some other value (or if its a local variable, just return):
    tbl := ""
    }

    Test1() {
        MyGui := Gui()
        MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
        MyGui.BackColor := "EEAA99"  ; Can be any RGB color (it will be made transparent below).
        MyGui.SetFont("s32")  ; Set a large font size (32-point).
        CoordText := MyGui.Add("Text", "cLime", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.
        ; Make all pixels of this color transparent and make the text itself translucent (150):
        WinSetTransColor(MyGui.BackColor " 150", MyGui)
        SetTimer(UpdateOSD, 200)
        SetTimer () => myGui.Destroy(), -3000
        UpdateOSD()  ; Make the first update immediate rather than waiting for the timer.
        MyGui.Show("x750 y800 NoActivate")  ; NoActivate avoids deactivating the currently active window.
        HotIfWinExist "A"
        UpdateOSD(*)
        {
            MouseGetPos &MouseX, &MouseY
            CoordText.Value := "X" MouseX ", Y" MouseY
            A_Clipboard := " " MouseX ", " MouseY
        }
}

    
    
    
; }
