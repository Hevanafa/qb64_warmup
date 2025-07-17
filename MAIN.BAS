$Debug
$Let UNCAPPED = 0
Option _Explicit

'$Include: 'INCLUDES\VGA.BI'
'$Include: 'INCLUDES\TIMING.BI'
'$Include: 'INCLUDES\FPS.BI'
'$Include: 'INCLUDES\CONV.BI'
'$include: 'INCLUDES\CAMERA.BI'


Const K_ESC = 27

Const K_W = 119
Const K_A = 97
Const K_S = 115
Const K_D = 100

const K_UP = 18432
const K_DOWN = 20480
const K_LEFT = 19200
const K_RIGHT = 19712

Const False = 0
Const True = Not False
Const cornflowerBlue = &HFF6495ED

' Game state
Dim Shared done: done = False
Common Shared As Long imgMacJago, imgTilemap
Dim Shared As Integer x, y

' More of your game state here

Dim Shared As Double nextUpdateTick


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


'$Include: 'INCLUDES\VGA.BM'
'$Include: 'INCLUDES\BITMAP.BM'
'$Include: 'INCLUDES\CONV.BM'
'$Include: 'INCLUDES\TIMING.BM'
'$Include: 'INCLUDES\FPS.BM'
'$include: 'INCLUDES\CAMERA.BM'


Sub INIT
  initBuffer

  _Title "Hello again QB64!"

  ' Turns off black background of _PrintString
  _PrintMode _KeepBackground
  _Font 8
  _ScreenMove _Middle

  Randomize Timer

  x = 160
  y = 100

  ' loadImage imgMacJago, "IMG\ntupin Mac Jago.png"
  loadImage imgTilemap, "IMG\tilemap.png"
End Sub

Sub NUpdate
  updateDeltaTime
  incrementFPS

  ' Handle inputs
  If isKeyDown(K_ESC) Then done = True

  If isKeyDown(K_W) Then y = y - 1
  If isKeyDown(K_S) Then y = y + 1
  If isKeyDown(K_A) Then x = x - 1
  If isKeyDown(K_D) Then x = x + 1

  if isKeyDown(K_UP) then cameraY = cameraY - 1
  if isKeyDown(K_DOWN) then cameraY = cameraY + 1
  if isKeyDown(K_LEFT) then cameraX = cameraX - 1
  if isKeyDown(K_RIGHT) then cameraX = cameraX + 1
  
End Sub


Sub NDraw
  Cls , cornflowerBlue

  NPrint "Hello again QB64!", 8, 8, &HFFFFFFFF

  NPrint f32str(dt), 8, 20, &HFFFFFFFF

  Circle (x, y), 5, &HFFFFFFFF

  NPset 100, 100, &HFFFFFFFF

  nprint "Camera: {" + i32str(cameraX) + ", " + i32str(cameraY) + "}", 10, 40, &hFFFFFFFF
  
  ' nprint "Handle: " + i32str(imgMacJago), 10, 30, &HFFFFFFFF

  ' spr imgMacJago, 10, 20
  ' spr imgTilemap, 10, 10
  sprRegion imgTilemap, 34, 17, 16, 16, 10, 30
  ' _putimage (10, 20), imgMacJago
  

  drawFPS

  _PutImage , surface, scaled
  _Display
End Sub


