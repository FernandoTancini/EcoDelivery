
local background
local lucio
local ourPhysics
local world
local objects

local lucioVelXMax = 500
local tamanhoDaPista = 8000

local isPersonagemTocandoPista = false

function love.load()
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- background
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = love.graphics.getHeight() / background:getHeight()
  
  -- world
  world = ourPhysics.setupWorld()
  objects = ourPhysics.getObjects(world)
  world:setCallbacks(beginContact, endContact)
  
end

function love.update(dt)
  
  world:update(dt) -- é preciso chamar essa funcao para o phisics atuar com o "seu update"
  
  -- pegar velocidades para usa abaixo
  local lucioVelX, lucioVelY = objects.lucio.body:getLinearVelocity()
  local lucioX, lucioY = objects.lucio.body:getPosition()
  
  -- eventos de teclas pressioandas
  if love.keyboard.isDown("right") then
    objects.lucio.body:applyForce(200, 0)
  end
  if love.keyboard.isDown("left") then
    objects.lucio.body:applyForce(-200, 0)
  end
  
  if love.keyboard.isDown("up") and isPersonagemTocandoPista then
    objects.lucio.body:applyForce(0, -4000)
  end
  
  -- regular velocidade maxima
  if lucioVelX > lucioVelXMax then
    objects.lucio.body:setLinearVelocity(lucioVelXMax, lucioVelY)
  elseif lucioVelX < - lucioVelXMax then
    objects.lucio.body:setLinearVelocity(-lucioVelXMax, lucioVelY)
  end
  
end

function love.draw()
  
  -- background
  love.graphics.setColor(255,255,255)
  love.graphics.draw(background, 0, 0, 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  
  ourPhysics.draw(objects)
  
  
end

function beginContact(a, b, coll)
  if (a:getUserData() == "personagem" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagem") then
    -- teve contato entre pista e personagem
    isPersonagemTocandoPista = true
  end
end
 
function endContact(a, b, coll)
  if (a:getUserData() == "personagem" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagem") then
    -- acabaou contato entre pista e personagem
    isPersonagemTocandoPista = false
  end
end





















