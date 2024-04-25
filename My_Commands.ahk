#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk

; Before we start dont forget to add ',' after
; each pair of COMMAND-PATH or COMMAND-URL
; syntax is: 
; My_Commands := Map(
;     COMMAND1, PATH1,
;     COMMAND2, URL1,
; )
; Here are some examples: 
; My_Commands := Map(
;(A_User is variable that holds this path: "C:\Users\%Your Username%")

; Folder Example (Will give an error if you dont have Playlists folder in Music one)

; "playlists",     A_User "\Music\Playlists",
; "viber",         A_User "\AppData\Roaming\Microsoft\Windows\Start Menu",

; You can also use full paths like this:

; "image",         "c:\Users\User\Pictures\example.jpg",
; )


;?========================================================================
;?     ADD YOUR DESIRED COMMANDS AND SHORTCUTS HERE
;?========================================================================
My_Commands := Map(


)

Default_Commands := Map(
;?=======================================================
;?                OFTEN DIRECTORIES                      
;?=======================================================
    ["downs","downloads"],    User.Downloads,
    "appdata",                User.AppData,
    ["pictures","images",
     "pics"],                 User.Pictures,    
    "music",                  User.Music,
    ["videos","vids"],        User.Videos,
    ["docs","documents"],     A_MyDocuments,
    "desktop",                A_Desktop,
    ["startup","sup"],        A_Startup,
    "startmenu",              A_StartMenu,
    "programs",               A_Programs,
    "myprograms", User.AppData "\Local\Programs",
;?=======================================================
;?                 OFTEN WEBSITES                
;?=======================================================
    ["g","gpt","chatgpt"],  "https://chat.openai.com",
    ["gm","gmail"],         Google.Gmail,
    ["cal","calendar"],     Google.Calendar,
    ["trans","translate"],  Google.Translate,
    "maps",                 Google.Maps,
    ["y","yt","youtube"],   Google.Youtube,
    "dm",                   Instagram.DM,
    ["ins","insta"],        Instagram.com,
    ["wa","whatsapp"],      "https://web.whatsapp.com/",
    ["pint","p"],           "https://www.pinterest.com/",
    "discord",              "https://discord.com/channels/@me",
;?=======================================================
;?                 DEFAULT APPS                
;?=======================================================
    ; "duo",                "https://www.duolingo.com/",
    ; "chess",              "www.chess.com/play",
;?=======================================================
;?                 OFTEN APPS                
;?=======================================================
    ["notepad","note"],     "notepad.exe",
    ["calc", "calculator"], "calc.exe", 
    "word",                 "winword.exe",
    ["ex","excel"],         "excel.exe",
    "cmd",                  () => CMD(),
    ["python","py"],        "python.exe",
;?=======================================================
;?                 OFTEN FUNCTIONS                
;?=======================================================
    "raw",                   () => Raw.Terminal(),
;?=======================================================
;?                 HOTKEY REPLACEMENTS                
;?=======================================================
    ["tsk","task manager","tman","task","mngr"
    ,"manager","tskmngr"],   () => Send("^+{Escape}"),
    ["settings","sett"],     () => Send("#i"),
    "display",               () => Send("#u"),
    ["emo","emoji"],         () => Send("#."),
    "tbar",                  () => Send("#b{Enter}"), 
    "display",               () => Send("#u"),
    ["date","time"],         () => Send("#!d"),
;?=======================================================
;?                 WINDOWS SETTINGS                
;?=======================================================
    "apps",                 A_Applications,
    "mouse",                A_MouseProperties,
;?=======================================================
;?                     AUTOMATION                
;?=======================================================
    "taskbar",               Automation "\Toggle_Hide_Taskbar.exe",
    "taskkill",              Automation '\Taskkiller.bat',

    ; ; Windows Window Switching:
    "1",                     () => Send("#1"),
    "2",                     () => Send("#2"),
    "3",                     () => Send("#3"),
    "4",                     () => Send("#4"),
    "5",                     () => Send("#5"),

    ;! myb Settings(#i) automation commands 
    
)
; ; Class of Arrays that will work as your bundles for specific work
; ; for example your Work, Project and so on...
; class Pack {
    ; :*    :startday::
    ; }
; Great for Workflows   