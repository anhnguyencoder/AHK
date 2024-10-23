; Script để hiện tọa độ chuột
#Persistent
SetTimer, WatchMouse, 100
Return

WatchMouse:
MouseGetPos, x, y
ToolTip, X: %x%`nY: %y%
Return

~Esc:: ; Nhấn Esc để tắt
    ToolTip
    ExitApp
