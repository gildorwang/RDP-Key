# RDP-Key
An AutoHotKey script providing hotkeys to minimize/restore/switch between Remote Desktop (mstsc) sessions. Essentially this is a script I wrote a few years ago and has been by far my most frequently used script. 

With this script you can totally get rid of the annoying floating bar on top of your Remote Desktop session. No more need to reach your mouse and hit that small button.

## Usage
* Ctrl-Shift-CapsLock: Minimize/restore RDP window
* Ctrl-CapsLock: Rotate between RDP windows
* Alt-CapsLock: Switch between 2 most recent RDP windows
* Alt-Shift-CapsLock: Restore fullscreen RDP into window mode

## Script versions
Two script versions are included. Use the matching main script and include file together:

* **AutoHotkey v1:** `RDPKey.ahk` with `common.ahk`
* **AutoHotkey v2:** `RDPKeyV2.ahk` with `commonV2.ahk`

Keep each pair in the same folder; do not mix files between versions. The v2 script requires AutoHotkey v2. When running the v2 script directly, keep `RDPKey16.ico` in the same folder as well. The compiled v2 executable is `RDPKeyV2.exe`.

## Download
Find the latest release [here](https://github.com/gildorwang/RDP-Key/releases/latest).
