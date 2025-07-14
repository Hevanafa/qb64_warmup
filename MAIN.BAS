$Debug
$Let UNCAPPED = 0
Option _Explicit

' Implement module separation like unit files in Pascal
' Maybe BMFont support?
' Implement rotated sprite with a pair of triangles

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

Dim Shared As Double lastFPSTime
Dim Shared As Integer fps, lastFPS

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


Sub INIT
  _PrintMode _KeepBackground
  _Font 8

  Randomize Timer

  x = 160
  y = 100
End Sub


Function getTimer#
  getTimer = Timer(0.001)
End Function


Sub incrementFPS
  Dim now: now = getTimer
  If now >= lastFPSTime + 1.0 Then
    lastFPSTime = now
    lastFPS = fps
    fps = 1
  Else
    fps = fps + 1
  End If
End Sub

Sub drawFPS
  Color &HFFFFFF00
  _PrintString (240, 0), "FPS:" + Str$(lastFPS)
  Color &HFFFFFFFF
End Sub


Sub NUpdate
  Dim now: now = getTimer
  dt = now - lastTime
  lastTime = now

  incrementFPS

  ' Handle inputs
  If _KeyDown(K_ESC) Then done = true

  If _KeyDown(K_W) Then y = y - 1
  If _KeyDown(K_S) Then y = y + 1
  If _KeyDown(K_A) Then x = x - 1
  If _KeyDown(K_D) Then x = x + 1

End Sub


Sub NDraw
  Cls , cornflowerBlue

  Color &HFFFFFFFF
  _PrintString (8, 8), "Hello again QB64!"

  _PrintString (8, 20), Str$(dt)

  Circle (x, y), 5, &HFFFFFFFF

  drawFPS

  _PutImage , buffer, scaled
  _Display
End Sub

