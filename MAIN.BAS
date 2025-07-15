$Debug
$Let UNCAPPED = 0
'$Include: 'INCLUDES\VGA.BI'
'$Include: 'INCLUDES\FPS.BI'
Option _Explicit


Const K_ESC = 27

Const K_W = 119
Const K_A = 97
Const K_S = 115
Const K_D = 100

Const False = 0
Const True = Not False
Const cornflowerBlue = &HFF6495ED

Common Shared As Long imgMacJago
Dim Shared done: done = False

_Title "Hello again QB64!"

Dim Shared As Double lastTime, dt
lastTime = getTimer
Dim Shared As Double nextUpdateTick

Dim Shared As Integer x, y


INIT

$If UNCAPPED Then

  Do
    NUpdate
    NDraw
  Loop Until done

$Else

  Do
    ' Web version has a hard limit of the user's refresh rate
    _Limit 60

    Dim now: now = getTimer
  
    If now >= nextUpdateTick Then
      nextUpdateTick = now + 1.0 / 60
      NUpdate
      NDraw
    End If
  Loop Until done

$End If

freeImage imgMacJago

System


Function isKeyDown% (keycode As Integer)
  isKeyDown = _KeyDown(keycode)
End Function


Function getTimer#
  getTimer = Timer(0.001)
End Function

'$Include: 'INCLUDES\VGA.BM'
'$Include: 'INCLUDES\BITMAP.BM'
'$Include: 'INCLUDES\FPS.BM'
'$Include: 'INCLUDES\CONV.BM'


Sub INIT
  initBuffer

  ' Turns off black background of _PrintString
  _PrintMode _KeepBackground
  _Font 8

  Randomize Timer

  x = 160
  y = 100

  loadImage imgMacJago, "IMG\ntupin Mac Jago.png"
End Sub

Sub NUpdate
  Dim now: now = getTimer
  dt = now - lastTime
  lastTime = now

  incrementFPS

  ' Handle inputs
  If isKeyDown(K_ESC) Then done = True

  If isKeyDown(K_W) Then y = y - 1
  If isKeyDown(K_S) Then y = y + 1
  If isKeyDown(K_A) Then x = x - 1
  If isKeyDown(K_D) Then x = x + 1
End Sub


Sub NDraw
  Cls , cornflowerBlue

  NPrint "Hello again QB64!", 8, 8, &HFFFFFFFF

  NPrint f32str(dt), 8, 20, &HFFFFFFFF

  Circle (x, y), 5, &HFFFFFFFF

  NPset 100, 100, &HFFFFFFFF

  ' nprint "Handle: " + i32str(imgMacJago), 10, 30, &HFFFFFFFF

  spr imgMacJago, 10, 20
  ' _putimage (10, 20), imgMacJago
  

  drawFPS

  _PutImage , surface, scaled
  _Display
End Sub


