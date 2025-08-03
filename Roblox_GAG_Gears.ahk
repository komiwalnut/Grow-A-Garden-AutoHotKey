#Requires AutoHotkey v2.0

running := false

F1::StartScript()
F2::StopScript()
Esc::ExitApp

; Helper function to safely move mouse with offset and sleep
SafeMove(offsetX, offsetY) {
    global running
    if !running
        return false
    MouseGetPos(&x, &y)
    MouseMove(x + offsetX, y + offsetY, 0)
    Sleep(500)
    return running
}

; Helper function to click multiple times with checks
SafeClickMultiple(times, delay := 300) {
    global running
    Loop times {
        if !running
            return false
        Click()
        Sleep(delay)
    }
    return running
}

; Helper function for scroll and click pattern
ScrollAndClick(direction, moveX := 0, moveY := 0, clickCount := 1) {
    global running
    if !running
        return false
    
    Click("Wheel" . direction)
    Sleep(1000)
    
    if !SafeMove(moveX, 0)
        return false
    if !running
        return false
    
    Click()
    Sleep(500)
    
    if moveY != 0 {
        MouseGetPos(&x, &y)
        MouseMove(x, y + moveY, 0)
        if !running
            return false
    }
    
    return SafeClickMultiple(clickCount)
}

StartScript() {
    global running
    running := true
    
    while running {
        ; Initial position and click
        MouseMove(830, 530, 0)
        if !SafeMove(3, 0) || !running
            break
        Click()
        Sleep(1000)
        
        ; Second position and click 3 times
        MouseMove(830, 665, 0)
        if !SafeMove(-3, 0) || !running
            break
        if !SafeClickMultiple(3)
            break
        
        ; Repeat scroll pattern 8 times
        Loop 8 {
            if !ScrollAndClick("Down", -3, 10, 3)
                break
        }
        if !running
            break

	    ; Repeat scroll pattern 7 times
        Loop 7 {
            if !ScrollAndClick("Down", -3, 8, 3)
                break
        }
        if !running
            break
        
        ; Final scroll down pattern
        if !ScrollAndClick("Down", 3, 20, 3)
            break
        
        ; Scroll up 20 times
        Loop 20 {
            if !running
                break
            Click("WheelUp")
            Sleep(200)
        }
        if !running
            break
        
        Sleep(500)
    }
}

StopScript() {
    global running
    running := false
}