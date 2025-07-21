$Debug
$Let UNCAPPED = 0
Option _Explicit

'$Include: 'INCLUDES\VGA.BI'
'$Include: 'INCLUDES\TIMING.BI'
'$Include: 'INCLUDES\FPS.BI'
'$Include: 'INCLUDES\CONV.BI'
'$include: 'INCLUDES\CAMERA.BI'
'$include: 'INCLUDES\GRAPHICS.BI'
'$include: 'INCLUDES\BMFONT.BI'

type TRect
  as integer x, y, width, height
end type

type TPhysicsRect
  as double x, y, width, height
  as double vx, vy
end type

' In case PI isn't included yet
' const PI# = 3.1415926535
const GRAVITY# = 0.03 ' Acceleration, applied per frame

Const K_ESC = 27

Const K_W = 119
Const K_A = 97
Const K_S = 115
Const K_D = 100
const K_Z = 122

const K_UP = 18432
const K_DOWN = 20480
const K_LEFT = 19200
const K_RIGHT = 19712
const K_SPACEBAR = 32

Const False = 0
Const True = Not False
Const cornflowerBlue& = &HFF6495ED

' Mouse inputs
dim shared as integer mouseX, mouseY, mouseButton

' Game state
Dim Shared as integer done: done = False
dim shared as integer _
  isGrounded, isJumping, hasJumpButtonDown

dim shared as double jumpEndTick

' Dim Shared As Integer x, y

' More of your game state here

Dim Shared As Double nextUpdateTick
dim shared as TPhysicsRect playerZone


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

' Your cleanup code here
closeLogger

initTextMode
_mouseShow

System


' implementation

function getScreenWidth%
  getScreenWidth = _width
end function

function getScreenHeight%
  getScreenHeight = _height
end function


sub updatePhysics
  playerZone.vy = playerZone.vy + GRAVITY

  playerZone.x = playerZone.x + playerZone.vx
  playerZone.y = playerZone.y + playerZone.vy

  if playerZone.y + playerZone.height >= _height then 
    playerZone.y = _height - playerZone.height
    playerZone.vy = 0
    isGrounded = true
  end if
end sub

sub initPlayerZone
  playerZone.x = 160
  playerZone.y = 100
  playerZone.width = 24
  playerZone.height = 32
end sub

' sub updatePlayerZone
'   playerZone.x = x
'   playerZone.y = y
' end sub

sub drawZone(zone as TRect)
  rect zone.x, zone.y, zone.x + zone.width - 1, zone.y + zone.height - 1, &hFFFFFFFF
end sub

sub drawPhysicsZone(zone as TPhysicsRect)
  rect zone.x, zone.y, zone.x + zone.width - 1, zone.y + zone.height - 1, &hFF808000
  NPset zone.x, zone.y, &hFFFFFFFF
end sub


Function isKeyDown% (keycode As Integer)
  isKeyDown = _KeyDown(keycode)
End Function

'$include: 'INCLUDES\LOGGER.BM'
'$include: 'INCLUDES\MATHS.BM'
'$Include: 'INCLUDES\VGA.BM'
'$Include: 'INCLUDES\BITMAP.BM'
'$Include: 'INCLUDES\CONV.BM'
'$Include: 'INCLUDES\TIMING.BM'
'$Include: 'INCLUDES\FPS.BM'
'$include: 'INCLUDES\CAMERA.BM'
'$include: 'INCLUDES\GRAPHICS.BM'
'$include: 'INCLUDES\BMFONT.BM'
'$include: 'INCLUDES\STRINGS.BM'

sub updateMouse
  while _mouseInput
    mouseX = _mouseX \ 2
    mouseY = _mouseY \ 2

    ' The signs have to be flipped due to how True is encoded as -1
    mouseButton = _shl(-_mouseButton(2), 1) + -_mouseButton(1)
  wend
end sub


Sub INIT
  _mouseHide

  initLogger
  initBuffer
  startScaledMode

  writeLog "Starting game..."

  _Title "Platforming"

  ' Turns off black background of _PrintString
  _PrintMode _KeepBackground
  _Font 8
  _ScreenMove _Middle

  Randomize Timer

  ' x = 160
  ' y = 100

  initPlayerZone

  ' loadImage imgMacJago, "IMG\ntupin Mac Jago.png"
End Sub

Sub NUpdate
  updateDeltaTime
  incrementFPS
  updateMouse

  ' Handle inputs
  If isKeyDown(K_ESC) Then done = True

  ' If isKeyDown(K_W) Then y = y - 1
  ' If isKeyDown(K_S) Then y = y + 1
  If isKeyDown(K_A) Then playerZone.x = playerZone.x - 1
  If isKeyDown(K_D) Then playerZone.x = playerZone.x + 1

  hasJumpButtonDown = (isKeyDown(K_Z) or isKeyDown(K_SPACEBAR))

  if isGrounded and not isJumping then
    if hasJumpButtonDown then
      isGrounded = false
      isJumping = true
      jumpEndTick = getTimer + 0.5
    end if
  end if

  if isJumping then
    playerZone.vy = -1.5

    if hasJumpButtonDown then
      if getTimer >= jumpEndTick then
        isJumping = false
        playerZone.vy = 0
      end if
    else
      isJumping = false
      playerZone.vy = 0
    end if
  end if

  if isKeyDown(K_UP) then cameraY = cameraY - 1
  if isKeyDown(K_DOWN) then cameraY = cameraY + 1
  if isKeyDown(K_LEFT) then cameraX = cameraX - 1
  if isKeyDown(K_RIGHT) then cameraX = cameraX + 1

  updatePhysics
  ' updatePlayerZone
End Sub


Sub NDraw
  Cls , cornflowerBlue

  ' rect 10, 10, 25, 50, &hFFFFFFFF
  nPrint "Mouse: {" + i32str(mouseX) + ", " + i32str(mouseY) + "}", 0, 0, &hFFFFFFFF
  nPrint "Buttons: " + i32str(mouseButton), 0, 8, &hFFFFFFFF
  nPset mouseX, mouseY, &hFFFFFFFF

  drawPhysicsZone playerZone

  drawFPS
  flush
End Sub


