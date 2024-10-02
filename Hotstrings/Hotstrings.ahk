#Requires Autohotkey v2.0
#SingleInstance Force
;?========================================================================
;?========================================================================
;?
;? PLACE THIS SCRIPT'S SHORTCUT IN YOUR STARTUP FOLDER 
;? TO AUTOMATICALLY RUN ON STARTUP
;?
;?========================================================================
;?========================================================================
;-----------------------------------------------------------------------------------------
/* HOTSTRINGS FOR VARIABLES */
;-----------------------------------------------------------------------------------------
:*:curdate::{
    Send FormatTime(, "d.MM.yyyy")
}
:*:curtime::{
    Send FormatTime(, "H:mm") 
}
:*:]date::{
    Send FormatTime(, "d.MM.yyyy")
}
:*:]time::{
    Send FormatTime(, "H:mm")
}
:*:\date::{
    Send FormatTime(, "d.MM.yyyy")
}
:*:\time::{
    Send FormatTime(, "H:mm") 
}
:*:>date<::{
    Send FormatTime(, "d.MM.yyyy")
}
:*:>time<::{
    Send FormatTime(, "H:mm") 
}

;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
; AUTO FINISH BRACES
;-----------------------------------------------------------------------------------------
; :*?B0:(::){Left}
; :*?B0:[::]{Left}
#HotIf !(WinActive("ahk_class Chrome_WidgetWin_1")) && !(WinActive("ahk_exe ghostwriter.exe"))
LeaveBrac(s) {
    ; Selected := Get.SelectedText()
    ;     MsgBox(Selected)
    ; if  Selected != "" {
        ;     Send Selected
        ; }
        Send s 
        Send "{Left}"
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
; :*b0:(:: {
;     LeaveBrac(")")
; }
; :*b0:[:: {
;     LeaveBrac("]")
; }
; ; :*?B0:{::{}}{Left}

; :*b0:{:: {
;     LeaveBrac("{U+007D}")
; }
; :*b0:":: {
;     LeaveBrac('"')
; }
; :*b0:':: {
;     LeaveBrac("'")
; }
#HotIf
;-----------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------
/* HOTSTRINGS FOR YOUR EMAILS */
;-----------------------------------------------------------------------------------------
:*:@mymail::{
    Send("example@email.com")
}
:*b0:@gmail::{
    Send(".com")
}
;-----------------------------------------------------------------------------------------



; :*?:\e;skull::💀
; :*?:\e;speechless::😶
; :*?:\e;zzz::😴
; :*?:\e;sad::😔
; :*?:\e;madface::😠
; :*?:\e;emotionless::😑
; :*?:\e;wink::😉
; :*?:\e;smiley::😊

; :*?:html5template::
; (
; <!DOCTYPE html>
; <html lang="en">
; <head>
;     <meta charset="UTF-8">
;     <meta name="viewport" content="width=device-width, initial-scale=1.0">
;     <title>Document</title>
; </head>
; <body>
    
; </body>
; </html>
; )
; ::forloop::
; (
; for (int i = 0; i < count; i++) 
; { 

; }
; )

; ščžćđŠČŽĆĐ
;---------------------
:*?:\sh::š
:*?:\ch::č
:*?:\zh::ž
:*?:\vs::š
:*?:\vc::č
:*?:\vz::ž
:*?:\'c::ć
:*?:\;c::ć
:*?:\dj::đ
:*?:\Sh::Š
:*?:\Ch::Č
:*?:\Zh::Ž
:*?:\vS::Š
:*?:\vC::Č
:*?:\vZ::Ž
:*?:\'C::Ć
:*?:\;C::Ć
:*?:\Dj::Đ
