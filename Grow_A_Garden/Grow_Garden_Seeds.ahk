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

; Helper function to hold left click for specified duration
SafeClickHold(duration := 5000) {
    global running
    if !running
        return false
    Click("Down")
    Sleep(duration)
    Click("Up")
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
ScrollAndClick(direction, moveX := 0, moveY := 0, holdDuration := 5000) {
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
    
    return SafeClickHold(holdDuration)
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
        Sleep(500)
        
        ; Second position and hold click for 5 seconds
        MouseMove(830, 665, 0)
        if !SafeMove(-3, 0) || !running
            break
        if !SafeClickHold(5000)
            break
        
        ; Repeat scroll pattern 12 times
        Loop 12 {
            if !ScrollAndClick("Down", -3, 10, 5000)
                break
        }
        if !running
            break

	    ; Repeat scroll pattern 12 times
        Loop 12 {
            if !ScrollAndClick("Down", -3, 8, 5000)
                break
        }
        if !running
            break
        
        ; Final scroll down pattern
        if !ScrollAndClick("Down", 3, 20, 5000)
            break
        
        ; Scroll up 29 times
        Loop 29 {
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