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

Info(msg, title="")
{
    SplashImage , ,b1 cw000000 ctffffff, %msg%, %title%
    Sleep, 500
    SplashImage, Off
}

GetCenterPos(ByRef X=0, ByRef Y=0)
{
	SysGet, MonitorPrimary, MonitorPrimary
	SysGet, Area, MonitorWorkArea, MonitorPrimary
	X := (AreaRight - AreaLeft) / 2
	Y := (AreaBottom - AreaTop) / 2
}

WinAtPos(px, py, ByRef title="", ByRef class="", ByRef x=0, ByRef y=0, ByRef width=0, ByRef height=0)
{
  #NoEnv
  VarSetCapacity(POINT, 8, 0)
  NumPut(px, POINT, 0, "int"), NumPut(py, POINT, 4, "int")
  HWND := DllCall("WindowFromPoint", "Int64", NumGet(POINT, 0, "Int64"))
  HWND := DllCall("GetAncestor", "UInt", HWND, "UInt", GA_ROOT := 2)
  WinExist("ahk_id" . HWND)
  WinGetTitle, title
  WinGetClass, class
  WinGetPos, x, y, width, height
}
