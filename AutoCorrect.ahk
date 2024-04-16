;?========================================================================
;?========================================================================
;?
;? PLACE THIS SCRIPT'S SHORTCUT IN YOUR STARTUP FOLDER 
;? TO AUTOMATICALLY RUN ON STARTUP
;?
;?========================================================================
;?========================================================================
#Requires AutoHotkey v2.0
#SingleInstance Force
;------------------------------------------------------------------------------
; CONTENTS
;	Discussion
;   AUto-COrrect TWo COnsecutive CApitals @1
;   Hotstring Helper -- Multi Line @2
;   Fix for -ign instead of -ing 
;   Word endings
;   Word beginnings
;   Accented English words
;   Common Misspellings - the main list
;   Ambiguous entries - commented out
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;   Disussion
;   This is based on the excellent 2007 AutoCorrect.ahk script by Jim Biancolo
;   and Wikipedia's Lists of Common Misspellings.  Please find download link
;   here https://www.autohotkey.com/docs/v2/Hotstrings.htm#AutoCorrect
;   The original script has additional discussion and information.
;   See also, discussion here: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=120220
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;       AUto-COrrect TWo COnsecutive CApitals
; This version by forum user Ntepa. Updated 8-7-2023.
; https://www.autohotkey.com/boards/viewtopic.php?p=533067#p533067
;------------------------------------------------------------------------------

; fix_consecutive_caps()
; fix_consecutive_caps() {
;     ; Hotstring only works if CapsLock is off.
;     HotIf (*) => !GetKeyState("CapsLock", "T")
;     loop 26 {
;         char1 := Chr(A_Index + 64)
;         loop 26 {
;             char2 := Chr(A_Index + 64)
;             ; Create hotstring for every possible combination of two letter capital letters.
;             Hotstring(":*?CXB0:" char1 char2, fix.Bind(char1, char2))
;         }
;     }
;     HotIf

;     ; Third letter is checked using InputHook.
;     fix(char1, char2, *) {
;         ih := InputHook("V I101 L1 T.4")
;         ih.OnEnd := OnEnd
;         ih.Start()
;         OnEnd(ih) {
;             char3 := ih.Input
;             if (char3 ~= "[a-z]") ; If char is lowercase alpha.
;             || (char3 = A_Space && char1 char2 ~= "OF|TO|IN|IT|IS|AS|AT|WE|HE|BY|ON|BE|NO") ; Fix two letter words.
;                 Send("{BS 2}" StrLower(char2) char3)
;         }
;     }
; }

;------------------------------------------------------------------------------
;       Hotstring Helper - Multi line
; By Kunkel321, with much help from forum members and others. Version 8-7-2023
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=114688
; A version of Hotstring Helper that will support block multi-line replacements.
; Customization options are present throughout, and are flagged as such.
; Needs AHK v2. Partly auto-converted from v1, partly rewritten.
; Please get a copy of AutoHotkey.exe (v2) and rename it to match the name of this
; script file, so that the .exe and the .ahk have the same name, in the same folder.
; DO NOT COMPILE, or the Append command won't work. The Gui stays in RAM, but gets
; repopulated upon hotkey press. HotStrings will be appended (added) by the
; script at the bottom.Remove these comments as desired.
;------------------------------------------------------------------------------

;==Change=colors=as=desired========================
GuiColor := "F0F8FF" ; "F0F8FF" is light blue
FontColor := "003366" ; "003366" is dark blue
;==================================================

Global hFactor := 0 ; Don't change size here.  Change in TogSize() function, below.
Global wFactor := 0 ; Don't change here.  Change in TogSize() function.
FormName := "Hotstring Helper -- Muli-Line" ; Change here, if desired.

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
hh.AddButton('vSymTog x+5 h8 +notab', '+ Symbols').OnEvent("Click", TogSym)
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

#h::   ; HotString Helper activation hotkey-combo (not string) is Win+h. Change if desired.
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

TogSym(*)
{ ;====assign=symbolss=for="show symb"=button=================================
  myPilcrow := "¶"    ; Okay to change symb here if desired.
  myDot := "• "       ; adding a space allows more natural wrapping.
  myTab := " -> "
  ;===========================================================================
  If (hh['SymTog'].text = "+ Symbols") {
     hh['SymTog'].text := "- Symbols"
     RepStr := hh['RepStr'].text
     RepStr := StrReplace(StrReplace(RepStr, "`r`n", "`n"), "`n", myPilcrow . "`n") ; Pilcrow for Enter
     RepStr := StrReplace(RepStr, A_Space, myDot) ; middle dot for Space
     RepStr := StrReplace(RepStr, A_Tab, myTab) ; space arrow space for Tab
     hh['RepStr'].value := RepStr
     hh['RepStr'].Opt("+Readonly")
     ButApp.Enabled := false
     hh.Show('Autosize')
     return
  }
  If (hh['SymTog'].text = "- Symbols") {
    hh['SymTog'].text := "+ Symbols"
    RepStr := hh['RepStr'].text
    RepStr := StrReplace(RepStr, myPilcrow . "`r", "`r") ; Have to use `r ... weird.
	RepStr := StrReplace(RepStr, myDot, A_Space)
	RepStr := StrReplace(RepStr, myTab, A_Tab)
    hh['RepStr'].value := RepStr
    hh['RepStr'].Opt("-Readonly")
    ButApp.Enabled := true
    hh.Show('Autosize')
    return
  }
}

#HotIf WinActive(FormName, ) ; Allows window-specific hotkeys.
{
$Enter:: ; When Enter is pressed, but only in this GUI. "$" prevents accidental Enter key loop.
  { If (hh['SymTog'].text = "Hide Symb")
      return
    Else if RepStr.Focused {
      Send("{Enter}") ; Just normal typing; Enter yields Enter key press.
      Return
    }
    Else {
      hhButtonAppend() ; Replacement box not focused, so press Append button.
      return
    }
  }
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
  FileAppend("`n" WholeStr, A_ScriptFullPath) ; 'n makes sure it goes on a new line.
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

;######## Below parts are from original AutoCorrect 2007 ##################
#Hotstring R  ; Set the default to be "raw mode" (might not actually be relied upon by anything yet).

;------------------------------------------------------------------------------
; Fix for -ign instead of -ing.
; Words to exclude: (could probably do this by return without rewrite)
; From: http://www.morewords.com/e nds-with/gn/
;------------------------------------------------------------------------------
#Hotstring B0  ; Turns off automatic backspacing for the following hotstrings.
::align::
::antiforeign::
::arraign::
::assign::
::benign::
::campaign::
::champaign::
::codesign::
::coign::
::condign::
::consign::
::coreign::
::cosign::
::countercampaign::
::countersign::
::deign::
::deraign::
::design::
::eloign::
::ensign::
::feign::
::foreign::
::indign::
::malign::
::misalign::
::outdesign::
::overdesign::
::preassign::
::realign::
::reassign::
::redesign::
::reign::
::resign::
::sign::
::sovereign::
::unbenign::
::verisign::
{
return  ; This makes the above hotstrings do nothing so that they override the ign->ing rule below.
}

#Hotstring B  ; Turn back on automatic backspacing for all subsequent hotstrings.
:?:ign::ing


;------------------------------------------------------------------------------
; Word endings
;------------------------------------------------------------------------------
:?:bilites::bilities
:?:bilties::bilities
:?:blities::bilities
:?:bilty::bility
:?:blity::bility
:?:, btu::, but ; Not just replacing "btu", as that is a unit of heat.
:?:; btu::; but
:?:n;t::n't
:?:;ll::'ll
:?:;re::'re
:?:;ve::'ve
::sice::since  ; Must precede the following line!
:?:sice::sive
:?:t eh:: the
:?:t hem:: them


;------------------------------------------------------------------------------
; Word beginnings
;------------------------------------------------------------------------------
:*:abondon::abandon
:*:abreviat::abbreviat
:*:accomadat::accommodat
:*:accomodat::accommodat
:*:acheiv::achiev
:*:achievment::achievement
:*:acquaintence::acquaintance
:*:adquir::acquir
:*:aquisition::acquisition
:*:agravat::aggravat
:*:allign::align
:*:ameria::America
:*:archaelog::archaeolog
:*:archtyp::archetyp
:*:archetect::architect
:*:arguement::argument
:*:assasin::assassin
:*:asociat::associat
:*:assymetr::asymmet
:*:atempt::attempt
:*:atribut::attribut
:*:avaialb::availab
:*:comision::commission
:*:contien::conscien
:*:critisi::critici
:*:crticis::criticis
:*:critiz::criticiz
:*:desicant::desiccant
:*:desicat::desiccat
::develope::develop  ; Omit asterisk so that it doesn't disrupt the typing of developed/developer.
:*:dissapoint::disappoint
:*:divsion::division
:*:dcument::document
:*:embarass::embarrass
:*:emminent::eminent
:*:empahs::emphas
:*:enlargment::enlargement
:*:envirom::environm
:*:enviorment::environment
:*:excede::exceed
:*:exilerat::exhilarat
:*:extraterrestial::extraterrestrial
:*:faciliat::facilitat
:*:garantee::guaranteed
:*:guerrila::guerrilla
:*:guidlin::guidelin
:*:girat::gyrat
:*:harasm::harassm
:*:immitat::imitat
:*:imigra::immigra
:*:impliment::implement
:*:inlcud::includ
:*:indenpenden::independen
:*:indisputib::indisputab
:*:isntall::install
:*:insitut::institut
:*:knwo::know
:*:lsit::list
:*:mountian::mountain
:*:nmae::name
:*:necassa::necessa
:*:negociat::negotiat
:*:neigbor::neighbour
:*:noticibl::noticeabl
:*:ocasion::occasion
:*:occuranc::occurrence
:*:priveledg::privileg
:*:recie::recei
:*:recived::received
:*:reciver::receiver
:*:recepient::recipient
:*:reccomend::recommend
:*:recquir::requir
:*:requirment::requirement
:*:respomd::respond
:*:repons::respons
:*:ressurect::resurrect
:*:seperat::separat
:*:sevic::servic
:*:smoe::some
:*:supercede::supersede
:*:superceed::supersede
:*:weild::wield


;------------------------------------------------------------------------------
; Word middles
;------------------------------------------------------------------------------
:?*:compatab::compatib  ; Covers incompat* and compat*
:?*:catagor::categor  ; Covers subcatagories and catagories.


;------------------------------------------------------------------------------
; Accented English words, from, amongst others,
; http://en.wikipedia.org/wiki/List_of_English_words_with_diacritics
; I have included all the ones compatible with reasonable codepages, and placed
; those that may often not be accented either from a clash with an unaccented
; word (resume), or because the unaccented version is now common (cafe).
; 2023: Most of the definitions are from https://www.easydefine.com/ or from the WordWeb application.
; 2023: Several are converted to word endings to accommodate verb tenses, plural, etc.
;------------------------------------------------------------------------------
::aesop::Æsop ; noun Greek author of fables (circa 620-560 BC)
::a bas::à bas ; French: Down with -- To the bottom.  A type of clothing.
::a la::à la ; In the manner of...
::ancien regime::Ancien Régime ; noun a political and social system that no longer governs (especially the system that existed in France before the French Revolution)
:*:angstrom::Ångström ; noun a metric unit of length equal to one ten billionth of a meter (or 0.0001 micron); used to specify wavelengths of electromagnetic radiation
:*:anime::animé ; noun any of various resins or oleoresins; a hard copal derived from an African tree
::ao dai::ào dái  ; noun the traditional dress of Vietnamese women consisting of a tunic with long sleeves and panels front and back; the tunic is worn over trousers
:*:apertif::apértif ; noun an alcoholic drink that is taken as an appetizer before a meal
:*:applique::appliqué ; noun a decorative design made of one material sewn over another; verb sew on as a decoration
::apres::après ; French:  Too late.  After the event.
::arete::arête ; noun a sharp narrow ridge found in rugged mountains
::attache::attaché ; noun a specialist assigned to the staff of a diplomatic mission; a shallow and rectangular briefcase
::auto-da-fe::auto-da-fé ; noun the burning to death of heretics (as during the Spanish Inquisition)
::belle epoque::belle époque ; French: Fine period.   noun the period of settled and comfortable life preceding World War I
::bete noire::bête noire ; noun a detested person
::betise::bêtise ; noun a stupid mistake
::Bjorn::Bjørn ; An old norse name.  Means "Bear."
::blase::blasé ; adj. nonchalantly unconcerned; uninterested because of frequent exposure or indulgence; very sophisticated especially because of surfeit; versed in the ways of the world
:*:boite::boîte ; French: "Box."  a small restaurant or nightclub.
::boutonniere::boutonnière ; noun a flower that is worn in a buttonhole.
:*:canape::canapé  ; noun an appetizer consisting usually of a thin slice of bread or toast spread with caviar or cheese or other savory food
:*:celebre::célèbre ; Cause célèbre An incident that attracts great public attention.
:*:chaine::chaîné ; / (ballet) noun A series of small fast turns, often with the arms extended, used to cross a floor or stage.
:*:cinema verite::cinéma vérité ; noun a movie that shows ordinary people in actual activities without being controlled by a director
::cinemas verite::cinémas vérit ; noun a movie that shows ordinary people in actual activities without being controlled by a directoré
::champs-elysees::Champs-Élysées ; noun a major avenue in Paris famous for elegant shops and cafes
::charge d'affaires::chargé d'affaires ; noun the official temporarily in charge of a diplomatic mission in the absence of the ambassador
:*:chateau::château ; noun an impressive country house (or castle) in France
:*:cliche::cliché ; noun a trite or obvious remark; clichéd adj. repeated regularly without thought or originality
::cloisonne::cloisonné ; adj. (for metals) having areas separated by metal and filled with colored enamel and fired; noun enamelware in which colored areas are separated by thin metal strips
:*:consomme::consommé ; noun clear soup usually of beef or veal or chicken
:*:communique::communiqué ; noun an official report (usually sent in haste)
:*:confrere::confrère ; noun a person who is member of your class or profession
:*:cortege::cortège ; noun the group following and attending to some important person; a funeral procession
:*:coup d'etat::coup d'état ; noun a sudden and decisive change of government illegally or by force
:*:coup de tat::coup d'état ; noun a sudden and decisive change of government illegally or by force
:*:coup de grace::coup de grâce ; noun the blow that kills (usually mercifully)
:*:creche::crèche ; noun a hospital where foundlings (infant children of unknown parents) are taken in and cared for; a representation of Christ's nativity in the stable at Bethlehem
:*:coulee::coulée ; A stream of lava.  A deep gulch or ravine, frequently dry in summer.
::creme brulee::crème brûlée ; noun custard sprinkled with sugar and broiled
:*:crepe::crêpe ; noun a soft thin light fabric with a crinkled surface; paper with a crinkled texture; usually colored and used for decorations; small very thin pancake; verb cover or drape with crape
:*:creme caramel::crème caramel ; noun baked custard topped with caramel
::creme de cacao::crème de cacao ; noun sweet liqueur flavored with vanilla and cacao beans
::creme de menthe::crème de menthe ; noun sweet green or white mint-flavored liqueur
:*:crouton::croûton ; noun a small piece of toasted or fried bread; served in soup or salads
::creusa::Creüsa ; In Greek mythology, Creusa was the daughter of Priam and Hecuba.
::crudites::crudités ; noun raw vegetables cut into bite-sized strips and served with a dip
::curacao::curaçao ; noun flavored with sour orange peel; a popular island resort in the Netherlands Antilles
:*:dais::daïs ; noun a platform raised above the surrounding level to give prominence to the person on it
:*:debacle::débâcle ; noun a sudden and violent collapse; flooding caused by a tumultuous breakup of ice in a river during the spring or summer; a sound defeat
:*:debutante::débutant ; noun a sudden and violent collapse; flooding caused by a tumultuous breakup of ice in a river during the spring or summer; a sound defeat
::declasse::déclassé ; Fallen or lowered in class, rank, or social position; lacking high station or birth; of inferior status
::decolletage::décolletage ; noun a low-cut neckline on a woman's dress
::decollete::décolleté ; adj. (of a garment) having a low-cut neckline
:*:decor::décor ; noun decoration consisting of the layout and furnishings of a livable interior
::decoupage::découpage ; noun the art of decorating a surface with shapes or pictures and then coating it with vanish or lacquer; art produced by decorating a surface with cutouts and then coating it with several layers of varnish or lacquer
::degage::dégagé ; adj. showing lack of emotional involvement; free and relaxed in manner
::deja vu::déjà vu ; noun the experience of thinking that a new situation had occurred before
::demode::démodé ; adj. out of fashion
::denoument::dénoument ; Narrative structure.  (Not in most dictionaries)
::derailleur::dérailleur ; (cycling) the mechanism on a bicycle used to move the chain from one sprocket (gear) to another
:*:derriere::derrière ; noun the fleshy part of the human body that you sit on
::deshabille::déshabillé ; noun the state of being carelessly or partially dressed
::detente::détente ; noun the easing of tensions or strained relations (especially between nations)
::diamante::diamanté ; noun adornment consisting of a small piece of shiny material used to decorate clothing
:*:discotheque::discothèque ; noun a public dance hall for dancing to recorded popular music
:*:divorcee::divorcée ; noun a divorced woman or a woman who is separated from her husband
:*:doppelganger::doppelgänger ; noun a ghostly double of a living person that haunts its living counterpart
:*:eclair::éclair ; noun oblong cream puff
::eclat::éclat ; noun brilliant or conspicuous success or effect; ceremonial elegance and splendor; enthusiastic approval
::el nino::El Niño ; noun the Christ child; (oceanography) a warm ocean current that flows along the equator from the date line and south off the coast of Ecuador at Christmas time
::elan::élan ; noun enthusiastic and assured vigor and liveliness; distinctive and stylish elegance; a feeling of strong eagerness (usually in favor of a person or cause)
:*:emigre::émigré ; noun someone who leaves one country to settle in another
:*:entree::entrée ; noun the act of entering; the right to enter; the principal dish of a meal; something that provides access (to get in or get out)
::entrepot::entrepôt ; noun a port where merchandise can be imported and then exported without paying import duties; a depository for goods
::entrecote::entrecôte ; Cut of meat taken from between the ribs
:*:epee::épée ; noun a fencing sword similar to a foil but with a heavier blade
::etouffee::étouffée ; A Cajun shellfish dish.
:*:facade::façade ; noun the face or front of a building; a showy misrepresentation intended to conceal something unpleasant
:*:fete::fête ; noun an elaborate party (often outdoors); an organized series of acts and performances (usually in one place); verb have a celebration
::faience::faïence ; noun an elaborate party (often outdoors); an organized series of acts and performances (usually in one place); verb have a celebration
:*:fiance::fiancé ; noun a man who is engaged to be married. fiancee ; noun a woman who is engaged to be married
::filmjolk::filmjölk ; Nordic milk product.
::fin de siecle::fin de siècle ; adj. relating to or characteristic of the end of a century (especially the end of the 19th century)
:*:flambe::flambé ; verb pour liquor over and ignite (a dish)
::fleche::flèche ; a type of church spire; a team cycling competition; an aggressive offensive fencing technique; a defensive fortification; ships of the Royal Navy
::Fohn wind::Föhn wind ; A type of dry, relatively warm, downslope wind that occurs in the lee (downwind side) of a mountain range.
::folie a deux::folie à deux ; noun the simultaneous occurrence of symptoms of a mental disorder (as delusions) in two persons who are closely related (as siblings or man and wife)
::folies a deux::folies à deux
::fouette::fouetté ; From Ballet: The working leg is extended and whipped around
:*:frappe::frappé ; noun thick milkshake containing ice cream; liqueur poured over shaved ice; a frozen dessert with fruit flavoring (especially one containing no milk)
:*:fraulein::fräulein ; noun a German courtesy title or form of address for an unmarried woman
:*:garcon::garçon ; A waiter, esp. at a French restaurant
:*:gateau::gâteau ; noun any of various rich and elaborate cakes
::gemutlichkeit::gemütlichkeit ; Friendliness.
::glace::glacé ; adj. (used especially of fruits) preserved by coating with or allowing to absorb sugar
::glogg::glögg ; noun Scandinavian punch made of claret and aquavit with spices and raisins and orange peel and sugar
::gewurztraminer::Gewürztraminer ; An aromatic white wine grape variety that grows best in cooler climates
::gotterdammerung::Götterdämmerung ; noun myth about the ultimate destruction of the gods in a battle with evil
::grafenberg spot::Gräfenberg spot ;  An erogenous area of the vagina.
:*:habitue::habitué ; noun a regular patron
::ingenue::ingénue ; noun an actress who specializes in playing the role of an artless innocent young girl
::jager::jäger ; A German or Austrian hunter, rifleman, or sharpshooter
:*:jalapeno::jalapeño ; noun hot green or red pepper of southwestern United States and Mexico; plant bearing very hot and finely tapering long peppers; usually red
::jardiniere::jardinière ; A preparation of mixed vegetables stewed in a sauce.  An arrangement of flowers.
::krouzek::kroužek ; A ring-shaped diacritical mark (°), whose use is largely restricted to Å, å and U, u.
::kummel::kümmel ; noun liqueur flavored with caraway seed or cumin
::kaldolmar::kåldolmar ; Swedish cabbage rolls filled with rice and minced meat.
::landler::ländler ; noun a moderately slow Austrian country dance in triple time; involves spinning and clapping; music in triple time for dancing the landler
::langue d'oil::langue d'oïl ; noun medieval provincial dialects of French spoken in central and northern France
::la nina::La Niña ; Spanish:'The Girl' is an oceanic and atmospheric phenomenon that is the colder counterpart of El Niño.
::litterateur::littérateur ; noun a writer of literary works
::lycee::lycée ; noun a school for students intermediate between elementary school and college; usually grades 9 to 12
::macedoine::macédoine ; noun mixed diced fruits or vegetables; hot or cold
::macrame::macramé ; noun a coarse lace; made by weaving and knotting cords; verb make knotted patterns
::maitre d'hotel::maître d'hôtel ; noun a dining-room attendant who is in charge of the waiters and the seating of customers
::malaguena::malagueña ; A Spanish dance or folk tune resembling the fandango.
::manana::mañana ; Spanish: Tomorrow.
::manege::manège ; The art of horsemanship or of training horses.
::manque::manqué ; adj. unfulfilled or frustrated in realizing an ambition
::materiel::matériel ; noun equipment and supplies of a military force
:*:matinee::matinée ; noun a theatrical performance held during the daytime (especially in the afternoon)
::melange::mélange ; noun a motley assortment of things
:*:melee::mêlée ; noun a noisy riotous fight
::menage a trois::ménage à trois ; noun household for three; an arrangement where a married couple and a lover of one of them live together while sharing sexual relations
::menages a trois::ménages à trois
::mesalliance::mésalliance ; noun a marriage with a person of inferior social status
::metier::métier ; noun an occupation for which you are especially well suited; an asset of special worth or utility
::minaudiere::minaudière ; A small, decorative handbag without handles or a strap.
::mobius::Möbius ; noun a continuous closed surface with only one side; formed from a rectangular strip by rotating one end 180 degrees and joining it with the other end
::moire::moiré ; adj. (of silk fabric) having a wavelike pattern; noun silk fabric with a wavy surface pattern
:*:moireing::moiré ; A textile technique that creates a wavy or "watered" effect in fabric.
::motley crue::Mötley Crüe ; American heavy metal band formed in Hollywood, California in 1981.
::motorhead::Motörhead ; English rock band formed in London in 1975.
:*:naif::naïf ; adj. marked by or showing unaffected simplicity and lack of guile or worldly experience; noun a naive or inexperienced person
::naive::naïve ; adj. inexperienced; marked by or showing unaffected simplicity and lack of guile or worldly experience
::naiver::naïver ; See above.
::naives::naïves ; See above.
::naivete::naïveté ; See above.
::nee::née ; adj. (meaning literally `born') used to indicate the maiden or family name of a married woman
:*:negligee::negligée ; noun a loose dressing gown for women
::neufchatel::Neufchâtel ; a cheese
::nez perce::Nez Percé ; noun the Shahaptian language spoken by the Nez Perce; a member of a tribe of the Shahaptian people living on the pacific coast
:*:noel::Noël ; French:  Christmas.
::número uno::número uno ; Number one
::objet trouve::objet trouvé ; An object found or picked up at random and considered aesthetically pleasing.
::objets trouve::objets trouvé ; See above.
:*:ombre::ombré ;  (literally "shaded" in French) is the blending of one color hue to another.  A card game.
::omerta::omertà ; noun a code of silence practiced by the Mafia; a refusal to give evidence to the police about criminal activities
::opera bouffe::opéra bouffe ; noun opera with a happy ending and in which some of the text is spoken
::operas bouffe::opéras bouffe ; see above.
::opera comique::opéra comique ; noun opera with a happy ending and in which some of the text is spoken
::operas comique::opéras comique ; See above.
::outre::outré ; adj. conspicuously or grossly unconventional or unusual
::papier-mache::papier-mâché ; noun a substance made from paper pulp that can be molded when wet and painted when dry
::passe::passé ; adj. out of fashion
::piece de resistance::pièce de résistance ; noun the most important dish of a meal; the outstanding item (the prize piece or main exhibit) in a collection
::pied-a-terre::pied-à-terre ; noun lodging for occasional or secondary use
::plisse::plissé ; (Of a fabric) chemically treated to produce a shirred or puckered effect.
:*:pina colada::Piña Colada ; noun a mixed drink made of pineapple juice and coconut cream and rum
:*:pinata::piñata ; noun plaything consisting of a container filled with toys and candy; suspended from a height for blindfolded children to break with sticks
:*:pinon::piñon ; noun any of several low-growing pines of western North America
::pirana::piraña ; noun small voraciously carnivorous freshwater fishes of South America that attack and destroy living animals
::pique::piqué ; noun tightly woven fabric with raised cords; a sudden outburst of anger; verb cause to feel resentment or indignation
::piqued::piquéd ;noun Animosity or ill-feeling, Offence taken. transitive verb To wound the pride of To arouse, stir, provoke.
::più::più ; Move.
::plie::plié ; A movement in ballet, in which the knees are bent while the body remains upright
::precis::précis ; noun a sketchy summary of the main points of an argument or theory; verb make a summary (of)
:*:protege::protégé ; noun a person who receives support and protection from an influential patron who furthers the protege's career.  protegee ; noun a woman protege
:*:puree::purée ; noun food prepared by cooking and straining or processed in a blender; verb rub through a strainer or process in an electric blender
::polsa::pölsa ; A traditional northern Swedish dish which has been compared to hash
::pret-a-porter::prêt-à-porter ; Ready-to-wear / Off-the-rack.
::Quebecois::Québécois ; adj. of or relating to Quebec
::raison d'etre::raison d'être ; noun the purpose that justifies a thing's existence; reason for being
::recherche::recherché ; adj. lavishly elegant and refined
::retrousse::retroussé ; adjective (of a person's nose) turned up at the tip in an attractive way.
::risque::risqué ; adjective slightly indecent and liable to shock, especially by being sexually suggestive.
::riviere::rivière ; noun a necklace of gems that increase in size toward a large central stone, typically consisting of more than one string.
::roman a clef::roman à clef ; noun a novel in which actual persons and events are disguised as fictional characters
::roue::roué ; noun a dissolute man in fashionable society
:*:saute::sauté ; adj. fried quickly in a little fat; noun a dish of sauteed food; verb fry briefly over high heat
:*:seance::séance ; noun a meeting of spiritualists
:*:senor::señor ; noun a Spanish title or form of address for a man; similar to the English `Mr' or `sir'. senora/señorita ; noun a Spanish title or form of address for a married woman; similar to the English `Mrs' or `madam'
:*:smorgasbord::smörgåsbord ; noun served as a buffet meal; a collection containing a variety of sorts of things
:*:soiree::soirée ; noun a party of people assembled in the evening (usually at a private house)
:*:souffle::soufflé ; noun light fluffy dish of egg yolks and stiffly beaten egg whites mixed with e.g. cheese or fish or fruit
::sinn fein::Sinn Féin ; noun an Irish republican political movement founded in 1905 to promote independence from England
::smorgastarta::smörgåstårta ; "sandwich-cake" or "sandwich-torte" is a dish of Swedish origin
::soigne::soigné ; adj. polished and well-groomed; showing sophisticated elegance
:*:soupcon::soupçon ; noun a slight but appreciable addition
::surstromming::surströmming ; Lightly salted fermented Baltic Sea herring.
:*:tete-a-tete::tête-à-tête ; adj. involving two persons; intimately private; noun a private conversation between two people; small sofa that seats two people
::touche::touché ; Acknowledgement of a hit in fencing or a point made at one's expense.
::tourtiere::tourtière ; A meat pie that is usually eaten at Christmas in Québec
:*:ubermensch::Übermensch ; noun a person with great powers and abilities
::ventre a terre::ventre à terre ; (French) At high speed (literally, belly to the ground.)
::vicuna::vicuña ; noun small wild cud-chewing Andean animal similar to the guanaco but smaller; valued for its fleecy undercoat; a soft wool fabric made from the fleece of the vicuna; the wool of the vicuna
::vin rose::vin rosé ; White wine.
::vins rose::vins rosé ; See above
::vis a vis::vis à vis ; adv. face-to-face
::vis-a-vis::vis-à-vis ; See above
::voila::voilà ; Behold.  There you are.

;------------------------------------------------------------------------------
; Common Misspellings - the main list
;------------------------------------------------------------------------------
::htp:::http:
::http:\\::http://
::httpL::http:
::herf::href

::avengence::a vengeance
::adbandon::abandon
::abandonned::abandoned
::aberation::aberration
::aborigene::aborigine
::abortificant::abortifacient
::abbout::about
::abotu::about
::baout::about
::abouta::about a
::aboutit::about it
::aboutthe::about the
::abscence::absence
::absense::absence
::abcense::absense
::absolutly::absolutely
::asorbed::absorbed
::absorbsion::absorption
::absorbtion::absorption
::abundacies::abundances
::abundancies::abundances
::abundunt::abundant
::abutts::abuts
::acadmic::academic
::accademic::academic
::acedemic::academic
::acadamy::academy
::accademy::academy
::accelleration::acceleration
::acceptible::acceptable
::acceptence::acceptance
::accessable::accessible
::accension::accession
::accesories::accessories
::accesorise::accessorise
::accidant::accident
::accidentaly::accidentally
::accidently::accidentally
::acclimitization::acclimatization
::accomdate::accommodate
::accomodate::accommodate
::acommodate::accommodate
::acomodate::accommodate
::accomodated::accommodated
::accomodates::accommodates
::accomodating::accommodating
::accomodation::accommodation
::accomodations::accommodations
::accompanyed::accompanied
::acomplish::accomplish
::acomplished::accomplished
::acomplishment::accomplishment
::acomplishments::accomplishments
::accoring::according
::acording::according
::accordingto::according to
::acordingly::accordingly
::accordeon::accordion
::accordian::accordion
::acocunt::account
::acuracy::accuracy
::acccused::accused
::accussed::accused
::acused::accused
::acustom::accustom
::acustommed::accustomed
::achive::achieve
::achivement::achievement
::achivements::achievements
::acknowldeged::acknowledged
::acknowledgeing::acknowledging
::accoustic::acoustic
::acquiantence::acquaintance
::aquaintance::acquaintance
::aquiantance::acquaintance
::acquiantences::acquaintances
::accquainted::acquainted
::aquainted::acquainted
::aquire::acquire
::aquired::acquired
::aquiring::acquiring
::aquit::acquit
::acquited::acquitted
::aquitted::acquitted
::accross::across
::activly::actively
::activites::activities
::actualy::actually
::actualyl::actually
::adaption::adaptation
::adaptions::adaptations
::addtion::addition
::additinal::additional
::addtional::additional
::additinally::additionally
::addres::address
::adres::address
::adress::address
::addresable::addressable
::adresable::addressable
::adressable::addressable
::addresed::addressed
::adressed::addressed
::addressess::addresses
::addresing::addressing
::adresing::addressing
::adecuate::adequate
::adequit::adequate
::adequite::adequate
::adherance::adherence
::adhearing::adhering
::adminstered::administered
::adminstrate::administrate
::adminstration::administration
::admininistrative::administrative
::adminstrative::administrative
::adminstrator::administrator
::admissability::admissibility
::admissable::admissible
::addmission::admission
::admited::admitted
::admitedly::admittedly
::adolecent::adolescent
::addopt::adopt
::addopted::adopted
::addoptive::adoptive
::adavanced::advanced
::adantage::advantage
::advanage::advantage
::adventrous::adventurous
::advesary::adversary
::advertisment::advertisement
::advertisments::advertisements
::asdvertising::advertising
::adviced::advised
::aeriel::aerial
::aeriels::aerials
::areodynamics::aerodynamics
::asthetic::aesthetic
::asthetical::aesthetic
::asthetically::aesthetically
::afair::affair
::affilate::affiliate
::affilliate::affiliate
::afficionado::aficionado
::afficianados::aficionados
::afficionados::aficionados
::aforememtioned::aforementioned
::affraid::afraid
::afterthe::after the
::agian::again
::agin::again
::againnst::against
::agains::against
::agaisnt::against
::aganist::against
::agianst::against
::aginst::against
::againstt he::against the
::aggaravates::aggravates
::agregate::aggregate
::agregates::aggregates
::agression::aggression
::aggresive::aggressive
::agressive::aggressive
::agressively::aggressively
::agressor::aggressor
::agrieved::aggrieved
::agre::agree
::aggreed::agreed
::agred::agreed
::agreing::agreeing
::aggreement::agreement
::agreeement::agreement
::agreemeent::agreement
::agreemnet::agreement
::agreemnt::agreement
::agreemeents::agreements
::agreemnets::agreements
::agricuture::agriculture
::airbourne::airborne
::aicraft::aircraft
::aircaft::aircraft
::aircrafts::aircraft
::airrcraft::aircraft
::aiport::airport
::airporta::airports
::albiet::albeit
::alchohol::alcohol
::alchol::alcohol
::alcohal::alcohol
::alochol::alcohol
::alchoholic::alcoholic
::alcholic::alcoholic
::alcoholical::alcoholic
::algebraical::algebraic
::algoritm::algorithm
::algorhitms::algorithms
::algoritms::algorithms
::alientating::alienating
::alltime::all-time
::aledge::allege
::alege::allege
::alledge::allege
::aledged::alleged
::aleged::alleged
::alledged::alleged
::alledgedly::allegedly
::allegedely::allegedly
::allegedy::allegedly
::allegely::allegedly
::aledges::alleges
::alledges::alleges
::alegience::allegiance
::allegence::allegiance
::allegience::allegiance
::alliviate::alleviate
::allopone::allophone
::allopones::allophones
::alotted::allotted
::alowed::allowed
::alowing::allowing
::alusion::allusion
::almots::almost
::almsot::almost
::alomst::almost
::alonw::alone
::allready::already
::alraedy::already
::alreayd::already
::alreday::already
::aready::already
::alsation::Alsatian
::alsot::also
::aslo::also
::alternitives::alternatives
::allthough::although
::altho::although
::althought::although
::altough::although
::allwasy::always
::allwyas::always
::alwasy::always
::alwats::always
::alway::always
::alwyas::always
::amalgomated::amalgamated
::amatuer::amateur
::amerliorate::ameliorate
::ammend::amend
::ammended::amended
::admendment::amendment
::amendmant::amendment
::ammendment::amendment
::ammendments::amendments
::amoung::among
::amung::among
::amoungst::amongst
::ammount::amount
::ammused::amused
::analagous::analogous
::analogeous::analogous
::analitic::analytic
::anarchim::anarchism
::anarchistm::anarchism
::ansestors::ancestors
::ancestory::ancestry
::ancilliary::ancillary
::adn::and
::anbd::and
::anmd::and
::andone::and one
::andt he::and the
::andteh::and the
::andthe::and the
::androgenous::androgynous
::androgeny::androgyny
::anihilation::annihilation
::aniversary::anniversary
::annouced::announced
::anounced::announced
::anual::annual
::annualy::annually
::annuled::annulled
::anulled::annulled
::annoint::anoint
::annointed::anointed
::annointing::anointing
::annoints::anoints
::anomolies::anomalies
::anomolous::anomalous
::anomoly::anomaly
::anonimity::anonymity
::anohter::another
::anotehr::another
::anothe::another
::anwsered::answered
::antartic::antarctic
::anthromorphisation::anthropomorphisation
::anthromorphization::anthropomorphization
::anti-semetic::anti-Semitic
::anyother::any other
::anytying::anything
::anyhwere::anywhere
::appart::apart
::aparment::apartment
::appartment::apartment
::appartments::apartments
::apenines::Apennines
::appenines::Apennines
::apolegetics::apologetics
::appologies::apologies
::appology::apology
::aparent::apparent
::apparant::apparent
::apparrent::apparent
::apparantly::apparently
::appealling::appealing
::appeareance::appearance
::appearence::appearance
::apperance::appearance
::apprearance::appearance
::appearences::appearances
::apperances::appearances
::appeares::appears
::aplication::application
::applicaiton::application
::applicaitons::applications
::aplied::applied
::applyed::applied
::appointiment::appointment
::apprieciate::appreciate
::aprehensive::apprehensive
::approachs::approaches
::appropiate::appropriate
::appropraite::appropriate
::appropropiate::appropriate
::approrpiate::appropriate
::approrpriate::appropriate
::apropriate::appropriate
::approproximate::approximate
::aproximate::approximate
::approxamately::approximately
::approxiately::approximately
::approximitely::approximately
::aproximately::approximately
::arbitarily::arbitrarily
::abritrary::arbitrary
::arbitary::arbitrary
::arbouretum::arboretum
::archiac::archaic
::archimedian::Archimedean
::archictect::architect
::archetectural::architectural
::architectual::architectural
::archetecturally::architecturally
::architechturally::architecturally
::archetecture::architecture
::architechture::architecture
::architechtures::architectures
::arn't::aren't
::argubly::arguably
::armamant::armament
::armistace::armistice
::arised::arose
::arond::around
::aroud::around
::arround::around
::arund::around
::aranged::arranged
::arangement::arrangement
::arrangment::arrangement
::arrangments::arrangements
::arival::arrival
::artical::article
::artice::article
::articel::article
::artifical::artificial
::artifically::artificially
::artillary::artillery
::asthe::as the
::aswell::as well
::asetic::ascetic
::aisian::Asian
::asside::aside
::askt he::ask the
::asphyxation::asphyxiation
::assisnate::assassinate
::assassintation::assassination
::assosication::assassination
::asssassans::assassins
::assualt::assault
::assualted::assaulted
::assemple::assemble
::assertation::assertion
::assesment::assessment
::asign::assign
::assit::assist
::assistent::assistant
::assitant::assistant
::assoicate::associate
::assoicated::associated
::assoicates::associates
::assocation::association
::asume::assume
::asteriod::asteroid
::atthe::at the
::athiesm::atheism
::athiest::atheist
::atheistical::atheistic
::athenean::Athenian
::atheneans::Athenians
::atmospher::atmosphere
::attrocities::atrocities
::attatch::attach
::atain::attain
::attemp::attempt
::attemt::attempt
::attemped::attempted
::attemted::attempted
::attemting::attempting
::attemts::attempts
::attendence::attendance
::attendent::attendant
::attendents::attendants
::attened::attended
::atention::attention
::attension::attention
::attentioin::attention
::attitide::attitude
::atorney::attorney
::attributred::attributed
::audeince::audience
::audiance::audience
::austrailia::Australia
::austrailian::Australian
::australian::Australian
::auther::author
::autor::author
::authorative::authoritative
::authoritive::authoritative
::authorites::authorities
::authoritiers::authorities
::authrorities::authorities
::authorithy::authority
::autority::authority
::authobiographic::autobiographic
::authobiography::autobiography
::autochtonous::autochthonous
::autoctonous::autochthonous
::automaticly::automatically
::automibile::automobile
::automonomous::autonomous
::auxillaries::auxiliaries
::auxilliaries::auxiliaries
::auxilary::auxiliary
::auxillary::auxiliary
::auxilliary::auxiliary
::availablility::availability
::availaible::available
::availalbe::available
::availble::available
::availiable::available
::availible::available
::avalable::available
::avaliable::available
::avilable::available
::avalance::avalanche
::averageed::averaged
::avation::aviation
::awared::awarded
::awya::away
::aywa::away
::abck::back
::bakc::back
::bcak::back
::backgorund::background
::backrounds::backgrounds
::balence::balance
::ballance::balance
::banannas::bananas
::bandwith::bandwidth
::bankrupcy::bankruptcy
::banruptcy::bankruptcy
::barbeque::barbecue
::basicaly::basically
::basicly::basically
::cattleship::battleship
::bve::be
::eb::be
::beachead::beachhead
::beatiful::beautiful
::beautyfull::beautiful
::beutiful::beautiful
::becamae::became
::baceause::because
::beacuse::because
::becasue::because
::becaus::because
::beccause::because
::becouse::because
::becuase::because
::becuse::because
::becausea::because a
::becauseof::because of
::becausethe::because the
::becauseyou::because you
::becoe::become
::becomeing::becoming
::becomming::becoming
::bedore::before
::befoer::before
::begginer::beginner
::begginers::beginners
::beggining::beginning
::begining::beginning
::beginining::beginning
::beginnig::beginning
::begginings::beginnings
::beggins::begins
::behavour::behaviour
::beng::being
::beleagured::beleaguered
::beligum::belgium
::beleif::belief
::beleiev::believe
::beleieve::believe
::beleive::believe
::belive::believe
::beleived::believed
::belived::believed
::beleives::believes
::beleiving::believing
::belligerant::belligerent
::bellweather::bellwether
::bemusemnt::bemusement
::benefical::beneficial
::benificial::beneficial
::beneficary::beneficiary
::benifit::benefit
::benifits::benefits
::bergamont::bergamot
::bernouilli::Bernoulli
::beseige::besiege
::beseiged::besieged
::beseiging::besieging
::beastiality::bestiality
::betweeen::between
::betwen::between
::bewteen::between
::inbetween::between
::vetween::between
::bicep::biceps
::bilateraly::bilaterally
::billingualism::bilingualism
::binominal::binomial
::bizzare::bizarre
::blaim::blame
::blaimed::blamed
::blessure::blessing
::blitzkreig::Blitzkrieg
::bodydbuilder::bodybuilder
::bombardement::bombardment
::bombarment::bombardment
::bonnano::Bonanno
::bondary::boundary
::boundry::boundary
::boxs::boxes
::brasillian::Brazilian
::breakthough::breakthrough
::breakthroughts::breakthroughs
::brethen::brethren
::bretheren::brethren
::breif::brief
::breifly::briefly
::briliant::brilliant
::brillant::brilliant
::brimestone::brimstone
::britian::Britain
::brittish::British
::broacasted::broadcast
::brodcast::broadcast
::broadacasting::broadcasting
::broady::broadly
::borke::broke
::buddah::Buddha
::bouy::buoy
::bouyancy::buoyancy
::buoancy::buoyancy
::bouyant::buoyant
::boyant::buoyant
::beaurocracy::bureaucracy
::beaurocratic::bureaucratic
::burried::buried
::buisness::business
::busness::business
::bussiness::business
::busineses::businesses
::buisnessman::businessman
::butthe::but the
::byt he::by the
::ceasar::Caesar
::casion::caisson
::caluclate::calculate
::caluculate::calculate
::calulate::calculate
::calcullated::calculated
::caluclated::calculated
::caluculated::calculated
::calulated::calculated
::calculs::calculus
::calander::calendar
::calenders::calendars
::califronia::California
::califronian::Californian
::caligraphy::calligraphy
::callipigian::callipygian
::cambrige::Cambridge
::camoflage::camouflage
::campain::campaign
::campains::campaigns
::acn::can
::cna::can
::cxan::can
::can't of::can't have
::candadate::candidate
::candiate::candidate
::candidiate::candidate
::candidtae::candidate
::candidtaes::candidates
::cannister::canister
::cannisters::canisters
::cannnot::cannot
::cannonical::canonical
::cantalope::cantaloupe
::caperbility::capability
::capible::capable
::capetown::Cape Town
::captial::capital
::captued::captured
::capturd::captured
::carcas::carcass
::carreer::career
::carrers::careers
::carefull::careful
::carribbean::Caribbean
::carribean::Caribbean
::careing::caring
::carmalite::Carmelite
::carniverous::carnivorous
::carthagian::Carthaginian
::cartilege::cartilage
::cartilidge::cartilage
::carthographer::cartographer
::cartdridge::cartridge
::cartrige::cartridge
::casette::cassette
::cassawory::cassowary
::cassowarry::cassowary
::casulaties::casualties
::causalities::casualties
::casulaty::casualty
::categiory::category
::ctaegory::category
::catterpilar::caterpillar
::catterpilars::caterpillars
::cathlic::catholic
::catholocism::catholicism
::caucasion::Caucasian
::cacuses::caucuses
::cieling::ceiling
::cellpading::cellpadding
::celcius::Celsius
::cemetaries::cemeteries
::cementary::cemetery
::cemetarey::cemetery
::cemetary::cemetery
::sensure::censure
::cencus::census
::cententenial::centennial
::centruies::centuries
::centruy::century
::cerimonial::ceremonial
::cerimonies::ceremonies
::cerimonious::ceremonious
::cerimony::ceremony
::ceromony::ceremony
::certian::certain
::certainity::certainty
::chariman::chairman
::challange::challenge
::challege::challenge
::challanged::challenged
::challanges::challenges
::chalenging::challenging
::champange::champagne
::chaneg::change
::chnage::change
::changable::changeable
::chanegs::changes
::changeing::changing
::changng::changing
::caharcter::character
::carachter::character
::charachter::character
::charactor::character
::charecter::character
::charector::character
::chracter::character
::caracterised::characterised
::charaterised::characterised
::charactersistic::characteristic
::charistics::characteristics
::caracterized::characterized
::charaterized::characterized
::cahracters::characters
::charachters::characters
::charactors::characters
::carismatic::charismatic
::charasmatic::charismatic
::chartiable::charitable
::caht::chat
::chekc::check
::chemcial::chemical
::chemcially::chemically
::chemicaly::chemically
::chemestry::chemistry
::cheif::chief
::childbird::childbirth
::childen::children
::childrens::children's
::chilli::chili
::choosen::chosen
::chuch::church
::curch::church
::churchs::churches
::cincinatti::Cincinnati
::cincinnatti::Cincinnati
::circut::circuit
::ciricuit::circuit
::curcuit::circuit
::circulaton::circulation
::circumsicion::circumcision
::sercumstances::circumstances
::cirtus::citrus
::civillian::civilian
::claimes::claims
::clas::class
::clasic::classic
::clasical::classical
::clasically::classically
::claer::clear
::cleareance::clearance
::claered::cleared
::claerer::clearer
::claerly::clearly
::cliant::client
::clincial::clinical
::clinicaly::clinically
::caost::coast
::coctail::cocktail
::cognizent::cognizant
::co-incided::coincided
::coincedentally::coincidentally
::colaborations::collaborations
::collaberative::collaborative
::colateral::collateral
::collegue::colleague
::collegues::colleagues
::collectable::collectible
::colection::collection
::collecton::collection
::colelctive::collective
::collonies::colonies
::colonisators::colonisers
::colonizators::colonizers
::collonade::colonnade
::collony::colony
::collosal::colossal
::colum::column
::combintation::combination
::combanations::combinations
::combinatins::combinations
::combusion::combustion
::comback::comeback
::commedic::comedic
::confortable::comfortable
::comming::coming
::commadn::command
::comander::commander
::comando::commando
::comandos::commandos
::commandoes::commandos
::comemmorate::commemorate
::commemmorate::commemorate
::commmemorated::commemorated
::comemmorates::commemorates
::commemmorating::commemorating
::comemoretion::commemoration
::commemerative::commemorative
::commerorative::commemorative
::commerical::commercial
::commericial::commercial
::commerically::commercially
::commericially::commercially
::comission::commission
::commision::commission
::comissioned::commissioned
::commisioned::commissioned
::comissioner::commissioner
::commisioner::commissioner
::comissioning::commissioning
::commisioning::commissioning
::comissions::commissions
::commisions::commissions
::comit::commit
::committment::commitment
::committments::commitments
::comited::committed
::comitted::committed
::commited::committed
::comittee::committee
::commitee::committee
::committe::committee
::committy::committee
::comiting::committing
::comitting::committing
::commiting::committing
::commongly::commonly
::commonweath::commonwealth
::comunicate::communicate
::comminication::communication
::communciation::communication
::communiation::communication
::commuications::communications
::commuinications::communications
::communites::communities
::comunity::community
::comanies::companies
::comapnies::companies
::comany::company
::comapany::company
::comapny::company
::company;s::company's
::comparitive::comparative
::comparitively::comparatively
::compair::compare
::comparision::comparison
::comparisions::comparisons
::compability::compatibility
::compatiable::compatible
::compensantion::compensation
::competance::competence
::competant::competent
::compitent::competent
::competitiion::competition
::compeitions::competitions
::competative::competitive
::competive::competitive
::competiveness::competitiveness
::copmetitors::competitors
::complier::compiler
::compleated::completed
::completedthe::completed the
::competely::completely
::compleatly::completely
::completelyl::completely
::completly::completely
::compleatness::completeness
::completness::completeness
::completetion::completion
::componant::component
::composate::composite
::comphrehensive::comprehensive
::comprimise::compromise
::compulsary::compulsory
::compulsery::compulsory
::cmoputer::computer
::coputer::computer
::computarised::computerised
::computarized::computerized
::concieted::conceited
::concieve::conceive
::concieved::conceived
::consentrate::concentrate
::consentrated::concentrated
::consentrates::concentrates
::consept::concept
::consern::concern
::conserned::concerned
::conserning::concerning
::comdemnation::condemnation
::condamned::condemned
::condemmed::condemned
::condidtion::condition
::condidtions::conditions
::conditionsof::conditions of
::condolances::condolences
::conferance::conference
::confidental::confidential
::confidentally::confidentially
::confids::confides
::configureable::configurable
::confirmmation::confirmation
::coform::conform
::congradulations::congratulations
::congresional::congressional
::conjecutre::conjecture
::conjuction::conjunction
::conected::connected
::conneticut::Connecticut
::conection::connection
::conived::connived
::cannotation::connotation
::cannotations::connotations
::conotations::connotations
::conquerd::conquered
::conqured::conquered
::conquerer::conqueror
::conquerers::conquerors
::concious::conscious
::consious::conscious
::conciously::consciously
::conciousness::consciousness
::consciouness::consciousness
::consiciousness::consciousness
::consicousness::consciousness
::consectutive::consecutive
::concensus::consensus
::conesencus::consensus
::conscent::consent
::consequeseces::consequences
::consenquently::consequently
::consequentually::consequently
::conservitive::conservative
::concider::consider
::consdider::consider
::considerit::considerate
::considerite::considerate
::concidered::considered
::consdidered::considered
::consdiered::considered
::considerd::considered
::consideres::considered
::concidering::considering
::conciders::considers
::consistant::consistent
::consistantly::consistently
::consolodate::consolidate
::consolodated::consolidated
::consonent::consonant
::consonents::consonants
::consorcium::consortium
::conspiracys::conspiracies
::conspiricy::conspiracy
::conspiriator::conspirator
::constatn::constant
::constanly::constantly
::constarnation::consternation
::consituencies::constituencies
::consituency::constituency
::constituant::constituent
::constituants::constituents
::consituted::constituted
::consitution::constitution
::constituion::constitution
::costitution::constitution
::consitutional::constitutional
::constituional::constitutional
::constaints::constraints
::consttruction::construction
::constuction::construction
::contruction::construction
::consulant::consultant
::consultent::consultant
::consumber::consumer
::consumate::consummate
::consumated::consummated
::comntain::contain
::comtain::contain
::comntains::contains
::comtains::contains
::containes::contains
::countains::contains
::contaiminate::contaminate
::contemporaneus::contemporaneous
::contamporaries::contemporaries
::contamporary::contemporary
::contempoary::contemporary
::contempory::contemporary
::contendor::contender
::constinually::continually
::contined::continued
::continueing::continuing
::continous::continuous
::continously::continuously
::contritutions::contributions
::contributer::contributor
::contributers::contributors
::controll::control
::controled::controlled
::controling::controlling
::controlls::controls
::contravercial::controversial
::controvercial::controversial
::controversal::controversial
::controvertial::controversial
::controveries::controversies
::contraversy::controversy
::controvercy::controversy
::controvery::controversy
::conveinent::convenient
::convienient::convenient
::convential::conventional
::convertion::conversion
::convertor::converter
::convertors::converters
::convertable::convertible
::convertables::convertibles
::conveyer::conveyor
::conviced::convinced
::cooparate::cooperate
::cooporate::cooperate
::coordiantion::coordination
::cpoy::copy
::copywrite::copyright
::coridal::cordial
::corparate::corporate
::corproation::corporation
::coorperations::corporations
::corperations::corporations
::corproations::corporations
::correcters::correctors
::corrispond::correspond
::corrisponded::corresponded
::correspondant::correspondent
::corrispondant::correspondent
::correspondants::correspondents
::corrispondants::correspondents
::correponding::corresponding
::correposding::corresponding
::corrisponding::corresponding
::corrisponds::corresponds
::corridoors::corridors
::corosion::corrosion
::corruptable::corruptible
::cotten::cotton
::coudl::could
::could of::could have
::couldthe::could the
::coudln't::couldn't
::coudn't::couldn't
::couldnt::couldn't
::coucil::council
::counries::countries
::countires::countries
::ocuntries::countries
::ocuntry::country
::coururier::courier
::convenant::covenant
::creaeted::created
::creedence::credence
::criterias::criteria
::critereon::criterion
::crtical::critical
::critised::criticised
::criticing::criticising
::criticists::critics
::crockodiles::crocodiles
::crucifiction::crucifixion
::crusies::cruises
::crystalisation::crystallisation
::culiminating::culminating
::cumulatative::cumulative
::currenly::currently
::ciriculum::curriculum
::curriculem::curriculum
::cusotmer::customer
::cutsomer::customer
::cusotmers::customers
::cutsomers::customers
::cxan::cyan
::cilinder::cylinder
::cyclinder::cylinder
::dakiri::daiquiri
::dalmation::dalmatian
::danceing::dancing
::dardenelles::Dardanelles
::dael::deal
::debateable::debatable
::decaffinated::decaffeinated
::decathalon::decathlon
::decieved::deceived
::decideable::decidable
::deside::decide
::decidely::decidedly
::ecidious::deciduous
::decison::decision
::descision::decision
::desicion::decision
::desision::decision
::decisons::decisions
::descisions::decisions
::desicions::decisions
::desisions::decisions
::decomissioned::decommissioned
::decomposit::decompose
::decomposited::decomposed
::decomposits::decomposes
::decompositing::decomposing
::decress::decrees
::deafult::default
::defendent::defendant
::defendents::defendants
::defencive::defensive
::deffensively::defensively
::definance::defiance
::deffine::define
::deffined::defined
::definining::defining
::definate::definite
::definit::definite
::definately::definitely
::definatly::definitely
::definetly::definitely
::definitly::definitely
::definiton::definition
::defintion::definition
::degredation::degradation
::degrate::degrade
::dieties::deities
::diety::deity
::delagates::delegates
::deliberatly::deliberately
::delerious::delirious
::delusionally::delusively
::devels::delves
::damenor::demeanor
::demenor::demeanor
::damenor::demeanour
::damenour::demeanour
::demenour::demeanour
::demorcracy::democracy
::demographical::demographic
::demolision::demolition
::demostration::demonstration
::denegrating::denigrating
::densly::densely
::deparment::department
::deptartment::department
::dependance::dependence
::dependancy::dependency
::dependant::dependent
::despict::depict
::derivitive::derivative
::deriviated::derived
::dirived::derived
::derogitory::derogatory
::decendant::descendant
::decendent::descendant
::decendants::descendants
::decendents::descendants
::descendands::descendants
::decribe::describe
::discribe::describe
::decribed::described
::descibed::described
::discribed::described
::decribes::describes
::descriibes::describes
::discribes::describes
::decribing::describing
::discribing::describing
::descriptoin::description
::descripton::description
::descripters::descriptors
::dessicated::desiccated
::disign::design
::desgined::designed
::dessigned::designed
::desigining::designing
::desireable::desirable
::desktiop::desktop
::dispair::despair
::desparate::desperate
::despiration::desperation
::dispicable::despicable
::dispite::despite
::destablised::destabilised
::destablized::destabilized
::desinations::destinations
::desitned::destined
::destory::destroy
::desctruction::destruction
::distruction::destruction
::distructive::destructive
::detatched::detached
::detailled::detailed
::deatils::details
::dectect::detect
::deteriate::deteriorate
::deteoriated::deteriorated
::deterioriating::deteriorating
::determinining::determining
::detremental::detrimental
::devasted::devastated
::devestated::devastated
::devestating::devastating
::devistating::devastating
::devellop::develop
::devellops::develop
::develloped::developed
::developped::developed
::develloper::developer
::developor::developer
::develeoprs::developers
::devellopers::developers
::developors::developers
::develloping::developing
::delevopment::development
::devellopment::development
::develpment::development
::devolopement::development
::devellopments::developments
::divice::device
::diablical::diabolical
::diamons::diamonds
::diarhea::diarrhoea
::dichtomy::dichotomy
::didnot::did not
::didint::didn't
::didnt::didn't
::differance::difference
::diferences::differences
::differances::differences
::difefrent::different
::diferent::different
::diferrent::different
::differant::different
::differemt::different
::differnt::different
::diffrent::different
::differentiatiations::differentiations
::diffcult::difficult
::diffculties::difficulties
::dificulties::difficulties
::diffculty::difficulty
::difficulity::difficulty
::dificulty::difficulty
::delapidated::dilapidated
::dimention::dimension
::dimentional::dimensional
::dimesnional::dimensional
::dimenions::dimensions
::dimentions::dimensions
::diminuitive::diminutive
::diosese::diocese
::diptheria::diphtheria
::diphtong::diphthong
::dipthong::diphthong
::diphtongs::diphthongs
::dipthongs::diphthongs
::diplomancy::diplomacy
::directiosn::direction
::driectly::directly
::directer::director
::directers::directors
::disagreeed::disagreed
::dissagreement::disagreement
::disapear::disappear
::dissapear::disappear
::dissappear::disappear
::dissapearance::disappearance
::disapeared::disappeared
::disappearred::disappeared
::dissapeared::disappeared
::dissapearing::disappearing
::dissapears::disappears
::dissappears::disappears
::dissappointed::disappointed
::disapointing::disappointing
::disaproval::disapproval
::dissarray::disarray
::diaster::disaster
::disasterous::disastrous
::disatrous::disastrous
::diciplin::discipline
::disiplined::disciplined
::unconfortability::discomfort
::diconnects::disconnects
::discontentment::discontent
::dicover::discover
::disover::discover
::dicovered::discovered
::discoverd::discovered
::dicovering::discovering
::dicovers::discovers
::dicovery::discovery
::descuss::discuss
::dicussed::discussed
::desease::disease
::disenchanged::disenchanted
::desintegrated::disintegrated
::desintegration::disintegration
::disobediance::disobedience
::dissobediance::disobedience
::dissobedience::disobedience
::disobediant::disobedient
::dissobediant::disobedient
::dissobedient::disobedient
::desorder::disorder
::desoriented::disoriented
::disparingly::disparagingly
::despatched::dispatched
::dispell::dispel
::dispeled::dispelled
::dispeling::dispelling
::dispells::dispels
::dispence::dispense
::dispenced::dispensed
::dispencing::dispensing
::diaplay::display
::dispaly::display
::unplease::displease
::dispostion::disposition
::disproportiate::disproportionate
::disputandem::disputandum
::disatisfaction::dissatisfaction
::disatisfied::dissatisfied
::disemination::dissemination
::disolved::dissolved
::dissonent::dissonant
::disctinction::distinction
::distiction::distinction
::disctinctive::distinctive
::distingish::distinguish
::distingished::distinguished
::distingquished::distinguished
::distingishes::distinguishes
::distingishing::distinguishing
::ditributed::distributed
::distribusion::distribution
::distrubution::distribution
::disricts::districts
::devide::divide
::devided::divided
::divison::division
::divisons::divisions
::docrines::doctrines
::doctines::doctrines
::doccument::document
::docuemnt::document
::documetn::document
::documnet::document
::documenatry::documentary
::doccumented::documented
::doccuments::documents
::docuement::documents
::documnets::documents
::doens::does
::doese::does
::doe snot::does not ; *could* be legitimate... but very unlikely!
::doens't::doesn't
::doesnt::doesn't
::dosen't::doesn't
::dosn't::doesn't
::doign::doing
::doimg::doing
::doind::doing
::donig::doing
::dollers::dollars
::dominent::dominant
::dominiant::dominant
::dominaton::domination
::do'nt::don't
::dont::don't
::don't no::don't know
::doulbe::double
::dowloads::downloads
::dramtic::dramatic
::draughtman::draughtsman
::dravadian::Dravidian
::deram::dream
::derams::dreams
::dreasm::dreams
::drnik::drink
::driveing::driving
::drummless::drumless
::druming::drumming
::drunkeness::drunkenness
::dukeship::dukedom
::dumbell::dumbbell
::dupicate::duplicate
::durig::during
::durring::during
::duting::during
::dieing::dying
::eahc::each
::eachotehr::eachother
::ealier::earlier
::earlies::earliest
::eearly::early
::earnt::earned
::ecclectic::eclectic
::eclispe::eclipse
::ecomonic::economic
::eceonomy::economy
::esctasy::ecstasy
::eles::eels
::effeciency::efficiency
::efficency::efficiency
::effecient::efficient
::efficent::efficient
::effeciently::efficiently
::efficently::efficiently
::effulence::effluence
::efort::effort
::eforts::efforts
::aggregious::egregious
::eight o::eight o
::eigth::eighth
::eiter::either
::ellected::elected
::electrial::electrical
::electricly::electrically
::electricty::electricity
::eletricity::electricity
::elementay::elementary
::elimentary::elementary
::elphant::elephant
::elicided::elicited
::eligable::eligible
::eleminated::eliminated
::eleminating::eliminating
::alse::else
::esle::else
::eminate::emanate
::eminated::emanated
::embargos::embargoes
::embarras::embarrass
::embarrased::embarrassed
::embarrasing::embarrassing
::embarrasment::embarrassment
::embezelled::embezzled
::emblamatic::emblematic
::emmigrated::emigrated
::emmisaries::emissaries
::emmisarries::emissaries
::emmisarry::emissary
::emmisary::emissary
::emision::emission
::emmision::emission
::emmisions::emissions
::emited::emitted
::emmited::emitted
::emmitted::emitted
::emiting::emitting
::emmiting::emitting
::emmitting::emitting
::emphsis::emphasis
::emphaised::emphasised
::emphysyma::emphysema
::emperical::empirical
::imploys::employs
::enameld::enamelled
::encouraing::encouraging
::encryptiion::encryption
::encylopedia::encyclopedia
::endevors::endeavors
::endevour::endeavour
::endevours::endeavours
::endig::ending
::endolithes::endoliths
::enforceing::enforcing
::engagment::engagement
::engeneer::engineer
::engieneer::engineer
::engeneering::engineering
::engieneers::engineers
::enlish::English
::enchancement::enhancement
::emnity::enmity
::enourmous::enormous
::enourmously::enormously
::enought::enough
::ensconsed::ensconced
::entaglements::entanglements
::intertaining::entertaining
::enteratinment::entertainment
::entitlied::entitled
::entitity::entity
::entrepeneur::entrepreneur
::entrepeneurs::entrepreneurs
::intrusted::entrusted
::enviornment::environment
::enviornmental::environmental
::enviornmentalist::environmentalist
::enviornmentally::environmentally
::enviornments::environments
::envrionments::environments
::epsiode::episode
::epidsodes::episodes
::equitorial::equatorial
::equilibium::equilibrium
::equilibrum::equilibrium
::equippment::equipment
::equiped::equipped
::equialent::equivalent
::equivalant::equivalent
::equivelant::equivalent
::equivelent::equivalent
::equivilant::equivalent
::equivilent::equivalent
::equivlalent::equivalent
::eratic::erratic
::eratically::erratically
::eraticly::erratically
::errupted::erupted
::especally::especially
::especialy::especially
::especialyl::especially
::espesially::especially
::expecially::especially
::expresso::espresso
::essense::essence
::esential::essential
::essencial::essential
::essentail::essential
::essentual::essential
::essesital::essential
::essentialy::essentially
::estabishes::establishes
::establising::establishing
::esitmated::estimated
::ect::etc
::ethnocentricm::ethnocentrism
::europian::European
::eurpean::European
::eurpoean::European
::europians::Europeans
::evenhtually::eventually
::eventally::eventually
::eventially::eventually
::eventualy::eventually
::eveyr::every
::everytime::every time
::everthing::everything
::evidentally::evidently
::efel::evil
::envolutionary::evolutionary
::exerbate::exacerbate
::exerbated::exacerbated
::excact::exact
::exagerate::exaggerate
::exagerrate::exaggerate
::exagerated::exaggerated
::exagerrated::exaggerated
::exagerates::exaggerates
::exagerrates::exaggerates
::exagerating::exaggerating
::exagerrating::exaggerating
::exhalted::exalted
::examinated::examined
::exemple::example
::exmaple::example
::excedded::exceeded
::exeedingly::exceedingly
::excell::excel
::excellance::excellence
::excelent::excellent
::excellant::excellent
::exelent::excellent
::exellent::excellent
::excells::excels
::exept::except
::exeptional::exceptional
::exerpt::excerpt
::exerpts::excerpts
::excange::exchange
::exchagne::exchange
::exhcange::exchange
::exchagnes::exchanges
::exhcanges::exchanges
::exchanching::exchanging
::excitment::excitement
::exicting::exciting
::exludes::excludes
::exculsivly::exclusively
::excecute::execute
::excecuted::executed
::exectued::executed
::excecutes::executes
::excecuting::executing
::excecution::execution
::exection::execution
::exampt::exempt
::excercise::exercise
::exersize::exercise
::exerciese::exercises
::execising::exercising
::extered::exerted
::exhibtion::exhibition
::exibition::exhibition
::exibitions::exhibitions
::exliled::exiled
::excisted::existed
::existance::existence
::existince::existence
::existant::existent
::exisiting::existing
::exonorate::exonerate
::exoskelaton::exoskeleton
::exapansion::expansion
::expeced::expected
::expeditonary::expeditionary
::expiditions::expeditions
::expell::expel
::expells::expels
::experiance::experience
::experienc::experience
::expierence::experience
::exprience::experience
::experianced::experienced
::exprienced::experienced
::expeiments::experiments
::expalin::explain
::explaning::explaining
::explaination::explanation
::explictly::explicitly
::explotation::exploitation
::exploititive::exploitative
::exressed::expressed
::expropiated::expropriated
::expropiation::expropriation
::extention::extension
::extentions::extensions
::exerternal::external
::exinct::extinct
::extradiction::extradition
::extrordinarily::extraordinarily
::extrordinary::extraordinary
::extravagent::extravagant
::extemely::extremely
::extrememly::extremely
::extremly::extremely
::extermist::extremist
::extremeophile::extremophile
::fascitious::facetious
::facillitate::facilitate
::facilites::facilities
::farenheit::Fahrenheit
::familair::familiar
::familar::familiar
::familliar::familiar
::fammiliar::familiar
::familes::families
::fimilies::families
::famoust::famous
::fanatism::fanaticism
::facia::fascia
::fascitis::fasciitis
::facinated::fascinated
::facist::fascist
::favoutrable::favourable
::feasable::feasible
::faeture::feature
::faetures::features
::febuary::February
::fedreally::federally
::efel::feel
::fertily::fertility
::fued::feud
::fwe::few
::ficticious::fictitious
::fictious::fictitious
::feild::field
::feilds::fields
::fiercly::fiercely
::firey::fiery
::fightings::fighting
::filiament::filament
::fiel::file
::fiels::files
::fianlly::finally
::finaly::finally
::finalyl::finally
::finacial::financial
::financialy::financially
::fidn::find
::fianite::finite
::firts::first
::fisionable::fissionable
::ficed::fixed
::flamable::flammable
::flawess::flawless
::flemmish::Flemish
::glight::flight
::fluorish::flourish
::florescent::fluorescent
::flourescent::fluorescent
::flouride::fluoride
::foucs::focus
::focussed::focused
::focusses::focuses
::focussing::focusing
::follwo::follow
::follwoing::following
::folowing::following
::formalhaut::Fomalhaut
::foootball::football
::fora::for a
::forthe::for the
::forbad::forbade
::forbiden::forbidden
::forhead::forehead
::foriegn::foreign
::formost::foremost
::forunner::forerunner
::forsaw::foresaw
::forseeable::foreseeable
::fortelling::foretelling
::foreward::foreword
::forfiet::forfeit
::formallise::formalise
::formallised::formalised
::formallize::formalize
::formallized::formalized
::formaly::formally
::fomed::formed
::fromed::formed
::formelly::formerly
::fourties::forties
::fourty::forty
::forwrd::forward
::foward::forward
::forwrds::forwards
::fowards::forwards
::faught::fought
::fougth::fought
::foudn::found
::foundaries::foundries
::foundary::foundry
::fouth::fourth
::fransiscan::Franciscan
::fransiscans::Franciscans
::frequentily::frequently
::freind::friend
::freindly::friendly
::firends::friends
::freinds::friends
::frmo::from
::frome::from
::fromt he::from the
::fromthe::from the
::froniter::frontier
::fufill::fulfill
::fufilled::fulfilled
::fulfiled::fulfilled
::funtion::function
::fundametal::fundamental
::fundametals::fundamentals
::furneral::funeral
::funguses::fungi
::firc::furc
::furuther::further
::futher::further
::futhermore::furthermore
::galatic::galactic
::galations::Galatians
::gallaxies::galaxies
::galvinised::galvanised
::galvinized::galvanized
::gameboy::Game Boy
::ganes::games
::ghandi::Gandhi
::ganster::gangster
::garnison::garrison
::guage::gauge
::geneological::genealogical
::geneologies::genealogies
::geneology::genealogy
::gemeral::general
::generaly::generally
::generatting::generating
::genialia::genitalia
::gentlemens::gentlemen's
::geographicial::geographical
::geometrician::geometer
::geometricians::geometers
::geting::getting
::gettin::getting
::guilia::Giulia
::guiliani::Giuliani
::guilio::Giulio
::guiseppe::Giuseppe
::gievn::given
::giveing::giving
::glace::glance
::gloabl::global
::gnawwed::gnawed
::godess::goddess
::godesses::goddesses
::godounov::Godunov
::goign::going
::gonig::going
::oging::going
::giid::good
::gothenberg::Gothenburg
::gottleib::Gottlieb
::goverance::governance
::govement::government
::govenment::government
::govenrment::government
::goverment::government
::governmnet::government
::govorment::government
::govornment::government
::govermental::governmental
::govormental::governmental
::gouvener::governor
::governer::governor
::gracefull::graceful
::graffitti::graffiti
::grafitti::graffiti
::grammer::grammar
::gramatically::grammatically
::grammaticaly::grammatically
::greatful::grateful
::greatfully::gratefully
::gratuitious::gratuitous
::gerat::great
::graet::great
::grat::great
::gridles::griddles
::greif::grief
::gropu::group
::gruop::group
::gruops::groups
::grwo::grow
::guadulupe::Guadalupe
::gunanine::guanine
::gauarana::guarana
::gaurantee::guarantee
::gaurentee::guarantee
::guarentee::guarantee
::gurantee::guarantee
::gauranteed::guaranteed
::gaurenteed::guaranteed
::guarenteed::guaranteed
::guranteed::guaranteed
::gaurantees::guarantees
::gaurentees::guarantees
::guarentees::guarantees
::gurantees::guarantees
::gaurd::guard
::guatamala::Guatemala
::guatamalan::Guatemalan
::guidence::guidance
::guiness::Guinness
::guttaral::guttural
::gutteral::guttural
::gusy::guys
::habaeus::habeas
::habeus::habeas
::habsbourg::Habsburg
::hda::had
::hadbeen::had been
::haemorrage::haemorrhage
::hallowean::Halloween
::ahppen::happen
::hapen::happen
::hapened::happened
::happend::happened
::happended::happened
::happenned::happened
::hapening::happening
::hapens::happens
::harras::harass
::harased::harassed
::harrased::harassed
::harrassed::harassed
::harrasses::harassed
::harases::harasses
::harrases::harasses
::harrasing::harassing
::harrassing::harassing
::harassement::harassment
::harrasment::harassment
::harrassment::harassment
::harrasments::harassments
::harrassments::harassments
::hace::hare
::hsa::has
::hasbeen::has been
::hasnt::hasn't
::ahev::have
::ahve::have
::haev::have
::hvae::have
::havebeen::have been
::haveing::having
::hvaing::having
::hge::he
::hesaid::he said
::hewas::he was
::headquater::headquarter
::headquatered::headquartered
::headquaters::headquarters
::healthercare::healthcare
::heathy::healthy
::heared::heard
::hearign::hearing
::herat::heart
::haviest::heaviest
::heidelburg::Heidelberg
::hieght::height
::hier::heir
::heirarchy::heirarchy
::helment::helmet
::halp::help
::hlep::help
::helpped::helped
::helpfull::helpful
::hemmorhage::hemorrhage
::ehr::her
::ehre::here
::here;s::here's
::heridity::heredity
::heroe::hero
::heros::heroes
::hertzs::hertz
::hesistant::hesitant
::heterogenous::heterogeneous
::heirarchical::hierarchical
::hierachical::hierarchical
::hierarcical::hierarchical
::heirarchies::hierarchies
::hierachies::hierarchies
::heirarchy::hierarchy
::hierachy::hierarchy
::hierarcy::hierarchy
::hieroglph::hieroglyph
::heiroglyphics::hieroglyphics
::hieroglphs::hieroglyphs
::heigher::higher
::higer::higher
::higest::highest
::higway::highway
::hillarious::hilarious
::himselv::himself
::hismelf::himself
::hinderance::hindrance
::hinderence::hindrance
::hindrence::hindrance
::hipopotamus::hippopotamus
::hersuit::hirsute
::hsi::his
::ihs::his
::historicians::historians
::hsitorians::historians
::hstory::history
::hitsingles::hit singles
::hosited::hoisted
::holliday::holiday
::homestate::home state
::homogeneize::homogenize
::homogeneized::homogenized
::honourarium::honorarium
::honory::honorary
::honourific::honorific
::hounour::honour
::horrifing::horrifying
::hospitible::hospitable
::housr::hours
::howver::however
::huminoid::humanoid
::humoural::humoral
::humer::humour
::humerous::humourous
::humurous::humourous
::husban::husband
::hydogen::hydrogen
::hydropile::hydrophile
::hydropilic::hydrophilic
::hydropobe::hydrophobe
::hydropobic::hydrophobic
::hygeine::hygiene
::hypocracy::hypocrisy
::hypocrasy::hypocrisy
::hypocricy::hypocrisy
::hypocrit::hypocrite
::hypocrits::hypocrites
::i;d::I'd
::i"m::I'm
::iconclastic::iconoclastic
::idae::idea
::idaeidae::idea
::idaes::ideas
::identicial::identical
::identifers::identifiers
::identofy::identify
::idealogies::ideologies
::idealogy::ideology
::idiosyncracy::idiosyncrasy
::ideosyncratic::idiosyncratic
::ignorence::ignorance
::illiegal::illegal
::illegimacy::illegitimacy
::illegitmate::illegitimate
::illess::illness
::ilness::illness
::ilogical::illogical
::ilumination::illumination
::illution::illusion
::imagenary::imaginary
::imagin::imagine
::inbalance::imbalance
::inbalanced::imbalanced
::imediate::immediate
::emmediately::immediately
::imediately::immediately
::imediatly::immediately
::immediatley::immediately
::immediatly::immediately
::immidately::immediately
::immidiately::immediately
::imense::immense
::inmigrant::immigrant
::inmigrants::immigrants
::imanent::imminent
::immunosupressant::immunosuppressant
::inpeach::impeach
::impecabbly::impeccably
::impedence::impedance
::implamenting::implementing
::inpolite::impolite
::importamt::important
::importent::important
::importnat::important
::impossable::impossible
::emprisoned::imprisoned
::imprioned::imprisoned
::imprisonned::imprisoned
::inprisonment::imprisonment
::improvemnt::improvement
::improvment::improvement
::improvments::improvements
::inproving::improving
::improvision::improvisation
::int he::in the
::inteh::in the
::inthe::in the
::inwhich::in which
::inablility::inability
::inaccessable::inaccessible
::inadiquate::inadequate
::inadquate::inadequate
::inadvertant::inadvertent
::inadvertantly::inadvertently
::inappropiate::inappropriate
::inagurated::inaugurated
::inaugures::inaugurates
::inaguration::inauguration
::incarcirated::incarcerated
::incidentially::incidentally
::incidently::incidentally
::includ::include
::includng::including
::incuding::including
::incomptable::incompatible
::incompetance::incompetence
::incompetant::incompetent
::incomptetent::incompetent
::imcomplete::incomplete
::inconsistant::inconsistent
::incorportaed::incorporated
::incorprates::incorporates
::incorperation::incorporation
::incorruptable::incorruptible
::inclreased::increased
::increadible::incredible
::incredable::incredible
::incramentally::incrementally
::incunabla::incunabula
::indefinately::indefinitely
::indefinitly::indefinitely
::indepedence::independence
::independance::independence
::independece::independence
::indipendence::independence
::indepedent::independent
::independant::independent
::independendet::independent
::indipendent::independent
::indpendent::independent
::indepedantly::independently
::independantly::independently
::indipendently::independently
::indpendently::independently
::indecate::indicate
::indite::indict
::indictement::indictment
::indigineous::indigenous
::indispensible::indispensable
::individualy::individually
::indviduals::individuals
::enduce::induce
::indulgue::indulge
::indutrial::industrial
::inudstry::industry
::inefficienty::inefficiently
::unequalities::inequalities
::inevatible::inevitable
::inevitible::inevitable
::inevititably::inevitably
::infalability::infallibility
::infallable::infallible
::infrantryman::infantryman
::infectuous::infectious
::infered::inferred
::infilitrate::infiltrate
::infilitrated::infiltrated
::infilitration::infiltration
::infinit::infinite
::infinitly::infinitely
::enflamed::inflamed
::inflamation::inflammation
::influance::influence
::influented::influenced
::influencial::influential
::infomation::information
::informatoin::information
::informtion::information
::infrigement::infringement
::ingenius::ingenious
::ingreediants::ingredients
::inhabitans::inhabitants
::inherantly::inherently
::inheritence::inheritance
::inital::initial
::intial::initial
::ititial::initial
::initally::initially
::intially::initially
::initation::initiation
::initiaitive::initiative
::inate::innate
::inocence::innocence
::inumerable::innumerable
::innoculate::inoculate
::innoculated::inoculated
::insectiverous::insectivorous
::insensative::insensitive
::inseperable::inseparable
::insistance::insistence
::instaleld::installed
::instatance::instance
::instade::instead
::insted::instead
::institue::institute
::instutionalized::institutionalized
::instuction::instruction
::instuments::instruments
::insufficent::insufficient
::insufficently::insufficiently
::insurence::insurance
::intergrated::integrated
::intergration::integration
::intelectual::intellectual
::inteligence::intelligence
::inteligent::intelligent
::interchangable::interchangeable
::interchangably::interchangeably
::intercontinetal::intercontinental
::intrest::interest
::itnerest::interest
::itnerested::interested
::itneresting::interesting
::itnerests::interests
::interferance::interference
::interfereing::interfering
::interm::interim
::interrim::interim
::interum::interim
::intenational::international
::interational::international
::internation::international
::interpet::interpret
::intepretation::interpretation
::intepretator::interpretor
::interrugum::interregnum
::interelated::interrelated
::interupt::interrupt
::intevene::intervene
::intervines::intervenes
::inot::into
::inctroduce::introduce
::inctroduced::introduced
::intrduced::introduced
::introdued::introduced
::intruduced::introduced
::itnroduced::introduced
::instutions::intuitions
::intutive::intuitive
::intutively::intuitively
::inventer::inventor
::invertibrates::invertebrates
::investingate::investigate
::involvment::involvement
::ironicly::ironically
::irelevent::irrelevant
::irrelevent::irrelevant
::irreplacable::irreplaceable
::iresistable::irresistible
::iresistible::irresistible
::irresistable::irresistible
::iresistably::irresistibly
::iresistibly::irresistibly
::irresistably::irresistibly
::iritable::irritable
::iritated::irritated
::i snot::is not
::isthe::is the
::isnt::isn't
::issueing::issuing
::itis::it is
::itwas::it was
::it;s::it's
::its a::it's a
::it snot::it's not
::it' snot::it's not
::iits the::it's the
::its the::it's the
::ihaca::Ithaca
::jaques::jacques
::japanes::Japanese
::jeapardy::jeopardy
::jewelery::jewellery
::jewllery::jewellery
::johanine::Johannine
::jospeh::Joseph
::jouney::journey
::journied::journeyed
::journies::journeys
::juadaism::Judaism
::juadism::Judaism
::judgment::judgement
::jugment::judgment
::judical::judicial
::juducial::judicial
::judisuary::judiciary
::iunior::junior
::juristiction::jurisdiction
::juristictions::jurisdictions
::jstu::just
::jsut::just
::kindergarden::kindergarten
::klenex::kleenex
::knive::knife
::knifes::knives
::konw::know
::kwno::know
::nkow::know
::nkwo::know
::knowldge::knowledge
::knowlege::knowledge
::knowlegeable::knowledgeable
::knwon::known
::konws::knows
::labled::labelled
::labratory::laboratory
::labourious::laborious
::layed::laid
::laguage::language
::laguages::languages
::larg::large
::largst::largest
::larrry::larry
::lavae::larvae
::lazer::laser
::lasoo::lasso
::lastr::last
::lsat::last
::lastyear::last year
::lastest::latest
::lattitude::latitude
::launchs::launch
::launhed::launched
::lazyness::laziness
::leage::league
::leran::learn
::learnign::learning
::lerans::learns
::elast::least
::leaded::led
::lefted::left
::legitamate::legitimate
::legitmate::legitimate
::leibnitz::leibniz
::liesure::leisure
::lenght::length
::let;s::let's
::leathal::lethal
::let's him::lets him
::let's it::lets it
::levle::level
::levetate::levitate
::levetated::levitated
::levetates::levitates
::levetating::levitating
::liasion::liaison
::liason::liaison
::liasons::liaisons
::libell::libel
::libitarianisn::libertarianism
::libary::library
::librarry::library
::librery::library
::lybia::Libya
::lisense::license
::leutenant::lieutenant
::lieutenent::lieutenant
::liftime::lifetime
::lightyear::light year
::lightyears::light years
::lightening::lightning
::liek::like
::liuke::like
::liekd::liked
::likelyhood::likelihood
::likly::likely
::lukid::likud
::lmits::limits
::libguistic::linguistic
::libguistics::linguistics
::linnaena::linnaean
::lippizaner::lipizzaner
::liquify::liquefy
::listners::listeners
::litterally::literally
::litature::literature
::literture::literature
::littel::little
::litttle::little
::liev::live
::lieved::lived
::livley::lively
::liveing::living
::lonelyness::loneliness
::lonley::lonely
::lonly::lonely
::longitudonal::longitudinal
::lookign::looking
::loosing::losing
::lotharingen::lothringen
::loev::love
::lveo::love
::lvoe::love
::lieing::lying
::mackeral::mackerel
::amde::made
::magasine::magazine
::magincian::magician
::magnificient::magnificent
::magolia::magnolia
::mailny::mainly
::mantain::maintain
::mantained::maintained
::maintinaing::maintaining
::maintainance::maintenance
::maintainence::maintenance
::maintance::maintenance
::maintenence::maintenance
::majoroty::majority
::marjority::majority
::amke::make
::mkae::make
::mkea::make
::amkes::makes
::makse::makes
::mkaes::makes
::amking::making
::makeing::making
::mkaing::making
::malcom::Malcolm
::maltesian::Maltese
::mamal::mammal
::mamalian::mammalian
::managable::manageable
::managment::management
::manuver::maneuver
::manoeuverability::maneuverability
::manifestion::manifestation
::manisfestations::manifestations
::manufature::manufacture
::manufacturedd::manufactured
::manufatured::manufactured
::manufaturing::manufacturing
::mrak::mark
::maked::marked
::marketting::marketing
::markes::marks
::marmelade::marmalade
::mariage::marriage
::marrage::marriage
::marraige::marriage
::marryied::married
::marrtyred::martyred
::massmedia::mass media
::massachussets::Massachusetts
::massachussetts::Massachusetts
::masterbation::masturbation
::materalists::materialist
::mathmatically::mathematically
::mathematican::mathematician
::mathmatician::mathematician
::matheticians::mathematicians
::mathmaticians::mathematicians
::mathamatics::mathematics
::mathematicas::mathematics
::may of::may have
::mccarthyst::mccarthyist
::meaninng::meaning
::menat::meant
::mchanics::mechanics
::medieval::mediaeval
::medacine::medicine
::mediciney::mediciny
::medeival::medieval
::medevial::medieval
::medievel::medieval
::mediterainnean::mediterranean
::mediteranean::Mediterranean
::meerkrat::meerkat
::memeber::member
::membranaphone::membranophone
::momento::memento
::rememberable::memorable
::menally::mentally
::maintioned::mentioned
::mercentile::mercantile
::mechandise::merchandise
::merchent::merchant
::mesage::message
::mesages::messages
::messenging::messaging
::messanger::messenger
::metalic::metallic
::metalurgic::metallurgic
::metalurgical::metallurgical
::metalurgy::metallurgy
::metamorphysis::metamorphosis
::methaphor::metaphor
::metaphoricial::metaphorical
::methaphors::metaphors
::mataphysical::metaphysical
::meterologist::meteorologist
::meterology::meteorology
::micheal::Michael
::michagan::Michigan
::micoscopy::microscopy
::midwifes::midwives
::might of::might have
::mileau::milieu
::mileu::milieu
::melieux::milieux
::miliary::military
::miliraty::military
::millitary::military
::miltary::military
::milennia::millennia
::millenia::millennia
::millenial::millennial
::millenialism::millennialism
::milennium::millennium
::millenium::millennium
::milion::million
::millon::million
::millioniare::millionaire
::millepede::millipede
::minerial::mineral
::minature::miniature
::minumum::minimum
::minstries::ministries
::ministery::ministry
::minstry::ministry
::miniscule::minuscule
::mirrorred::mirrored
::miscelaneous::miscellaneous
::miscellanious::miscellaneous
::miscellanous::miscellaneous
::mischeivous::mischievous
::mischevious::mischievous
::mischievious::mischievous
::misdameanor::misdemeanor
::misdemenor::misdemeanor
::misdameanors::misdemeanors
::misdemenors::misdemeanors
::misfourtunes::misfortunes
::mysogynist::misogynist
::mysogyny::misogyny
::misile::missile
::missle::missile
::missonary::missionary
::missisipi::Mississippi
::missisippi::Mississippi
::misouri::Missouri
::mispell::misspell
::mispelled::misspelled
::mispelling::misspelling
::mispellings::misspellings
::mythraic::Mithraic
::missen::mizzen
::modle::model
::moderm::modem
::moil::mohel
::mosture::moisture
::moleclues::molecules
::moent::moment
::monestaries::monasteries
::monestary::monastery
::moeny::money
::monickers::monikers
::monkies::monkeys
::monolite::monolithic
::montypic::monotypic
::mounth::month
::monts::months
::monserrat::Montserrat
::mroe::more
::omre::more
::moreso::more so
::morisette::Morissette
::morrisette::Morissette
::morroccan::moroccan
::morrocco::morocco
::morroco::morocco
::morgage::mortgage
::motiviated::motivated
::mottos::mottoes
::montanous::mountainous
::montains::mountains
::movment::movement
::movei::movie
::mucuous::mucous
::multicultralism::multiculturalism
::multipled::multiplied
::multiplers::multipliers
::muncipalities::municipalities
::muncipality::municipality
::munnicipality::municipality
::muder::murder
::mudering::murdering
::muscial::musical
::muscician::musician
::muscicians::musicians
::muhammadan::muslim
::mohammedans::muslims
::must of::must have
::mutiliated::mutilated
::myu::my
::myraid::myriad
::mysef::myself
::mysefl::myself
::misterious::mysterious
::misteryous::mysterious
::mysterous::mysterious
::mistery::mystery
::naieve::naive
::napoleonian::Napoleonic
::ansalisation::nasalisation
::ansalization::nasalization
::naturual::natural
::naturaly::naturally
::naturely::naturally
::naturually::naturally
::nazereth::Nazareth
::neccesarily::necessarily
::neccessarily::necessarily
::necesarily::necessarily
::nessasarily::necessarily
::neccesary::necessary
::neccessary::necessary
::necesary::necessary
::nessecary::necessary
::necessiate::necessitate
::neccessities::necessities
::ened::need
::neglible::negligible
::negligable::negligible
::negociable::negotiable
::negotiaing::negotiating
::negotation::negotiation
::neigbourhood::neighbourhood
::neolitic::neolithic
::nestin::nesting
::nver::never
::neverthless::nevertheless
::nwe::new
::newyorker::New Yorker
::foundland::Newfoundland
::newletters::newsletters
::enxt::next
::nickle::nickel
::neice::niece
::nightime::nighttime
::ninteenth::nineteenth
::ninties::nineties ; fixed from "1990s": could refer to temperatures too.
::ninty::ninety
::nineth::ninth
::noone::no one
::noncombatents::noncombatants
::nontheless::nonetheless
::unoperational::nonoperational
::nonsence::nonsense
::noth::north
::northereastern::northeastern
::norhern::northern
::northen::northern
::nothern::northern
:C:Nto::Not
:C:nto::not
::noteable::notable
::notabley::notably
::noteably::notably
::nothign::nothing
::notive::notice
::noticable::noticeable
::noticably::noticeably
::noticeing::noticing
::noteriety::notoriety
::notwhithstanding::notwithstanding
::noveau::nouveau
::nowe::now
::nwo::now
::nowdays::nowadays
::nucular::nuclear
::nuculear::nuclear
::nuisanse::nuisance
::nusance::nuisance
::nullabour::Nullarbor
::munbers::numbers
::numberous::numerous
::nuptual::nuptial
::nuremburg::Nuremberg
::nuturing::nurturing
::nutritent::nutrient
::nutritents::nutrients
::obediance::obedience
::obediant::obedient
::obssessed::obsessed
::obession::obsession
::obsolecence::obsolescence
::obstacal::obstacle
::obstancles::obstacles
::obstruced::obstructed
::ocassion::occasion
::occaison::occasion
::occassion::occasion
::ocassional::occasional
::occassional::occasional
::ocassionally::occasionally
::ocassionaly::occasionally
::occassionally::occasionally
::occassionaly::occasionally
::occationally::occasionally
::ocassioned::occasioned
::occassioned::occasioned
::ocassions::occasions
::occassions::occasions
::occour::occur
::occurr::occur
::ocur::occur
::ocurr::occur
::occured::occurred
::ocurred::occurred
::occurence::occurrence
::occurrance::occurrence
::ocurrance::occurrence
::ocurrence::occurrence
::occurences::occurrences
::occurrances::occurrences
::occuring::occurring
::octohedra::octahedra
::octohedral::octahedral
::octohedron::octahedron
::odouriferous::odoriferous
::odourous::odorous
::ouevre::oeuvre
::fo::of
:C:fo::of
:C:od::of
::ofits::of its
::ofthe::of the
::oft he::of the ; Could be legitimate in poetry, but more usually a typo.
::offereings::offerings
::offcers::officers
::offical::official
::offcially::officially
::offically::officially
::officaly::officially
::officialy::officially
::oftenly::often
::omlette::omelette
::omnious::ominous
::omision::omission
::ommision::omission
::omited::omitted
::ommited::omitted
::ommitted::omitted
::omiting::omitting
::ommiting::omitting
::ommitting::omitting
::omniverous::omnivorous
::omniverously::omnivorously
::ont he::on the
::onthe::on the
::oneof::one of
::onepoint::one point
::onyl::only
::onomatopeia::onomatopoeia
::oppenly::openly
::openess::openness
::opperation::operation
::oeprator::operator
::opthalmic::ophthalmic
::opthalmologist::ophthalmologist
::opthamologist::ophthalmologist
::opthalmology::ophthalmology
::oppinion::opinion
::oponent::opponent
::opponant::opponent
::oppononent::opponent
::oppotunities::opportunities
::oportunity::opportunity
::oppertunity::opportunity
::oppotunity::opportunity
::opprotunity::opportunity
::opposible::opposable
::opose::oppose
::oppossed::opposed
::oposite::opposite
::oppasite::opposite
::opposate::opposite
::opposit::opposite
::oposition::opposition
::oppositition::opposition
::opression::oppression
::opressive::oppressive
::optomism::optimism
::optmizations::optimizations
::orded::ordered
::oridinarily::ordinarily
::orginize::organise
::organim::organism
::organiztion::organization
::orginization::organization
::orginized::organized
::orgin::origin
::orginal::original
::origional::original
::orginally::originally
::origanaly::originally
::originall::originally
::originaly::originally
::originially::originally
::originnally::originally
::orignally::originally
::orignially::originally
::orthagonal::orthogonal
::orthagonally::orthogonally
::ohter::other
::otehr::other
::otherw::others
::otu::out
::outof::out of
::overthe::over the
::overthere::over there
::overshaddowed::overshadowed
::overwelming::overwhelming
::overwheliming::overwhelming
::pwn::own
::oxident::oxidant
::oxigen::oxygen
::oximoron::oxymoron
::peageant::pageant
::paide::paid
::payed::paid
::paleolitic::paleolithic
::palistian::Palestinian
::palistinian::Palestinian
::palistinians::Palestinians
::pallete::palette
::pamflet::pamphlet
::pamplet::pamphlet
::pantomine::pantomime
::papanicalou::Papanicolaou
::papaer::paper
::perade::parade
::parrakeets::parakeets
::paralel::parallel
::paralell::parallel
::parralel::parallel
::parrallel::parallel
::parrallell::parallel
::paralelly::parallelly
::paralely::parallelly
::parallely::parallelly
::parrallelly::parallelly
::parrallely::parallelly
::parellels::parallels
::paraphenalia::paraphernalia
::paranthesis::parenthesis
::parliment::parliament
::paliamentarian::parliamentarian
::partof::part of
::partialy::partially
::parituclar::particular
::particualr::particular
::paticular::particular
::particuarly::particularly
::particularily::particularly
::particulary::particularly
::pary::party
::pased::passed
::pasengers::passengers
::passerbys::passersby
::pasttime::pastime
::pastural::pastoral
::pattented::patented
::paitience::patience
::pavillion::pavilion
::paymetn::payment
::paymetns::payments
::peacefuland::peaceful and
::peculure::peculiar
::pedestrain::pedestrian
::perjorative::pejorative
::peloponnes::Peloponnesus
::peleton::peloton
::penatly::penalty
::penerator::penetrator
::penisula::peninsula
::penninsula::peninsula
::pennisula::peninsula
::pensinula::peninsula
::penisular::peninsular
::penninsular::peninsular
::peolpe::people
::peopel::people
::poeple::people
::poeoples::peoples
::percieve::perceive
::percepted::perceived
::percieved::perceived
::percentof::percent of
::percentto::percent to
::precentage::percentage
::perenially::perennially
::performence::performance
::perfomers::performers
::performes::performs
::perhasp::perhaps
::perheaps::perhaps
::perhpas::perhaps
::perphas::perhaps
::preiod::period
::preriod::period
::peripathetic::peripatetic
::perjery::perjury
::permanant::permanent
::permenant::permanent
::perminent::permanent
::permenantly::permanently
::permissable::permissible
::premission::permission
::perpindicular::perpendicular
::perseverence::perseverance
::persistance::persistence
::peristent::persistent
::persistant::persistent
::peronal::personal
::perosnality::personality
::personalyl::personally
::personell::personnel
::personnell::personnel
::prespective::perspective
::pursuade::persuade
::persuded::persuaded
::pursuaded::persuaded
::pursuades::persuades
::pususading::persuading
::pertubation::perturbation
::pertubations::perturbations
::preverse::perverse
::pessiary::pessary
::petetion::petition
::pharoah::Pharaoh
::phenonmena::phenomena
::phenomenonal::phenomenal
::phenomenonly::phenomenally
::phenomenom::phenomenon
::phenomonenon::phenomenon
::phenomonon::phenomenon
::feromone::pheromone
::phillipine::Philippine
::philipines::Philippines
::phillipines::Philippines
::phillippines::Philippines
::philisopher::philosopher
::philospher::philosopher
::philisophical::philosophical
::phylosophical::philosophical
::phillosophically::philosophically
::philosphies::philosophies
::philisophy::philosophy
::philosphy::philosophy
::phonecian::Phoenecian
::pheonix::phoenix ; Not forcing caps, as it could be the bird
::fonetic::phonetic
::phongraph::phonograph
::physicaly::physically
::pciture::picture
::peice::piece
::peices::pieces
::pilgrimmage::pilgrimage
::pilgrimmages::pilgrimages
::pinapple::pineapple
::pinnaple::pineapple
::pinoneered::pioneered
::pich::pitch
::palce::place
::plagarism::plagiarism
::plantiff::plaintiff
::planed::planned
::planation::plantation
::plateu::plateau
::plausable::plausible
::playright::playwright
::playwrite::playwright
::playwrites::playwrights
::pleasent::pleasant
::plesant::pleasant
::plebicite::plebiscite
::peom::poem
::peoms::poems
::peotry::poetry
::poety::poetry
::poisin::poison
::posion::poison
::polical::political
::poltical::political
::politican::politician
::politicans::politicians
::polinator::pollinator
::polinators::pollinators
::polute::pollute
::poluted::polluted
::polutes::pollutes
::poluting::polluting
::polution::pollution
::polyphonyic::polyphonic
::polysaccaride::polysaccharide
::polysaccharid::polysaccharide
::pomegranite::pomegranate
::populare::popular
::popularaty::popularity
::popoulation::population
::poulations::populations
::portayed::portrayed
::potrayed::portrayed
::protrayed::portrayed
::portraing::portraying
::portugese::Portuguese
::portuguease::portuguese
::possition::position
::postion::position
::postition::position
::psoition::position
::postive::positive
::posess::possess
::posessed::possessed
::posesses::possesses
::posseses::possesses
::possessess::possesses
::posessing::possessing
::possesing::possessing
::posession::possession
::possesion::possession
::posessions::possessions
::possiblility::possibility
::possiblilty::possibility
::possable::possible
::possibile::possible
::possably::possibly
::posthomous::posthumous
::potatoe::potato
::potatos::potatoes
::potentialy::potentially
::postdam::Potsdam
::pwoer::power
::poverful::powerful
::poweful::powerful
::powerfull::powerful
::practial::practical
::practially::practically
::practicaly::practically
::practicly::practically
::pratice::practice
::practicioner::practitioner
::practioner::practitioner
::practicioners::practitioners
::practioners::practitioners
::prairy::prairie
::prarie::prairie
::praries::prairies
::pre-Colombian::pre-Columbian
::preample::preamble
::preceed::precede
::preceeded::preceded
::preceeds::precedes
::preceeding::preceding
::precice::precise
::precisly::precisely
::precurser::precursor
::precedessor::predecessor
::predecesors::predecessors
::predicatble::predictable
::predicitons::predictions
::predomiantly::predominately
::preminence::preeminence
::preferrably::preferably
::prefernece::preference
::preferneces::preferences
::prefered::preferred
::prefering::preferring
::pregancies::pregnancies
::pregnent::pregnant
::premeire::premiere
::premeired::premiered
::premillenial::premillennial
::premonasterians::Premonstratensians
::preocupation::preoccupation
::prepartion::preparation
::preperation::preparation
::preperations::preparations
::prepatory::preparatory
::prepair::prepare
::perogative::prerogative
::presance::presence
::presense::presence
::presedential::presidential
::presidenital::presidential
::presidental::presidential
::presitgious::prestigious
::prestigeous::prestigious
::prestigous::prestigious
::presumabely::presumably
::presumibly::presumably
::prevelant::prevalent
::previvous::previous
::priestood::priesthood
::primarly::primarily
::primative::primitive
::primatively::primitively
::primatives::primitives
::primordal::primordial
::pricipal::principal
::priciple::principle
::privte::private
::privelege::privilege
::privelige::privilege
::privilage::privilege
::priviledge::privilege
::privledge::privilege
::priveleged::privileged
::priveliged::privileged
::priveleges::privileges
::priveliges::privileges
::privelleges::privileges
::priviledges::privileges
::protem::pro tem
::probablistic::probabilistic
::probabilaty::probability
::probalibity::probability
::probablly::probably
::probaly::probably
::porblem::problem
::probelm::problem
::porblems::problems
::probelms::problems
::procedger::procedure
::proceedure::procedure
::procede::proceed
::proceded::proceeded
::proceding::proceeding
::procedings::proceedings
::procedes::proceeds
::proccess::process
::proces::process
::proccessing::processing
::processer::processor
::proclamed::proclaimed
::proclaming::proclaiming
::proclaimation::proclamation
::proclomation::proclamation
::proffesed::professed
::profesion::profession
::proffesion::profession
::proffesional::professional
::profesor::professor
::professer::professor
::proffesor::professor
::programable::programmable
::ptogress::progress
::progessed::progressed
::prohabition::prohibition
::prologomena::prolegomena
::preliferation::proliferation
::profilic::prolific
::prominance::prominence
::prominant::prominent
::prominantly::prominently
::promiscous::promiscuous
::promotted::promoted
::pomotion::promotion
::propmted::prompted
::pronomial::pronominal
::pronouced::pronounced
::pronounched::pronounced
::prouncements::pronouncements
::pronounciation::pronunciation
::propoganda::propaganda
::propogate::propagate
::propogates::propagates
::propogation::propagation
::propper::proper
::propperly::properly
::prophacy::prophecy
::poportional::proportional
::propotions::proportions
::propostion::proposition
::propietary::proprietary
::proprietory::proprietary
::proseletyzing::proselytizing
::protaganist::protagonist
::protoganist::protagonist
::protaganists::protagonists
::pretection::protection
::protien::protein
::protocal::protocol
::protruberance::protuberance
::protruberances::protuberances
::proove::prove
::prooved::proved
::porvide::provide
::provded::provided
::provicial::provincial
::provinicial::provincial
::provisonal::provisional
::provacative::provocative
::proximty::proximity
::psuedo::pseudo
::pseudonyn::pseudonym
::pseudononymous::pseudonymous
::psyhic::psychic
::pyscic::psychic
::psycology::psychology
::publically::publicly
::publicaly::publicly
::pucini::Puccini
::puertorrican::Puerto Rican
::puertorricans::Puerto Ricans
::pumkin::pumpkin
::puchasing::purchasing
::puritannical::puritanical
::purpotedly::purportedly
::purposedly::purposely
::persue::pursue
::persued::pursued
::persuing::pursuing
::persuit::pursuit
::persuits::pursuits
::puting::putting
::quantaty::quantity
::quantitiy::quantity
::quarantaine::quarantine
::quater::quarter
::quaters::quarters
::quesion::question
::questoin::question
::quetion::question
::questonable::questionable
::questionnair::questionnaire
::quesions::questions
::questioms::questions
::questiosn::questions
::quetions::questions
::quicklyu::quickly
::quinessential::quintessential
::quitted::quit
::quizes::quizzes
::rabinnical::rabbinical
::radiactive::radioactive
::rancourous::rancorous
::repid::rapid
::rarified::rarefied
::rasberry::raspberry
::ratehr::rather
::radify::ratify
::racaus::raucous
::reched::reached
::reacing::reaching
::readmition::readmission
::rela::real
::relized::realised
::realsitic::realistic
::erally::really
::raelly::really
::realy::really
::realyl::really
::relaly::really
::rebllions::rebellions
::rebounce::rebound
::rebiulding::rebuilding
::reacll::recall
::receeded::receded
::receeding::receding
::receieve::receive
::receivedfrom::received from
::receving::receiving
::rechargable::rechargeable
::recipiant::recipient
::reciepents::recipients
::recipiants::recipients
::recogise::recognise
::recogize::recognize
::reconize::recognize
::reconized::recognized
::reccommend::recommend
::recomend::recommend
::reommend::recommend
::recomendation::recommendation
::recomendations::recommendations
::recommedations::recommendations
::reccommended::recommended
::recomended::recommended
::reccommending::recommending
::recomending::recommending
::recomends::recommends
::reconcilation::reconciliation
::reconaissance::reconnaissance
::reconnaissence::reconnaissance
::recontructed::reconstructed
::recrod::record
::rocord::record
::recordproducer::record producer
::recrational::recreational
::recuiting::recruiting
::rucuperate::recuperate
::recurrance::recurrence
::reoccurrence::recurrence
::reaccurring::recurring
::reccuring::recurring
::recuring::recurring
::recyling::recycling
::reedeming::redeeming
::relected::reelected
::revaluated::reevaluated
::referrence::reference
::refference::reference
::refrence::reference
::refernces::references
::refrences::references
::refedendum::referendum
::referal::referral
::refered::referred
::reffered::referred
::referiang::referring
::refering::referring
::referrs::refers
::refrers::refers
::refect::reflect
::refromist::reformist
::refridgeration::refrigeration
::refridgerator::refrigerator
::refusla::refusal
::irregardless::regardless
::regardes::regards
::regluar::regular
::reguarly::regularly
::regularily::regularly
::regulaion::regulation
::regulaotrs::regulators
::rehersal::rehearsal
::reigining::reigning
::reicarnation::reincarnation
::reenforced::reinforced
::realtions::relations
::relatiopnship::relationship
::realitvely::relatively
::relativly::relatively
::relitavely::relatively
::releses::releases
::relevence::relevance
::relevent::relevant
::relient::reliant
::releive::relieve
::releived::relieved
::releiver::reliever
::religeous::religious
::religous::religious
::religously::religiously
::relinqushment::relinquishment
::reluctent::reluctant
::remaing::remaining
::remeber::remember
::rememberance::remembrance
::remembrence::remembrance
::remenicent::reminiscent
::reminescent::reminiscent
::reminscent::reminiscent
::reminsicent::reminiscent
::remenant::remnant
::reminent::remnant
::renedered::rende
::rendevous::rendezvous
::rendezous::rendezvous
::renewl::renewal
::reknown::renown
::reknowned::renowned
::rentors::renters
::reorganision::reorganisation
::repeteadly::repeatedly
::repentence::repentance
::repentent::repentant
::reprtoire::repertoire
::repetion::repetition
::reptition::repetition
::relpacement::replacement
::reportadly::reportedly
::represnt::represent
::represantative::representative
::representive::representative
::representativs::representatives
::representives::representatives
::represetned::represented
::reproducable::reproducible
::requred::required
::reasearch::research
::reserach::research
::resembelance::resemblance
::resemblence::resemblance
::ressemblance::resemblance
::ressemblence::resemblance
::ressemble::resemble
::ressembled::resembled
::resembes::resembles
::ressembling::resembling
::resevoir::reservoir
::recide::reside
::recided::resided
::recident::resident
::recidents::residents
::reciding::residing
::resignement::resignment
::resistence::resistance
::resistent::resistant
::resistable::resistible
::resollution::resolution
::resorces::resources
::repsectively::respectively
::respectivly::respectively
::respomse::response
::responce::response
::responibilities::responsibilities
::responsability::responsibility
::responisble::responsible
::responsable::responsible
::responsibile::responsible
::resaurant::restaurant
::restaraunt::restaurant
::restauraunt::restaurant
::resteraunt::restaurant
::restuarant::restaurant
::resturant::restaurant
::resturaunt::restaurant
::restaraunts::restaurants
::resteraunts::restaurants
::restaraunteur::restaurateur
::restaraunteurs::restaurateurs
::restauranteurs::restaurateurs
::restauration::restoration
::resticted::restricted
::reult::result
::resurgance::resurgence
::resssurecting::resurrecting
::resurecting::resurrecting
::ressurrection::resurrection
::retalitated::retaliated
::retalitation::retaliation
::retreive::retrieve
::returnd::returned
::reveral::reversal
::reversable::reversible
::reveiw::review
::reveiwing::reviewing
::revolutionar::revolutionary
::rewriet::rewrite
::rewitten::rewritten
::rhymme::rhyme
::rhythem::rhythm
::rhythim::rhythm
::rythem::rhythm
::rythim::rhythm
::rythm::rhythm
::rhytmic::rhythmic
::rythmic::rhythmic
::rythyms::rhythms
::rediculous::ridiculous
::rigourous::rigorous
::rigeur::rigueur
::rininging::ringing
::rockerfeller::Rockefeller
::rococco::rococo
::roomate::roommate
::rised::rose
::rougly::roughly
::rudimentatry::rudimentary
::rulle::rule
::rumers::rumors
::runing::running
::runnung::running
::russina::Russian
::russion::Russian
::sacrafice::sacrifice
::sacrifical::sacrificial
::sacreligious::sacrilegious
::sandess::sadness
::saftey::safety
::safty::safety
::saidhe::said he
::saidit::said it
::saidthat::said that
::saidt he::said the
::saidthe::said the
::salery::salary
::smae::same
::santioned::sanctioned
::sanctionning::sanctioning
::sandwhich::sandwich
::sanhedrim::Sanhedrin
::satelite::satellite
::sattelite::satellite
::satelites::satellites
::sattelites::satellites
::satric::satiric
::satrical::satirical
::satrically::satirically
::satisfactority::satisfactorily
::saterday::Saturday
::saterdays::Saturdays
::svae::save
::svaes::saves
::saxaphone::saxophone
::sasy::says
::syas::says
::scaleable::scalable
::scandanavia::Scandinavia
::scaricity::scarcity
::scavanged::scavenged
::senarios::scenarios
::scedule::schedule
::schedual::schedule
::sceduled::scheduled
::scholarhip::scholarship
::scholarstic::scholastic
::shcool::school
::scince::science
::scinece::science
::scientfic::scientific
::scientifc::scientific
::screenwrighter::screenwriter
::scirpt::script
::scoll::scroll
::scrutinity::scrutiny
::scuptures::sculptures
::seach::search
::seached::searched
::seaches::searches
::secratary::secretary
::secretery::secretary
::sectino::section
::seing::seeing
::segementation::segmentation
::seguoys::segues
::sieze::seize
::siezed::seized
::siezing::seizing
::siezure::seizure
::siezures::seizures
::seldomly::seldom
::selectoin::selection
::seinor::senior
::sence::sense
::senstive::sensitive
::sentance::sentence
::separeate::separate
::sepulchure::sepulchre
::sargant::sergeant
::sargeant::sergeant
::sergent::sergeant
::settelement::settlement
::settlment::settlement
::severeal::several
::severley::severely
::severly::severely
::shaddow::shadow
::seh::she
::shesaid::she said
::sherif::sheriff
::sheild::shield
::shineing::shining
::shiped::shipped
::shiping::shipping
::shopkeeepers::shopkeepers
::shortwhile::short while
::shorly::shortly
::shoudl::should
::should of::should have
::shoudln't::shouldn't
::shouldent::shouldn't
::shouldnt::shouldn't
::sohw::show
::showinf::showing
::shreak::shriek
::shrinked::shrunk
::sedereal::sidereal
::sideral::sidereal
::seige::siege
::signitories::signatories
::signitory::signatory
::siginificant::significant
::signficant::significant
::signficiant::significant
::signifacnt::significant
::signifigant::significant
::signifantly::significantly
::significently::significantly
::signifigantly::significantly
::signfies::signifies
::silicone chip::silicon chip
::simalar::similar
::similiar::similar
::simmilar::similar
::similiarity::similarity
::similarily::similarly
::similiarly::similarly
::simplier::simpler
::simpley::simply
::simpyl::simply
::simultanous::simultaneous
::simultanously::simultaneously
::sicne::since
::sincerley::sincerely
::sincerly::sincerely
::singsog::singsong
::sixtin::Sistine
::skagerak::Skagerrak
::skateing::skating
::slaugterhouses::slaughterhouses
::slowy::slowly
::smoothe::smooth
::smoothes::smooths
::sneeks::sneaks
::snese::sneeze
::sot hat::so that
::soical::social
::socalism::socialism
::socities::societies
::sofware::software
::soilders::soldiers
::soliders::soldiers
::soley::solely
::soliliquy::soliloquy
::solatary::solitary
::soluable::soluble
::soem::some
::somene::someone
::somethign::something
::someting::something
::somthing::something
::somtimes::sometimes
::somewaht::somewhat
::somwhere::somewhere
::sophicated::sophisticated
::suphisticated::sophisticated
::sophmore::sophomore
::sorceror::sorcerer
::saught::sought
::seeked::sought
::soudn::sound
::soudns::sounds
::sountrack::soundtrack
::suop::soup
::sourth::south
::sourthern::southern
::souvenier::souvenir
::souveniers::souvenirs
::soverign::sovereign
::sovereignity::sovereignty
::soverignity::sovereignty
::soverignty::sovereignty
::soveits::soviets
::soveits::soviets(x
::spoace::space
::spainish::Spanish
::speciallized::specialised
::speices::species
::specfic::specific
::specificaly::specifically
::specificalyl::specifically
::specifiying::specifying
::speciman::specimen
::spectauclar::spectacular
::spectaulars::spectaculars
::spectum::spectrum
::speach::speech
::sprech::speech
::sppeches::speeches
::spermatozoan::spermatozoon
::spriritual::spiritual
::spritual::spiritual
::spendour::splendour
::sponser::sponsor
::sponsered::sponsored
::sponzored::sponsored
::spontanous::spontaneous
::spoonfulls::spoonfuls
::sportscar::sports car
::spreaded::spread
::spred::spread
::sqaure::square
::stablility::stability
::stainlees::stainless
::stnad::stand
::standars::standards
::strat::start
::statment::statement
::statememts::statements
::statments::statements
::stateman::statesman
::staion::station
::sterotypes::stereotypes
::steriods::steroids
::sitll::still
::stiring::stirring
::stirrs::stirs
::stpo::stop
::storeis::stories
::storise::stories
::sotry::story
::stopry::story
::stoyr::story
::stroy::story
::strnad::strand
::stange::strange
::startegic::strategic
::stratagically::strategically
::startegies::strategies
::stradegies::strategies
::startegy::strategy
::stradegy::strategy
::streemlining::streamlining
::stregth::strength
::strenght::strength
::strentgh::strength
::strenghen::strengthen
::strenghten::strengthen
::strenghened::strengthened
::strenghtened::strengthened
::strengtened::strengthened
::strenghening::strengthening
::strenghtening::strengthening
::strenous::strenuous
::strictist::strictest
::strikely::strikingly
::stingent::stringent
::stong::strong
::stornegst::strongest
::stucture::structure
::sturcture::structure
::stuctured::structured
::struggel::struggle
::strugle::struggle
::stuggling::struggling
::stubborness::stubbornness
::studnet::student
::studdy::study
::studing::studying
::stlye::style
::sytle::style
::stilus::stylus
::subconsiously::subconsciously
::subjudgation::subjugation
::submachne::submachine
::sepina::subpoena
::subsquent::subsequent
::subsquently::subsequently
::subsidary::subsidiary
::subsiduary::subsidiary
::subpecies::subspecies
::substace::substance
::subtances::substances
::substancial::substantial
::substatial::substantial
::substituded::substituted
::subterranian::subterranean
::substract::subtract
::substracted::subtracted
::substracting::subtracting
::substraction::subtraction
::substracts::subtracts
::suburburban::suburban
::suceed::succeed
::succceeded::succeeded
::succedded::succeeded
::succeded::succeeded
::suceeded::succeeded
::suceeding::succeeding
::succeds::succeeds
::suceeds::succeeds
::succsess::success
::sucess::success
::succcesses::successes
::sucesses::successes
::succesful::successful
::successfull::successful
::succsessfull::successful
::sucesful::successful
::sucessful::successful
::sucessfull::successful
::succesfully::successfully
::succesfuly::successfully
::successfuly::successfully
::successfulyl::successfully
::successully::successfully
::sucesfully::successfully
::sucesfuly::successfully
::sucessfully::successfully
::sucessfuly::successfully
::succesion::succession
::sucesion::succession
::sucession::succession
::succesive::successive
::sucessive::successive
::sucessor::successor
::sucessot::successor
::sufferred::suffered
::sufferring::suffering
::suffcient::sufficient
::sufficent::sufficient
::sufficiant::sufficient
::suffciently::sufficiently
::sufficently::sufficiently
::sufferage::suffrage
::suggestable::suggestible
::sucidial::suicidal
::sucide::suicide
::sumary::summary
::sunglases::sunglasses
::superintendant::superintendent
::surplanted::supplanted
::suplimented::supplemented
::supplamented::supplemented
::suppliementing::supplementing
::suppy::supply
::wupport::support
::supose::suppose
::suposed::supposed
::suppoed::supposed
::suppossed::supposed
::suposedly::supposedly
::supposingly::supposedly
::suposes::supposes
::suposing::supposing
::supress::suppress
::surpress::suppress
::supressed::suppressed
::surpressed::suppressed
::supresses::suppresses
::supressing::suppressing
::surley::surely
::surfce::surface
::suprise::surprise
::suprize::surprise
::surprize::surprise
::suprised::surprised
::suprized::surprised
::surprized::surprised
::suprising::surprising
::suprizing::surprising
::surprizing::surprising
::suprisingly::surprisingly
::suprizingly::surprisingly
::surprizingly::surprisingly
::surrended::surrendered
::surrundering::surrendering
::surrepetitious::surreptitious
::surreptious::surreptitious
::surrepetitiously::surreptitiously
::surreptiously::surreptitiously
::suround::surround
::surounded::surrounded
::surronded::surrounded
::surrouded::surrounded
::sorrounding::surrounding
::surounding::surrounding
::surrouding::surrounding
::suroundings::surroundings
::surounds::surrounds
::surveill::surveil
::surveilence::surveillance
::surveyer::surveyor
::survivied::survived
::surviver::survivor
::survivers::survivors
::suseptable::susceptible
::suseptible::susceptible
::suspention::suspension
::swaer::swear
::swaers::swears
::swepth::swept
::swiming::swimming
::symettric::symmetric
::symmetral::symmetric
::symetrical::symmetrical
::symetrically::symmetrically
::symmetricaly::symmetrically
::symetry::symmetry
::synphony::symphony
::sypmtoms::symptoms
::synagouge::synagogue
::syncronization::synchronization
::synonomous::synonymous
::synonymns::synonyms
::syphyllis::syphilis
::syrap::syrup
::sytem::system
::sysmatically::systematically
::tkae::take
::tkaes::takes
::tkaing::taking
::talekd::talked
::talkign::talking
::tlaking::talking
::targetted::targeted
::targetting::targeting
::tast::taste
::tatoo::tattoo
::tattooes::tattoos
::teached::taught
::taxanomic::taxonomic
::taxanomy::taxonomy
::tecnical::technical
::techician::technician
::technitian::technician
::techicians::technicians
::techiniques::techniques
::technnology::technology
::technolgy::technology
::telphony::telephony
::televize::televise
::telelevision::television
::televsion::television
::tellt he::tell the
::temperment::temperament
::tempermental::temperamental
::temparate::temperate
::temerature::temperature
::tempertaure::temperature
::temperture::temperature
::temperarily::temporarily
::tepmorarily::temporarily
::temprary::temporary
::tendancies::tendencies
::tendacy::tendency
::tendancy::tendency
::tendonitis::tendinitis
::tennisplayer::tennis player
::tenacle::tentacle
::tenacles::tentacles
::terrestial::terrestrial
::terriories::territories
::terriory::territory
::territoy::territory
::territorist::terrorist
::terroist::terrorist
::testiclular::testicular
::tahn::than
::thna::than
::thansk::thanks
::taht::that
::tath::that
::thgat::that
::thta::that
::thyat::that
::tyhat::that
::thatt he::that the
::thatthe::that the
::thast::that's
::thats::that's
::hte::the
::teh::the
::tehw::the
::tghe::the
::theh::the
::thge::the
::thw::the
::tje::the
::tjhe::the
::tthe::the
::tyhe::the
::thecompany::the company
::thefirst::the first
::thegovernment::the government
::thenew::the new
::thesame::the same
::thetwo::the two
::theather::theatre
::theri::their
::thier::their
::there's is::theirs is
::htem::them
::themself::themselves
::themselfs::themselves
::themslves::themselves
::hten::then
::thn::then
::thne::then
::htere::there
::their are::there are
::they're are::there are
::their is::there is
::they're is::there is
::therafter::thereafter
::therby::thereby
::htese::these
::theese::these
::htey::they
::tehy::they
::tyhe::they
::they;l::they'll
::theyll::they'll
::they;r::they're
::they;v::they've
::theyve::they've
::theif::thief
::theives::thieves
::hting::thing
::thign::thing
::thnig::thing
::thigns::things
::thigsn::things
::thnigs::things
::htikn::think
::htink::think
::thikn::think
::thiunk::think
::tihkn::think
::thikning::thinking
::thikns::thinks
::thrid::third
::htis::this
::tghis::this
::thsi::this
::tihs::this
::thisyear::this year
::throrough::thorough
::throughly::thoroughly
::thsoe::those
::threatend::threatened
::threatning::threatening
::threee::three
::threshhold::threshold
::throuhg::through
::thru::through
::thoughout::throughout
::througout::throughout
::tiget::tiger
::tiem::time
::timne::time
::tot he::to the
::tothe::to the
::tabacco::tobacco
::tobbaco::tobacco
::todya::today
::todays::today's
::tiogether::together
::togehter::together
::toghether::together
::toldt he::told the
::tolerence::tolerance
::tolkein::Tolkien
::tomatos::tomatoes
::tommorow::tomorrow
::tommorrow::tomorrow
::tomorow::tomorrow
::tounge::tongue
::tongiht::tonight
::tonihgt::tonight
::tormenters::tormentors
::toriodal::toroidal
::torpeados::torpedoes
::torpedos::torpedoes
::totaly::totally
::totalyl::totally
::towrad::toward
::towords::towards
::twon::town
::traditition::tradition
::traditionnal::traditional
::tradionally::traditionally
::traditionaly::traditionally
::traditionalyl::traditionally
::tradtionally::traditionally
::trafic::traffic
::trafficed::trafficked
::trafficing::trafficking
::transcendance::transcendence
::trancendent::transcendent
::transcendant::transcendent
::transcendentational::transcendental
::trancending::transcending
::transending::transcending
::transcripting::transcribing
::transfered::transferred
::transfering::transferring
::tranform::transform
::transformaton::transformation
::tranformed::transformed
::transistion::transition
::translater::translator
::translaters::translators
::transmissable::transmissible
::transporation::transportation
::transesxuals::transsexuals
::tremelo::tremolo
::tremelos::tremolos
::triathalon::triathlon
::tryed::tried
::triguered::triggered
::triology::trilogy
::troling::trolling
::toubles::troubles
::troup::troupe
::truely::truly
::truley::truly
::turnk::trunk
::tust::trust
::trustworthyness::trustworthiness
::tuscon::Tucson
::termoil::turmoil
::twpo::two
::typcial::typical
::typicaly::typically
::tyranies::tyrannies
::tyrranies::tyrannies
::tyrany::tyranny
::tyrrany::tyranny
::ubiquitious::ubiquitous
::ukranian::Ukrainian
::ukelele::ukulele
::alterior::ulterior
::ultimely::ultimately
::unacompanied::unaccompanied
::unanymous::unanimous
::unathorised::unauthorised
::unavailible::unavailable
::unballance::unbalance
::unbeleivable::unbelievable
::uncertainity::uncertainty
::unchallengable::unchallengeable
::unchangable::unchangeable
::uncompetive::uncompetitive
::unconcious::unconscious
::unconciousness::unconsciousness
::uncontitutional::unconstitutional
::unconvential::unconventional
::undecideable::undecidable
::indefineable::undefinable
::undert he::under the
::undreground::underground
::udnerstand::understand
::understnad::understand
::understoon::understood
::undesireable::undesirable
::undetecable::undetectable
::undoubtely::undoubtedly
::unforgetable::unforgettable
::unforgiveable::unforgivable
::unforetunately::unfortunately
::unfortunatley::unfortunately
::unfortunatly::unfortunately
::unfourtunately::unfortunately
::unahppy::unhappy
::unilatreal::unilateral
::unilateraly::unilaterally
::unilatreally::unilaterally
::unihabited::uninhabited
::uninterruped::uninterrupted
::uninterupted::uninterrupted
::unitedstates::United States
::unitesstates::United States
::univeral::universal
::univeristies::universities
::univesities::universities
::univeristy::university
::universtiy::university
::univesity::university
::unviersity::university
::unkown::unknown
::unliek::unlike
::unlikey::unlikely
::unmanouverable::unmanoeuvrable
::unmistakeably::unmistakably
::unneccesarily::unnecessarily
::unneccessarily::unnecessarily
::unnecesarily::unnecessarily
::uneccesary::unnecessary
::unecessary::unnecessary
::unneccesary::unnecessary
::unneccessary::unnecessary
::unnecesary::unnecessary
::unoticeable::unnoticeable
::inofficial::unofficial
::unoffical::unofficial
::unplesant::unpleasant
::unpleasently::unpleasantly
::unprecendented::unprecedented
::unprecidented::unprecedented
::unrepentent::unrepentant
::unrepetant::unrepentant
::unrepetent::unrepentant
::unsubstanciated::unsubstantiated
::unsuccesful::unsuccessful
::unsuccessfull::unsuccessful
::unsucesful::unsuccessful
::unsucessful::unsuccessful
::unsucessfull::unsuccessful
::unsuccesfully::unsuccessfully
::unsucesfuly::unsuccessfully
::unsucessfully::unsuccessfully
::unsuprised::unsurprised
::unsuprized::unsurprised
::unsurprized::unsurprised
::unsuprising::unsurprising
::unsuprizing::unsurprising
::unsurprizing::unsurprising
::unsuprisingly::unsurprisingly
::unsuprizingly::unsurprisingly
::unsurprizingly::unsurprisingly
::untill::until
::untranslateable::untranslatable
::unuseable::unusable
::unusuable::unusable
::unwarrented::unwarranted
::unweildly::unwieldy
::unwieldly::unwieldy
::tjpanishad::upanishad
::upcomming::upcoming
::upgradded::upgraded
::useage::usage
::uise::use
::usefull::useful
::usefuly::usefully
::useing::using
::usally::usually
::usualy::usually
::usualyl::usually
::ususally::usually
::vaccum::vacuum
::vaccume::vacuum
::vaguaries::vagaries
::vailidty::validity
::valetta::valletta
::valuble::valuable
::valueable::valuable
::varient::variant
::varations::variations
::vaieties::varieties
::varities::varieties
::variey::variety
::varity::variety
::vreity::variety
::vriety::variety
::varous::various
::varing::varying
::vasall::vassal
::vasalls::vassals
::vegitable::vegetable
::vegtable::vegetable
::vegitables::vegetables
::vegatarian::vegetarian
::vehicule::vehicle
::vengance::vengeance
::vengence::vengeance
::venemous::venomous
::verfication::verification
::vermillion::vermilion
::versitilaty::versatility
::versitlity::versatility
::verison::version
::verisons::versions
::veyr::very
::vrey::very
::vyer::very
::vyre::very
::vacinity::vicinity
::vincinity::vicinity
::vitories::victories
::wiew::view
::vigilence::vigilance
::vigourous::vigorous
::villification::vilification
::villify::vilify
::villian::villain
::violentce::violence
::virgina::Virginia
::virutal::virtual
::virtualyl::virtually
::visable::visible
::visably::visibly
::visting::visiting
::vistors::visitors
::volcanoe::volcano
::volkswagon::Volkswagen
::voleyball::volleyball
::volontary::voluntary
::volonteer::volunteer
::volounteer::volunteer
::volonteered::volunteered
::volounteered::volunteered
::volonteering::volunteering
::volounteering::volunteering
::volonteers::volunteers
::volounteers::volunteers
::vulnerablility::vulnerability
::vulnerible::vulnerable
::watn::want
::whant::want
::wnat::want
::wan tit::want it
::wanna::want to
::wnated::wanted
::whants::wants
::wnats::wants
::wardobe::wardrobe
::warrent::warrant
::warantee::warranty
::warrriors::warriors
::wass::was
::weas::was
::ws::was
::wa snot::was not
::wasnt::wasn't
::wya::way
::wayword::wayward
::we;d::we'd
::weaponary::weaponry
::wether::weather
::wendsay::Wednesday
::wensday::Wednesday
::wiegh::weigh
::wierd::weird
::vell::well
::werre::were
::wern't::weren't
::waht::what
::whta::what
::what;s::what's
::wehn::when
::whn::when
::whent he::when the
::wehre::where
::wherre::where
::where;s::where's
::wereabouts::whereabouts
::wheras::whereas
::wherease::whereas
::whereever::wherever
::whther::whether
::hwich::which
::hwihc::which
::whcih::which
::whic::which
::whihc::which
::whlch::which
::wihch::which
::whicht he::which the
::hwile::while
::woh::who
::who;s::who's
::hwole::whole
::wohle::whole
::wholey::wholly
::widesread::widespread
::weilded::wielded
::wief::wife
::iwll::will
::wille::will
::wiull::will
::willbe::will be
::will of::will have
::willingless::willingness
::windoes::windows
::wintery::wintry
::iwth::with
::whith::with
::wih::with
::wiht::with
::withe::with
::witht::with
::witn::with
::wtih::with
::witha::with a
::witht he::with the
::withthe::with the
::withdrawl::withdrawal
::witheld::withheld
::withold::withhold
::withing::within
::womens::women's
::wo'nt::won't
::wonderfull::wonderful
::wrod::word
::owrk::work
::wokr::work
::wrok::work
::wokring::working
::wroking::working
::workststion::workstation
::worls::world
::worstened::worsened
::owudl::would
::owuld::would
::woudl::would
::wuould::would
::wouldbe::would be
::would of::would have
::woudln't::wouldn't
::wouldnt::wouldn't
::wresters::wrestlers
::rwite::write
::wriet::write
::wirting::writing
::writting::writing
::writen::written
::wroet::wrote
::x-Box::Xbox
::xenophoby::xenophobia
::yatch::yacht
::yaching::yachting
::eyar::year
::yera::year
::eyars::years
::yeasr::years
::yeras::years
::yersa::years
::yelow::yellow
::eyt::yet
::yeild::yield
::yeilding::yielding
::yoiu::you
::ytou::you
::yuo::you
::youare::you are
::you;d::you'd
::your a::you're a
::your an::you're an
::your her::you're her
::your here::you're here
::your his::you're his
::your my::you're my
::your the::you're the
::your their::you're their
::your your::you're your
::youve::you've
::yoru::your
::yuor::your
::you're own::your own
::youself::yourself
::youseff::yousef
::zeebra::zebra
::sionist::Zionist
::sionists::Zionists

;------------------------------------------------------------------------------
; Ambiguous entries.  Where desired, pick the one that's best for you, edit,
; and move into the above list or, preferably, the autocorrect user file.
;------------------------------------------------------------------------------
/*
:*:cooperat::coöperat
::(c)::©
::(r)::®
::(tm)::™
::a gogo::à gogo
::abbe::abbé
::accension::accession, ascension
::achive::achieve, archive
::achived::achieved, archived
::ackward::awkward, backward
::addres::address, adders
::adress::address, A dress
::adressing::addressing, dressing
::afair::affair, afar, Afar (African place), a fair, acronym "as far as I recall"
::affort::afford, effort
::agin::again, a gin, aging
::agina::again, angina
::ago-go::àgo-go
::aledge::allege, a ledge
::alot::a lot, allot
::alusion::allusion, illusion
::amature::armature, amateur
::anu::añu
::anual::annual, anal
::anual::annual, manual
::aparent::apparent, a parent
::apon::upon, apron
::appealling::appealing, appalling
::archaoelogy::archeology, archaeology
::archaology::archeology, archaeology
::archeaologist::archeologist, archaeologist
::archeaologists::archeologists, archaeologists
::assosication::assassination, association
::attaindre::attainder, attained
::attened::attended or attend
::baout::about, bout
::beggin::begin, begging
::behavour::behavior, behaviour
::belives::believes, beliefs
::boaut::bout, boat, about
::Bon::Bön

::assasined::assassinated Broken by ":*:assasin::", but no great loss.
::Bootes::Boötes
::bric-a-brac::bric-à-brac
::buring::burying, burning, burin, during
::busineses::business, businesses
::cafe::café
::calaber::caliber, calibre
::calander::calendar, calender, colander
::cancelled::canceled  ; commonwealth vs US
::cancelling::canceling  ; commonwealth vs US
::canon::cañon
::cant::cannot, can not, can't
::carcas::carcass, Caracas
::carmel::caramel, carmel-by-the-sea
::Cataline::Catiline, Catalina
::censur::censor, censure
::ceratin::certain, keratin
::cervial::cervical, servile, serval
::chasr::chaser, chase
::clera::clear, sclera
::comander::commander, commandeer
::competion::competition, completion
::continuum::continuüm
::coopt::coöpt
::coordinat::coördinat
::coorperation::cooperation, corporation
::coudl::could, cloud
::councellor::councillor, counselor, councilor
::councellors::councillors, counselors, councilors
::coururier::courier, couturier
::coverted::converted, covered, coveted
::cpoy::coy, copy
::creme::crème
::dael::deal, dial, dahl
::deram::dram, dream
::desparate::desperate, disparate
::diea::idea, die
::dieing::dying, dyeing
::diversed::diverse, diverged
::divorce::divorcé
::Dona::Doña
::doub::doubt, daub
::dyas::dryas, Dyas (Robert Dyas is a hardware chain), dais
::efford::effort, afford
::effords::efforts, affords
::eigth::eighth, eight
::electic::eclectic, electric
::electon::election, electron
::elite::élite
::emition::emission, emotion
::emminent::eminent, imminent
::empirial::empirical, imperial
::Enlish::English, enlist
::erally::orally, really
::erested::arrested, erected
::ethose::those, ethos
::etude::étude
::expose::exposé
::extint::extinct, extant
::eyar::year, eyas
::eyars::years, eyas
::eyasr::years, eyas
::fiel::feel, field, file, phial
::fiels::feels, fields, files, phials
::firts::flirts, first
::fleed::fled, freed
::fo::for, of
::fomr::from, form
::fontrier::fontier, frontier
::fro::for, to and fro, (a)fro
::futhroc::futhark, futhorc
::gae::game, Gael, gale
::gaurd::guard, gourd
::gogin::going, Gauguin
::Guaduloupe::Guadalupe, Guadeloupe
::Guadulupe::Guadalupe, Guadeloupe
::guerrila::guerilla, guerrilla
::guerrilas::guerillas, guerrillas
::haev::have, heave
::Hallowean::Hallowe'en, Halloween
::herad::heard, Hera
::housr::hours, house
::hten::then, hen, the
::htere::there, here
::humer::humor, humour
::humerous::humorous, humourous, humerus
::hvea::have, heave
::idesa::ideas, ides
::imaginery::imaginary, imagery
::imanent::eminent, imminent
::iminent::eminent, imminent, immanent
::indispensable::indispensible ; commonwealth vs US?
::indispensible::indispensable ; commonwealth vs US?
::inheritage::heritage, inheritance
::inspite::in spite, inspire
::interbread::interbreed, interbred
::intered::interred, interned
::inumerable::enumerable, innumerable
::israelies::Israelis, Israelites
::labatory::lavatory, laboratory
::labled::labelled, labeled
::lame::lamé
::leanr::lean, learn, leaner
::lible::libel, liable
::liscense::license, licence
::lisence::license, licence
::lisense::license, licence
::lonly::lonely, only
::maked::marked, made
::managable::manageable, manageably
::manoeuver::maneuver ; Commonwealth vs US?
::manouver::maneuver, manoeuvre
::manouver::manoeuvre ; Commonwealth vs US?
::manouverability::maneuverability, manoeuvrability, manoeuverability
::manouverable::maneuverable, manoeuvrable
::manouvers::maneuvers, manoeuvres
::manuever::maneuver, manoeuvre
::manuevers::maneuvers, manoeuvres
::mear::wear, mere, mare
::meranda::veranda, Miranda
::Metis::Métis
::mit::mitt, M.I.T., German "with"
::monestary::monastery, monetary
::moreso::more, more so
::muscels::mussels, muscles
::ne::né
::neice::niece, nice
::neigbour::neighbour, neighbor
::neigbouring::neighbouring, neighboring
::neigbours::neighbours, neighbors
::nto:: not ; Replaced with case sensitive for NTO acronym.
::oging::going, ogling
::ole::olé
::onot::note, not
::opium::opïum
::ore::öre
::ore::øre
::orgin::origin, organ
::palce::place, palace
::pate::pâte
::pate::pâté
::performes::performed, performs
::personel::personnel, personal
::positon::position, positron
::preëmpt
::premiere::première
::premiered::premièred
::premieres::premières
::premiering::premièring
::procede::proceed, precede
::proceded::proceeded, preceded
::procedes::proceeds, precedes
::proceding::proceeding, preceding
::profesion::profusion, profession
::progrom::pogrom, program
::progroms::pogroms, programs
::prominately::prominently, predominately
::qtuie::quite, quiet
::qutie::quite, quiet
::reenter::reënter
::relized::realised, realized
::repatition::repetition, repartition
::residuum::residuüm
::restraunt::restraint, restaurant
::resume::résumé
::rigeur::rigueur, rigour, rigor
::role::rôle
::rose::rosé
::sasy::says, sassy
::scholarstic::scholastic, scholarly
::secceeded::seceded, succeeded
::seceed::succeed, secede
::seceeded::succeeded, seceded
::sepulchure::sepulchre, sepulcher
::sepulcre::sepulchre, sepulcher
::shamen::shaman, shamans
::sheat::sheath, sheet, cheat
::shoudln::should, shouldn't
::sieze::seize, size
::siezed::seized, sized
::siezing::seizing, sizing
::sinse::sines, since
::snese::sneeze, sense
::sotyr::satyr, story
::sould::could, should, sold
::speciallized::specialised, specialized
::specif::specific, specify
::spects::aspects, expects
::strat::start, strata
::stroy::story, destroy
::surley::surly, surely
::surrended::surrounded, surrendered
::thast::that, that's
::theather::theater, theatre
::ther::there, their, the
::thikning::thinking, thickening
::throught::thought, through, throughout
::tiem::time, Tim
::tiome::time, tome
::tourch::torch, touch
::transcripting::transcribing, transcription
::travelling::traveling   ; commonwealth vs US
::troups::troupes, troops
::turnk::turnkey, trunk
::uber::über
::unmanouverable::unmaneuverable, unmanoeuvrable
::unsed::used, unused, unsaid
::vigeur::vigueur, vigour, vigor
::villin::villi, villain, villein
::vistors::visitors, vistas
::wanna::want to - often deliberate
::weild::wield, wild
::wholy::wholly, holy
::wich::which, witch
::withdrawl::withdrawal, withdraw
::woulf::would, wolf
::ws::was, www.example.ws
::Yementite::Yemenite, Yemeni
:?:oology::oölogy
:?:t he:: the  ; Can't use this. Needs to be cleverer.
*/

;-------------------------------------------------------------------------------
;  Capitalise dates
;-------------------------------------------------------------------------------
::monday::Monday
::tuesday::Tuesday
::wednesday::Wednesday
::thursday::Thursday
::friday::Friday
::saturday::Saturday
::sunday::Sunday

::january::January
::february::February
; ::march::March  ; Commented out because it matches the common word "march".
::april::April
; ::may::May  ; Commented out because it matches the common word "may".
::june::June
::july::July
::august::August
::september::September
::october::October
::november::November
::december::December


;-------------------------------------------------------------------------------
; Anything below this point was added to the script by the user via the Win+H hotkey.
;-------------------------------------------------------------------------------
