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



;? OFTEN USED WINDOWS SETTINGS AND APPS
;! -  -  -  -  -  -  -  -  -  -  -  -
#HotIf GetKeyState("LShift","P")
;! CapsLock + LShift + KEY
#HotIf GetKeyState("CapsLock","P")
; RShift::L
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