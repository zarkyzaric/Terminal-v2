#Requires Autohotkey v2.0
#SingleInstance Force ; If script is running in the background, and you want to start it again, this input makes sure that is executed without a questioning you do you want to shutdown the previous one, but rather exits by default
; #NoTrayIcon
; library for personalized functions:
#Include <Functions>
;library for file locations,paths,urls,classes:
#Include <Paths> 
#Include <My_Paths>
; RControl::
; {
;F0FFFF;FFF8DC
;! ADD MODS:

;todo----------------------------------------------------------
;todo       CUSTOMIZE POPUP WINDOW'S APPEARANCE             
;todo----------------------------------------------------------

DurationOfAppearance := 1000

Font := "Consolas", FontColor := "ffe6e6", FontSize := 17, 
BGColor := "1e1e1e"
            
Width := 400, Height := 50

;todo----------------------------------------------------------

;Gui_Object(Extra Settings)(Not Recommended to edit if you don't know Gui Object in AHK)______________________________________________________________________
;_________________________________________________________________
GuiOptions := "+AlwaysOnTop -caption Border"
FontOptions := "q5"
InputBoxOptions := "-E0x200 -VScroll Center x0 " "W" Width " H" (Height - 5)
PositionAndSize := "W" Width "H" Height "y20"
; ShowTaskbarIcon := "+Owner"
;_________________________________________________________________


myGui := Gui(GuiOptions " -SysMenu ")
myGui.BackColor := BGColor   
myGui.SetFont("s" FontSize " " FontOptions " c" FontColor, Font) 
global Input := myGui.Add("Edit", "Background" BGColor " " InputBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := "ahk_id " myGui.Hwnd ; Saving Window handle for destroying GUI

iconsize := 32  ; Ideal size for alt-tab varies between systems and OS versions.
hIcon := LoadPicture(AHK.Lib "\duck.ico", "Icon1 w" iconsize " h" iconsize, &imgtype)
SendMessage(0x0080, 1, hIcon, MyGui) 

myGui.Show(PositionAndSize)

;Input Handling  and Gui's Destruction_____________________________________
Destruction(t,shouldContinue := False) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    userInput := Input.Value
    myGui.Destroy()
    if userInput == ""
        return
    else if shouldContinue = True {
        (Fuzzy_Navigator(userInput)) ;If not found in first terminal, then go into a second one
        ExitApp()
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
    Hotkey("/",Send_Stroke.Bind(,"_"),"On") ;!
;todo----------------------------------------------------------

SetTimer () => ExitApp(), -(DurationOfAppearance * 1000)

;?_______________________________________________________________________________________________
Fuzzy_Navigator(Input) {
    global My_Solo_Commands 
    
    if Input==""
        return
    else if SubStr(input,1,2) == "c=" {
        Raw.Run(input)
        return
    }

    static Solos := Map(    
;?=======================================================
;?                OFTEN DIRECTORIES                      ;@1
;?=======================================================
    ["downs","downloads"],    User.Downloads
    "appdata",                User.AppData
    "pictures"                User.Pictures
    "music",                  User.Music,
    "videos",                 User.Videos,
    ["docs","documents"],     A_MyDocuments,
    "desktop",                A_Desktop,
    ["startup","sup"],        A_Startup,
    ; "startmenu", A_StartMenu,
    ; "programs", A_Programs,
    ; "myprograms", User.AppData "\Local\Programs",
;?=======================================================
;?                 OFTEN WEBSITES                
;?=======================================================
    ["g","gpt","chatgpt"],  "https://chat.openai.com",
    ["gm","gmail"],         Google.Gmail,
    ["cal","calendar"],     Google.Calendar,
    "dm",                   Instagram.DM,
    ["ins","insta"],        Instagram.com,
    "trans",                Google.Translate,
    "wa",                   "https://web.whatsapp.com/",
    "maps",                 Google.Maps,
    ["pint","p"],           "https://www.pinterest.com/",
    ; "discord",              "https://discord.com/channels/@me",
    ; "duo",                "https://www.duolingo.com/",
    ; "chess",              "www.chess.com/play",
;?=======================================================
;?                 OFTEN APPS                
;?=======================================================
    ["note","notepad"],      "notepad.exe",
    ; "cmd",                   "cmd.exe",
;?=======================================================
;?                 OFTEN FUNCTIONS                
;?=======================================================
    "raw",                   () => Raw.Meat(),
;?=======================================================
;?                 HOTKEY REPLACEMENTS                
;?=======================================================
    ["task manager","tman","task","tsk","mngr"
    ,"manager","tskmngr"],   () => Send("^+{Escape}"),
    "settings",              () => Send("#i"),
    "display",               () => Send("#u"),
    ["emo","emoji"],         () => Send("#."),
    ["tbar","taskbar"],      () => Send("#b{Enter}"),
    "display",               () => Send("#u"),
    ; ; Windows Window Switching:
    "1",                     () => Send("#1"),
    "2",                     () => Send("#2"),
    "3",                     () => Send("#3"),
    "4",                     () => Send("#4"),
    "5",                     () => Send("#5"),
    ; ; Browser Window Switching:
    ; "w1",                    () => Send("^1"),
    ; "w2",                    () => Send("^2"),
    ; "w3",                    () => Send("^3"),
    ; "w4",                    () => Send("^4"),
    ; "w5",                    () => Send("^5"),
;?=======================================================
    )

    ; try 
    ;     GoThrough(Solos,Input)
    ; catch Error as err
    ;     OnError Raw.Run(input)
    GoTh := GoThrough.Bind(,input)
    if GoTh(My_Solo_Commands)
        return 1
    else if GoTh(Solos)
        return 1

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
        ; "default",  () => SetDefault(input),
        "r",        () => Raw.Run(input), ; r @raw_ahk_code
        
        "mp3",      () => Mp3.Download(input), ; mp3 @song_name
        "mpy",      () => Mp3.Download(input,"LINK"), ; mpy @youtube_url

        "s",        () => Search.Smart(input), ; s @search_text
        ["y","z"],  () => Search.YT(input), ; y @search_text
        "git",      () => Search.GitHub(input), ; git @search_text
        "g",        () => Search.GPT(input), ; g @prompt
        "p",        () => Search.Pinterest(input), ; p @search_text
        "em",       () => Search.Emoji(input), ; em @search_text
        "def",      () => Search.Meaning(input), ; def @define_text
        "art",      () => AI.Art(input), ; art @prompt

        ["pastebin","pb","bin"], () => Search.PasteBin(input), ; pb @unique_code

        "t",        () => Search.Translate(input), ; t @translate_text
        "conv",     () => Image.Convert(input), ; conv @from_format-to_format ; Example: conv webp-png 

        "shutdown", () => OS.Shutdown(input), ;shutdown @seconds
        "logoff",   () => OS.Logoff(input), ; logoff @seconds
        "restart",  () => OS.Restart(input), ; restart @seconds

        "h",        () => (Run(Help), Sleep(2000), SendText(input),Send("{Enter}")), ; h @search_text

        "theme",    () => Settings.Theme(input), ; theme @NN | N is either 1 or 0, first N is for System's Theme, second is for Window's theme (1=light, 0=dark)
        "brightness",() => Settings.Brightness(input), ; brightness @% | Example: brightness 70
        ; "play",     () => Run("ahk_exe ApplicationFrameHost.exe " input),

    )
    if GoThrough(FuncCalls,prefix)
        ExitApp()

    ; static Prefixes := Map(
    ;     "im", Image.Dict,
    ;     "ai", AI.Dict,
    ;     ; "find",     
    ;     ; "mod", Mods,

    ; )

    ; if !(Prefixes.Has(prefix)) ; if prefix is not contained in Map, it exists program
    ;     return
    ; for key in Prefixes { ; for loop for searching in for key matching with prefix
    ;     if (key == prefix) { 
    ;         Commands := Prefixes[key]
    ;         if input == "opt" { 
    ;             allOptions := ""    
    ;             for opt in Commands{
    ;                 allOptions := allOptions . opt "`n"
    ;             }
    ;             ; Hotkey("Enter",Run.Bind(A_ScriptFullPath),"On")
    ;             SetTimer () => (ToolTip(allOptions,960,60),Sleep(10000),Run(A_ScriptFullPath)), -1
    ;             return
    ;         }
    ;         for com in Commands { ; for loop for searching a input that should be executed
    ;             if (com == input){
    ;                 Run(Commands[com])
    ;                 return
    ;             }
    ;         }
    ;     }  
    ; }
    ExitApp()
    return
}