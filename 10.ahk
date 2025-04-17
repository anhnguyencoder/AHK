#NoTrayIcon

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

    ; Ẩn/hiện các ứng dụng với lớp TkTopLevel
    WinGet, appID, List, ahk_class TkTopLevel
    Loop, %appID%
    {
        thisAppID := appID%A_Index%
        ; Kiểm tra trạng thái hiện tại của ứng dụng và ẩn/hiện nó trên taskbar
        WinGet, style, ExStyle, ahk_id %thisAppID%
        if (style & 0x00000080) ; WS_EX_TOOLWINDOW
        {
            WinSet, ExStyle, -0x00000080, ahk_id %thisAppID% ; Bỏ ẩn trên taskbar
        }
        else
        {
            WinSet, ExStyle, +0x00000080, ahk_id %thisAppID% ; Ẩn trên taskbar
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
        height := 250
        
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


; Biến độ mờ (opacity) mặc định
global opacity := 50 ; Giá trị độ mờ ban đầu (10%)











; Tăng độ trong suốt thêm 5% bằng Shift + 1
!q:: ; ALT + Q để tăng độ trong suốt
    if (opacity > 5) ; Giới hạn ở mức 100% trong suốt
    {
        opacity -= 10 ; Giảm giá trị opacity để tăng độ trong suốt (5% ~ 10 đơn vị)
        ; Cập nhật độ mờ cho cả ba ứng dụng
        WinSet, Transparent, %opacity%, ChatGPT
        WinSet, Transparent, %opacity%, AutoPaste
        WinSet, Transparent, %opacity%, STT
    }
return

; Giảm độ trong suốt 5% bằng Shift + 2
!w:: ; ALT + W để giảm độ trong suốt
    if (opacity < 255) ; Giới hạn ở mức 0% trong suốt
    {
        opacity += 10 ; Tăng giá trị opacity để giảm độ trong suốt (5% ~ 10 đơn vị)
        ; Cập nhật độ mờ cho cả ba ứng dụng
        WinSet, Transparent, %opacity%, ChatGPT
        WinSet, Transparent, %opacity%, AutoPaste
        WinSet, Transparent, %opacity%, STT
    }

    ; Nếu giá trị opacity < 15 (hoàn toàn trong suốt), ẩn cửa sổ
    if (opacity < 15)
    {
        WinHide, ChatGPT ; Ẩn cửa sổ khi quá trong suốt
        WinHide, AutoPaste ; Ẩn cửa sổ khi quá trong suốt
        WinHide, STT ; Ẩn cửa sổ khi quá trong suốt
    }
    else
    {
        WinShow, ChatGPT ; Hiển thị lại cửa sổ nếu opacity tăng
        WinShow, AutoPaste ; Hiển thị lại cửa sổ nếu opacity tăng
        WinShow, STT ; Hiển thị lại cửa sổ nếu opacity tăng
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



; Biến trạng thái cửa sổ AutoPaste
autoPasteHidden := false


; Phím tắt để ẩn/hiện cửa sổ AutoPaste khi nhấn ALT + J
!j:: ; ALT + j để ẩn/hiện
    if autoPasteHidden
    {
        ; Sử dụng tiêu đề cửa sổ để xác định AutoPaste
        WinShow, AutoPaste ; Hiển thị lại cửa sổ AutoPaste
        WinActivate, AutoPaste ; Đưa cửa sổ ra phía trước
        autoPasteHidden := false ; Cập nhật trạng thái
    }
    else
    {
        WinHide, AutoPaste ; Ẩn cửa sổ AutoPaste
        autoPasteHidden := true ; Cập nhật trạng thái
    }
return


; Biến trạng thái cửa sổ STT
sttHidden := false
; Phím tắt để ẩn/hiện cửa sổ STT khi nhấn ALT + K
!k:: ; ALT + k để ẩn/hiện
    if sttHidden
    {
        ; Sử dụng tiêu đề cửa sổ để xác định STT
        WinShow, STT ; Hiển thị lại cửa sổ STT
        WinActivate, STT ; Đưa cửa sổ ra phía trước
        sttHidden := false ; Cập nhật trạng thái
    }
    else
    {
        WinHide, STT ; Ẩn cửa sổ STT
        sttHidden := true ; Cập nhật trạng thái
    }
return









; Phím tắt để mở STT ở chế độ app mode với độ mờ 10%
^!s:: ; Ctrl + Alt + S để mở STT
    ; Kiểm tra xem cửa sổ STT đã tồn tại chưa
    if !WinExist("STT") ; Kiểm tra tiêu đề cửa sổ STT
    {
        Run, "C:\Users\Anhnguyencoder\AppData\Local\Programs\Python\Python313\pythonw.exe" "D:\ANHNGUYENCODER\Speech-To-Text\latest version\app.py", , Hide
        ; Chờ một chút để cửa sổ mở
        Sleep, 1000
        ; Lấy ID của cửa sổ STT dựa vào tiêu đề
        WinWait, STT
        
        ; Kích thước cửa sổ
        width := 150
        height := 170
        
        ; Đặt vị trí cửa sổ ở giữa theo chiều ngang và dưới cùng theo chiều dọc
        ScreenWidth := A_ScreenWidth
        ScreenHeight := A_ScreenHeight
        x := (ScreenWidth - width) // 2 ; Tính vị trí x để căn giữa
        y := ScreenHeight - height ; Đặt vị trí y ở dưới cùng
        
        ; Đặt kích thước và vị trí cửa sổ
        WinMove, STT,, x+300, y-50, width, height

        ; Đặt độ mờ cửa sổ ban đầu (10%)
        global opacity := 50
        WinSet, Transparent, %opacity%, STT
        WinHide, STT ; Ẩn cửa sổ ngay sau khi mở
    }
    else
    {
        ; Nếu cửa sổ đã mở, có thể kích hoạt nó
        WinActivate, STT
    }
return

; Phím tắt để mở AutoPaste ở chế độ app mode với độ mờ 10%
^!a:: ; Ctrl + Alt + A để mở AutoPaste
    ; Kiểm tra xem cửa sổ AutoPaste đã tồn tại chưa
    if !WinExist("AutoPaste") ; Kiểm tra tiêu đề cửa sổ AutoPaste
    {
        Run, "C:\Users\anhnguyencoder\AppData\Local\Programs\Python\Python312\pythonw.exe" "D:\GitHub\Auto Paste\app.py", , Hide
        ; Chờ một chút để cửa sổ mở
        Sleep, 1000
        ; Lấy ID của cửa sổ AutoPaste dựa vào tiêu đề
        WinWait, AutoPaste
        
        ; Kích thước cửa sổ
        width := 120
        height := 110
        
        ; Đặt vị trí cửa sổ ở giữa theo chiều ngang và dưới cùng theo chiều dọc
        ScreenWidth := A_ScreenWidth
        ScreenHeight := A_ScreenHeight
        x := (ScreenWidth - width) // 2 ; Tính vị trí x để căn giữa
        y := ScreenHeight - height ; Đặt vị trí y ở dưới cùng
        
        ; Đặt kích thước và vị trí cửa sổ
        WinMove, AutoPaste,, x-300, y-60, width, height

        ; Đặt độ mờ cửa sổ ban đầu (10%)
        global opacity := 50
        WinSet, Transparent, %opacity%, AutoPaste
        WinHide, AutoPaste ; Ẩn cửa sổ ngay sau khi mở
    }
    else
    {
        ; Nếu cửa sổ đã mở, có thể kích hoạt nó
        WinActivate, AutoPaste
    }
return


!r:: ; Khi nhấn Alt + R
Run, "C:\Program Files\Capture2Text_v4.6.3_64bit\Capture2Text\Capture2Text.exe" ; Mở Capture2Text
return


