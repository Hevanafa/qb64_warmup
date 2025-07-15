$Debug
$Let UNCAPPED = 0
'$Include: 'INCLUDES\FPS.BI'
Option _Explicit


Const K_ESC = 27

Const K_W = 119
Const K_A = 97
Const K_S = 115
Const K_D = 100

Const false = 0
Const true = Not false
Const cornflowerBlue = &HFF6495ED

Dim Shared buffer
Dim Shared scaled
buffer = _NewImage(320, 200, 32)
scaled = _NewImage(640, 400, 32)
Screen scaled: _Dest buffer: _Delay 0.1: _Display

Dim Shared done: done = false

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

System


Function isKeyDown% (keycode As Integer)
  isKeyDown = _KeyDown(keycode)
End Function


Function getTimer#
  getTimer = Timer(0.001)
End Function

Sub NPrint (text As String, x As Integer, y As Integer, colour As Long)
  Dim lastColour: lastColour = _DefaultColor
  Color colour
  _PrintString (x, y), text
  Color lastColour
End Sub


'$Include: 'INCLUDES\FPS.BM'
'$Include: 'INCLUDES\CONV.BM'


Sub INIT
  _PrintMode _KeepBackground
  _Font 8

  Randomize Timer

  x = 160
  y = 100
End Sub

Sub NUpdate
  Dim now: now = getTimer
  dt = now - lastTime
  lastTime = now

  incrementFPS

  ' Handle inputs
  If isKeyDown(K_ESC) Then done = true

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

  drawFPS

  _PutImage , buffer, scaled
  _Display
End Sub

