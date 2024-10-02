#Requires AutoHotkey v2.0+
#SingleInstance Force
TraySetIcon "C:\Windows\System32\Shell32.dll", 245
~Escape::ExitApp
~!Space::Reload

VSCodePath := "C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
TraySetIcon "C:\Windows\System32\Shell32.dll", 245

; GUI Setup
MyGui := Gui()
MyGui.Title := "AHK Manager"
MyGui.BackColor := "313131"
MyGui.Add("Text", "x5 y3 w290 h50 cc47cff", "Running AHK Scripts:").SetFont("s13 Bold", "Calibri")
MyGui.Add("Text", "x250 y3 w120 h50 cffffff", "List Refresh:").SetFont("s11", "Calibri")

iconPath := "C:\Windows\System32\Shell32.dll"
iconNumber := 239

; Add the icon as a Picture control
icon := MyGui.Add("Picture", "x332 y3 w20 h20 Icon" . iconNumber, iconPath).OnEvent("Click", (*) => Refresh())
Scripts := MyGui.Add("ListBox", "x5 y25 w350 h200 vScriptList Background313131 cFFFFFF")
Scripts.SetFont("s9.5")

; Add buttons function
AddButton(x, y, w, text, callback) {
    btn := MyGui.AddButton(x " " y " " w, text)
    btn.OnEvent("Click", callback)
    btn.SetFont("s10")
    return btn
}

AddButton("x35", "y+m", "w90", "Reload All", (*) => ManageAllScripts("Reload"))
AddButton("x+m", "yp", "wp", "Suspend All", (*) => ManageAllScripts("Suspend"))
AddButton("x+m", "yp", "wp", "Kill All", (*) => ManageAllScripts("Kill"))
AddButton("x35", "y+m", "wp", "Reload", (*) => ReloadScript())
AddButton("x+m", "yp", "wp", "Suspend", (*) => SuspendScript())
AddButton("x+m", "yp", "wp", "Kill", (*) => ExitScript())
AddButton("x35", "y+m", "WP", "Select - Edit", (*) => EditScript())
AddButton("x+m", "yp", "wp", "GUI Reload", (*) => Reload())
AddButton("x+m", "yP", "wp", "Quit", (*) => ExitApp())

MyGui.Show("w360 h330")
Refresh()


Refresh() {
    DetectHiddenWindows(true)
    scriptList := []
    for script in WinGetList("ahk_class AutoHotkey") {
        title := WinGetTitle("ahk_id " script)
        SplitPath(title, &scriptName)
        if !(scriptName ~= "\.exe$") {
            scriptList.Push(scriptName " (" script ")")
        }
    }
    Scripts.Delete()
    Scripts.Add(scriptList)
    DetectHiddenWindows(false)
}

GetSelectedScriptInfo() {
    if (selectedItem := Scripts.Text) {
        scriptID := RegExReplace(selectedItem, ".*\((\d+)\).*", "$1")
        DetectHiddenWindows(true)
        winTitle := WinGetTitle("ahk_id " scriptID)
        DetectHiddenWindows(false)
        scriptPath := RegExReplace(winTitle, " - AutoHotkey v[^\s]+$")
        return { path: scriptPath, id: scriptID }
    }
    return false
}

EditScript() {
    if (scriptInfo := GetSelectedScriptInfo()) {
        if FileExist(scriptInfo.path) {
            if FileExist(VSCodePath) {
                Run(VSCodePath ' "' scriptInfo.path '"')
            } else {
                MsgBox("VS Code not found at the specified path. Please update the VSCodePath variable.")
            }
        } else {
            MsgBox("Unable to find the script file at path: " scriptInfo.path)
        }
    } else {
        MsgBox("Please select a script to edit.")
    }
    Refresh()
}

SendAHKMessage(scriptPath, message) {
    DetectHiddenWindows(true)
    SetTitleMatchMode(2)
    if (hWnd := WinExist(scriptPath " ahk_class AutoHotkey")) {
        PostMessage(0x111, message, 0,, "ahk_id " hWnd)
        return true
    }
    return false
}

ReloadScript() {
    if (scriptInfo := GetSelectedScriptInfo()) {
        SendAHKMessage(scriptInfo.path, 65400)
    }
    Refresh()
}

SuspendScript() {
    if (scriptInfo := GetSelectedScriptInfo()) {
        SendAHKMessage(scriptInfo.path, 65404)
    }
    Refresh()
}

ExitScript() {
    if (scriptInfo := GetSelectedScriptInfo()) {
        SendAHKMessage(scriptInfo.path, 65405)
    }
    Refresh()
}

ManageAllScripts(action) {
    DetectHiddenWindows(true)
    for script in WinGetList("ahk_class AutoHotkey") {
        winTitle := WinGetTitle("ahk_id " script)
        scriptPath := RegExReplace(winTitle, " - AutoHotkey v[^\s]+$")
        if (A_ScriptFullPath != scriptPath) {
            switch action {
                case "Reload": SendAHKMessage(scriptPath, 65400)
                case "Suspend": SendAHKMessage(scriptPath, 65404)
                case "Kill": SendAHKMessage(scriptPath, 65405)
            }
        }
    }
    DetectHiddenWindows(false)
    Refresh()
}