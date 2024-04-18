## Version 2.1 in development:
Planned new features & progress of the project can be found [here](https://github.com/users/zarkyzaric/projects/1/views/1)

---
# Custom Search Functions and Commands Popup Terminal

This project provides a custom popup terminal using AutoHotkey to facilitate quick access to specific websites, apps, and search functions through custom commands.

## Features

- **Quick Access**: Open websites and apps directly from the terminal.
- **Custom Search**: Execute predefined searches with just a few keystrokes.
- **Extensibility**: Easily add or modify commands as needed.

## Installation

1. **Install AutoHotkey**: Download and install from [AutoHotkey](https://www.autohotkey.com/).
2. **Download Scripts**: Download the script files as [ZIP](https://github.com/zarkyzaric/Terminal-v2/archive/refs/heads/main.zip) to your local machine or clone this repository.
3. **Run**: Double-click the `Terminal.ahk` file to run the script.


To set up your custom hotkey:
1. **Edit Hotkeys**: Open `Hotkeys.ahk` in a text editor.
2. **Set Keyboard Shortcut**: Define your desired keyboard shortcut. For guidance on writing hotkeys, visit the [AutoHotkey Hotkeys documentation](https://www.autohotkey.com/docs/Hotkeys.htm).

## Usage

Press `Ctrl+Alt+T` or your custom hotkey (*see down below how to customize it*) to open the popup terminal. Type a command and hit Enter to execute:

## Some Default Commands:
- **Search**: [ **s** *@search_text* ]
    > **s** How to draw better
- **Youtube Search**: [ **y** *@search_text* ]
    > **y** MrBeast latest video
- **Translate**: [ **t** *@translate_text* ]
    > **t** beetroot
- **Shutdown/Log off/Restart in Specific Time**: [**shutdown/logoff/restart** *@seconds*]
    > **restart** 120 (*this will restart the computer in 120 seconds*)
- **Brightness**: [ **brightness** *@%* ]
    > **brightness** 70
- **Theme**: [ **theme** *@NN* ]
    > **theme** 11 (*Light Theme*)
    > **theme** 00 (*Dark Theme*)
---
## On Startup
To set script to autorun on startup, place `Hotkeys.ahk` shortcut in your Startup folder. If you don't know how to access Startup folder, press Win+R and type "shell:startup" and then press Enter.

## Adding My Own Commands
To add your own commands follow these steps:
1. Open `My Commands.ahk` in VSCode or as a text file
2. Read everything bellow the 4. line for default commands,examples, usage, and adding your custom ones. There you will see something like this:
```ahk
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
"playlists",     A_User "\Music\Playlists",
"viber",         A_User "\AppData\Roaming\Microsoft\Windows\Start Menu",
; You can also use full paths like this:
"image",         "c:\Users\User\Pictures\example.jpg"
; )


;?========================================================================
;?     ADD YOUR DESIRED COMMANDS AND SHORTCUTS HERE
;?========================================================================
My_Commands := Map(


)

Default_Commands := Map(
;?=======================================================
;?                OFTEN DIRECTORIES                      ;@1
;?=======================================================
    ["downs","downloads"],    User.Downloads,
    "appdata",                User.AppData,
    ["pictures","images","pics"], User.Pictures,    
    "music",                  User.Music,
    ["videos","vids"],        User.Videos,
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
    ; "raw",                   () => Raw.Terminal(),
;?=======================================================
;?                 HOTKEY REPLACEMENTS                
;?=======================================================
    ["task manager","tman","task","tsk","mngr"
    ,"manager","tskmngr"],   () => Send("^+{Escape}"),
    ["settings","sett"],     () => Send("#i"),
    "display",               () => Send("#u"),
    ["emo","emoji"],         () => Send("#."),
    ["tbar","wifi"],      () => Send("#b{Enter}"),
    "display",               () => Send("#u"),
    "taskbar",               Batch "\Toggle_Hide_Taskbar.exe",
    ; ; Windows Window Switching:
    "1",                     () => Send("#1"),
    "2",                     () => Send("#2"),
    "3",                     () => Send("#3"),
    "4",                     () => Send("#4"),
    "5",                     () => Send("#5"),


)
```





. To add or modify variables that hold paths and URLs, edit the `Paths.ahk` file. You will there see something like this:
```ahk

#Requires AutoHotkey v2.0
Help := "https://www.autohotkey.com/docs/v2/FAQ.htm"
CMD := "C:\Windows\system32\cmd.exe"
Class Instagram {
    static COM := "https://www.instagram.com"
    static URL := "https://www.instagram.com"
    static DM := instagram.url "/direct"
}
class Google {
    static Calendar := "https://calendar.google.com/calendar/u/0/r"
    static Maps := "https://www.google.com/maps"

. . .
```
Following the syntax 

## CREATING HOTKEYS
```ahk
; Example hotkeys:

^!t::Run(A_ScriptDir "\Terminal.ahk")

!n::Run("notepad.exe")
```

## RECOMMENDED VSC EXTENSIONS
> Simply paste this in VSC extensions search (Press Ctrl + Shift + X)
- AUTOFOLDING => *bobmagicii.autofoldyeah*
- BETTER COMMENTS => *aaron-bond.better-comments*
