local fase = {}

local world
local objects = {}

local background

local cameraXPosition = 0

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
function fase.load(numeroFase)
  
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
  objects.pista = carregarPista(numeroFase)

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
    objects.lucioTop.body:setAngularVelocity(math.pi*1.5)
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
  
  -- funcao que atualiza os os obstaculos que devem aparecer de acordo com a posicao da camera com relacao ao mundo
  ourPhysics.updatePista(cameraXPosition, (cameraXPosition + love.graphics.getHeight()))
  
end


-- DRAW --------------------------------------------------
function fase.draw()

  -- pegar velocidades para usa abaixo
  local lucioX, lucioY = objects.lucioLeftWheel.body:getPosition()
  
  -- atualizar o tarnslate
  local dx, dy
  if objects.lucioLeftWheel.body:getX() > 200 and objects.lucioLeftWheel.body:getX() < (tamanhoDaPista - 600) then
    dx = 200 - lucioX
    dy = 450 - lucioY
  elseif objects.lucioLeftWheel.body:getX() < 200 then
    dx = 0
    dy = 450 - lucioY
  elseif objects.lucioLeftWheel.body:getX() > (tamanhoDaPista - 600) then
    dx = 200 + 600 - tamanhoDaPista
    dy = 450 - lucioY
  end
  love.graphics.translate(dx, dy)
  -- atualizar a cameraXPosition para ser usada na hora de informar o ourPhysics.updatePista() a posicao da camera em relacao ao mundo
  cameraXPosition = -dx

  -- background
  love.graphics.setColor(255,255,255)
  for x=0, tamanhoDaPista, (background:getWidth() * backgroundHeightScaleFactor) do
    love.graphics.draw(background, x, (love.graphics.getHeight() - alturaDaPista), 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  
  -- funcao para o ourPhysics desenhar os objetos do physics
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

function carregarPista(numeroFase)
    local pista = {}
    if numeroFase == 1 then
      pista[1] = criarObstaculoDeLinha(400,450,500,420)
      pista[2] = criarObstaculoDeLinha(500,420,600,420)
      pista[3] = criarObstaculoDeLinha(600,420,700,450)
    end
    return pista
end

function criarObstaculoDeLinha(x1,y1,x2,y2, raio)
  if raio == nil then raio = 2 end
  local linha = {}
  local altura = y2 - y1
  local largura = x2 - x1
  local coeficienteAngular = altura / largura
  
  for i = 0, largura - 1, 1 do
    linha[i+1] = {}
    linha[i+1].x = x1 + i
    linha[i+1].y = y1 + (coeficienteAngular * i)
    linha[i+1].raio = raio
  end
  
  obstaculoDeLinha = {}
  obstaculoDeLinha.xInicial = x1
  obstaculoDeLinha.xFinal = x2
  obstaculoDeLinha.obstaculo = linha
  obstaculoDeLinha.shouldAppear = false
  return obstaculoDeLinha
end

return fase