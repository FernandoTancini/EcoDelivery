
local background
local lucio
local ourPhysics
local world
local objects

local lucioVelXMax = 5000
local tamanhoDaPista = 8000
local alturaDaPista = 740

local isPersonagemTocandoPistaL = false
local isPersonagemTocandoPistaR = false
local isPersonagemTocandoPistaT = false
local reset = false

function love.load()
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- background
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = alturaDaPista / background:getHeight()
  
  -- world
  world = ourPhysics.setupWorld()
  objects = ourPhysics.getObjects(world, tamanhoDaPista, alturaDaPista)
  world:setCallbacks(beginContact, endContact)

end

function love.update(dt)
  
  if objects.lucioL.body:getY() > 1500 then
    reset = true
    objects.lucioL.body:setLinearVelocity(0, 0)
    objects.lucioR.body:setLinearVelocity(0, 0)
    objects.lucioT.body:setLinearVelocity(0, 0)
    
    else reset = false
  end
  
  world:update(dt) -- é preciso chamar essa funcao para o phisics atuar com o "seu update"
  
  -- pegar velocidades para usa abaixo
  local lucioVelX, lucioVelY = objects.lucioL.body:getLinearVelocity()
  lucioX, lucioY = objects.lucioL.body:getPosition()
  
  -- eventos de teclas pressioandas
  if love.keyboard.isDown("q") or reset then
    reset = false
    objects.lucioL.body:setAngularVelocity(0)
    objects.lucioR.body:setAngularVelocity(0)
    objects.lucioT.body:setAngularVelocity(0)
    objects.lucioL.body:setAngle(0)
    objects.lucioR.body:setAngle(0)
    objects.lucioT.body:setAngle(0)
    objects.lucioL.body:setLinearVelocity(0, 0)
    objects.lucioR.body:setLinearVelocity(0, 0)
    objects.lucioT.body:setLinearVelocity(0, 0)
    objects.lucioL.body:setPosition(800/2, 600/2)
    objects.lucioR.body:setPosition(800/2+40, 600/2)
    objects.lucioT.body:setPosition(800/2+20, 600/2-20)
    
  end
  
  
  if love.keyboard.isDown("up") then
    objects.lucioL.body:applyForce(200, 0)
    objects.lucioR.body:applyForce(200, 0)
    objects.lucioT.body:setAngularVelocity(0)

  end
  if love.keyboard.isDown("down") then
    objects.lucioL.body:applyForce(-200, 0)
    objects.lucioR.body:applyForce(-200, 0)
    objects.lucioT.body:setAngularVelocity(0)

  end

  if love.keyboard.isDown("right") then
    objects.lucioT.body:setAngularVelocity(math.pi*2)
  end
  
  if love.keyboard.isDown("left") then
    objects.lucioT.body:setAngularVelocity(-math.pi*3)
  end
  
  
  if love.keyboard.isDown("space") and (isPersonagemTocandoPistaL or isPersonagemTocandoPistaR) then
    objects.lucioL.body:applyForce(0, -4000)
    objects.lucioR.body:applyForce(0, -4000)
    objects.lucioT.body:applyForce(0, 0)

  end
  
  -- regular velocidade maxima
  if lucioVelX > lucioVelXMax then
    objects.lucioL.body:setLinearVelocity(lucioVelXMax, lucioVelY)
  elseif lucioVelX < - lucioVelXMax then
    objects.lucioL.body:setLinearVelocity(-lucioVelXMax, lucioVelY)
  end
  
end

function love.draw()
  if objects.lucioL.body:getX() > 200 and objects.lucioL.body:getX() < (tamanhoDaPista - 600) then
    love.graphics.translate(-lucioX+200, -lucioY+450)
  elseif objects.lucioL.body:getX() < 200 then
    love.graphics.translate(0, -lucioY+450)
  elseif objects.lucioL.body:getX() > (tamanhoDaPista - 600) then
    love.graphics.translate(-tamanhoDaPista + 600 + 200, -lucioY+450)
  end
  
  -- background
  love.graphics.setColor(255,255,255)
  for x=0, tamanhoDaPista, (background:getWidth() * backgroundHeightScaleFactor) do
  love.graphics.draw(background, x, (love.graphics.getHeight() - alturaDaPista), 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  ourPhysics.draw(objects)
  
  
end

function beginContact(a, b,  coll)
  if (a:getUserData() == "personagemL" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemL") then
    -- teve contato entre pista e personagem
    isPersonagemTocandoPistaL = true
  end
  if (a:getUserData() == "personagemR" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemR") then
    -- teve contato entre pista e personagem
    isPersonagemTocandoPistaR = true
  end
  if (a:getUserData() == "personagemT" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemT") then
    -- teve contato entre pista e personagem
    reset = true
  end
end
 
function endContact(a, b, coll)
  if (a:getUserData() == "personagemL" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemL") then
    -- acabaou contato entre pista e personagem
    isPersonagemTocandoPistaL = false
  end
  if (a:getUserData() == "personagemR" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemR") then
    -- acabaou contato entre pista e personagem
    isPersonagemTocandoPistaR = false
  end
end

 





















