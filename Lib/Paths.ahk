
#Requires AutoHotkey v2.0
Help := "https://www.autohotkey.com/docs/v2/FAQ.htm"
CMD := "C:\Windows\system32\cmd.exe"
Class Instagram {
    static COM := "https://www.instagram.com"
    static URL := "https://www.instagram.com"
    static DM := instagram.url "/direct"
}
class Google {
    static Calendar := "https://calendar.google.com/calendar/u/0/r"
    static Maps := "https://www.google.com/maps"
    static Translate := "https://translate.google.com/"
    static Gmail := "https://mail.google.com/mail/u/0/#inbox"
    static Mail(N := "0") => Run("https://mail.google.com/mail/u/" N "/#inbox")
}
A_User := "C:\Users\" A_UserName
class User {
    static Documents := A_MyDocuments
    static Docs := A_MyDocuments
    static Music := A_User "\Music"
    static Videos := A_User "\Videos"
    static Pictures := A_User "\Pictures"
        static Pics := User.Pictures
    static Downloads := A_User "\Downloads"
        static Downs := User.Downloads
    static Desktop := A_Desktop
    static Startup :=  A_Startup
    static StartMenu := A_StartMenu
    static Programs := A_Programs
    ; class AppData {
        ;     static this := A_User "\AppData"
        ;     static Local := AppData.this "\Local"
        ; }
    static AppData := A_User "\AppData"
}
class C {
    static Program_Files := "C:\Program Files"
      class Windows {
        static Fonts := "C:\Windows\Fonts"
    }
}

; Main Directories
Lib := A_ScriptDir "\Lib"
Batch := A_ScriptDir "\Lib\Batch"
Singletons := A_ScriptDir "\Lib\Singletons"
Data_Types := A_ScriptDir "\Lib\Data_Types"



VSC := User.AppData "\Local\Programs\Microsoft VS Code\Code.exe"



; class My {
;     static Documents := A_MyDocuments
;     static Docs := A_MyDocuments
;     static Videos := A_User "\Videos"
;     static Music := A_User "\Music"
;     static Pictures := A_User "\Pictures"
;     static Downloads := A_User "\Downloads"
;     static Desktop := A_Desktop
;     static Startup :=  A_Startup
;     static StartMenu := A_StartMenu
;     static Programs := A_Programs
;     ; class AppData {
;         ;     static this := A_User "\AppData"
;         ;     static Local := AppData.this "\Local"
;         ; }
;         static AppData := A_User "\AppData"
; }



; Class Default {
;     ; static Browser := 
; }
;? _______________RANDOM___________________________________________________________________



A_WindowsTools := "shell:::{D20EA4E1-3957-11D2-A40B-0C5020524153}"
A_ThisPC := "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
A_RecycleBin := "shell:::{645FF040-5081-101B-9F08-00AA002F954E}"
A_ControlPanelAll := "shell:::{21EC2020-3AEA-1069-A2DD-08002B30309D}" 
A_DateAndTime := "shell:::{E2E7934B-DCE5-43C4-9576-7FE4F75E7480}"
A_MouseProperties := '::{6C8EEC18-8D75-41B2-A177-8831D59D2D50}'
A_TextToSpeech := '::{D17D1D6D-CC3F-4815-8FE3-607E7D5D10B3}'
A_Applications := "shell:::{4234D49B-0245-4DF3-B780-3893943456E1}"
A_Run := "shell:::{2559A1F3-21D7-11D4-BDAF-00C04F60B9F0}"
A_DefaultApps := "shell:::{2559A1F7-21D7-11D4-BDAF-00C04F60B9F0}"
A_TaskbarSettings := "shell:::{0DF44EAA-FF21-4412-828E-260A8728E7F1}"
A_WS := "shell:::{3080F90E-D7AD-11D9-BD98-0000947B0257}" ; Window Switcher
A_EmailApp := "shell:::{2559A1F5-21D7-11D4-BDAF-00C04F60B9F0}"
A_System := "shell:::{BB06C0E4-D293-4F75-8A90-CB05B6477EEE}"
A_ShowDesktop := "shell:::{3080F90D-D7AD-11D9-BD98-0000947B0257}"
A_RecentFolders := "shell:::{22877A6D-37A1-461A-91B0-DBDA5AAEBC99}"
A_DeviceManager := 'shell:::{74246BFC-4C96-11D0-ABEF-0020AF6B0B7A}'
A_ControlPanel := 'shell:::{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}'
A_AutoPlay := 'shell:::{9C60DE1E-E5FC-40F4-A487-460851A8D915}'
A_AllTasks_GodMode := "shell:::{ED7BA470-8E54-465E-825C-99712043E01C}"
A_Firewall := "shell:::{4026492F-2F69-46B8-B9BF-5654FC07E423}"
A_WindowsSearch := "shell:::{2559A1F8-21D7-11D4-BDAF-00C04F60B9F0}"
A_FolderOptions := "shell:::{6DFD7C5C-2451-11D3-A299-00C04F8EF6AF}"



class KURS {
    static URL := "https://imi.pmf.kg.ac.rs"
    static OGLASNA := KURS.URL "/oglasna=tabla"
    static ID := KURS.URL "/moodle/course/view.php?id="
    static RASP_KLK := "https://imi.pmf.kg.ac.rs/pub/2cb8552c12d0b06588bf738c975988a0_03272024_010554/inf_raspored_kolokvijuma_2023-24_letnji_v2.pdf"
    static RASP_ISP := "https://imi.pmf.kg.ac.rs/pub/af3b4da1bb95aacba0a68ae081aad307_01292024_111643/inf_raspored_ispita_2023-24_jun-sep.pdf"
    static SKRIPTE := KURS.ID "96"
    static PIP3 := KURS.ID "467"
    static SPA1 := KURS.ID "12"
    static MAT2 := KURS.ID "490"
    static ARH := KURS.ID "395"
    static RS := KURS.ID "35"
    static SA := KURS.ID "396"
}

