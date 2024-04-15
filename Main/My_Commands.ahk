#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk

My_Commands := Map(
    "v",                     () => Open.VSC(),
)
Default_Commands := Map(
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
    ; "discord",   s           "https://discord.com/channels/@me",
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
    "raw",                   () => Raw.Terminal(),
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
;?                       IMI                
;?=======================================================
    "h",                Help,
    "skr",              KURS.SKRIPTE,
    "arh",              KURS.ARH,
    ["spa","spa1"],     KURS.SPA1,
    ["mat","mat2"],     KURS.MAT2,
    ["pip","pip3"],     KURS.PIP3,
    "rs",               KURS.RS,
    "sa",               KURS.SA,
    "isp",              KURS.RASP_ISP,
    "klk",              KURS.RASP_KLK,
    ["oglasna","og"],   KURS.OGLASNA,

)