; Phím tắt để ẩn/hiện biểu tượng Notepad
^!h:: ; Ctrl + Alt + H để ẩn/hiện
    WinGet, notepadID, List, ahk_exe notepad.exe
    Loop, %notepadID%
    {
        thisNotepadID := notepadID%A_Index%
        WinGetTitle, title, ahk_id %thisNotepadID%
        if InStr(title, "Untitled") ; Có thể thay đổi tên nếu bạn có file mở
        {
            WinGet, style, ExStyle, ahk_id %thisNotepadID%
            if (style & 0x00000080) ; WS_EX_TOOLWINDOW
            {
                WinSet, ExStyle, -0x00000080, ahk_id %thisNotepadID% ; Bỏ ẩn trên taskbar
            }
            else
            {
                WinSet, ExStyle, +0x00000080, ahk_id %thisNotepadID% ; Ẩn trên taskbar
            }
        }
    }
return

; Phím tắt để mở Notepad với độ mờ 10%
^!n:: ; Ctrl + Alt + N để mở Notepad
    ; Kiểm tra xem Notepad đã tồn tại chưa
    if !WinExist("Untitled - Notepad")
    {
        Run, notepad.exe
        ; Chờ một chút để Notepad mở
        Sleep, 1000
        ; Lấy ID của cửa sổ vừa mở
        WinWait, Untitled - Notepad
        
        ; Đặt kích thước và vị trí cửa sổ
        width := 400
        height := 300
        x := (A_ScreenWidth - width) // 2 ; Căn giữa
        y := (A_ScreenHeight - height) // 2 ; Căn giữa
        
        ; Đặt kích thước và vị trí cửa sổ
        WinMove, Untitled - Notepad,, x, y, width, height

        ; Đặt độ mờ cửa sổ ban đầu (10%)
        global opacity := 50
        WinSet, Transparent, %opacity%, Untitled - Notepad
        WinHide, Untitled - Notepad ; Ẩn cửa sổ ngay sau khi mở
    }
    else
    {
        ; Nếu cửa sổ đã mở, có thể kích hoạt nó
        WinActivate, Untitled - Notepad
    }
return

; Tăng độ trong suốt thêm 5% bằng phím tắt Alt + a
!a:: 
    if (opacity > 0) ; Giới hạn ở mức 100% trong suốt
    {
        opacity -= 10 ; Giảm giá trị opacity để tăng độ trong suốt
        WinSet, Transparent, %opacity%, Untitled - Notepad
    }
return

; Giảm độ trong suốt 5% bằng phím tắt Alt + s
!s:: 
    if (opacity < 255) ; Giới hạn ở mức 0% trong suốt
    {
        opacity += 10 ; Tăng giá trị opacity để giảm độ trong suốt
        WinSet, Transparent, %opacity%, Untitled - Notepad
    }

    ; Nếu giá trị opacity < 15 (hoàn toàn trong suốt), ẩn cửa sổ
    if (opacity < 15)
    {
        WinHide, Untitled - Notepad ; Ẩn cửa sổ khi quá trong suốt
    }
    else
    {
        WinShow, Untitled - Notepad ; Hiển thị lại cửa sổ nếu opacity tăng
    }
return

; Biến trạng thái cửa sổ Notepad
notepadHidden := false

; Phím tắt để ẩn/hiện cửa sổ Notepad khi nhấn ALT + L
^;:: ; alt+ l để ẩn/hiện
    if notepadHidden
    {
        WinShow, Untitled - Notepad ; Hiển thị lại cửa sổ
        WinActivate, Untitled - Notepad ; Đưa cửa sổ ra phía trước
        notepadHidden := false ; Cập nhật trạng thái
    }
    else
    {
        WinHide, Untitled - Notepad ; Ẩn cửa sổ
        notepadHidden := true ; Cập nhật trạng thái
    }
return
