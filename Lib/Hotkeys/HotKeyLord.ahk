#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk
; Holding Right Mouse Button while scrolling with Mouse Wheel to switch between windows
; RButton + Wheel => Switching trought tabs
RButton & WheelDown::AltTab
RButton & WheelUp::ShiftAltTab
    RButton::RButton

;? OFTEN APPS | APPS HOTKEYS - - - - - - - - - - - - - - - - - - - - - - - - 
;! -  -  -  -  -  -  -  -  -  -  -  - CAPSLOCK + KEY
; CapsLock & a::
CapsLock & b::Run Default_Browser
CapsLock & c::Run Google.Calendar
; CapsLock & d::
; CapsLock & e::
; CapsLock & f::
CapsLock & g::Run ChatGPT
CapsLock & h::Run Help
; CapsLock & i::
; CapsLock & j::
; CapsLock & k::
; CapsLock & l::
CapsLock & m::Run Google.Gmail
; CapsLock & n::
; CapsLock & o::
; CapsLock & p::
; CapsLock & q::
; CapsLock & r::
; CapsLock & s::        
; CapsLock & t::
; CapsLock & u::
; CapsLock & v::
CapsLock & w::Run WhatsApp
; CapsLock & x::
; CapsLock & y::
; CapsLock & z::
; NumLock & z::
; #HotIf

#HotIf GetKeyState("CapsLock","P")
; RShift::LC
; LShift & a::
; LShift & b::
LShift & c::Run 'calc.exe'
; LShift & d::
LShift & e::Run 'excel.exe'
; LShift & f::
; LShift & g::
; LShift & h::
; LShift & i::
; LShift & j::
; LShift & k::
; LShift & l::
LShift & m::Run A_MouseProperties
LShift & n::Run 'notepad.exe'
; LShift & o::
; LShift & p::
; LShift & q::
; LShift & r::
LShift & s::Send "#i"
; LShift & t::
; LShift & u::
; LShift & v::
LShift & w::Run 'winword.exe'
; LShift & x::
; LShift & y::
; LShift & z::
; LShift & 1::
; LShift & 2::
; LShift & 3::
; LShift & 4::
; LShift & 5::
; LShift & 6::
; LShift & 7::
; LShift & 8::
; LShift & 9::
; LShift & 0::
; LShift & F1::
; LShift & F2::
; LShift & F3::
; LShift & F4::
; LShift & F5::
; LShift & F6::
; LShift & F7::
; LShift & F8::
; LShift & F9::
; LShift & F10::
; LShift & F11::
; LShift & F12::
#HotIf