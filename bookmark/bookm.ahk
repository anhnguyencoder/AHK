; Script để nhấp chuột vào vị trí (1200, 130) ngay lập tức khi nhấn Alt + S
!s::
{
    ; Lưu vị trí chuột hiện tại
    MouseGetPos, originalX, originalY

    ; Di chuyển chuột đến vị trí cụ thể và nhấp chuột
    MouseMove, 1200, 130 
    Click

    ; Quay trở lại vị trí ban đầu
    MouseMove, originalX, originalY  
}
return
