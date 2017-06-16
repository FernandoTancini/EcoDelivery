local fase = {}

local world

local background

local cameraXPosition = 0

local isPersonagemTocandoPista = false
local reset = false

local ourPhysics

-- vatriaveis parametricas
local lucioVelXMax = 500
local lucioVelYMax = 250
local tamanhoDaPista = 7500
local alturaDaPista = 740

local casaImage
local casaPosition

local tempoDecorrido = 0
local temperaturaDaPizza = 60
local framesTermometro = {}
local framesTermometroAtual = 1


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
  ourPhysics.setObjects(world, tamanhoDaPista)
  world:setCallbacks(beginContact, endContact)
  
  -- popular a tabela de sprites do personagem
  for x = 1, 4, 1 do
    ourPhysics.objects.lucio.framesDeMovimento[x] = love.graphics.newImage ("imagens/lucio0" .. x .. ".png")
  end
  
  -- carregar imagens do termometro
  for x = 1, 5, 1 do
    framesTermometro[x] = love.graphics.newImage ("imagens/termometro"..x..".png")
  end
  
  local construidorDePista = require "construidorDePista"
  ourPhysics.objects.pista = construidorDePista.carregarPista(numeroFase)
  
  -- inicioalizar casa do final da pista
  casaImage, casaPosition = construidorDePista.getCasaImageAndPosition(numeroFase)

end


-- UPDATE --------------------------------------------------
function fase.update(dt)
  
  -- atualizar temperatura da pizza
  temperaturaDaPizza = temperaturaDaPizza - dt/3
  -- atualizar o tempoDecorrido
  tempoDecorrido = tempoDecorrido + dt
  -- atualizar frame do termometro
  if temperaturaDaPizza > 55 then
    framesTermometroAtual = 1
  elseif temperaturaDaPizza > 50 then
    framesTermometroAtual = 2
  elseif temperaturaDaPizza > 45 then
    framesTermometroAtual = 3
  elseif temperaturaDaPizza > 40 then
    framesTermometroAtual = 4
  elseif temperaturaDaPizza > 35 then
    framesTermometroAtual = 5
  end
  
  
  
  if tempoDecorrido > 60 then
    reset = true
  end
  
  
  -- eh preciso chamar essa funcao para o phisics atuar com o "seu update"
  world:update(dt)
  
  -- controles:
  
  -- pegar velocidades para usa abaixo
  local lucioVelX, lucioVelY = ourPhysics.objects.lucioLeftWheel.body:getLinearVelocity()
  local lucioX, lucioY = ourPhysics.objects.lucioLeftWheel.body:getPosition()
  
  -- seta para cima
  if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
    ourPhysics.objects.lucioLeftWheel.body:applyForce(200, 0)
    ourPhysics.objects.lucioRightWheel.body:applyForce(200, 0)
    
    -- ANIMCAO DE MOVIMENTO
    ourPhysics.objects.lucio.timer = ourPhysics.objects.lucio.timer + dt --incrementa o tempo usando dt
    if ourPhysics.objects.lucio.timer > 0.1 then -- quando acumular mais de 0.1 segundos
      ourPhysics.objects.lucio.frameAtual = ourPhysics.objects.lucio.frameAtual + 1 --avanca para proximo frame
        if ourPhysics.objects.lucio.frameAtual > 4 then
          ourPhysics.objects.lucio.frameAtual = 1
        end
      --reinicializa a contagem do tempo
      ourPhysics.objects.lucio.timer = 0                
    end
  end
  
  -- seta para baixo
  if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
    ourPhysics.objects.lucioLeftWheel.body:applyForce(-200, 0)
    ourPhysics.objects.lucioRightWheel.body:applyForce(-200, 0)
  end

  -- seta para a direita
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
    ourPhysics.objects.lucioTop.body:setAngularVelocity(math.pi*1.5)
  end
  
  -- seta para a esquerda
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
    ourPhysics.objects.lucioTop.body:setAngularVelocity(-math.pi*2)
  end
  
  -- barra de espaco
  if (love.keyboard.isDown(" ") or love.keyboard.isDown("space")) and (isPersonagemTocandoPista) then
    ourPhysics.objects.lucioLeftWheel.body:applyForce(0, -2000)
    ourPhysics.objects.lucioRightWheel.body:applyForce(0, -2000)
  end
  
  
  -- regular velocidade maxima
  if lucioVelX > lucioVelXMax then
    ourPhysics.objects.lucioLeftWheel.body:setLinearVelocity(lucioVelXMax, lucioVelY)
  elseif lucioVelX < - lucioVelXMax then
    ourPhysics.objects.lucioLeftWheel.body:setLinearVelocity(-lucioVelXMax, lucioVelY)
  end
  if lucioVelY < - lucioVelYMax then
    ourPhysics.objects.lucioLeftWheel.body:setLinearVelocity(lucioVelX, - lucioVelYMax)
  end
  
  -- checar se o Y do pesonagem ja cresceu muito, ou seja, se o personagem caiu para fora da pista
  if lucioY > 500 then
    reset = true
  end
  
  -- checar se eh para dar reset
  if love.keyboard.isDown("q") or reset then
    reset = false
    ourPhysics.objects.lucioLeftWheel.body:setAngularVelocity(0)
    ourPhysics.objects.lucioRightWheel.body:setAngularVelocity(0)
    ourPhysics.objects.lucioTop.body:setAngularVelocity(0)
    ourPhysics.objects.lucioMorteColider.body:setAngularVelocity(0)
    ourPhysics.objects.lucioFixadorDaSprite.body:setAngularVelocity(0)
    ourPhysics.objects.lucioLeftWheel.body:setAngle(0)
    ourPhysics.objects.lucioRightWheel.body:setAngle(0)
    ourPhysics.objects.lucioTop.body:setAngle(0)
    ourPhysics.objects.lucioMorteColider.body:setAngle(0)
    ourPhysics.objects.lucioFixadorDaSprite.body:setAngle(0)
    ourPhysics.objects.lucioLeftWheel.body:setLinearVelocity(0, 0)
    ourPhysics.objects.lucioRightWheel.body:setLinearVelocity(0, 0)
    ourPhysics.objects.lucioTop.body:setLinearVelocity(0, 0)
    ourPhysics.objects.lucioMorteColider.body:setLinearVelocity(0, 0)
    ourPhysics.objects.lucioFixadorDaSprite.body:setLinearVelocity(0, 0)
    ourPhysics.objects.lucioLeftWheel.body:setPosition(85, 400)
    ourPhysics.objects.lucioRightWheel.body:setPosition(125, 400)
    ourPhysics.objects.lucioTop.body:setPosition(ourPhysics.objects.lucioLeftWheel.body:getX()+20, ourPhysics.objects.lucioLeftWheel.body:getY()-25)
    ourPhysics.objects.lucioMorteColider.body:setPosition(ourPhysics.objects.lucioLeftWheel.body:getX()+20, ourPhysics.objects.lucioLeftWheel.body:getY()-30)
    ourPhysics.objects.lucioFixadorDaSprite.body:setLinearVelocity(ourPhysics.objects.lucioLeftWheel.body:getX()-15, ourPhysics.objects.lucioLeftWheel.body:getY()-55)
    
    -- zerar timer
    tempoDecorrido = 0
    temperaturaDaPizza = 60
  end
  
  -- funcao que atualiza os os obstaculos que devem aparecer de acordo com a posicao da camera com relacao ao mundo
  ourPhysics.updatePista(cameraXPosition, (cameraXPosition + love.graphics.getWidth()))
  
  -- atualizar is tocando pista
  isPersonagemTocandoPista = updateIsTocandoPista()
  
  
  -- ver se chegou no final
  if lucioX > casaPosition[1] + 50 then
    reset = true
  end
  
end


-- DRAW --------------------------------------------------
function fase.draw()

  -- pegar velocidades para usa abaixo
  local lucioX, lucioY = ourPhysics.objects.lucioLeftWheel.body:getPosition()
  
  -- atualizar o tarnslate
  local dx, dy
  if ourPhysics.objects.lucioLeftWheel.body:getX() > 200 and ourPhysics.objects.lucioLeftWheel.body:getX() < (tamanhoDaPista - 600) then
    dx = 200 - lucioX
    dy = 450 - lucioY
  elseif ourPhysics.objects.lucioLeftWheel.body:getX() < 200 then
    dx = 0
    dy = 450 - lucioY
  elseif ourPhysics.objects.lucioLeftWheel.body:getX() > (tamanhoDaPista - 600) then
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
  
  -- desenhar casa
  love.graphics.setColor(255,255,255)
  love.graphics.draw(casaImage, casaPosition[1] , casaPosition[2], 0, 2,2)
  
  -- funcao para o ourPhysics desenhar os objetos do physics
  ourPhysics.draw(ourPhysics.objects)
  
  -- printar a "hud rudimentar"
  love.graphics.print("Posicao: "..string.sub(tostring(lucioX), 0, 4).."  de 7500", 10 - dx, 10 - dy)
  love.graphics.print("Tempo decorrido: "..string.sub(tostring(tempoDecorrido), 0, 4), 10 - dx, 25 - dy)
  love.graphics.print("Temperatura da Pizza: "..string.sub(tostring(temperaturaDaPizza), 0, 4), 10 - dx, 40 - dy)
  
  -- pirntar HUD
  love.graphics.setColor(255,255,255)
  love.graphics.draw(framesTermometro[framesTermometroAtual], 740-dx, -dy, 0, .15, .15)
  
end

-- FUNCOES DE COLISAO --------------------------------------------------
function beginContact(a, b,  coll)
  -- checar se houve contato entre a pista e a roda direita do lucio
  if (a:getUserData() == "personagemRightWheel" and b:getUserData()[1] == "pista") or (a:getUserData()[1] == "pista" and b:getUserData() == "personagemRightWheel") then
    
    if (a:getUserData()[1] == "pista") then
      -- "a" eh a pista
      ourPhysics.objects.pista[a:getUserData()[2]].isTocandoRodaDireitaDoPersonagem = true
    elseif (b:getUserData()[1] == "pista") then
      -- "b" eh a pista
      ourPhysics.objects.pista[b:getUserData()[2]].isTocandoRodaDireitaDoPersonagem = true
    end
  end
  
  -- checar se houve contato entre a pista e a roda direita do lucio
  if (a:getUserData() == "personagemLeftWheel" and b:getUserData()[1] == "pista") or (a:getUserData()[1] == "pista" and b:getUserData() == "personagemLeftWheel") then
    
    if (a:getUserData()[1] == "pista") then
      -- "a" eh a pista
      ourPhysics.objects.pista[a:getUserData()[2]].isTocandoRodaEsquerdaDoPersonagem = true
    elseif (b:getUserData()[1] == "pista") then
      -- "b" eh a pista
      ourPhysics.objects.pista[b:getUserData()[2]].isTocandoRodaEsquerdaDoPersonagem = true
    end
  end
  
  -- checar se houve contato entre pista e o topo do personagem
  if (a:getUserData() == "personagemMorteColider" and b:getUserData()[1] == "pista") or (a:getUserData()[1] == "pista" and b:getUserData() == "personagemMorteColider") then
    reset = true
  end
end
 
function endContact(a, b, coll)
  
  -- checar se houve contato entre a pista e a roda direita do lucio
  if (a:getUserData() == "personagemRightWheel" and b:getUserData()[1] == "pista") or (a:getUserData()[1] == "pista" and b:getUserData() == "personagemRightWheel") then
    -- acabaou contato entre pista e personagem
    
    if (a:getUserData()[1] == "pista") then
      -- "a" eh a pista
     ourPhysics.objects.pista[a:getUserData()[2]].isTocandoRodaDireitaDoPersonagem = false
    elseif (b:getUserData()[1] == "pista") then
      -- "b" eh a pista
      ourPhysics.objects.pista[b:getUserData()[2]].isTocandoRodaDireitaDoPersonagem = false
    end
  end
  
  -- checar se houve contato entre a pista e a roda esquerda do lucio
  if (a:getUserData() == "personagemLeftWheel" and b:getUserData()[1] == "pista") or (a:getUserData()[1] == "pista" and b:getUserData() == "personagemLeftWheel") then
    -- acabaou contato entre pista e personagem
    
    if (a:getUserData()[1] == "pista") then
      -- "a" eh a pista
     ourPhysics.objects.pista[a:getUserData()[2]].isTocandoRodaEsquerdaDoPersonagem = false
    elseif (b:getUserData()[1] == "pista") then
      -- "b" eh a pista
      ourPhysics.objects.pista[b:getUserData()[2]].isTocandoRodaEsquerdaDoPersonagem = false
    end
  end
  
end

--[[Updated upstream
--=======
function carregarPista(numeroFase)
    local pista = {}
    if numeroFase == 1 then
      
      --chao
      pista[1] = criarObstaculoDeLinha(0,450,8000,450)
      --primeira rampa
      pista[2] = criarObstaculoDeLinha(500,450,650,410)
      pista[3] = criarObstaculoDeLinha(650,410,1200,410)
      pista[4] = criarObstaculoDeLinha(1200,410,1350,450)
      --bloco 1 
      pista[5] = criarObstaculoDeLinha(1500,450,1500,410)
      pista[6] = criarObstaculoDeLinha(1500,410,1560,410)
      pista[7] = criarObstaculoDeLinha(1560,410,1560,450)
      --bloco 2
      pista[8] = criarObstaculoDeLinha(1600,450,1600,390)
      pista[9] = criarObstaculoDeLinha(1600,390,1660,390)
      pista[10] = criarObstaculoDeLinha(1660,390,1660,450)
      --bloco 3
      pista[11] = criarObstaculoDeLinha(1700,450,1700,370)
      pista[12] = criarObstaculoDeLinha(1700,370,1760,370)
      pista[13] = criarObstaculoDeLinha(1760,370,1760,450)
      
    end
    return pista
end

function criarObstaculoDeLinha(x1,y1,x2,y2)
  if raio == nil then raio = 2 end
  local linha = {}
  local altura = y2 - y1
  local largura = x2 - x1
  
  local comprimento = math.sqrt(largura*largura + altura*altura)
  local angulacao = math.asin(altura/comprimento)
  
  local xDoCentro = x1 + (x2 - x1) / 2
  local yDoCentro = y1 + (y2 - y1) / 2
  
  obstaculoDeLinha = {}
  obstaculoDeLinha.xInicial = x1
  obstaculoDeLinha.xFinal = x2
  obstaculoDeLinha.yInicial = y1
  obstaculoDeLinha.yFinal = y2
  obstaculoDeLinha.xDoCentro = xDoCentro
  obstaculoDeLinha.yDoCentro = yDoCentro
  obstaculoDeLinha.comprimento = comprimento
  obstaculoDeLinha.angulacao = angulacao
  obstaculoDeLinha.shouldAppear = false
  obstaculoDeLinha.isTocandoRodaEsquerdaDoPersonagem = false
  obstaculoDeLinha.isTocandoRodaDireitaDoPersonagem = false
  obstaculoDeLinha.obstaculo = {}
  return obstaculoDeLinha
end]]

-->>>>>>> Stashed changes
function updateIsTocandoPista()
  local isTocandoAlgumObjetoDaPista = false
  for key,value in pairs(ourPhysics.objects.pista) do
    if (value.shouldAppear == true) then
      if (value.isTocandoRodaDireitaDoPersonagem == true or value.isTocandoRodaEsquerdaDoPersonagem == true) then
        isTocandoAlgumObjetoDaPista = true
      end
    end
  end
  return isTocandoAlgumObjetoDaPista
end

return fase