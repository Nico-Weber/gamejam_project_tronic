--Copyright (C) 2021 Nico Weber


--[[
  X = done
  * = currently working at

  TODO:
  1. playercharacter class X
  2. minimal movement
    2.1 input binding to movement X
    2.2 gravity *
    2.3 collision *
      2.3.1 down *
      2.3.1 up
      2.3.1 left
      2.3.1 right
    2.4 jumping
  3. camera control X
    3.1 easing interpolation X
  4. gamerules
    4.1 lifes, death
    4.2 danger
    4.3 switching Levels
    4.4 collectibles
  5. playercharacter extended
    5.1 portals
    5.2 changing form
    5.2 general refining
  6. adding assets
    6.1 animation
    6.2 music
    6.3 sound
  (7. endgame mechanics)
]]

--IMPORTANT
-- 8px = 1x1 spriteblock unit

--GLOBAL VARIABLES
local PLAYER1_SPRITE = {16,32}
local TEXT_COLOR = 14;
local CameraFocus = NewPoint(x,y)

--CLASSES
Pawn = {} --Pawn class defined

function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2
end

function Pawn:new(name,x,y) --creating an instance of class Pawn
  local newObject = {
    name = name,
    pos = NewPoint(x,y),
    speed = 10,
    flagID = -1
 }
  self.__index = self
  return setmetatable(newObject, self)
end

function Pawn:printPos() -- print position (x|y) of pawn
  DrawText(self.name .. ":" .. tostring(self.pos),1*8,1*8,DrawMode.Sprite,"large",TEXT_COLOR)
end


function Init()
  BackgroundColor(3)
  player1 = Pawn:new("Player_1",50,50)
  player1.speed = 1
end


function Update(timeDelta)
--PLAYER 1:
  --CONTROLS
  if(Button(Buttons.Right, InputState.Down, 0)) then
    player1.pos.x += player1.speed
  end
  if(Button(Buttons.Left, InputState.Down, 0)) then
    player1.pos.x -= player1.speed
  end
  if(Button(Buttons.Up, InputState.Down, 0)) then
    player1.pos.y -= player1.speed
  end
  if(Button(Buttons.Down, InputState.Down, 0)) then
    player1.pos.y += player1.speed
  end
  if(Button(Buttons.A, InputState.Down, 0)) then
    --DEBUG
  end
  --GRAVITY
  player1.pos.y = Repeat(player1.pos.y + 1,Display().y)
  --COLLISION
  player1.flagID = Flag(player1.pos.x/8, player1.pos.y/8)
  DrawText("Collision: " .. player1.flagID,1*8,2*8,DrawMode.Sprite,"large",TEXT_COLOR)
  if(player1.flagID == 0) then
    --TODO add penetration resolution
    DrawText("Colliding!",1*8,3*8,DrawMode.Sprite,"large",TEXT_COLOR)
  end
  --CAMERA-SCROLLING
  CameraFocus.x = lerp(CameraFocus.x,player1.pos.x-Display().x/2,0.04)
  CameraFocus.y = lerp(CameraFocus.y,player1.pos.y-Display().y/2,0.012)
  ScrollPosition(CameraFocus.x,CameraFocus.y)
  --GENERAL UPDATE CODE
  player1:printPos()
end


function Draw()
  RedrawDisplay()

  DrawSprites(PLAYER1_SPRITE, player1.pos.x-4, player1.pos.y-16, 1)

end
