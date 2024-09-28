; Phím tắt để ẩn/hiện biểu tượng Microsoft Edge trong chế độ app cho URL chatgpt.com
^!h:: ; Ctrl + Alt + h để ẩn/hiện
    WinGet, edgeID, List, ahk_exe msedge.exe
    Loop, %edgeID%
    {
        thisEdgeID := edgeID%A_Index%
        WinGetTitle, title, ahk_id %thisEdgeID%
        if InStr(title, "ChatGPT")
        {
            WinGet, style, ExStyle, ahk_id %thisEdgeID%
            if (style & 0x00000080) ; WS_EX_TOOLWINDOW
            {
                WinSet, ExStyle, -0x00000080, ahk_id %thisEdgeID% ; Bỏ ẩn trên taskbar
            }
            else
            {
                WinSet, ExStyle, +0x00000080, ahk_id %thisEdgeID% ; Ẩn trên taskbar
            }
        }
    }
return

; Phím tắt để mở ChatGPT ở chế độ app mode với độ mờ 10%
^!c:: ; ctrl + ALT + C để mở ChatGPT
    ; Kiểm tra xem cửa sổ ChatGPT đã tồn tại chưa
    if !WinExist("ChatGPT")
    {
     Run, "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --app=https://chatgpt.com/
        ; Chờ một chút để cửa sổ mở
        Sleep, 1000
        ; Lấy ID của cửa sổ vừa mở
        WinWait, ChatGPT
        
	 ; Kích thước cửa sổ
        width := 300
        height := 200
        
        ; Đặt vị trí cửa sổ ở giữa theo chiều ngang và dưới cùng theo chiều dọc
        ScreenWidth := A_ScreenWidth
        ScreenHeight := A_ScreenHeight
        x := (ScreenWidth - width) // 2 ; Tính vị trí x để căn giữa
        y := ScreenHeight - height ; Đặt vị trí y ở dưới cùng
        
        ; Đặt kích thước và vị trí cửa sổ
        WinMove, ChatGPT,, x, y-30, width, height

        ; Đặt độ mờ cửa sổ ban đầu (10%)
        global opacity := 50
        WinSet, Transparent, %opacity%, ChatGPT
        WinHide, ChatGPT ; Ẩn cửa sổ ngay sau khi mở
    }
    else
    {
        ; Nếu cửa sổ đã mở, có thể kích hoạt nó
        WinActivate, ChatGPT
    }
return


; Tăng độ trong suốt thêm 5% bằng Shift + 1
!q::
    if (opacity > 0) ; Giới hạn ở mức 100% trong suốt
    {
        opacity -= 10 ; Giảm giá trị opacity để tăng độ trong suốt (5% ~ 13 đơn vị)
        WinSet, Transparent, %opacity%, ChatGPT
    }
return

; Giảm độ trong suốt 5% bằng Shift + 2
!w::
    if (opacity < 255) ; Giới hạn ở mức 0% trong suốt
    {
        opacity += 10 ; Tăng giá trị opacity để giảm độ trong suốt (5% ~ 13 đơn vị)
        WinSet, Transparent, %opacity%, ChatGPT
    }

    ; Nếu giá trị opacity < 15 (hoàn toàn trong suốt), ẩn cửa sổ
    if (opacity < 15)
    {
        WinHide, ChatGPT ; Ẩn cửa sổ khi quá trong suốt
    }
    else
    {
        WinShow, ChatGPT ; Hiển thị lại cửa sổ nếu opacity tăng
    }
return

; Biến trạng thái cửa sổ ChatGPT
chatGPTHidden := false

; Phím tắt để ẩn/hiện cửa sổ ChatGPT khi nhấn ALT + L
!l:: ; ALT + l để ẩn/hiện
    if chatGPTHidden
    {
        WinShow, ChatGPT ; Hiển thị lại cửa sổ
        WinActivate, ChatGPT ; Đưa cửa sổ ra phía trước
        chatGPTHidden := false ; Cập nhật trạng thái
    }
    else
    {
        WinHide, ChatGPT ; Ẩn cửa sổ
        chatGPTHidden := true ; Cập nhật trạng thái
    }
return

#NoTrayIcon


