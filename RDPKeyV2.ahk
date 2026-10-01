; MIT License

; Copyright (c) 2026 Ken Wang

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
#include commonV2.ahk

if !A_IsCompiled {
    TraySetIcon(A_ScriptDir "\RDPKey16.ico")
    A_TrayMenu.Add()  ; Creates a separator line.
} else {
    ; Delete standard tray menu items
    A_TrayMenu.Delete()
}
A_TrayMenu.Add("Help", ShowHelp)
A_TrayMenu.Default := "Help"
A_TrayMenu.Add("About", ShowAbout)
A_TrayMenu.Add("Exit", DoExit)

global Wins := []
global RDCMWindowTitle := ""
global OldTime := 0
global OldIndex := 0
return

ShowHelp(*) {
    MsgBox("Ctrl+Shift+CapsLock:`tMinimize/restore RDP window`nCtrl+CapsLock:`t`tRotate between RDP windows`nAlt+CapsLock:`t`tSwitch between 2 most recent RDP windows`nAlt+Shift+CapsLock:`tRestore fullscreen RDP into window mode", "Hotkeys")
}

ShowAbout(*) {
    MsgBox("Any question/feedback please contact Ken (https://github.com/gildorwang/RDP-Key)", "RDP Key")
}

DoExit(*) {
    ExitApp()
}

#HotIf !A_IsCompiled
; Reload AHK script
$^s:: {
    SetTitleMatchMode(2)
    Send("^s")
    if WinActive("RDPV2.ahk") {
        Info(A_ScriptName, "Reloaded")
        Reload()
    }
}
#HotIf

; [RDP] Minimize/restore RDP windows
^+CapsLock:: {
    global RDCMWindowTitle
    if IsRDCMWinActive() {
        ; Store the title of the topmost one
        RDCMWindowTitle := WinGetTitle("A")
        Loop {
            ; Need a short sleep here for focus to restore properly.
            Sleep(50)
            WinMinimize("A")
            GetCenterPos(&centerX, &centerY)
            WinAtPos(centerX, centerY, &title)
            WinActivate(title)
            ; Continue to minimize other RDP windows
        } Until (!IsRDCMWinActive())
        Info( "Minimized", RDCMWindowTitle)
    }
    else if (RDCMWindowTitle != "") {
        SetTitleMatchMode(3)
        if WinExist(RDCMWindowTitle) {
            WinActivate(RDCMWindowTitle)
            Info("Restored", RDCMWindowTitle)
        } else {
            Info("Window not found", RDCMWindowTitle)
        }
    } else {
        ; When there's no previous RDP window, restore the first one
        SwitchRDCMWin()
    }
}

; [RDP] Restore fullscreen remote desktop into a window
!+CapsLock:: {
    if IsRDCMWinActive() {
        Send("^!{CtrlBreak}")
    }
}

; [RDP] Rotate between RDP windows
^CapsLock:: {
    global OldIndex, OldTime, Wins
    if (OldTime = 0) {
        OldTime := A_TickCount
        ;next: whether the next window should be activated; otherwise the first one
        next := false
    }
    else {
        next := (A_TickCount - OldTime) < 800
        OldTime := A_TickCount
    }
    if (next && (OldIndex != 0) && (Wins.Length > 1)) {
        OldIndex := Mod(OldIndex, Wins.Length) + 1
        ahkId := Wins[OldIndex]
        winId := Format("ahk_id {1}", ahkId)
        WinActivate(winId)
        winN_title := WinGetTitle(winId)
    }
    else{
        ; Go the normal way
        OldIndex := SwitchRDCMWin()
    }
    return
}

; [RDP] Switch between the 2 most recent RDP windows
!CapsLock:: {
    SwitchRDCMWin()
    return
}

IsRDCMWinActive() {
    return (WinActive("ahk_class TscShellContainerClass"))
}

SwitchRDCMWin() {
    local wins2_title, wins1_title
    Wins := WinGetList("ahk_class TscShellContainerClass")
    if (Wins.Length > 1) {
        winId := Format("ahk_id {1}", Wins[2])
        WinActivate(winId)
        wins2_title := WinGetTitle(winId)
        return 2
    }
    else if (Wins.Length = 1) {
        winId := Format("ahk_id {1}", Wins[1])
        WinActivate(winId)
        wins1_title := WinGetTitle(winId)
        return 1
    }
    else {
        Info("No more RDP windows", "RDP Keyss")
        return 0
    }
}
