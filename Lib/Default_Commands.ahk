#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\Lib\Paths.ahk


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
        "myprograms",             User.AppData "\Local\Programs",
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
        ["discord","disc"],             "https://discord.com/channels/@me",
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
        ; ["ex","excel"],         "excel.exe",
        ; ["python","py"],        "python.exe",
        ;?=======================================================
        ;?                 OFTEN FUNCTIONS                
        ;?=======================================================
        "cmd",                  () => CMD(),
        "py",                  "python.exe",
        "raw",                   () => Raw.Editor(),
    ;?=======================================================
    ;?                 HOTKEY REPLACEMENTS                
    ;?=======================================================
        ["tsk","task manager","task"],() => Send("^+{Escape}"),
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
        "mp3",                   () => (Run("pythonw.exe " Automation '\yt_downloader.py'),WinWait(),WinActivate()),
        "shutdown", () => OS.Shutdown(), ;shutdown @seconds
        "logoff",   () => OS.Logoff(), ; logoff @seconds
        "restart",  () => OS.Restart(), ; restart @seconds
        "sleep",  () => OS.Sleep(), ; restart @seconds
        
        
    
        ; ; Windows Window Switching:
        "1",                     () => Send("#1"),
        "2",                     () => Send("#2"),
        "3",                     () => Send("#3"),
        "4",                     () => Send("#4"),
        "5",                     () => Send("#5"),
    
        ;! myb Settings(#i) automation commands 

        "similar",               "https://www.chosic.com/playlist-generator/",

        
    )