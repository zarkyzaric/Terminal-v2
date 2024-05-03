#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Paths.ahk
SavePath := This_ProjectDir "\My_Commands.ahk"
GuiColor := "f8ffde" ; Light blue
FontColor := "38000f" ; Dark blue

FormName := "Command Helper"
ch := Gui('', FormName)
ch.Opt("-MinimizeBox +alwaysOnTop")
ch.BackColor := GuiColor
ch.SetFont("s11 c" . FontColor)

chID:= "ahk_id " ch.Hwnd

; -----  Trigger string area
ch.AddText('ym', 'Trigger word')
DefHotStr := ch.AddEdit('vDefHotStr xm y+2')

; ----- Replacement string area
ch.AddText('xm ', 'Trigger`'s functionality')
RepStr := ch.AddEdit('vRepStr +Wrap y+2 xs h100 w320')

; ----- Buttons
(ButApp := ch.AddButton('xm y+10', '&Append')).OnEvent("Click", chButtonAppend)
(ButOpen := ch.AddButton('+notab x+10', '&Open')).OnEvent("Click", chButtonOpen)
(ButCancel := ch.AddButton(' x+10', '&Cancel')).OnEvent("Click", chButtonCancel)

^!h::  ; Activation hotkey-combo (Ctrl+Alt+h)
{
chID:= "ahk_id " ch.Hwnd
ch.Show('Autosize Center')
Destruction(t,YN := "Yes") => chButtonCancel()
; Ignore(t,IgnoreThisKey := "Yes") {
;     Send("")
; }
HotIfWinExist chID
    Hotkey("Escape",Destruction,"On")
    Hotkey("^Space",Destruction,"On")
    ; Hotkey("Enter",Ignore,"On")

}
chButtonAppend(*) {
    tDefHotStr := ch['DefHotStr'].text
    tRepStr := ch['RepStr'].text
    Appendit(tDefHotStr, tRepStr)
}

Appendit(tDefHotStr, tRepStr){
    fileContent := FileRead(SavePath)
    if InStr(fileContent,"`n)"){
        fileContent := StrSplit(fileContent,"`n)")
        left := fileContent[1] "`n"
        right := "`n)"
    }
    else{

        MsgBox "Error Occurred while trying to append line to a file: " SavePath
        return
    }
    FileDelete(SavePath)
    if InStr(tRepStr,"`n",,StrLen(tRepStr) - 2)
        tRepStr := SubStr(tRepStr,1,StrLen(tRepStr) - 2)
    if !InStr(tRepStr,"() =>") && !InStr(tRepStr,".Bind")  
        NewLine := '`"' tDefHotStr '`",    ' '`"' tRepStr '`", '
    else 
        NewLine := "`"" tDefHotStr "`",    " tRepStr ", "
    FileAppend(Left NewLine Right, SavePath)
    Reload()  ; Reload the script so the new hotstring is active.
}

chButtonOpen(*) {
    Run "notepad.exe "  SavePath
    ExitApp
}

chButtonCancel(*) {
    ExitApp
}
