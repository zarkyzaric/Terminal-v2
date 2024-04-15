;
#Requires Autohotkey v2.0
; If script is running in the background, and you want to start it again, this command makes sure that is executed without a questioning you do you want to shutdown the previous one, but rather exits by default
#SingleInstance Force 
; library for personalized functions:
#Include <Functions> 
;library for file locations and urls:
#Include <Paths> 

; Fonts:
; "Bahnschrift"
; "System"
; "Fixedsys"
; "Palatino Linotype"
; Colors:
; 79461e
; 700000

;?_______________________________Gui_Design_________________________________________________

;*__________________CUSTOMIZE______________________________________________________________
DurationOfAppearance := 20
GuiOptions := "AlwaysOnTop -caption Border"
Font := "Consolas"
FontColor := "ffe6e6"
FontOptions := "s17 q5"
BGColor := "1e1e1e"
EditBoxOptions := "-E0x200 -VScroll Center x10 w377 h45"
PositionAndSize := "W400 H50 y20"

;*________________Gui_Object______________________________________________________________________

myGui := Gui(GuiOptions)
myGui.BackColor := BGColor   
myGui.SetFont(FontOptions " c" FontColor, Font) 
global Input := myGui.Add("Edit", "Background" BGColor " " EditBoxOptions) ; Adds an Input(Edit) Box in GUI
global WinID := myGui.Hwnd ; Saving Window handle for destroying GUI
myGui.Show(PositionAndSize)

;Input Handling  and Gui's Destruction
Destruction(t,shouldContinue := false) { ;for unknown reasons Destruction has to have 2 variables
    global Input
    userInput := Input.Value
    myGui.Destroy()
    if userInput == "" {
        ;// myGui.Destroy()
        ExitApp()
    }
    else if shouldContinue = true {
        ;//myGui.Destroy()
        if !(Terminal_1(userInput)){ ;If not found in first terminal, then go into a second one
            Terminal_2(userInput)
            SetTimer () => ExitApp(), -(DurationOfAppearance * 1000)
        }
    }
}
; If Input Bar exists or is active the following hotkeys will do certain actions
HotIfWinExist("ahk_id " WinID) 
    Hotkey("Escape",Destruction,"On")
; // HotIfWinExist("ahk_id " WinID) 
; //     Hotkey("RControl",Destruction,"On")
HotIfWinExist("ahk_id " WinID) 
    Hotkey("LButton",Destruction,"On") ; adds {Esc} hotkey if user wants to exit pop up
HotIfWinActive("ahk_id " WinID)
    Hotkey("Enter",Destruction.Bind(,true),"On") ; adds {Enter} hotkey if user wants to send value into execution


;?__________________________________________________________________________________________
Terminal_1(Input) { ; Handles one-word, unique location/url commands

    if Input==""
        return

    static Solos := Map(
    "docs", A_MyDocuments,
    "h", "https://www.autohotkey.com/docs/v2/FAQ.htm",
    "latex", "C:\Users\LEPALALA\Documents\ENV\Work\KaTeX.htm",
    "h", "https://www.autohotkey.com/docs/v2/FAQ.htm",
    "trans", "https://translate.google.com/",
    )
    if !(Solos.Has(Input)) ; if it doesn't have corresponding key, it goes onto a next terminal
        return 0
    GoThrough(Solos,Input)
    return 1
}

;?_______________________________________________________________________________________________
Terminal_2(Input) { ; Handles function calls and Maps in Maps 

    if Input==""
        return

    spacePos := InStr(Input, " ") 
    if !(spacePos) ; returns 0 if not found
        return
    else{
        prefix := SubStr(Input, 1, spacePos - 1)
        command := SubStr(Input, spacePos + 1)
    }
    ; static FuncCalls := Map(  
    ;     "y",    YTSearch.Bind(command), 
    ;     "git",  GitRep.Bind(command),
    ;     "s",    Search.Bind(command),
    ;     "url",  UrlSearch.Bind(command),
    ;     "gm",   Gmail.Bind(command),
    ;     "gmail",Gmail.Bind(command),
    ;     "mail", Gmail.Bind(command),
    ;     "a",    Run.Bind(command ".ahk"),  
    ;     "getlink", () => ((A_Clipboard := command),Run("GetLink.ahk")), 
    ;     "shutdown", () => (Sleep((Integer(command))*1000),Shutdown(1),ExitApp()),
    ;     "sleep", () => (Sleep((Integer(command))*1000),Shutdown(0),ExitApp()),
    ;     )
    ; GoThrough(FuncCalls,prefix) 


    static GPTs := Map(
        "ahk", AHK_gpt,
        "random", "https://chat.openai.com/c/2d6ba617-40be-496c-ad7d-05a851a44caf",
        "train", "https://chat.openai.com/c/db135fa0-c150-4954-ab67-470ad279e961",
        "toi", "https://chat.openai.com/c/49fd9714-1c6f-4a40-976f-d283a9f35cf7",
        "rs", "https://chat.openai.com/g/g-9YeZz6m6k-math-solver/c/8a5bbb86-25f0-40de-b8e4-0cc6a05c5ba1",
        "op", "https://chat.openai.com/c/83256ad1-f8ed-489f-94b2-205338da05a0",
        "gimp", "https://chat.openai.com/c/b95f1ec5-1e58-4d56-ad16-94271c9c7d19",
    )
    static AITools := Map(
        "leonardo", "https://app.leonardo.ai",
        "leonardo realtime", "https://app.leonardo.ai/realtime-gen",
        "pixverse", "https://app.pixverse.ai/create/video",
        "pixverse my", "https://app.pixverse.ai/create/history",
        "restore","https://replicate.com/tencentarc/gfpgan",
        "object remover","https://objectremover.com/",
        "sharpener","https://imglarger.com/Sharpener",
        "upscale","https://imglarger.com/ImageUpscaler",

    )
    ; static Mods := Map(

    ; )
    static Prefixes := Map(
        "g", GPTs,
        "im", Clrs,
        "ai", AITools,
        ; "mod", Mods,
    )

    
    if !(Prefixes.Has(prefix)) ; if prefix is not contained in Map, it exists program
        return
    for key in Prefixes { ; for loop for searching in for key matching with prefix
        if (key == prefix) { 
            Commands := Prefixes[key]
            if command == "opt" {
                AllOpt := ""
                for opt in Commands{
                    AllOpt := AllOpt . opt "`n"
                }
                SetTimer () => (ToolTip(AllOpt,960,60),Sleep(5000),Run(A_ScriptFullPath)), -1
                return
            }
            for com in Commands { ; for loop for searching a command that should be executed
                if (com == command){
                    Run(Commands[com])
                    return
                }
            } 
        }  
    }
    return
}


GoThrough(Commands,command, SubCommands := Map.Call()){
    for key in Commands{
        if (StrCompare(key,command) == 0) {
            if !(IsObject(Commands[key])) 
                Run(Commands[key])
            else
                Commands[key].Call() ; or Commands[key]() works the same
        }
    }
}

YTSearch(input) {
    Run("https://www.youtube.com/results?search_query=" StrReplace(input, A_Space, "+"))
}