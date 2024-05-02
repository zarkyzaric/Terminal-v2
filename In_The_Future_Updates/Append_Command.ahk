#Requires AutoHotkey v2.0
#SingleInstance Force
; Modifierd code from AutoCorrect.ahk

;==Change=colors=as=desired========================
GuiColor := "F0F8FF" ; "F0F8FF" is light blue
FontColor := "003366" ; "003366" is dark blue
FormName := "Command Maker -- Multi-Line" ; Change here, if desired.
;==================================================

Global hFactor := 0 ; Don't change size here.  Change in TogSize() function, below.
Global wFactor := 0 ; Don't change here.  Change in TogSize() function.

hh := Gui('', FormName)
hh.Opt("-MinimizeBox +alwaysOnTop")
hh.BackColor := GuiColor
hh.SetFont("s11 c" . FontColor)
; -----  Trigger string parts
hh.AddText('y4 w30', 'Options')
hh.AddText('vTrigStrLbl x+20 w250', 'Trigger String')
hh.AddEdit('vMyDefaultOpts yp+20 xm+10 w30 h24')
DefHotStr := hh.AddEdit('vDefHotStr x+28 w' . wFactor + 250, '')
; ----- Replacement string parts
hh.AddText('xm', 'Enter Replacement String')
hh.SetFont('s9')
hh.AddButton('vSizeTog x+5 yp-5 h8 +notab', 'Make Bigger').OnEvent("Click", TogSize)
hh.SetFont('s11')
;RepStr := hh.AddEdit('vRepStr +Wrap yp+25 xs h' . hFactor + 100 . ' w' . wFactor + 320, '')
RepStr := hh.AddEdit('vRepStr +Wrap y+1 xs h' . hFactor + 100 . ' w' . wFactor + 320, '')
ComLbl := hh.AddText('xm y' . hFactor + 182, 'Enter Comment')
hh.SetFont("s11 cGreen")
ComStr := hh.AddEdit('vComStr xs y' . hFactor + 200 . ' w' . wFactor + 315)
; ---- Buttons
(ButApp := hh.AddButton('xm y' . hFactor + 234, '&Append')).OnEvent("Click", hhButtonAppend)
(ButVal := hh.AddButton('+notab x+5 y' . hFactor + 234, '&Validate')).OnEvent("Click", hhButtonValidate)
(ButSpell := hh.AddButton('+notab x+5 y' . hFactor + 234, '&Spell')).OnEvent("Click", hhButtonSpell)
(ButOpen := hh.AddButton('+notab x+5 y' . hFactor + 234, '&Open')).OnEvent("Click", hhButtonOpen)
(ButCancel := hh.AddButton('+notab x+5 y' . hFactor + 234, '&Cancel')).OnEvent("Click", hhButtonCancel)

#j::   ; HotString Helper activation hotkey-combo (not string) is Win+h. Change if desired.
{ MyDefaultOpts := ""
  DefaultHotStr := ""
  Global myPrefix := ""
  Global mySuffix := ""
  Global ClipboardOld := ClipboardAll() ; Save and put back later.
  A_Clipboard := ""  ; Must start off blank for detection to work.
  Send("^c") ; Copy selected text.
  Errorlevel := !ClipWait(0.3) ; Wait for clipboard to contain text.
  If !InStr(A_Clipboard, "`n") ; Only trim NON multi line text strings.
    A_Clipboard := Trim(A_Clipboard) ; Because MS Word keeps leaving spaces.

  ; If white space present in selected text, probably not an Autocorrect entry.
  If (InStr(A_Clipboard, " ") || InStr(A_Clipboard, "`n"))
  {
   ;=======Change=options=for=MULTI=word=entry=options=and=trigger=strings=as=desired==============
   MyDefaultOpts := ""    ; PreEnter these multi-word hotstring options; "*" = end char not needed, etc.
   myPrefix := ";"        ; Optional character that you want suggested at the beginning of each hotstring.
   addFirstLetters := 5   ; Add first letter of this many words. (5 recommended; 0 = don't use feature.)
    tooSmallLen := 2      ; Only first letters from words longer than this. (Moot if addFirstLetters = 0)
   mySuffix := ""         ; An empty string "" means don't use feature.
  ;===========================================================one=more=below=======================
    If (addFirstLetters > 0)
    { LBLhotstring := "Edit trigger string as needed"
      initials := "" ; Initials will be the first letter of each word as a hotstring suggestion.
      HotStrSug := StrReplace(A_Clipboard, "`n", " ") ; Unwrap, but only for hotstr suggestion.
      Loop Parse, HotStrSug, A_Space
      { If (Strlen(A_LoopField) > tooSmallLen) ; Check length of each word, ignore if N letters.
           initials :=initials . SubStr(A_LoopField, ("1")<1 ? ("1")-1 : ("1"), "1")
        If (StrLen(initials) = addFirstLetters) ; stop looping if hotstring is N chars long.
           break
      }
      initials := StrLower(initials)
      DefaultHotStr := myPrefix . initials . mySuffix ; Append preferred prefix or suffix, as defined above, to initials.
    }
    else
    {LBLhotstring := "Add a trigger string"
     DefaultHotStr := myPrefix . mySuffix ; Use prefix and/or suffix as needed, but no initials.
    }
  }
  Else If (A_Clipboard = "")
      LBLhotstring := "Add a trigger string"
  else
  { LBLhotstring := "Add misspelled word"
    DefaultHotStr := A_Clipboard ; No spaces found so assume it's a mispelling autocorrect entry: no pre/suffix.
    ;===============Change=options=AUTOCORRECT=words=as=desired======================================
    myDefaultOpts := ""    ; PreEnter these (single-word) autocorrect options; "T" = raw text mode, etc.
    ;================================================================================================
  }
  hh['MyDefaultOpts'].value := MyDefaultOpts
  hh['TrigStrLbl'].value := LBLhotstring
  hh['DefHotStr'].value := DefaultHotStr
  hh['RepStr'].value := A_Clipboard
  hh['RepStr'].Opt("-Readonly")
  ButApp.Enabled := true
  hh.Show('Autosize')
} ; bottom of hotkey function

TogSize(*)
{   If (hh['SizeTog'].text = "Make Bigger") {
    hh['SizeTog'].text := "Make Smaller"
    ; ======Change=size=of=GUI=when="Make Bigger"=is=envoked========
    hFactor := 200 ; Height of Replacement box, Y pos of things below it.
    wFactor := 200 ; Width of 3 of the edit boxes.
    ;===============================================================
    SubTogSize(hFactor, wFactor)
    hh.Show('Autosize Center')
    return
  }
  If (hh['SizeTog'].text = "Make Smaller") {
    hh['SizeTog'].text := "Make Bigger"
    SubTogSize(0, 0)
    hh.Show('Autosize')
    return
  }
  SubTogSize(hFactor, wFactor)
  {
    DefHotStr.Move(,, wFactor + 250,)
    RepStr.Move(,, wFactor + 320, hFactor + 100)
    ComLbl.Move(, hFactor + 182,,)
    ComStr.move(, hFactor + 200, wFactor + 315,)
    ButApp.Move(, hFactor + 234,,)
    ButVal.Move(, hFactor + 234,,)
    ButSpell.Move(, hFactor + 234,,)
    ButOpen.Move(, hFactor + 234,,)
    ButCancel.Move(, hFactor + 234,,)
  }
}

#HotIf WinActive(FormName, ) ; Allows window-specific hotkeys.
{
; $Enter:: ; When Enter is pressed, but only in this GUI. "$" prevents accidental Enter key loop.
;   { If (hh['SymTog'].text = "Hide Symb")
;       return
;     Else if RepStr.Focused {
;       Send("{Enter}") ; Just normal typing; Enter yields Enter key press.
;       Return
;     }
;     Else {
;       hhButtonAppend() ; Replacement box not focused, so press Append button.
;       return
;     }
;   }
  Esc::
  { hh.Hide()
    A_Clipboard := ClipboardOld
  }
}
#HotIf ; Turn off window-specific behavior.

hhButtonAppend(*)
{ tMyDefaultOpts := hh['MyDefaultOpts'].text
  tDefHotStr := hh['DefHotStr'].text
  tRepStr := hh['RepStr'].text
  ValidationFunction(tMyDefaultOpts, tDefHotStr, tRepStr)
  If Not InStr(CombinedValidMsg, "-Okay.",,, 3)
  {    ; Msg doesn't have three occurrences of "-Okay."
    msgResult := MsgBox(CombinedValidMsg "`n`n####################`nContinue Anyway?", "VALIDATION", "OC 4096" )
    if (msgResult = "OK") {
       Appendit(tMyDefaultOpts, tDefHotStr, tRepStr) ; not valid, but user chose to continue anyway
       return
     }
    else
       return ; not valid, and user cancelled
  }
  else { ; no validation problems found
    Appendit(tMyDefaultOpts, tDefHotStr, tRepStr)
    return
 }
}

hhButtonValidate(*)
{ tMyDefaultOpts := hh['MyDefaultOpts'].text
  tDefHotStr := hh['DefHotStr'].text
  tRepStr := hh['RepStr'].text
  ValidationFunction(tMyDefaultOpts, tDefHotStr, tRepStr)
  MsgBox("Validation Results`n#################`n" . CombinedValidMsg,, 4096)
  Return
}

ValidationFunction(tMyDefaultOpts, tDefHotStr, tRepStr)
{ Global CombinedValidMsg
  ThisFile := Fileread(A_ScriptName) ; Save these contents to variable 'ThisFile'.
 ; ThisFile := Fileread("S:\AutoHotkey\MasterScript\MasterScript.ahk") ; <---- CHANGE later
  If (tMyDefaultOpts = "") ; If options box is empty, skip regxex check.
    validOpts := "Okay."
  else { ;===== Make sure hotstring options are valid ========
   NeedleRegEx := "(\*|B0|\?|SI|C|K[0-9]{1,3}|SE|X|SP|O|R|T)" ; These are in the AHK docs I swear!!!
   WithNeedlesRemoved := RegExReplace(tMyDefaultOpts, NeedleRegEx, "") ; Remove all valid options from var.

  If(WithNeedlesRemoved = "") ; If they were all removed...
     validOpts := "Okay."
   else { ; Some characters from the Options box were not recognized.
     OptTips := " ; Just a block text assignement to var
       (
  Don't include the colons.
  ..from AHK v1 docs...
   * - ending char not needed
   ? - trigger inside other words
   B0 - no backspacing
   SI - send input mode
   C - case-sensitive
   K(n) - set key delay
   SE - send event mode
   X - execute command
   SP - send play mode
   O - omit end char
   R - send raw
   T - super raw
      )"
     validOpts := "Invalid Hotsring Options found.`n---> " . WithNeedlesRemoved . "`n`n`tTips:`n" . OptTips
   }
  }
    ;==== Make sure hotstring box content is valid ========
  validHot := "" ; Reset to empty each time.
  If (tDefHotStr = "") || (tDefHotStr = myPrefix) || (tDefHotStr = mySuffix) || InStr(tDefHotStr, ":")
      validHot := "HotString box should not be empty.`n-Don't include colons."
  else ; No colons, and not empty. Good. Now check for duplicates.
     Loop Parse, ThisFile, "`n", "`r" ; Check line-by-line.
      If instr(A_LoopField, ":" . tDefHotStr . "::") { ; If line contains tDefHotStr...
           validHot := "DUPLICATE FOUND`nAt Line " . A_Index . ":`n " . A_LoopField
           break
         }
   If (validHot = "") ; If variable didn't get set in loop, then no duplicates found
       validHot := "Okay."
  ;==== Make sure replacement string box content is valid ===========
  If (tRepStr = "") || (SubStr(tRepStr, ("1")<1 ? ("1")-1 : ("1"), "1")==":") ; If Replacement box empty, or first char is ":"
      validRep := "Replacement string box should not be empty.`n-Don't include the colons."
  else
      validRep := "Okay."
  ; Concatenate the three above validity checks.
  CombinedValidMsg := "OPTIONS BOX `n-" . validOpts . "`n`nHOTSTRING BOX `n-" . validHot . "`n`nREPLACEMENT BOX `n-" . validRep
  Return CombinedValidMsg ; return result for use is Append or Validation functions.
} ; end of validation func

Appendit(tMyDefaultOpts, tDefHotStr, tRepStr)
{ WholeStr := ""
  tMyDefaultOpts := hh['MyDefaultOpts'].text
  tDefHotStr := hh['DefHotStr'].text
  tRepStr := hh['RepStr'].text
  tComStr := hh['ComStr'].text
  If (tComStr != "")
    tComStr := " `; " . tComStr
  If InStr(tRepStr, "`n") { 
    WholeStr :=  ":" . tMyDefaultOpts . ":" . tDefHotStr . "::" . tComStr . "`n(`n" . tRepStr . "`n)"
  }
  Else {
    WholeStr :=  ":" . tMyDefaultOpts . ":" . tDefHotStr . "::" . tRepStr . tComStr
  }
  FileAppend("`n" WholeStr, "My_Commands.ahk") ; 'n makes sure it goes on a new line.
  Reload() ; relaod the script so the new hotstring will be ready for use.
}

hhButtonSpell(*) ; Called is "Spell" because "Spell Check" is too long.
{ tRepStr := hh['RepStr'].text
  If (tRepStr = "")
    MsgBox("Replacement Text not found.",, 4096)
  else {
    googleSugg := GoogleAutoCorrect(tRepStr) ; Calls below function
    If (googleSugg = "")
        MsgBox("No suggestions found.",, 4096)
    Else {
      msgResult := MsgBox(googleSugg "`n`n######################`nChange Replacement Text?", "Google Suggestion", "OC 4096")
      if (msgResult = "OK")
        hh['RepStr'].value := googleSugg
      else
      return
    }
  }
}

GoogleAutoCorrect(word)
{ ; Original by TheDewd, converted to v2 by Mikeyww.
  ; autohotkey.com/boards/viewtopic.php?f=82&t=120143
 objReq := ComObject('WinHttp.WinHttpRequest.5.1')
 objReq.Open('GET', 'https://www.google.com/search?q=' word)
 objReq.SetRequestHeader('User-Agent'
  , 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)')
 objReq.Send(), HTML := objReq.ResponseText
 If RegExMatch(HTML, 'value="(.*?)"', &A)
 If RegExMatch(HTML, ';spell=1.*?>(.*?)<\/a>', &B)
 Return B[1] || A[1]
}

hhButtonOpen(*)
{  ; Open this file and go to the bottom so you can see your Hotstrings.
  hh.Hide()
  A_Clipboard := ClipboardOld  ; Restore previous contents of clipboard.
  Edit()
  WinWaitActive(A_ScriptName) ; Wait for the script to be open in text editor.
  Sleep(250)
  Send("{Ctrl Down}{End}{Ctrl Up}{Home}") ; Navigate to the bottom.
}

hhButtonCancel(*)
{ hh.Hide()
  A_Clipboard := ClipboardOld  ; Restore previous contents of clipboard.
}

::;ghdcs::
(
Global hFactor := 0 ; Don't change size here.  Change in TogSize() function, below.

)
::;h'rs::
(
hh.AddText('xm', 'Enter Replacement String')

)
::;ggcbf::
(
    googleSugg := GoogleAutoCorrect(tRepStr) ; Calls below function

)