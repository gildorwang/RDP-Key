; MIT License

; Copyright (c) 2016 Ken Wang

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

#SingleInstance force
#Include %A_ScriptDir%
#include common.ahk

If(!A_IsCompiled)
    Menu, Tray, Icon, RDPKey16.ico
If(A_IsCompiled)
    Menu, Tray, NoStandard
Menu, Tray, Add, &Help, ShowHelp
Menu, Tray, Default, &Help
Menu, Tray, Add, &About, ShowAbout
Menu, Tray, Add, E&xit, DoExit
Menu, Tray, Tip, RDP Key
return

ShowHelp:
    MsgBox, , Hotkeys, Ctrl-Shift-CapsLock:`tMinimize/restore RDP window`nCtrl-CapsLock:`tRotate between RDP windows`nAlt-CapsLock:`tSwitch between 2 most recent RDP windows`nAlt-Shift-CapsLock:`tRestore fullscreen RDP into window mode
    return

ShowAbout:
    MsgBox, , RDP Key, Any question/feedback please contact Ken (https://github.com/gildorwang/RDP-Key)
    return

DoExit:
    ExitApp
    return

#If !A_IsCompiled
; Reload AHK script
$!s::
    SetTitleMatchMode, 2
    Send, !s
    IfWinActive, RDP.ahk
    {
        Info(A_ScriptName, "Reloaded")
        Reload
    }
    return
#If

; [RDP] Minimize/restore RDP windows
^+CapsLock::
    if(IsRDCMWinActive())
    {
        ; Store the title of the topmost one
        WinGetActiveTitle, RDCMWindowTitle
        Loop
        {
            ; Need a short sleep here for focus to restore properly.
            Sleep 50
            WinMinimize
            GetCenterPos(centerX, centerY)
            WinAtPos(centerX, centerY, title)
            WinActivate % title
            ; Continue to minimize other RDP windows
        } Until (!IsRDCMWinActive())
        Info(RDCMWindowTitle, "Minimized")
    }
    else if (RDCMWindowTitle != "")
    {
        SetTitleMatchMode 3
        WinActivate %RDCMWindowTitle%
        Info(RDCMWindowTitle, "Restored")
    }
    return

; [RDP] Restore fullscreen remote desktop into a window
!+CapsLock::
    if(IsRDCMWinActive())
    {
        Send ^!{CtrlBreak}
    }
    return

; [RDP] Rotate between RDP windows
^CapsLock::
    if (OldTime = "") {
        OldTime := A_TickCount
        ;next: whether the next window should be activated; otherwise the first one
        next := false
    }
    else {
        next := (A_TickCount - OldTime) < 800
        OldTime := A_TickCount
    }
    if (next && OldIndex <> "") {
        OldIndex := Mod(OldIndex, Wins) + 1
        ahkId := Wins%OldIndex%
        WinActivate ahk_id %ahkId%
        WinGetTitle, winN_title, ahk_id %ahkId%
    }
    else{
        ; Go the normal way
        OldIndex := SwitchRDCMWin()
    }
    return

; [RDP] Switch between the 2 most recent RDP windows
!CapsLock::
    SwitchRDCMWin()
    return

IsRDCMWinActive() {
    return (WinActive("ahk_class TscShellContainerClass"))
}

SwitchRDCMWin() {
    local wins2_title, wins1_title
    WinGet, Wins, List, ahk_class TscShellContainerClass
    if (Wins > 1) {
        WinActivate ahk_id %Wins2%
        WinGetTitle, wins2_title, ahk_id %Wins2%
        return 2
    }
    else if (Wins = 1) {
        WinActivate ahk_id %Wins1%
        WinGetTitle, wins1_title, ahk_id %Wins1%
        return 1
    }
    else {
        Info("No more RDP windows", "RDP Key")
        return 0
    }
}
