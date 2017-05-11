
local background
local lucio
local ourPhysics
local world
local objects

local lucioVelXMax = 500
local larguraDoMundo = 8000
local windowWidth = 800
local windowHeight = 600
local leftMarginForMoviment = 150
local rightMarginForMoviment = 150

local posicaoXJanelaComRelacaoAPista = 0
local velXJanelaComrelacaoAPista = 0

local backgroundHeightScaleFactor = 1
local quantidadeDeBackgroundsARepetir = 1

local velocidadeDoPersonagemAntesDaColisao = 0

local isPersonagemTocandoPista = false

function love.load()
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- background
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = love.graphics.getHeight() / background:getHeight()
  quantidadeDeBackgroundsARepetir = larguraDoMundo / (backgroundHeightScaleFactor * background:getWidth())
  
  -- world
  world = ourPhysics.setupWorld()
  objects = ourPhysics.getObjects(world, larguraDoMundo, windowWidth, windowHeight, leftMarginForMoviment, rightMarginForMoviment)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
end

function love.update(dt)
  
  world:update(dt) -- é preciso chamar essa funcao para o phisics atuar com o "seu update"
  
  -- pegar velocidade e posicao para usa abaixo
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
  
  -- atualizar posicao
  posicaoXJanelaComRelacaoAPista = posicaoXJanelaComRelacaoAPista + (velXJanelaComrelacaoAPista * dt)
  
end

function love.draw()
  
  -- background
  love.graphics.setColor(255,255,255)
  for i = 0, love.graphics.getWidth() / background:getWidth() do
    love.graphics.draw(background, (i * background:getWidth() * backgroundHeightScaleFactor) - posicaoXJanelaComRelacaoAPista, 0, 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  
  ourPhysics.draw(objects)
  
  
end

function beginContact(a, b, coll)
  -- colisao personagem - chao
  if (a:getUserData() == "personagem" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagem") then
    isPersonagemTocandoPista = true
  end
end
 
function endContact(a, b, coll)
  -- colisao personagem - chao
  if (a:getUserData() == "personagem" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagem") then
    isPersonagemTocandoPista = false
  end
  
  -- colisao personagem - rightColider
  if (a:getUserData() == "personagem" and b:getUserData() == "rightColider") or (a:getUserData() == "rightColider" and b:getUserData() == "personagem") then
    velXJanelaComrelacaoAPista = 0
  end
  
  -- colisao personagem - leftColider
  if (a:getUserData() == "personagem" and b:getUserData() == "leftColider") or (a:getUserData() == "leftColider" and b:getUserData() == "personagem") then
    velXJanelaComrelacaoAPista = 0
  end
end

function preSolve(a, b, coll)
 -- colisao personagem - rightColider
  if (a:getUserData() == "personagem" and b:getUserData() == "rightColider") or (a:getUserData() == "rightColider" and b:getUserData() == "personagem") then
    velocidadeDoPersonagemAntesDaColisao, lixo = a:getLinearVelocity()
  end
  
  -- colisao personagem - leftColider
  if (a:getUserData() == "personagem" and b:getUserData() == "leftColider") or (a:getUserData() == "leftColider" and b:getUserData() == "personagem") then
    
  end
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
 -- colisao personagem - rightColider
  if (a:getUserData() == "personagem" and b:getUserData() == "rightColider") or (a:getUserData() == "rightColider" and b:getUserData() == "personagem") then
    velXJanelaComrelacaoAPista = normalimpulse
    xx, yy = a:getVelocity()
    a:setVelocity(velocidadeDoPersonagemAntesDaColisao, yy)
  end
  
  -- colisao personagem - leftColider
  if (a:getUserData() == "personagem" and b:getUserData() == "leftColider") or (a:getUserData() == "leftColider" and b:getUserData() == "personagem") then
    velXJanelaComrelacaoAPista = - normalimpulse
  end
end





















