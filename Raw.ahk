#Requires Autohotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
#Include My_Commands.ahk
    Loop 10000 {
        t1:=A_TickCount, Text:=X:=Y:=""
        Text:="|<gptpin>**50$20.0Dz07Us3U70kkkMz46Qt1a6ENUXyLgbbD9tnmSQwbbD9tnmSQwbbD9tnmSQwbbD9tXaC0tnkSQTz7XzXMTln1UsQ0Q3sy8"
        ok:=FindText(&X, &Y, 0,0,0,0,0,0, Text)
        if !ok.length
            continue
        else
            {
                FindText().Click(X+50, Y, "L")
                break
            }
        }
