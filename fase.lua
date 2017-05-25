local fase = {}

local world
local objects

local background

local isPersonagemTocandoPista = false
local isPersonagemTocandoPistaR = false
local reset = false

local ourPhysics

-- vatriaveis parametricas
local lucioVelXMax = 500
local tamanhoDaPista = 8000
local alturaDaPista = 740


function fase.init(tamanhoPista, alturaPista)
  tamanhoDaPista = tamanhoPista
  alturaDaPista = alturaPista
end


-- LOAD --------------------------------------------------
function fase.load()
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- background
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = alturaDaPista / background:getHeight()
  
  -- world
  world = ourPhysics.setupWorld()
  objects = ourPhysics.getObjects(world, tamanhoDaPista)
  world:setCallbacks(beginContact, endContact)
  
  -- popular a tabela de sprites do personagem
  for x = 1, 4, 1 do
    objects.lucio.framesDeMovimento[x] = love.graphics.newImage ("imagens/lucio0" .. x .. ".png")
  end

end


-- UPDATE --------------------------------------------------
function fase.update(dt)
  
  -- eh preciso chamar essa funcao para o phisics atuar com o "seu update"
  world:update(dt)
  
  -- controles:
  
  -- pegar velocidades para usa abaixo
  local lucioVelX, lucioVelY = objects.lucioLeftWheel.body:getLinearVelocity()
  local lucioX, lucioY = objects.lucioLeftWheel.body:getPosition()
  
  -- seta para cima
  if love.keyboard.isDown("up") then
    objects.lucioLeftWheel.body:applyForce(200, 0)
    objects.lucioRightWheel.body:applyForce(200, 0)
    
    -- ANIMCAO DE MOVIMENTO
    objects.lucio.timer = objects.lucio.timer + dt --incrementa o tempo usando dt
    if objects.lucio.timer > 0.1 then -- quando acumular mais de 0.1 segundos
      objects.lucio.frameAtual = objects.lucio.frameAtual + 1 --avanca para proximo frame
        if objects.lucio.frameAtual > 4 then
          objects.lucio.frameAtual = 1
        end
      --reinicializa a contagem do tempo
      objects.lucio.timer = 0                
    end
  end
  
  -- seta para baixo
  if love.keyboard.isDown("down") then
    objects.lucioLeftWheel.body:applyForce(-200, 0)
    objects.lucioRightWheel.body:applyForce(-200, 0)
  end

  -- seta para a direita
  if love.keyboard.isDown("right") then
    objects.lucioTop.body:setAngularVelocity(math.pi*1)
  end
  
  -- seta para a esquerda
  if love.keyboard.isDown("left") then
    objects.lucioTop.body:setAngularVelocity(-math.pi*2)
  end
  
  -- barra de espaco
  if love.keyboard.isDown("space") and (isPersonagemTocandoPista) then
    objects.lucioLeftWheel.body:applyForce(0, -3500)
    objects.lucioRightWheel.body:applyForce(0, -3500)
  end
  
  
  -- regular velocidade maxima
  if lucioVelX > lucioVelXMax then
    objects.lucioLeftWheel.body:setLinearVelocity(lucioVelXMax, lucioVelY)
  elseif lucioVelX < - lucioVelXMax then
    objects.lucioLeftWheel.body:setLinearVelocity(-lucioVelXMax, lucioVelY)
  end
  
  -- checar se o Y do pesonagem ja cresceu muito, ou seja, se o personagem caiu para fora da pista
  if objects.lucioLeftWheel.body:getY() > 1500 then
    reset = true
  end
  
  -- checar se eh para dar reset
  if love.keyboard.isDown("q") or reset then
    reset = false
    objects.lucioLeftWheel.body:setAngularVelocity(0)
    objects.lucioRightWheel.body:setAngularVelocity(0)
    objects.lucioTop.body:setAngularVelocity(0)
    objects.lucioFixadorDaSprite.body:setAngularVelocity(0)
    objects.lucioLeftWheel.body:setAngle(0)
    objects.lucioRightWheel.body:setAngle(0)
    objects.lucioTop.body:setAngle(0)
    objects.lucioFixadorDaSprite.body:setAngle(0)
    objects.lucioLeftWheel.body:setLinearVelocity(0, 0)
    objects.lucioRightWheel.body:setLinearVelocity(0, 0)
    objects.lucioTop.body:setLinearVelocity(0, 0)
    objects.lucioFixadorDaSprite.body:setLinearVelocity(0, 0)
    objects.lucioLeftWheel.body:setPosition(800/2, 600/2)
    objects.lucioRightWheel.body:setPosition(800/2+40, 600/2)
    objects.lucioTop.body:setPosition(objects.lucioLeftWheel.body:getX()+20, objects.lucioLeftWheel.body:getY()-25)
    objects.lucioFixadorDaSprite.body:setLinearVelocity(objects.lucioLeftWheel.body:getX()-15, objects.lucioLeftWheel.body:getY()-55)
  end
  
end


-- DRAW --------------------------------------------------
function fase.draw()

  -- pegar velocidades para usa abaixo
  local lucioX, lucioY = objects.lucioLeftWheel.body:getPosition()
  
  -- atualizar o tarnslate
  if objects.lucioLeftWheel.body:getX() > 200 and objects.lucioLeftWheel.body:getX() < (tamanhoDaPista - 600) then
    love.graphics.translate(-lucioX+200, -lucioY+450)
  elseif objects.lucioLeftWheel.body:getX() < 200 then
    love.graphics.translate(0, -lucioY+450)
  elseif objects.lucioLeftWheel.body:getX() > (tamanhoDaPista - 600) then
    love.graphics.translate(-tamanhoDaPista + 600 + 200, -lucioY+450)
  end

  -- background
  love.graphics.setColor(255,255,255)
  for x=0, tamanhoDaPista, (background:getWidth() * backgroundHeightScaleFactor) do
    love.graphics.draw(background, x, (love.graphics.getHeight() - alturaDaPista), 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  ourPhysics.draw(objects)
  
end

-- FUNCOES DE COLISAO --------------------------------------------------
function beginContact(a, b,  coll)
  if (a:getUserData() == "personagemWheels" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemWheels") then
    -- teve contato entre pista e personagem
    isPersonagemTocandoPista = true
  end
  if (a:getUserData() == "personagemTop" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemTop") then
    -- teve contato entre pista e o topo do personagem
    reset = true
  end
end
 
function endContact(a, b, coll)
  if (a:getUserData() == "personagemWheels" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemWheels") then
    -- acabaou contato entre pista e personagem
    isPersonagemTocandoPista = false
  end
end

return fase