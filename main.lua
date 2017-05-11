
local background
local lucio
local ourPhysics
local world
local objects

local lucioVelXMax = 500
local worldWidth = 8000
local worldHeight = 900
local windowWidth = 800
local windowHeight = 600
local leftMarginForMoviment = 150
local rightMarginForMoviment = 610

local posicaoXJanelaComRelacaoAoMundo = 0
local posicaoYJanelaComRelacaoAoMundo = worldHeight - windowHeight - 50
local velXJanelaEmComparacaoAoMundo = 0
local velYJanelaEmComparacaoAoMundo = 0

local backgroundHeightScaleFactor = 1
local quantidadeDeBackgroundsARepetir = 1

local groundHeight = 150

function love.load()
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- background
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = worldHeight / background:getHeight()
  quantidadeDeBackgroundsARepetir = worldWidth / (backgroundHeightScaleFactor * background:getWidth())
  
  -- world
  world = ourPhysics.setupWorld()
  objects = ourPhysics.getObjects(world, worldWidth, windowWidth, windowHeight, leftMarginForMoviment, rightMarginForMoviment, groundHeight)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
  
end

function love.update(dt)
  
  world:update(dt) -- é preciso chamar essa funcao para o phisics atuar com o "seu update"
  
  -------- em x
  
  -- eventos de teclas pressioandas
  if love.keyboard.isDown("right") then
    velXJanelaEmComparacaoAoMundo = velXJanelaEmComparacaoAoMundo + (200 * dt)
  end
  if love.keyboard.isDown("left") then
    velXJanelaEmComparacaoAoMundo = velXJanelaEmComparacaoAoMundo - (200 * dt)
  end
  -- regular velocidade maxima
  if velXJanelaEmComparacaoAoMundo > lucioVelXMax then
    velXJanelaEmComparacaoAoMundo = lucioVelXMax
  elseif velXJanelaEmComparacaoAoMundo < - lucioVelXMax then
    velXJanelaEmComparacaoAoMundo = - lucioVelXMax
  end
  -- atualizar posicao
  posicaoXJanelaComRelacaoAoMundo = posicaoXJanelaComRelacaoAoMundo + (velXJanelaEmComparacaoAoMundo * dt)
  -- checar limites da posicao
  if posicaoXJanelaComRelacaoAoMundo < 0 then
    posicaoXJanelaComRelacaoAoMundo = 0
    velXJanelaEmComparacaoAoMundo = 0
  elseif posicaoXJanelaComRelacaoAoMundo > (worldWidth - windowWidth) then
    posicaoXJanelaComRelacaoAoMundo = (worldWidth - windowWidth)
    velXJanelaEmComparacaoAoMundo = 0
  end
  
  ----------- em y 
  
  -- eventos de teclas pressioandas
  -- TODO: esse "velYJanelaEmComparacaoAoMundo == 0 and posicaoYJanelaComRelacaoAoMundo == worldHeight - windowHeight" está provisório
  if love.keyboard.isDown("up") and velYJanelaEmComparacaoAoMundo == 0 and posicaoYJanelaComRelacaoAoMundo == worldHeight - windowHeight then
    velYJanelaEmComparacaoAoMundo = velYJanelaEmComparacaoAoMundo - (40000 * dt)
  end
  -- atualizar posicao
  posicaoYJanelaComRelacaoAoMundo = posicaoYJanelaComRelacaoAoMundo + (velYJanelaEmComparacaoAoMundo * dt)
  -- efeito da gravidade
  velYJanelaEmComparacaoAoMundo = velYJanelaEmComparacaoAoMundo + (9.8 * love.physics.getMeter() * dt)
  -- checar limites da posicao
  if posicaoYJanelaComRelacaoAoMundo > (worldHeight - windowHeight) then
    posicaoYJanelaComRelacaoAoMundo = (worldHeight - windowHeight)
    velYJanelaEmComparacaoAoMundo = 0
  end
  
  -- Atualizar posicao do chao
  objects.ground.body:setPosition(worldWidth/2, worldHeight - (groundHeight/2) - posicaoYJanelaComRelacaoAoMundo)
  
end

function love.draw()
  
  -- background
  love.graphics.setColor(255,255,255)
  for i = 0,quantidadeDeBackgroundsARepetir, 1 do
    love.graphics.draw(background, (i * background:getWidth() * backgroundHeightScaleFactor) - posicaoXJanelaComRelacaoAoMundo, - posicaoYJanelaComRelacaoAoMundo, 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  
  ourPhysics.draw(objects)
    
end

function beginContact(a, b, coll)
  -- colisao personagem - chao
  -- nada ainda
end
 
function endContact(a, b, coll)
  -- colisao personagem - chao
  -- nada ainda
end





















