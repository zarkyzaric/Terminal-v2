﻿;?========================================================================
;?========================================================================
;?
;? PLACE THIS SCRIPT'S SHORTCUT IN YOUR STARTUP FOLDER 
;? TO AUTOMATICALLY RUN ON STARTUP
;?
;?========================================================================
;?========================================================================
#Requires Autohotkey v2.0
#SingleInstance Force



/* HOTSTRINGS FOR VARIABLES */

:*:curdate::{
    Send FormatTime(, "d.MM.yyyy")
}
:*:curtime::{
    Send(FormatTime(, "H:mm"))
}


#HotIf !(WinActive("ahk_class Chrome_WidgetWin_1")) && !(WinActive("ahk_exe ghostwriter.exe"))
LeaveBrac(s) {
    ; Selected := Get.SelectedText()
    ;     MsgBox(Selected)
    ; if  Selected != "" {
        ;     Send Selected
        ; }
        Send s "{Left}"
    Hook := InputHook("L1 V1 *" , "{BS}") ;
    Hook.Start(), Hook.Wait(), userInput := Hook.Input
    Reason := Hook.EndReason
    if (Reason == "EndKey") {
        Send "{NumpadDel}"
    }
    ; else if userInput == ")"
    ;     Send "{Right}{BS}"
}
/*          EASYTYPE ()[]{}""''        */
:*b0:(:: {
    LeaveBrac(")")
}
:*b0:[:: {
    LeaveBrac("]")
}
:*b0:{:: {
    LeaveBrac("{}}")
}
:*b0:":: {
    LeaveBrac('"')
}
:*b0:':: {
    LeaveBrac("'")
}
#HotIf

/* HOTSTRINGS FOR YOUR EMAILS */

:*:@mymail::{
    Send("example@email.com")
}
:*b0:@gmail::{
    Send(".com")
}


