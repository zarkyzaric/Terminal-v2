#Requires Autohotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk
#F10::
F22:: {
    hook := InputHook("L3 -V M")
    hook.KeyOpt("{All}", "+E")
    hook.KeyOpt("1234567890{Numpad1}{Numpad2}{Numpad3}{Numpad4}{Numpad5}{Numpad6}{Numpad7}{Numpad8}{Numpad9}{Numpad0}{F22}{F10}", "-E +S")
    hook.Start()
    KeyWait SubStr(A_ThisHotkey, -3)
    hook.Stop()
    if (hook.Input) {
        Send "{Volume_Up}"
        SoundSetVolume Integer(hook.Input)
    }
}
