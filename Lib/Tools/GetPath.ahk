#Requires Autohotkey v2.0
#SingleInstance Force
;source: https://autohotkey.com/board/topic/60985-get-paths-of-selected-items-in-an-explorer-window/
;related post: http://www.autohotkey.com/board/topic/60723-can-autohotkey-retrieve-file-path-of-the-selected-file/page-2#entry383065

/*
	Library for getting info from a specific explorer window (if window handle not specified, the currently active
	window will be used).  Requires AHK_L or similar.  Works with the desktop.  Does not currently work with save
	dialogs and such.
	
	
	Explorer_GetSelected(hwnd="")   - paths of target window's selected items
	Explorer_GetAll(hwnd="")        - paths of all items in the target window's folder
	Explorer_GetPath(hwnd="")       - path of target window's folder
	
	example:
		F1::
			path := Explorer_GetPath()
			all := Explorer_GetAll()
			sel := Explorer_GetSelected()
			MsgBox % path
			MsgBox % all
			MsgBox % sel
		return
	
	Joshua A. Kinnison
	2011-04-27, 16:12
*/

F1::
{ ; V1toV2: Added bracket
	path := Explorer_GetPath()
	result := MsgBox(path)
	if result == "OK"
		A_Clipboard := path
} ; V1toV2: Added Bracket before hotkey or Hotstring

F2::
{ ; V1toV2: Added bracket
	all := Explorer_GetAll()
	result := MsgBox(all)
	if result == "OK"
		A_Clipboard := all
} ; V1toV2: Added Bracket before hotkey or Hotstring

F3::
{ ; V1toV2: Added bracket
	sel := Explorer_GetSelected()
	result := MsgBox(sel)
	if result == "OK"
		A_Clipboard := sel
} ; V1toV2: Added Bracket before hotkey or Hotstring


ESC::ExitApp()

Explorer_GetPath(hwnd:="")
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@", "ftp://")
	; StrReplace() is not case sensitive
	; check for StringCaseSense in v1 source script
	; and change the CaseSense param in StrReplace() if necessary
	path := StrReplace(path, "file:///",,,, 1)
	; StrReplace() is not case sensitive
	; check for StringCaseSense in v1 source script
	; and change the CaseSense param in StrReplace() if necessary
	path := StrReplace(path, "/", "\")
	
	; thanks to polyethene
	Loop
		If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", &hex)
			; StrReplace() is not case sensitive
			; check for StringCaseSense in v1 source script
			; and change the CaseSense param in StrReplace() if necessary
			path := StrReplace(path, "`%" hex[0], Chr("0x" . hex[0]))
		Else Break
	return path
}
Explorer_GetAll(hwnd:="")
{
	return Explorer_Get(hwnd)
}
Explorer_GetSelected(hwnd:="")
{
	return Explorer_Get(hwnd,true)
}

Explorer_GetWindow(hwnd:="")
{
	; thanks to jethrow for some pointers here
    process := WinGetprocessName("ahk_id" hwnd := hwnd? hwnd:WinExist("A"))
    class := WinGetClass("ahk_id " hwnd)
	
	if (process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObject("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW") 
		return "desktop" ; desktop found
}
Explorer_Get(hwnd:="",selection:=false)
{
	if !(window := Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
	{
		hwWindow := ControlGetHWND("SysListView321", "ahk_class Progman")
		if !hwWindow ; #D mode
			hwWindow := ControlGetHWND("SysListView321", "A")
        files := ListViewGetContent((selection ? "Selected":"") "Col1",,"ahk_id " hwWindow)

        base := SubStr(A_Desktop, -1, 1)=="\" ? SubStr(A_Desktop, 1, -1) : A_Desktop
		Loop Parse, files, "`n", "`r"
		{
			path := base "\" A_LoopField
			if FileExist(path) ; ignore special icons like Computer (at least for now)
				ret .= path "`n"
		}
	}
	else
	{
		if selection
			collection := window.document.SelectedItems
		else
			collection := window.document.Folder.Items
		for item in collection
			ret .= item.path "`n"
	}
	return Trim(ret,"`n")
}
