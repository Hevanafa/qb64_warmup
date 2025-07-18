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

Const False = 0
Const True = Not False
Const cornflowerBlue& = &HFF6495ED

' Game state
Dim Shared done: done = False
dim shared isGrounded, isJumping
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

sub jump
  isGrounded = false
  isJumping = true
  jumpEndTick = getTimer + 0.5
end sub


Function isKeyDown% (keycode As Integer)
  isKeyDown = _KeyDown(keycode)
End Function

'$include: 'INCLUDES\LOGGER.BM'
'$Include: 'INCLUDES\VGA.BM'
'$Include: 'INCLUDES\BITMAP.BM'
'$Include: 'INCLUDES\CONV.BM'
'$Include: 'INCLUDES\TIMING.BM'
'$Include: 'INCLUDES\FPS.BM'
'$include: 'INCLUDES\CAMERA.BM'
'$include: 'INCLUDES\GRAPHICS.BM'
'$include: 'INCLUDES\BMFONT.BM'
'$include: 'INCLUDES\STRINGS.BM'


Sub INIT
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

  ' Handle inputs
  If isKeyDown(K_ESC) Then done = True

  ' If isKeyDown(K_W) Then y = y - 1
  ' If isKeyDown(K_S) Then y = y + 1
  If isKeyDown(K_A) Then playerZone.x = playerZone.x - 1
  If isKeyDown(K_D) Then playerZone.x = playerZone.x + 1

  if isGrounded and not isJumping then
    if isKeyDown(K_Z) then jump
  end if

  if isJumping then
    playerZone.vy = -1.5

    if isKeyDown(K_Z) then
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
  drawPhysicsZone playerZone

  drawFPS
  flush
End Sub


