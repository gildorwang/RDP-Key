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

splashGui := Gui("+AlwaysOnTop +ToolWindow -Caption")
splashGui.MarginX := 0
splashGui.MarginY := 10
splashGui.SetFont("s15 w700")
global titleText := splashGui.AddText("cWhite w230 Center")
splashGui.MarginY := 0
splashGui.SetFont("s12 w400")
global msgText := splashGui.AddText("cWhite w230 Center")
splashGui.BackColor := "0x000000"
splashGui.MarginY := 10

Info(msg, title := "", duration := 500) {
    global msgText, splashGui
    msgText.Text := msg
    titleText.Text := title
    splashGui.Show("AutoSize")
    Sleep(duration)
    splashGui.Hide()
}

GetCenterPos(&X := 0, &Y := 0) {
    ; Define variables to store the coordinates
    Left := 0
    Top := 0
    Right := 0
    Bottom := 0

    ; Get the working area of the primary monitor
    MonitorGetWorkArea(1, &Left, &Top, &Right, &Bottom)
    X := (Right - Left) / 2
    Y := (Bottom - Top) / 2
}

WinAtPos(px, py, &title := "", &class := "", &x := 0, &y := 0, &width := 0, &height := 0) {
    POINT := Buffer(8, 0)
    NumPut("Int", px, POINT, 0)
    NumPut("Int", py, POINT, 4)
    HWND := DllCall("WindowFromPoint", "Int64", NumGet(POINT, 0, "Int64"))
    HWND := DllCall("GetAncestor", "UInt", HWND, "UInt", GA_ROOT := 2)
    WinExist("ahk_id" . HWND)
    title := WinGetTitle()
    class := WinGetClass()
    WinGetPos(&x, &y, &width, &height)
}
