#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk

; each pair of COMMAND-PATH or COMMAND-URL
; syntax is: 
; My_Commands := Map(
;     COMMAND1, PATH1,
;     COMMAND2, URL1,
; )
; Before we start dont forget to add ',' after
; Here are some examples: 
; My_Commands := Map(
; ; (A_User is variable that holds this path: "C:\Users\%Your Username%")

; ;  Folder Example (Will give an error if you dont have Playlists folder in Music one)

; "playlists",     A_User "\Music\Playlists",
; "viber",         A_User "\AppData\Roaming\Microsoft\Windows\Start Menu",

; ; You can also use full paths like this:

; "image",         "c:\Users\User\Pictures\example.jpg",
; )
;?========================================================================
;?     ADD YOUR DESIRED COMMANDS AND SHORTCUTS HERE
;?========================================================================
My_Commands := Map(

)


; ; Class of Arrays that will work as your bundles for specific work
; ; for example your Work, Project and so on...
; class Pack {
    ; :*    :startday::
    ; }
; Great for Workflows   