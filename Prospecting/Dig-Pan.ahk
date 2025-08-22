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

; Helper function for the new action sequence
ActionSequence() {
    global running
    if !running
        return false
    
    ; Loop 2 times
    Loop 2 {
        ; 1. Click and hold left click for 0.25 seconds then wait 1 second
        Click("Down")
        Sleep(250)
        Click("Up")
        Sleep(1000)
        if !running
            return false
    }
    
    ; 2. Press W for 0.5 seconds then wait 1 second
    Send("{w Down}")
    Sleep(500)
    Send("{w Up}")
    Sleep(1000)
    if !running
        return false
    
    ; 3. Left click once and wait 0.8 seconds
    Click()
    Sleep(800)
    if !running
        return false
    
    ; 4. Left click and hold for 5 seconds then wait for 2 seconds
    Click("Down")
    Sleep(5000)
    Click("Up")
    Sleep(2000)
    if !running
        return false
    
    ; 5. Press S for 0.5 seconds then wait 0.8 seconds
    Send("{s Down}")
    Sleep(500)
    Send("{s Up}")
    Sleep(800)
    
    return running
}

StartScript() {
    global running
    running := true
    
    while running {
        ; Perform the action sequence
        if !ActionSequence()
            break
    }
}

StopScript() {
    global running
    running := false
}
