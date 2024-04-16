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

## Adding My Own Commands And Customizings
To add your own commands follow these steps:
1. Open `My Commands.ahk` in VSCode or as a text file
2. To add or modify variables that hold paths and URLs, edit the `Paths.ahk` file. You will there see something like this:
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
```

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