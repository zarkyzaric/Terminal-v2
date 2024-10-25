#Requires AutoHotkey v2.0 
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include %A_ScriptDir%\Lib\FindText.ahk


Python(Args, Mode := "BG"){
    spacePos := InStr(Args," ")
    if !(spacePos)
        return
    else {
        myScriptPath := SubStr(Args, 1, spacePos - 1)
        Arg := SubStr(Args, spacePos + 1)
    }
    Run('pythonw.exe "' myScriptPath '" "' Arg '"')
; Run('pythonw.exe "C:\Users\LEPALALA\Documents\Python\Apps\PyClock\clock.py" "30"')
}


;                  FUNCTIONS:

; Compares if string matches with one of the array's items
IsIn(haystack,needles*) {
    has(needle)=>InStr(haystack,needle)
    ; if IsObject(needles){
    for index, needle in needles {
        if has(needle)
            return True
    }
    return False

}
;If you want to run multiple apps in one function
; Runs Workflows,Arrays,Paths,Urls
MultiRun(apps*) {
    for index, app in apps {
        if (IsObject(app)) {  ; Check if the argument is an array
            for i, path in app {  ; Loop through the array
                if (path == "")
                    continue
                Run(path)
                ; Uncomment to debug errors
                ; MsgBox("Error", "An error occurred while running " . path, 16)
            }
        } else {  ; It's a single path string
            if (app == "")
                continue
            Run(app)
            ; Uncomment to debug errors
            ; MsgBox("Error", "An error occurred while running " . app, 16)
        }
    }
}
;Custom MsgBox 
Msg(Text := "Empty MsgBox",PositionAndSize := "Autosize xcenter y" (A_ScreenHeight // 3),T := 3)
{
    
    DurationOfAppearance := 15

    Font := "Consolas"
    FontColor := "ff0ffff"
    FontSize := 15, 

    BGColor := "000000"
                
    Width := 600, Height := 200
    ;_________________________________________________________________
    ;_________________________________________________________________
    GuiOptions := "+AlwaysOnTop -caption Border -SysMenu "
    FontOptions := "q5"

    myGui := Gui(GuiOptions)
    
    myGui.BackColor := BGColor   
    WinSetTransColor("ffffff", myGui)
    WinSetTransparent(150, myGui)
    myGui.SetFont("s" FontSize " " FontOptions " c" FontColor, Font)
    myGui.Add("Text",, Text) ; "'" 
    myGui.AddText()

    myGui.Show(PositionAndSize)
    SetTimer () => myGui.Destroy(), -(T * 1000)
}
; Passes @param as Command Line parameter
CMD(Command := "", UseRootDir := False) {
    Dir := A_User
    if UseRootDir
        Dir := "C:\Windows\system32"
    if Command == ""
        Run(A_ComSpec, Dir)
    else
        Run(A_ComSpec ' /k ' Command, Dir)

}
FileGen(CODE:= "", fullFileName := A_ScriptDir "\Lib\Files\" "New.txt"){
    ;! myb naming it file is going to make a problem, we'll see
    Separator := InStr(CODE," || ")
    if !Separator
        return
    Content := SubStr(CODE, 1, Separator - 1)
    if Content == ""
        return
    fullFileName := A_ScriptDir "\Lib\Files\" SubStr(CODE, Separator + StrLen(Content) + 1)
    ; MsgBox(Content),MsgBox(fullFileName)
    FileAppend Content,  fullFileName
    Run(fullFileName)
}   
; Clears content of a file (file becomes empty)
ClearFile(fileName) => FileAppend("",fileName)




;  TIME BASED ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Same as Sleep, just in seconds, 
Wait(sec := 1, min := 0) => ( Sleep(min * 60000),Sleep(sec * 1000) )

SendIn(text, sec := 1){
    Sleep(sec * 1000)
    Send(text)
}
RunSend(App,Keystroke, sec := 2) => (Run(App),WinWait(App),WinActivate(),Sleep(sec * 1000),Send(Keystroke))

/*       HOTKEY FUNC:        */
F11(sec := 1){
    Sleep(sec * 1000)
    Send("{F11}")
}
Minimize(winTitle) => ( WinWait(winTitle),WinMinimize(winTitle) )
; Goes Through an Dictonary and activates or runs matching key's value (aither Bound Function or Path)
GoThrough(Commands,command,input := ""){

        properRun(Commands,key){
            IsObject(Commands[key]) ? Commands[key].Call() : Search.Smart(Commands[key])

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

    return 0


}

BrowserTabFinder(title) {
    SetTitleMatchMode 2
    browsers := ["firefox.exe", "brave.exe", "chrome.exe", "msedge.exe", "opera.exe",  "iexplore.exe", "safari.exe"]
    for _, browser in browsers {
        if WinExist("ahk_exe " . browser) {
            WinActivate
            originalTitle := WinGetTitle("A")
            tabCount := 0
            Loop {
                tabCount++
                Send "^{Tab}"
                Sleep 100
                if WinActive("ahk_exe " . browser) {
                    currentTitle := WinGetTitle("A")
                    if InStr(currentTitle, title) {
                        WinActivate
                        return true
                    }
                    if (currentTitle == originalTitle || tabCount > 50) {
                        break
                    }
                } else {
                    ToolTip "Browser window lost focus. Total tabs counted: " . tabCount
                    SetTimer () => ToolTip(), -5000
                    return false
                }
            }
        }
    }
    ToolTip "No supported browser found or target tab not found"

    SetTimer () => ToolTip(), -5000
    return false
}
click_chatgpt_inputarea(title) {
    if WinExist(title) {
        WinGetPos ,,&W, &H, "A"
        W := W / 2
        H := H / 2
        ControlClick "X" W " Y" H, "A"
            ; Sleep 500
            ; Click
        Sleep 500
    }
}

copy2clip() {
    bak := ClipboardAll()
    A_Clipboard := ""
    Send("^c")
    if ClipWait(1.2, 1) {
        return A_Clipboard
    } else {
        ToolTip("Couldn't put text into Clipboard.")
        SetTimer () => ToolTip(), -5000
        A_Clipboard := bak
    }
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
    static Clock(T:=5) {

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
        g_Clock := Gui("", "Clock")
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
        ; MsgBox ProcessGetName(g_Clock.Title)
        Sleep(T*1000)
        Reload()
        ; PID := WinGetPID(g_Clock.Title)
        ; WinKill g_Clock.Title

    
    }
}
class Open {
    static VSC(input?, Editor?) {
        if IsSet(input){
            !IsSet(Editor) ? Run(VSC " " input) : Run(VSCodium " " input)   ;() => (Send("{LWin}"),SendIn("vs",0.1),SendIn("{Enter}",0.1),SendIn("{LWin}{Up}"))
        }
        else
            Run(Editor)

    }
}

RunActivate(Path,TabName:= "") { ; TabName is string that has to be in Tab's name, 
 If !BrowserTabFinder(TabName)
    Run Path
}

class Search {
    static Social_Media(input) {
        input := StrReplace(StrReplace(StrReplace(StrReplace(StrReplace(input, " ", "%20"), "`n", "%0A"), "`r", "%0D"), "%", "%25"),"+","%2B")
        Search.Facebook(input)
        Search.Reddit(input)
        Search.X(input)
        Search.YouTube(input)
        Search.Pinterest(input)
        ; Search.Instagram(input)
        ; Search.Tiktok (input)

        }
    static Smart(input) {
        OnError(Other)
        ItHas(strings*)=>IsIn(input,strings*)
        if ItHas("c:\","C:\",":\","http",".exe")
            Run(input)
        else
            Run("https://" input)
        Other(exception,mode){
            Run("https://" input)
            MsgBox("Option A: `n`tAn error might occur due to an incorrect path. Please verify the full path.`nOption B:`n`tMaybe it's http and not https.")
            ; return true
        }
    }
    static ChatGPT(Search_text,prompt:="") {
        if prompt == ""
            A_Clipboard := Search_text . "`s"
        else
            A_Clipboard := prompt . ' > ' . Search_text . "`s"
        if !BrowserTabFinder('ChatGPT') {
            Run ChatGPT
            Sleep 3000
            if BrowserTabFinder('ChatGPT') {
                WinWaitActive 'ChatGPT'
                Sleep 200
                WinActivate 'ChatGPT'
                Sleep 200
            }  
        }
        click_chatgpt_inputarea('ChatGPT')
        WinActivate 'ChatGPT'
        Send '^v' . ".{Backspace}"
        ; Send '^v' 
        ; Sleep 100
        ; Send ".{Backspace}"
        Sleep 100
        Send '{Enter}'
    
    }
    static YT(input) => Run("https://www.youtube.com/results?search_query=" . StrReplace(input, A_Space, "+"))
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

    static Emoji(input) => Run("https://emojipedia.org/search?q=" StrReplace(input, A_Space, "+"))
    static Translate(input) => Run("https://translate.google.com/?sl=en&tl=sr&text=" input "&op=translate")
    static Maps(input) => Run("https://www.google.com/maps?q=" StrReplace(input,A_Space,"+"))
        static Map(input) => Search.Maps(input)

    static Browser(input) => Run("https://duckduckgo.com/?t=ffab&q=" . StrReplace(input, A_Space, "+") . "&atb=v403-1&ia=web")
        static DuckDuckGo(input) => Run("https://duckduckgo.com/?q=" StrReplace(input, A_Space, "+"))
    static Facebook(input) => Run("https://www.facebook.com/search/top/?q=" StrReplace(input, A_Space, "+"))
    static X(input) => Run("https://x.com/search?q=" StrReplace(input, A_Space, "+") "&src=typed_query&f=top")
    static Reddit(input) => Run("https://www.reddit.com/search/?q=" StrReplace(input, A_Space, "+"))
    static YouTube(input) => Run("https://www.youtube.com/results?search_query=" StrReplace(input, A_Space, "+"))
    static Google(input) => Run("https://www.google.com/search?q=" StrReplace(input, A_Space, "+"))
    static LinkedIn(input) => Run("https://www.linkedin.com/search/results/all/?keywords=" StrReplace(input, A_Space, "%20"))
    static Instagram(input) => Run("https://www.instagram.com/explore/tags/" StrReplace(input, A_Space, ""))
    static Pinterest(input) => Run("https://www.pinterest.com/search/pins/?q=" StrReplace(input, A_Space, "%20") "&rs=typed")
    ; static Bing(input) => Run("https://www.bing.com/search?q=" StrReplace(input, A_Space, "+"))
    static Amazon(input) => Run("https://www.amazon.com/s?k=" StrReplace(input, A_Space, "+"))
    static StackOverflow(input) => Run("https://stackoverflow.com/search?q=" StrReplace(input, A_Space, "+"))
    static GitHub(input) => Run("https://github.com/search?q=" StrReplace(input, A_Space, "+") "&type=repositories")
    ; static Quora(input) => Run("https://www.quora.com/search?q=" StrReplace(input, A_Space, "+"))
    static Spotify(input) => Run("https://open.spotify.com/search/" StrReplace(input, A_Space, "%20"))
    static Wikipedia(input) => Run("https://en.wikipedia.org/wiki/Special:Search?search=" StrReplace(input, A_Space, "+"))
    static TikTok(input) => Run("https://www.tiktok.com/search?q=" StrReplace(input, A_Space, "+"))
}


Toggle(this){
    static Toggles := Map(
    "taskbar",  Automation '\Toggle_Hide_Taskbar.exe',
    
    )
    GoThrough(Toggles,this)
}
class Raw {

    static ahk := "Raw.ahk"
    static Run(input, mode := '') {
        Has(needles*)=>IsIn(input,needles*)
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
    
        if mode = 'RUN'{
            code :=
        (
        "
        OnError HideError
        ; i := Integer(`"cause_error`")

        Run(" input ")

        HideError(exception, mode) {
            MultiRun(" input ")
            ; return true
            ExitApp()
        }
        "
        )
        }
        else
            code := input
        FileAppend(code,Raw.ahk)   
        Run(Raw.ahk)
        return 1

    }

    static Editor() {
        ;?________________CUSTOMIZE______________________________________________________________
        DurationOfAppearance := 500
        Font := "Consolas", FontSize := "18", FontColor := "ffffff"
        BGColor := "001000"
        Width := 500, Height := 600
        
        ;*________________Gui_Object(Appearance)______________________________________________________________________
        GuiOptions := "AlwaysOnTop +Caption +Border "
        FontOptions := "q5"
        EditBoxOptions := "-E0x200 -VScroll " "W" (Width - 5) " h" (Height - 5)
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
        SetTimer () => myGui.Destroy(), -(DurationOfAppearance * 1000)

    }
}
         


class Type {
    static Enter() => Send("{Enter}")    
    static Backspace() => Send("{BS}")
    static Space() => Send(A_Space)
}
class Song {
    static Similar(input) => Run("https://www.chosic.com/playlist-generator/")
}
class Photo {
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

    static Shutdown(T:=1) => OS.ShutdownIn(1,T)
    static Sleep(T:=1) => (Sleep(T*1000),SendMessage(0x112, 0xF170, 2,, "Program Manager"))
    static Logoff(T:=1) => OS.ShutdownIn(0,T)
    static Restart(T:=1) => OS.ShutdownIn(2,T)
    static ForceShutdown(T:=1) => OS.ShutdownIn(4,T)
    static ForceRestart(T:=1) => OS.ShutdownIn(6,T)
    ; static RIP(T:=1) => OS.ShutdownIn(8,T) ; use on your own responsability
}
class PowerShell {
    static Path := "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe"
    static Run(Options) => Run('' PowerShell.Path ' ' Options,,"MIN")
    static AppsUseLightTheme(N) => PowerShell.Run('"New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value "' N '" -Type Dword -Force"')
    static SystemUsesLightTheme(N) => PowerShell.Run('"New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value "' N '" -Type Dword -Force"')
    static SetBrightness(P) => PowerShell.Run('"(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,"' P '")"')
    static ScreenSaver() => PowerShell.Run('-command "& (Get-ItemProperty ‘HKCU:Control Panel\Desktop’).{SCRNSAVE.EXE}"')
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
    static ActiveFolderPath() {
        shellWindows := ComObject("Shell.Application").Windows
        for window in shellWindows {
            try {
                if (InStr(window.FullName, "explorer.exe")) {
                    doc := window.Document
                    if (doc) {
                        path := doc.Folder.Self.Path
                        return path
                    }
                }
            }
            catch Error as e {
                ; Handle error if necessary
            }
        }
        return "No active folder path found."
    }
}

; class Mp3 {
; }


;? Hidden because it's pretty much useless 
; HideFromTaskbar(T := 3){
;     IID_ITaskbarList  := "{56FDF342-FD6D-11d0-958A-006097C9A090}"
;     CLSID_TaskbarList := "{56FDF344-FD6D-11d0-958A-006097C9A090}"
    
;     ; Create the TaskbarList object.
;     tbl := ComObject(CLSID_TaskbarList, IID_ITaskbarList)
    
;     activeHwnd := WinExist("A")
    
;     ComCall(3, tbl)                     ; tbl.HrInit()
;     ComCall(5, tbl, "ptr", activeHwnd)  ; tbl.DeleteTab(activeHwnd)
;     Sleep T * 1000  
;     ComCall(4, tbl, "ptr", activeHwnd)  ; tbl.AddTab(activeHwnd)
    
;     ; When finished with the object, simply replace any references with
;     ; some other value (or if its a local variable, just return):
;     tbl := ""
;     }


ShowMouseCordsGui() {
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

