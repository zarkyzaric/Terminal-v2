#Requires AutoHotkey v2.0
#SingleInstance Force

SavePath := A_ScriptDir "\My_Commands.ahk"
GuiColor := "F0F8FF" ; Light blue
FontColor := "003366" ; Dark blue

FormName := "Command Helper"
ch := Gui('', FormName)
ch.Opt("-MinimizeBox +alwaysOnTop")
ch.BackColor := GuiColor
ch.SetFont("s11 c" . FontColor)

; -----  Trigger string area
ch.AddText('ym', 'Trigger String')
DefHotStr := ch.AddEdit('vDefHotStr xm ')

; ----- Replacement string area
ch.AddText('xm ', 'Replacement String')
RepStr := ch.AddEdit('vRepStr +Wrap y+1 xs h100 w320')

; ----- Buttons
(ButApp := ch.AddButton('xm y+10', '&Append')).OnEvent("Click", chButtonAppend)
(ButOpen := ch.AddButton('+notab x+10', '&Open')).OnEvent("Click", chButtonOpen)
(ButCancel := ch.AddButton('+notab x+10', '&Cancel')).OnEvent("Click", chButtonCancel)

^!h::  ; Activation hotkey-combo (Win+h)
{
ch.Show('Autosize Center')
}
chButtonAppend(*) {
    tDefHotStr := ch['DefHotStr'].text
    tRepStr := ch['RepStr'].text
    Appendit(tDefHotStr, tRepStr)
}

Appendit(tDefHotStr, tRepStr) {
    if !InStr(tRepStr,"() =>") && !InStr(tRepStr,".Bind")  
        FileAppend("`n" "`"" tDefHotStr "`",    " "`"" tRepStr "`"" , SavePath)
    else 
        FileAppend("`n" "`"" tDefHotStr "`", " tRepStr , SavePath)
    Reload()  ; Reload the script so the new hotstring is active.
}
AppenditBetter(tDefHotStr, tRepStr){
    fileContent := FileRead(SavePath)
    if InStr(fileContent,"`n)"){
        StrSplit(fileContent,"`n)")

    }
    else
        MsgBox "Error Occurred while trying to append line to a file: " SavePath

    if !InStr(tRepStr,"() =>") && !InStr(tRepStr,".Bind")  
        FileAppend("`n" "`"" tDefHotStr "`",    " "`"" tRepStr "`"" , SavePath)
    else 
        FileAppend("`n" "`"" tDefHotStr "`", " tRepStr , SavePath)
    Reload()  ; Reload the script so the new hotstring is active.
}

chButtonOpen(*) {
    Run "notepad.exe", SavePath
}

chButtonCancel(*) {
    ExitApp
}
