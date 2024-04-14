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
1. **Edit Hotkey**: Open `Hotkey.ahk` in a text editor.
2. **Set Keyboard Shortcut**: Define your desired keyboard shortcut. For guidance on writing hotkeys, visit the [AutoHotkey Hotkeys documentation](https://www.autohotkey.com/docs/Hotkeys.htm).
## Usage

Press `Ctrl+Alt+T` or your custom hotkey (*see down below how to customize it*) to open the popup terminal. Type a command and hit Enter to execute:

## Some Default Commands:
- **Search**: `n
type **s @search_text**
    Ex: `s How to draw better
- **Youtube Search** 
    type **y @search_text**
    - Ex: `y MrBeast latest video`
- **Translate**: type `t @translate_text
    - Ex: `t beetroot`
- **Search Command** type **s @search_text**
    - Ex: `s How to draw better`
- **Shutdown/Log off/Restart in Specific Time**: type `shutdown/logoff/restart @seconds`
    - Ex: `restart 120` (*this will restart the computer in 120 seconds*)




## Customizing

To add or modify variables that hold paths and URLs, edit the `Paths.ahk` file:
```ahk
; Example hotkeys:

^!t::Run(A_ScriptDir "\Terminal.ahk")

!n::Run("notepad.exe")
