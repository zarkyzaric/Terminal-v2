#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\Lib\Paths.ahk

R(a,b) => RunActivate(a,b)
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
        ["g","gpt","chatgpt"],  () => R(ChatGPT,"ChatGPT"),
        ["gm","gmail"],         Google.Gmail,
        ["cal","calendar"],     () => R(Google.Calendar,"Google "),
        ["tasks"],              Google.Tasks,
        ["trans","translate"],  Google.Translate,
        "maps",                 Google.Maps,
        ["y","yt","youtube"],   () => R(Google.Youtube,"Youtube"),
        ["ins","insta","dm"],   Instagram.DM,
        ["wa","whatsapp"],      WhatsApp,
        ["pint","p"],           "https://www.pinterest.com/",
        ["discord","disc"],     "https://discord.com/channels/@me",
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
        ["python","py"],        "python.exe",
    ;?=======================================================
    ;?                 OFTEN FUNCTIONS                
    ;?=======================================================
        "cmd",                  () => CMD(),
        "raw",                  () => Raw.Editor(),
        "get path",             Lib "\Tools\GetPath.ahk",
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
        "startup",              A_Startup,
        "apps",                 A_Applications,
        "mouse",                A_MouseProperties,
    ;?=======================================================
    ;?                     AUTOMATION                
    ;?=======================================================
        "taskbar",               Automation "\Toggle_Hide_Taskbar.exe",
        "taskkill",              Automation '\Taskkiller.bat',
        "mp3",                   () => (Run("pythonw.exe " Automation '\yt_downloader.py'),WinWait(),WinActivate()),
        "shutdown", () => OS.Shutdown(),
        "logoff",   () => OS.Logoff(),
        "restart",  () => OS.Restart(), 
        "sleep",  () => OS.Sleep(),
    
        ; ; Windows Window Switching:
        ; "1",                     () => Send("#1"),
        ; "2",                     () => Send("#2"),
        ; "3",                     () => Send("#3"),
        ; "4",                     () => Send("#4"),
        ; "5",                     () => Send("#5"),
        "ter",                   "https://github.com/zarkyzaric/Terminal-v2",
        ;! myb Settings(#i) automation commands 
        ; "similar",               "https://www.chosic.com/playlist-generator/",

        
    )

    IMI_Commands := Map(
        ["oglasna","og"],   KURS.OGLASNA,
        "klk",              KURS.RASP_KLK,
        "isp",              KURS.RASP_ISP,
        "skr",              KURS.SKRIPTE,
        
        ;? I godina________________________________________________________________________________
        "rs",               KURS.RS,
        ["pip","pip1"],     KURS.PIP1,
        ["sa","soal"],      KURS.SA,
        ["spa","spa1"],     KURS.SPA1,
        "pip3",             KURS.PIP3,
        "mat2",             KURS.MAT2,
        "arh",              KURS.ARH,
        
        ;? Predmeti
        ["oop"],            KURS.OOP,
        ["os","os1"],       KURS.OS1,
        "vap",              KURS.VAP,
    )