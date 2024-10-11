;
#Requires AutoHotkey v2.0 
#SingleInstance Force
#Include %A_ScriptDir%\Lib\Functions.ahk
#Include %A_ScriptDir%\Lib\Paths.ahk
;?========================================================================
;?  ADD YOUR DESIRED COMMANDS AND SHORTCUTS HERE IN My_Commands
;?========================================================================

My_Commands := Map(
["og","imi"],    "imi.pm f.kg.ac.rs/oglasna-tabla", 
"studp",    "https://studportal.pmf.kg.ac.rs/student", 
"imioer",    "https://github.com/studnetwork/PMFKG",
["v","config","this"],        () => Open.VSC(A_WorkingDir),

)