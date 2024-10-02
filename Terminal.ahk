#Requires Autohotkey v2.0
#Include %A_ScriptDir%\Lib\All.ahk
#SingleInstance Force ; If script is running in the background, and you want to start it again, this input makes sure that is executed without a questioning you do you want to shutdown the previous one, but rather exits by default
#NoTrayIcon


;*----------------------------------------------------------
;*       CUSTOMIZE POPUP WINDOW'S APPEARANCE             
;*----------------------------------------------------------

DurationOfAppearance := 60 ; seconds

Font          := "Consolas", 
FontColor     := "F0FFFF" ; RGB
FontSize      := 17 

BGColor       := "2e023e" ; RGB

Width         := 400
Height        := 50

; Image         := A_ScriptDir "\Lib\Images\icon.png"
; GIF         := A_ScriptDir "\Lib\Images\bg.gif"
; Transparancy  := 245    ; 0-255 
;todo----------------------------------------------------------

;_________________________________________________________________
;Gui_Object(Extra Settings)(Not Recommended to edit if you don't know Gui Object in AHK)______________________________________________________________________
;_________________________________________________________________


GuiOptions := "+AlwaysOnTop -caption +Border -SysMenu "
FontOptions := "q5"
PositionAndSize := "W" Width "H" Height  "y20"
InputBoxOptions := "-E0x200 -VScroll Center x0 " "W" Width " H" (Height - 10)

myGui := Gui(GuiOptions )
; ImageGui := Gui(GuiOptions)
; imageGui.Add("ActiveX","w300 h100 x100 y-30", GIF)
; imageGui.BackColor := BGColor  
myGui.BackColor := BGColor  
; WinSetTransColor("0e0e0e 255", myGui)
; WinSetTransparent(Transparancy, myGui)
; WS_CLIPSIBLINGS := 0x4000000
; imageGui.AddPic(' w50 h-1 x0 y0', image)
; WinSetTransparent(Transparancy, imageGui)

myGui.SetFont("s" FontSize " " FontOptions " c" FontColor, Font)
global Input := myGui.Add("Edit", "Background" BGColor " " InputBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := "ahk_id " myGui.Hwnd ; Saving Window handle for destroying GUI
; global ImageID := "ahk_id " imageGui.Hwnd ; Saving Window handle for destroying GUI


; ImageGui.Show(PositionAndSize)
myGui.Show(PositionAndSize)
; WinActivate WinID

;Input Handling  and Gui's Destruction_____________________________________
Destruction(t,shouldContinue := False) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    userInput := Input.Value
    myGui.Destroy()
    ; ImageGui.Destroy()    
    if userInput == ""
        return
    else if shouldContinue = True {
        (Fuzzy_Navigator(userInput)) ;If not found in first terminal, then go into a second one
    }
}
Arrow(t,Arrow := "Up"){
    OnError ShowEmpty
    og_input := Input.Value
    static i := 0
    fileContent := FileRead("History.txt")
    history:= StrSplit(fileContent,"`n")
    if fileContent == ""
        len := -1
    else
        len := history.Length
    ; msgbox history[len - i]
    if i <= len && i >= -1 {
        if Arrow == "Up"        && i < len - 1 { 
            i += 1
            ; if i == len
        }
        else if Arrow == "Down" && i > 0 {
            i -= 1
            if i == 0
                Input.Value := og_input

        }
        Input.Value := history[len - i]
    }
    ShowEmpty(exception, mode) {
        ; Input.Value := og_input
        i := -1
    }
}
; If Input Bar exists or is active the following hotkeys will do certain actions

;todo----------------------------------------------------------
;todo                POPUP WINDOW HOTKEYS             
;todo----------------------------------------------------------
HotIfWinExist(WinID)
    Hotkey("Enter",Destruction.Bind(,True),"On")
    Hotkey("NumpadEnter",Destruction.Bind(,True),"On")
    Hotkey("^Space",Destruction.Bind(,True),"On")
    Hotkey("Escape",Destruction,"On")
    Hotkey("LButton",Destruction,"On")
    Hotkey("LWin",Destruction,"On")
    Hotkey("^w",Destruction,"On")
    Hotkey("'",Send_Stroke.Bind(,"`'`'{Left}"),"On") ;!
    Hotkey('"',Send_Stroke.Bind(,"`"`"{Left}"),"On") ;!
    
    Hotkey("Up",Arrow.Bind(,"Up"),"On")
    Hotkey("Down",Arrow.Bind(,"Down"),"On")
;todo----------------------------------------------------------

SetTimer () => ExitApp(), -(DurationOfAppearance * 1000)

; ;* PYTHON GUI
; userInput := FileRead(A_ScriptDir "\input.txt")
; if userInput == ""
;     return
; else
;     Fuzzy_Navigator(userInput)

; ExitApp()
;?_______________________________________________________________________________________________
Fuzzy_Navigator(Input) {
    global Default_Commands,My_Commands
    ; Content := FileRead("History.txt")
    if Input=="" 
        return
    FileAppend(Input '`n' ,"History.txt")
    if SubStr(input,1,2) == "c=" {
        Raw.Run(input)
        return
    }
    GoTh := GoThrough.Bind(,input)
    if GoTh(Default_Commands)
        return
    if GoTh(My_Commands)
        return
    spacePos := InStr(Input," ")
    if !(spacePos)
        return
    else {
        prefix := SubStr(Input, 1, spacePos - 1)
        input := SubStr(Input, spacePos + 1)
    }
;?=======================================================
;?             FUNCTIONS WITH PARAMETERS                 
;?=======================================================
    static FuncCalls := Map(  
        ;TODO "default",  () => SetDefault(input),
        "raw",      () => Raw.Run(input), ; r @raw_ahk_code
        "r",        () => Raw.Run(input,'RUN'),
        
        "s",        () => Search.Smart(input), ; s @search_text
        ["y","z"],  () => Search.YT(input), ; y @search_text
        ["gh","git"],() => Search.GitHub(input), ; git @search_text
        "github",   ()=> Run("www.github.com/" input),
        "g",   () => Search.ChatGPT(input), ; g @prompt
        "p",        () => Search.Pinterest(input), ; p @search_text
        "em",       () => Search.Emoji(input), ; em @search_text
        "def",      () => Search.Meaning(input), ; def @define_text
        "gm",       () => Google.Mail(input), ; gm  @N
        "wiki",     () =>  Search.Wikipedia(input), ; wiki @search_text
        ["sof","so"], () => Search.StackOverflow(input),
        ["m","map","maps"],     () => Search.Maps(input), ; maps @search_text
        ["pastebin","pb","bin"], () => Search.PasteBin(input), ; pb @unique_code
        
        ["t","trans"], () => Search.Translate(input), ; t @translate_text
        "conv",     () => Photo.Convert(input), ; conv @from_format-to_format ; Example: conv webp-png 
        "toggle",   () => Toggle(input),

        "shutdown", () => OS.Shutdown(input), ;shutdown @seconds
        "logoff",   () => OS.Logoff(input), ; logoff @seconds
        "restart",  () => OS.Restart(input), ; restart @seconds
        "sleep",    () => OS.Sleep(input), ; restart @seconds
        "h",        () => (Run(Help), SendIn("!s",1.5), SendText(input),Send("{Enter}")), ; h @search_text
        
        "theme",     () => Settings.Theme(input), ; theme @NN | N is either 1 or 0, first N is for System's Theme, second is for Window's theme (1=light, 0=dark)
        "brightness",() => Settings.Brightness(input), ; brightness @% | Example: brightness 70
        
        "cmd",      () => CMD(input), ; cmd @cmd_parameters
        "taskkill", () => CMD("taskkill /im & " input ".exe /f & timeout /t 2 & exit"), ; cmd @cmd_parameters
        "pip",      () => CMD("pip " input), ; cmd @cmd_parameters
        "mp3",      () => CMD("cd " A_ScriptDir "\Lib\Automation & python yt_bg.py `"" input "`"" ""),
        ; ["touch","mfl","mf"], () => FileGen(input),
        ["co","create",
        "new","touch"], () => CMD('cd `"' A_ScriptDir '\Lib\Automation`" & python create_and_open_file.py `"' input '`"' ' ' '`"' Get.ActiveFolderPath() '`"  & exit'),
    )
    GoThrough(FuncCalls,prefix)
    ;TODO myb add here to delete this unrecognized input
    ;TODO if !GoThrough(FuncCalls,prefix)
    ;TODO delete last History.txt line
    ExitApp()

}