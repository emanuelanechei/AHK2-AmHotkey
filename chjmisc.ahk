﻿; Note: This file is saved with UTF8 with BOM, which is the best encoding choice to write Unicode chars here.

AUTOEXEC_chjmisc: ; Workaround for Autohotkey's ugly auto-exec feature. Don't delete.

; Something to place here.
; * Customize these global vars according to your running machine:
; * Call the run-once functions.

/* APIs:

chj_PrettyprintClipboardCode()

*/


global g_LeftsideClickPct := 0.3
global g_RightsideClickPct := -0.3
global g_MiddleFloorClickPct := 0.5

global g_prettyprint_template := "D:\chj\scripts\prettify_code_in_html\prettyprint-template.html"
global g_prettyprint_webbrowser := "" ; "D:\PortableApps\GoogleChrome-74\GoogleChromePortable.exe"
; -- Above two vars can be overridden by user.

chj_DefineQuickSwitchApps()
chjmisc_InitMenus()
Bcam4_Init()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
return ; End of auto-execute section.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include %A_LineFile%\..\libs\AmTrimPath.ahk
#Include %A_LineFile%\..\AmTemplates.ahk

;==============================================================================
; Some hotstring auto-replace
;==============================================================================

; Auto-replace `1 to be 192.168. -- easy typing those IP addresses.
; Note: You have to double ` here. ``1 means triggering chars `1 
; memo: [*] no need to post-type a space to trigger, 
;       [?] no need to prefix a wordchar to trigger
:*:``1::192.168.
:*:``2::172.24.0.
:*:``q::Q:{space}
:?*:;;::`:{space}

; Type ``t to get _T("") , or ``y to get _T(''),, then move the caret back inside the quotes
:*:````t::_T(""){left}{left}
:*:````y::_T(''){left}{left}

; Type ``pp to get pprint.pprint (python)
:*:````pp::from pprint import pprint as pp

; Type:
;	 ``!
; Get HTML comment block.
;	<!-- -->
:?*:````!::<{!}--  -->{left}{left}{left}{left}


; <<>> makes Chinese ShuMingHao
:?*:<<>>::《》{space}
:?*:``ss::《》{space}

; Type #! to insert a shebang line in .py script.
; b0 means no erase already typed #! // [2018-11-25] I forgot this shortcut bcz it is not led by my accustomed ``
;           :*Rb0:#!::/usr/bin/env python3 #-*- coding: utf-8 -*-

; Type ``# to insert a shebang line in .py script (AHK 1.1.24.05 ok).
; Thanks to https://superuser.com/a/1378252/74107
:*:`````#:: ; Yes, function calling should be on a separate line.
type_python_shebang()
type_python_shebang()
{
	SendInput {Raw}
	(
#!/usr/bin/env python3
#coding: utf-8

	)
}
; A more verbose way is:
;	:*:`````#::`{#`}`{!`}/usr/bin/env python3{enter}`{#`}coding: utf-8{enter}
;


; Type ``u to insert Python utf-8 heading
; R means raw, no re-interpreting # : etc, otherwise, a # causes Win key to be sent.
:*R:````u::#-*- coding: utf-8 -*-

!#0:: dev_WinMove_with_backup_with_prompt(0, 0, "", "") ; move window to (0,0) in case you can't see that window

; 2014-01-09: Ctrl+Win+<Num> to change current window size
^#1:: dev_WinMove_with_backup_with_prompt("","", 800, 600)
^#2:: dev_WinMove_with_backup_with_prompt("","", 1024, 768)
^#3:: dev_WinMove_with_backup_with_prompt("","",  1200, 900)
^#4:: dev_WinMove_with_backup_with_prompt("","", 1440, 1000)
; Ctrl+Win+0 toggle last two window positions
^#0:: dev_UndoChangeWindowSize()





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

chj_DefineQuickSwitchApps() ; as template for actual users
{
	QSA_DefineActivateGroup_Caps("/", "Notepad", "Notepad")
;	QSA_DefineActivateGroup_Caps("1", "Chrome_WidgetWin_1", "Chrome")
;	[2018-07-25] I have to use this bcz Skype 8.x UI is using the Chromium framework.
	;QSA_DefineActivateGroupFlex_Caps("1", "Chrome_WidgetWin_1", QSA_NO_WNDCLS_REGEX, "^(?!Skype).*", "Chrome")
	QSA_DefineActivateGroupFlex_Caps("1", "Chrome_WidgetWin_1", QSA_NO_WNDCLS_REGEX, "(Google Chrome|Comodo Dragon|Edge)$", "Google Chrome genre browser")
	
	QSA_DefineActivateGroupFlex_Caps("2", "MozillaWindowClass", QSA_NO_WNDCLS_REGEX, "(Firefox|Waterfox)", "Firefox or Waterfox")
	;QSA_DefineActivateGroup_Caps("2", "MozillaWindowClass", "Firefox") // would share with Active-state Komodo 7
	
	QSA_DefineActivateGroup_Caps("d", "ConsoleWindowClass", "CMD")
	QSA_DefineActivateGroup_Caps("q", "TXGuiFoundation", "QQ")
	QSA_DefineActivateGroup_Caps("h", "HH Parent", "CHM viewer")

;	QSA_DefineActivateSingle_Caps("m", "ENMainFrame", "Evernote") ;
;	QSA_DefineActivateGroup_Caps("n", "ENSingleNoteView", "Evernote Single-note")
	
	QSA_DefineActivateGroup_Caps("v", "VMUIFrame", "VMware Workstation")
		; Note: On activated, the VM may or may not grabs input immediately, which depends on 
		; whether you have used Ctrl+Alt to release control from the VM.
	QSA_DefineActivateGroupFlex_Caps("b", QSA_NO_WNDCLASS, QSA_NO_WNDCLS_REGEX, "VirtualBox Manager$", "VirtualBox Manager") ; virtualbox 6

	QSA_DefineActivateGroup_Caps("w", "CabinetWClass", "Windows Explorer")
	QSA_DefineActivateGroup_Caps("e", "EmEditorMainFrame3", "EmEditor")
	QSA_DefineActivateGroup_Caps("f", "classFoxitReader", "Foxit Reader")
	QSA_DefineActivateGroup_Caps("c", "VirtualConsoleClass", "ConEmu")
	QSA_DefineActivateGroup_Caps("p", "PuTTY", "PuTTY")

	QSA_DefineActivateGroupFlex_Caps("u", "ConsoleWindowClass", QSA_NO_WNDCLS_REGEX, "Ubuntu", "WSL Ubuntu")
	QSA_DefineActivateGroupFlex_Caps("o", "ConsoleWindowClass", QSA_NO_WNDCLS_REGEX, "^openSUSE", "WSL openSUSE")

	QSA_DefineActivateGroupFlex_Caps("j", QSA_NO_WNDCLASS, "HyperSnap (7|8) Window Class",  "", "Hypersnap 7 or 8")

	QSA_DefineActivateGroupFlex_Caps("6", QSA_NO_WNDCLASS, "^Afx", "Microsoft Visual C\+\+", "The Visual C++ 6 IDE")
		; VC6 winclass is like Afx:400000:8:10009:0:3ab31345
		; Sigh, with 1.1.19.02, MRU behavior is broken with this regex mode
		; http://superuser.com/questions/876491/autohotkey-groupactivate-mru-behavior-discrepancy-any-way-to-fix

     ; Visual Studio 2008:
     ;QSA_DefineActivateGroupFlex("AppsKey & 8", QSA_NO_SUFFIXKEY, "wndclass_desked_gsk", QSA_NO_WNDCLS_REGEX, "^Microsoft Visual Studio", "VS2008 IDE")
     ; -- AppsKey & 8
     ; or
     ;QSA_DefineActivateGroupFlex_Caps("8", "wndclass_desked_gsk", QSA_NO_WNDCLS_REGEX, "^Microsoft Visual Studio", "VS2008 IDE")
     ; -- CapsLock & 8

	; Visual Studio VS2010+
	QSA_DefineActivateGroupFlex_Caps("0", QSA_NO_WNDCLASS, "^HwndWrapper", "Microsoft Visual Studio( \(Administrator\))*$", "VS2010_or_above")

	; MS Help Viewer 2.x
	QSA_DefineActivateGroupFlex_Caps("-", QSA_NO_WNDCLASS, "^HwndWrapper\[HlpViewer", "", "MS Help Viewer 2.x")
	
	; Visual Studio Code (2018)
	QSA_DefineActivateGroupFlex_Caps("9", "Chrome_WidgetWin_1", QSA_NO_WNDCLS_REGEX, "Visual Studio Code$", "Visual Studio Code")
	
	; Python IDLE shell
	QSA_DefineActivateGroupFlex_Caps("y", "TkTopLevel", QSA_NO_WNDCLS_REGEX, "^\*?Python.+Shell", "Python IDLE shell window")
	
	; Navicat
	QSA_DefineActivateGroup_Caps("i", "TNavicatMainForm", "Navicat database manager")
	
	;QSA_DefineActivateGroupFlex_Caps("-", QSA_NO_WNDCLASS, "^HwndWrapper", "Microsoft Help Viewer", "MS Help Viewer 1.x/2.x") //VS2010 hlpviewer 1.x
}

;############### Zhongwen IME related ################

Is_PinyinJiaJia_Floatbar_Visible()
{
	; If PYJJ's floatbar is visible, user is typing Chinese chars, character picking pending.
	return dev_IsWinclassExist("PYJJ_COMPUI_WND")
}

IsTypingZhongwen_PinyinJiaJia() 
{
	; 获知当前是否处于 拼音加加 中文输入状态。
	; 若是，意思是敲入的一个英文字母将被输入法浮动窗口吸收。
	; 若否，敲入的一个英文字母将直接被应用程序获得。
	
	; 本函数适用于 拼音加加 5.2 。
	
	if WinExist("ahk_class PYJJ_STATUS_WND")
	{
		; PYJJ_STATUS_WND 是拼音加加附着在应用程序标题上的状态条。
		; 接下来检查拼音加加状态条最右侧的那个小格是否是“全”字（全拼状态），
		; 检查“全”字尖顶的那个粉红像素(x78, y3)，有的话则表示中文输入状态。
		; 暂不处理双拼。
		
		WinGetPos, jjx, jjy, jjw, jjh, ahk_class PYJJ_STATUS_WND
		CoordMode, Pixel, Screen
		PixelGetColor, color, jjx+78, jjy+3, RGB
		CoordMode, Pixel, Window
		if(color==0xFF0099)
			return true
		else
			return false
	}
	else
	{
		return false
	}
}

ToggleZhongwenStatus_PinyinJiaJia(is_zhongwen_on)
{
	zs := IsTypingZhongwen_PinyinJiaJia()
	if( (zs && !is_zhongwen_on) || (is_zhongwen_on && !zs))
		SendInput {Shift down}{Shift up}{Ctrl down}{Ctrl up}
	return zs ; return original status
}



get_dirfilecount(file_pattern)
{
	count := 0
	Loop, Files, %file_pattern%
	{
		count += 1
	}
	;MsgBox, %count%
	return count
}

chjmisc_InitMenus()
{
	Menu, tray, add  ; Creates a separator line.
	SystrayMenu_Add_MuteClicking()

	winshell_AddOneAhkFunctionMenuItem("Configure debug-modules", "Amdbg_ShowGui")
	winshell_AddOneAhkFunctionMenuItem("Accurate move current active window", "devui_ChangeWindowPosition")
	winshell_AddOneAhkFunctionMenuItem("AHK Trim path utility", "AmTrimPath_ShowGui")
	winshell_AddOneAhkFunctionMenuItem("[AmTemplate] Select new", "Amt_LaunchMenu")
	winshell_AddOneAhkFunctionMenuItem("[AmTemplate] Show previous", "Amt_ShowPreviousGui")
	
;	winshell_AddOneAhkFunctionMenuItem("[BadMenu] BadItem", "NotExistingFunction") ; test error reporting
	
	chjmisc_AddQuickPasteSnippets()
}


chjmisc_AddQuickPasteSnippets()
{
	winshell_AddOneSendTextMenu("venv39 - transcode"
		, ["d:\venv\venv39a\Scripts\activate.bat"
		, "d:\PFNoInst\chjtranscode\setenv.bat"
		, "set PYTHONPATH=D:\github\youtube-dl"])
	
	text =
	(
var m = location.href.match("https://github.com/([^/]+/[^/]+)");
var reposie = m[1]
var apiurl = "https://api.github.com/repos/" + reposie
fetch(apiurl)
  .then(v => v.json()).then((v) => { console.log(v['size'] + 'KB')  })
	)
	winshell_AddOneSendTextMenu("F12 console - Query github.com repo size", text)

	text = 
	(
class C1 {
public: 
	C1() { printf("C1 ctor() @[`%p]\n", this); }
	~C1(){ printf("C1 dtor() @[`%p]\n", this); }
	int m1;
};
	)
	winshell_AddOneSendTextMenu("a C++ class with ctor/dtor", text)
}

chj_StartMultiPageScreenGrabber(screenshot_hotkey, pgdn_hotkey, image_dir, pages, pgdn_wait_millisec:=500)
{
	; PURPOSE:
	; Grab screen content of each page of a ebook/doc, and save each screen shot to an image file.
	; So that, we steal the ebook/doc for offline viewing. After the page images are saved
	; (e.g. as png files), we can then merge them into a PDF file and OCR it for later convenient 
	; reading.
	;
	; For the above process to work, we need two additional tool/software:
	; (1) a ebook/doc reading software(e.g. Foxit PDF reader 9.7).
	; (2) a screen grabbing software(e.g. FastStone Capture 9.7). On pressing a global hotkey,
	;     it should grab a specific screen region and save it to file with auto-naming.
	;
	; PARAMETERS:
	; screenshot_hotkey : 
	;		This function will `Send` this hotkey to trigger screen grabbing. 
	;		This is a string, for example, "{F11}" .
	; pgdn_hotkey :
	;		The hotkey to trigger ebook reader page down.
	; image_dir :
	;		This function need to know where does screen-grabbing software store grabbed images,
	;		bcz this function will check this dir to know whether a new image file is generated.
	; pages :
	;		How many pages would you like to turn.
	;		Hint: You can pass in some more pages, to workaround casual "pgdn not responding"
	;		cases. Redundant tail pages is not a problem, bcz we can easily delete them.
	; pgdn_wait_millisec :
	;		How many millisec to wait for ebook reader's page-down action.
	;		Normally, 500ms should be enough.
	;
	; USAGE NOTE:
	; User should try to keep ebook reader software as foreground window, so that pgdn_hotkey 
	; works normally.
	;
	; To break a freezing run, try AHK reload (Win+Alt+R).
	;
	; TODO:
	; * We cannot know whether ebook reader has successfully respond to pgdn_hotkey.
	;	Maybe we should add screen content comparing or image file content comparing to know that.

	WinGet, winid, ID, A

	pattern := image_dir . "\*.*"
	count_base := get_dirfilecount(pattern)
	count_prev := count_base
	
	Loop, % pages
	{
		dev_TooltipAutoClear("Done grabbing pages: " . count_prev-count_base)

		Send %screenshot_hotkey% ; Let FSCapture repeat last capture
		
		; wait until a new file appears
		Loop
		{
			Sleep, 500 
			count := get_dirfilecount(pattern)
			if(count!=count_prev)
			{
				count_prev := count
				break ; a new file appears
			}

			dev_TooltipAutoClear(Format("Retrying {1} for page #{2}", A_Index, count_prev-count_base+1))
		}

		; FSCapture can steal foreground window state, so we have to 
		; wait for ebook-reader software regaining foreground state.
		;
		isok := dev_WinWaitActive_with_timeout("ahk_id " . winid, "", 1)
		if(!isok)
		{
			MsgBox, % "Lost Foxit foreground window. Stop."
			return
		}
		
		Send %pgdn_hotkey%
		Sleep, %pgdn_wait_millisec% ; wait for ebook-reader doing page-down/scrolling.
	}
	
	MsgBox, % "chj_StartMultiPageScreenGrabber() done!"
}

^+q:: chj_PrettyprintClipboardCode()

chj_PrettyprintClipboardCode()
{
	; Launch a webbrowser to display prettyprinted-code. 
	; The code text is from current clipboard.
	
	clipboard_text := Clipboard
	
	if(!clipboard_text) {
		dev_MsgBoxWarning("Clipboard has empty text.")
		return	
	}
	
	dev_TooltipAutoClear(Format("Prettyprint clipboard content, text length {1}...", StrLen(clipboard_text)))
	
	SplitPath, g_prettyprint_template, filename, dir
	
	hfTmpl := FileOpen(g_prettyprint_template, "r", "UTF-8-RAW")
	if(!hfTmpl) {
		msg := "Cannot open template file:`r`n`r`n" g_prettyprint_template
		dev_MsgBoxError(msg)
		return
	}
	
	html := hfTmpl.Read()
	hfTmpl.Close()
	
	clipboard_text := dev_EscapeHtmlChars(clipboard_text)
	
	html := StrReplace(html, "{{CODE}}", clipboard_text)
	
	htmlfile := dir "\prettyprint.html" ; in the same folder as template
	hfNew := FileOpen(htmlfile, "w", "UTF-8-RAW")
	
	if(!hfNew) {
		msg := "Cannot create file:`r`n`r`n" htmlfile
		dev_MsgBoxError(msg)
		return
	}
	
	hfNew.Write(html)
	hfNew.Close()

	if(g_prettyprint_webbrowser) {
	
		if(!FileExist(g_prettyprint_webbrowser)) {
			msg := Format("The Web browser program(g_prettyprint_webbrowser) ""{1}"" does not exist.", g_prettyprint_webbrowser)
			dev_MsgBoxError(msg)
			return
		}
	
		cmdbrowser := Format("""{1}"" ""{2}""", g_prettyprint_webbrowser, htmlfile)
	} 
	else {
		static s_warnonce := false
		
		exepath_chrome := dev_EnvGet("LocalAppData") . "\Google\Chrome\Application\chrome.exe"
		
		if(!s_warnonce) {
			dev_MsgBoxInfo("g_prettyprint_webbrowser global var is empty, so I will use Chrome browser at its default location.`n`n" . exepath_chrome)
			s_warnonce := true
		}
		cmdbrowser := Format("""{1}"" ""{2}""", exepath_chrome, htmlfile)
	}
	
	Run, % cmdbrowser
}


;==============================================================================
; Clipcache 3.4
;==============================================================================
#If IsWinClassActive("ClipCacheWindowClass")

CapsLock & Left:: ControlFocus, SysTreeView321, A

CapsLock & Up:: ControlFocus, SysListView321, A
CapsLock & Right:: ControlFocus, SysListView321, A

CapsLock & Down:: ControlFocus, RichEdit20W1, A


#If


;==============================================================
; Dreamweaver CS5
;==============================================================
; 2013-09-25 F12: Click into select CSS style combobox
#IfWinActive ahk_class _macr_dreamweaver_frame_window_
F12:: 
MouseGetPos origx, origy
ClickInActiveWindow(340, -133)
MouseMove origx, origy
return
#IfWinActive
; Historical note: 
; In case you use Ctrl+Win+0, you probably should add:
;#^0:: return ; otherwise, Ctrl+Win+0 will act as Win+0 (This workaround is great)




;==============================================================
; VLC Media Player 
; Note: Many apps use "QWidget" class, so check IsWinTitleMatchRegex() is required.
;==============================================================

; 2013-11-11, VLC 2.0 Loop A-B button hotkey
#If IsWinClassActive("QWidget") && IsWinTitleMatchRegex("VLC")
PrintScreen:: ClickInActiveWindow(90, -50)
#If




;==============================================================
; Skype 6.x/7.x , Swap Enter & Ctrl+Enter, so Ctrl+Enter to send message.
; Note: Skype 8.x start using Chromium framework UI.
;==============================================================
skype_IsChsIMEActive()
{
	if WinExist("ahk_class PYJJ_COMPUI_WND") ; Pinyin JiaJia 
		return true
	else
		return false
}

Is_Skype8Active()
{
	WinGet, Awinid, ID, A ; cache active window unique id
	WinGetClass, class, ahk_id %Awinid%
	WinGetTitle, title, ahk_id %Awinid%

	if( class=="Chrome_WidgetWin_1" and title=="Skype" )
	{
		return true
	}
	else
	{	
		return false
	}
}

#If WinActive("ahk_class tSkMainForm") or Is_Skype8Active()

Enter::
	if(skype_IsChsIMEActive()) 
	{
		; If doing Pinyin JiaJia input(IME floating window on screen), don't change Enter
		; dev_TooltipAutoClear("[Enter] PYJJ_COMPUI_WND active", 1000)
		SendInput {Enter}
	}
	else 
	{
		SendInput ^{Enter}
	}
return

^Enter:: 
	KeyWait, Ctrl ; Wait until Ctrl is released
	SendInput {enter}
return

#IfWinActive 


;==============================================================
;2014-05-09 VMware Workstation 10
;==============================================================
#IfWinActive ahk_class VMUIFrame

; Ctrl+F9 click into "Library" search box
^F9::
	ClickInActiveControl("Edit1", -2, -2)
return

^/:: 
	; Move mouse to right-bottom corner(device connect/disconnect controls there)
	; so easy to use keybad mouse there.
	MouseMoveInActiveWindow(-68, -14)
	ModifyMouseNudgeUnitAM(21)
return 

; Alt+p to pause/unpause VM, for VMwks 15+
!p:: vmwks_PauseVM()
; -- [2023-04-26] This hotkey cannot be activated for VMwks 16.2.3 on Win10, don't know why.
vmwks_PauseVM()
{
	dev_TooltipAutoClear("Sending Ctrl+Shift+p to pause/unpause the VM ...")
	dev_SendKeyToExeMainWindow("{Ctrl down}{Shift down}p{Shift up}{Ctrl up}", "A")
}

#IfWinActive


#IfWinActive ahk_class VMPlayerFrame

F1:: vmrc_ClickRemoteConsoleMenu()
vmrc_ClickRemoteConsoleMenu()
{
	; Click the button written as VMRC
	ClickInActiveControl("xui::TForm3", 0.5, 0.5)
}

#IfWinActive



;==============================================================
;2016-03-03 Everything 1.3.4
;==============================================================
#IfWinActive ahk_class EVERYTHING

Up::   Everything_SmartUpDown("Up")
Down:: Everything_SmartUpDown("Down")
PgUp:: Everything_SmartUpDown("PgUp")
PgDn:: Everything_SmartUpDown("PgDn")
Everything_SmartUpDown(keyname)
{
	ControlGetFocus, focusNN, A
	if(focusNN=="Edit1")
	{
		SendInput {Tab}
	}
	SendInput {%keyname%}
}

#IfWinActive ; ahk_class EVERYTHING



;==============================================================================
; MSDN 2008
;==============================================================================

; Virtual key-code 226(0xE2) is the Central Europe extra \ key at the left-side of 'Z', which is not used on a US keyboard layout.
; I happen to have this key on my B.FriendIt(type1) keyboard, so enjoy this.

vkE2 & 8:: MSDN2008_Activate__Focus_IndexPane()
vkE2 & F8:: MSDN2008_Activate__Focus_IndexPane()
; B.FriendIt(type2) keyboard does not have the Europe \ key, but instead a Fn, so I have to turn to Fn+F8 for MSDN2008.
vKB2:: MSDN2008_Activate__Focus_IndexPane()

MSDN2008_Activate__Focus_IndexPane()
{
	if(MSDN2008_IsActive())
		MSDN2008_Focus_IndexPane()
	else
		MSDN2008_ActivateGroup()
}


;===== iPad Reflector recording on my Chji Win7 =====

chji_CheckiOSRecordingReady(record_width:=600, record_height:=800, request_fps:=10)
{
	; Run this function so that Reflector2 window and Bandicam target-window rest in the "same" position.
	; Then bandicam screen recording will record the very iPad AirPlay casting screen content.
	;
	; Limitation: Sometimes, I have to run this function *twice*, to make the two windows rest in the same position.

	; Check if "Reflector 2" is running.
	; If so, move "Reflector 2" window to my designated position.
	
	; Its window class is sth like:
	;	HwndWrapper[Reflector2.exe;;534cdb1d-82b1-462a-8391-0c90eeaaf301]
	;
	; Title is sth like "Reflector 2 - Juns mini4w"
	; Process path: C:\Program Files\Reflector 2\Reflector2.exe

	
;	SetTitleMatchMode, 2 ; set partial title match mode
	hwndReflector := WinExist("Reflector 2")
;	SetTitleMatchMode, 3 ; restore to default exact match
	
	if(!hwndReflector) {
		dev_MsgBoxError("Cannot detect ""Reflector 2"" mirroring window.")
		return
	}
	
	WinGetPos, x,y,w,h, ahk_id %hwndReflector%
	if(w==325 && h==275) {
		dev_MsgBoxError("Reflector 2 small window is opened, you should close it first.")
		return
	}
	
	preset_x := 20
	preset_y := 20
	
	succ := dev_SetWindowSize_StickCorner(hwndReflector, record_width, record_height+80)
	if(!succ) {
		return
	}
	
	; Check whether Bandicam is running, if so, move it to the same location of Reflector2.
	; For Bandicam 3.4.2 .
	
	hwndBandicamRec := WinExist("ahk_class TARGETRECT")
	if(!hwndBandicamRec) {
		dev_MsgBoxError("Bandicam is not running yet, or, Bandicam's TARGETRECT is not visible now.")
		return
	}
	
	WinGetPos, ix,iy,iw,ih, ahk_id %hwndReflector% ; `i` implies the inner-window
	dev_WinMove_with_backup(ix-2, iy+37, iw+4, ih-50, hwndBandicamRec, false)

	;
	; Check whether Bandicam's current recording cfg is the desired one. If not, MsgBox warn.
	;
	
	hwndBandicamMain := WinExist("ahk_class Bandicam2.x")
	if(!hwndBandicamMain) {
		dev_MsgBoxError("Unexpect: Bandicam main-window does NOT exist.")
		return
	}
	
	WinActivate, ahk_id %hwndBandicamMain%
	
	isok := dev_WinWaitActive_with_timeout("ahk_id " . hwndBandicamMain)
	if(!isok) {
		dev_MsgBoxError("Unexpect: Bandicam main-window can not be activated.")
		return
	}
	
	; Click two buttons of Bandicam main window to force writing in-memory cfg to registry
	ClickInActiveWindow( 30, 94, false, 3)
	Sleep, 200
	ClickInActiveWindow(130, 94, false, 3)
	
	RegRead, now_fpms, HKEY_CURRENT_USER, Software\BANDISOFT\BANDICAM\OPTION, VideoFormat.VideoFrameRate
	; -- 12000 fpms means 12 fps
	
	if(now_fpms!=request_fps*1000) {
		dev_MsgBoxError("Cfg Error: Current recording FPS is not set to " . request_fps . " " . zz)
		return
	}
	
	dev_TooltipAutoClear(Format("chji_CheckiOSRecordingReady OK."))

}


class CDuraState
{
	__New(funcGetstate, context:=0)
	{
		; note: funcGetstate is a function name represented as a string
	
		this._funcGetState := funcGetstate
		this._context := context

		this._prevState := %funcGetstate%(context)
		this._timeSince := A_TickCount
		
;		tooltip, % "CDuraState __New()..." ; debug
	}
	
	GetState()
	{
		ucallback := this._funcGetState
		nowState := %ucallback%(this._context)
		
		if(nowState==this._prevState)
		{
			ret := {}
			ret.state := nowState
			ret.dura_millisec := A_TickCount - this._timeSince
		}
		else 
		{
			this._prevState := nowState
			this._timeSince := A_TickCount
			
			ret := { state: nowState , dura_millisec: 0 }
		}
		
		return ret
	}

	ResetTime()
	{
		this._timeSince := A_TickCount
	}
}


Check_Reflector2_Idle(context:=0)
{
	Process, Exist, Reflector2.exe
	if (ErrorLevel) {
		; Reflector2.exe process running 

		hwndReflector := WinExist("Reflector 2")
		if(hwndReflector) {
			; dev_MsgBoxError(" 'Reflector 2' mirroring window exists.")
			return "Mirroring"
		}
		else {
			return "Idle"
		}
	} 
	else {
		return "NotRun"
	}
}

chji_CheckSystemHealth()
{
	static Reflector2Idle := new CDuraState("Check_Reflector2_Idle")
		; [2018-12-01] Memo: This static object's __New is called as early as on script loading,
		; not when chji_CheckSystemHealth() is first called.
	
	
	ret := Reflector2Idle.GetState()
	durasec := ret.dura_millisec//1000
	durasec_warn := 60
	msgbox_timeout_sec := 30
;	MsgBox, % Format("Reflector2.exe state={} for {} seconds", ret.state, durasec) ; debug
	
	if(ret.state=="Idle" and durasec>durasec_warn)
	{
		MsgBox, % msgboxoption_IconExclamation, , % Format("Reflector2.exe has been idle for {} seconds. You should quit it for system safety.", durasec_warn), % msgbox_timeout_sec
		
		Reflector2Idle.ResetTime()
	}
}



;===== [2020-03-13] Bandicam 4.x Recording Parameter Checking. =====
; User interaction:
; When Bandicam is the active window, pressing F1 will bring up a popup menu listing a bunch of 
; recording scenarios, such as Net-meeting, motion-video grabbing, slide-show grabbing etc.
; And AHK code will verify the correctness of in-registry Bandicam parameters against the 
; selected scenario. 
;
; [2020-03-13] Limitation: This ahk code does not work well on a hybrid DPI-scaling multi-monitor machine.
; Workaround, move your bandicam window to the 100% DPI monitor.

#If IsWinClassExist("Bandicam2.x") ; Bandicam 4.x also use this winclass name
^F1:: Bcam4_ShowScenarioMenu()
#If ; IsWinClassExist("Bandicam2.x")

#If IsWinClassActive("Bandicam2.x") ; Bandicam 4.x also use this winclass name

F1:: Bcam4_ShowScenarioMenu()

Bcam4_Init()
{
	menu_title := "== Bandicam4: 选择要校验的场景 =="
	Menu, Bcam_Scenario, Add, % menu_title, Bcam4_null ; this acts as menu title
	Menu, Bcam_Scenario, Disable, % menu_title
	Menu, Bcam_Scenario, Add ; separator
	
	Menu, Bcam_Scenario, Add, % "网络会议录屏（同时录制我的声音） 24fps", Bcam4_VerifyNetMeeting_24fps
	Menu, Bcam_Scenario, Add, % "软件演示录屏（同时录制我的声音） 10 or 12fps", Bcam4_VerifyNetMeeting_10or12fps
	Menu, Bcam_Scenario, Add, % "单纯录屏（无麦） 24fps", Bcam4_VerifyMotionVideo_24fps
	Menu, Bcam_Scenario, Add, % "单纯录屏（无麦） 10 or 12fps", Bcam4_VerifyMotionVideo_10or12fps
	
	Menu, Bcam_Scenario, Add ;separator
	Menu, Bcam_Scenario, Add, % "Reflector 2 录屏布局, iPhone 6s (375*672) 10fps", Bcam4_ReflectorLayout_iPhone6s_10fps
	Menu, Bcam_Scenario, Add, % "Reflector 2 录屏布局, iPad 竖屏 (600*800) 10fps", Bcam4_ReflectorLayout_iPad_10fps
}

Bcam4_null()
{
}

Bcam4_ReflectorLayout_iPhone6s_10fps()
{
	chji_CheckiOSRecordingReady(375, 672, 10)
}
Bcam4_ReflectorLayout_iPad_10fps()
{
	chji_CheckiOSRecordingReady(600, 800, 10)
}

Bcam4_ReadOption(optname)
{
	RegRead, retval, HKEY_CURRENT_USER, Software\BANDISOFT\BANDICAM\OPTION, % optname
	return retval
}

Bcam4_ShowScenarioMenu()
{
	Menu, Bcam_Scenario, Show
}

Bcam4_FlushRegistry()
{
	; Click two buttons of Bandicam main window to force writing in-memory cfg to registry
	ClickInActiveWindow(130, 74, false, 3)
	Sleep, 200
	ClickInActiveWindow( 30, 74, false, 3)
}

Bcam4_VerifyNetMeeting_24fps()
{
	; 要求录制麦克风声音，并且与主声道混合
	;
	; "sVideoSndDevice2_2"="(某个非空值)" 
	;   // 如果外部定义了 Bcam4_microphone_uuid 变量，
	;	// 比如: global Bcam4_microphone_uuid:="{0.0.1.00000000}.{194d03c6-36f5-4020-96fe-9383220ff0d3}"
	;	// 那么，就要求 sVideoSndDevice2_2 和该值相等
	; "bVideoSndDeviceMix"=dword:00000001

	Bcam4_verifyRecordingParams(true, 24)
}
Bcam4_VerifyNetMeeting_10or12fps()
{
	Bcam4_verifyRecordingParams(true, [10,12])
}

Bcam4_VerifyMotionVideo_24fps()
{
	Bcam4_verifyRecordingParams(false, 24)
}
Bcam4_VerifyMotionVideo_10or12fps()
{
	Bcam4_verifyRecordingParams(false, [10,12])
}

Bcam4_verifyRecordingParams(want_mic, fps:=0)
{
	; fps can be an integer or and 'array of integers'

	Bcam4_FlushRegistry()
	errmsg_all := ""
	
	if(want_mic)
	{
		val := Bcam4_ReadOption("sVideoSndDevice2_2")
		if(Bcam4_microphone_uuid=="" and val=="")
		{
			errmsg_all .= "'Secondary Sound Device' must be enabled.`n"
		}
		else if(Bcam4_microphone_uuid!="" and val!=Bcam4_microphone_uuid)
		{
			errmsg_all .= "'Secondary Sound Device' must be set to a microphone device with uuid=""" . Bcam4_microphone_uuid . """`n"
		}

		val := Bcam4_ReadOption("bVideoSndDeviceMix")
		if(val != "1")
		{
			errmsg_all .= "'Two Sound Mixing' must be ticked.`n" 
		}
	}
	else
	{
		val := Bcam4_ReadOption("sVideoSndDevice2_2")
		if(val!="")
		{
			errmsg_all .= "'Secondary Sound Device' must be disabled.`n"
		}
	}

	if(fps!=0)
	{
		if(fps is Integer)
			ar_fps := [fps] ; make it an array
		else
			ar_fps := fps
		
		fps_count := ar_fps.Length()
		
		if(fps_count==1)
			errmsg1 := "Video frame rate must be set to " ; assume error message
		else
			errmsg1 := "Video frame rate must be set to one of " ; assume error message
		
		Loop, % fps_count
		{
			fps := ar_fps[A_Index]
			val := Bcam4_ReadOption("VideoFormat.VideoFrameRate")
			if(val==fps*1000)
			{
				errmsg1 := ""
				break
			}
			else
			{
				errmsg1 .= "" . fps . ", "
			}
		}
		
		if(errmsg1)
		{	
			; Replace the trailing ", " with ".", then append it to overall errmsg_all .
			errmsg_all .= SubStr(errmsg1, 1, StrLen(errmsg1)-2) . "."
		}
	}

	; ==== Conclusion ===

	if(errmsg_all) {
		dev_MsgBoxError("Please fix the following issues:`n`n" . errmsg_all)
	} else {
		dev_MsgBoxInfo("[Bandicam AHK] OK, no problems found.")
	}
}

#If ; Bandicam

;==========================================================================
; FastStone Capture App hotkey redefinition.
;==========================================================================


#If dev_IsExeActive("FSCapture.exe")

PasteImageToFastStone()
{
	delay_msec := 200
	dev_TooltipAutoClear(Format("Will send Ctrl+Shift+V to FSCapture.exe in {}ms...", delay_msec), 2000)
	Sleep, %delay_msec%
	ControlSend, ahk_parent, {Ctrl down}{Shift down}v{Ctrl up}{Shift up}, A ; ahk_parent is optional
}

; I use Ctrl+Alt+V to execute File -> Import from Clipboard(default to Ctrl+Shift+V)
^!v:: PasteImageToFastStone()

#If ; dev_IsExeActive("FSCapture.exe")



;==========================================================================
; Navicat (no custom hotkey feature)
;==========================================================================
#If dev_IsExeActive("navicat.exe")

^w:: dev_TooltipDisableCloseWindow("Ctrl+W")
+^w:: dev_TooltipDisableCloseWindow("Ctrl+Shift+W")


#If ;  dev_IsExeActive("navicat.exe")

