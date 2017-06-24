local fase = {}

local world

local background

-- variavel p saber se a fase foi completada
local acabou = false

local cameraXPosition = 0
local cameraYPosition = 0

local isPersonagemTocandoPista = false

-- essa variavel deve ser "subObjeto" do "objeto" fase para podermos acessa-la pelo arquivo main usando fase.reset
fase.reset = false

local ourPhysics

-- vatriaveis parametricas
local lucioVelXMax = 500
local lucioVelYMax = 250
local tamanhoDaPista = 7500
local alturaDaPista = 740

local xInicialLucio = 85

local casaImage
local casaPosition

local tempoDecorrido = 0
local temperaturaDaPizza = 60
local framesTermometro = {}
local framesTermometroAtual = 1

local relogioImagem = null


function fase.init(tamanhoPista, alturaPista)
  tamanhoDaPista = tamanhoPista
  alturaDaPista = alturaPista
end


-- LOAD --------------------------------------------------
function fase.load(numeroFase)
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- definir a imagem de background e também a escala dela
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = alturaDaPista / background:getHeight()
  
  -- world
  world = ourPhysics.setupWorld()
  ourPhysics.setObjects(world, tamanhoDaPista, xInicialLucio)
  world:setCallbacks(beginContact, endContact)
  
  -- popular a tabela de sprites do personagem
  for x = 1, 4, 1 do
    ourPhysics.objects.lucio.framesDeMovimento[x] = love.graphics.newImage ("imagens/lucio0" .. x .. ".png")
  end
  
  -- carregar imagens do termometro
  for x = 1, 5, 1 do
    framesTermometro[x] = love.graphics.newImage ("imagens/termometro"..x..".png")
  end
  
  relogioImagem = love.graphics.newImage ("imagens/relogio.png")
  
  local construidorDePista = require "construidorDePista"
  ourPhysics.objects.pista = construidorDePista.carregarPista(numeroFase)
  
  -- inicioalizar casa do final da pista
  casaImage, casaPosition = construidorDePista.getCasaImageAndPosition(numeroFase)

end


-- UPDATE --------------------------------------------------
function fase.update(dt)
  
  -- checar se eh para dar fase.reset
  if fase.reset then
    fase.reset = false
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
    ourPhysics.objects.lucioLeftWheel.body:setPosition(xInicialLucio, 400)
    ourPhysics.objects.lucioRightWheel.body:setPosition(xInicialLucio+40, 400)
    ourPhysics.objects.lucioTop.body:setPosition(ourPhysics.objects.lucioLeftWheel.body:getX()+20, ourPhysics.objects.lucioLeftWheel.body:getY()-25)
    ourPhysics.objects.lucioMorteColider.body:setPosition(ourPhysics.objects.lucioLeftWheel.body:getX()+20, ourPhysics.objects.lucioLeftWheel.body:getY()-30)
    ourPhysics.objects.lucioFixadorDaSprite.body:setLinearVelocity(ourPhysics.objects.lucioLeftWheel.body:getX()-15, ourPhysics.objects.lucioLeftWheel.body:getY()-55)
    
    -- zerar timer
    tempoDecorrido = 0
    temperaturaDaPizza = 400
  end
  
  -- atualizar temperatura da pizza
  temperaturaDaPizza = temperaturaDaPizza - dt/0.1
  -- atualizar o tempoDecorrido
  tempoDecorrido = tempoDecorrido + dt
  -- atualizar frame do termometro
  if temperaturaDaPizza > 328 then
    framesTermometroAtual = 1
  elseif temperaturaDaPizza > 256 then
    framesTermometroAtual = 2
  elseif temperaturaDaPizza > 184 then
    framesTermometroAtual = 3
  elseif temperaturaDaPizza > 112 then
    framesTermometroAtual = 4
  elseif temperaturaDaPizza > 40 then
    framesTermometroAtual = 5
  elseif temperaturaDaPizza <= 40 then
    fase.reset = true
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
  elseif lucioVelX < -lucioVelXMax then
    ourPhysics.objects.lucioLeftWheel.body:setLinearVelocity(-lucioVelXMax, lucioVelY)
  end
  if lucioVelY < - lucioVelYMax then
    ourPhysics.objects.lucioLeftWheel.body:setLinearVelocity(lucioVelX, - lucioVelYMax)
  end
  
  -- checar se o Y do pesonagem ja cresceu muito, ou seja, se o personagem caiu para fora da pista
  if lucioY > 500 then
    fase.reset = true
  end
  
  
  
  -- funcao que atualiza os os obstaculos que devem aparecer de acordo com a posicao da camera com relacao ao mundo
  ourPhysics.updatePista(cameraXPosition, (cameraXPosition + love.graphics.getWidth()))
  
  -- atualizar is tocando pista
  isPersonagemTocandoPista = updateIsTocandoPista()
  
  
  -- ver se chegou no final
  if lucioX > casaPosition[1] + 50 then
    fase.acabou = true
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
  cameraYPosition = -dy

  -- desenhar o background
  love.graphics.setColor(255,255,255)
  for x=0, tamanhoDaPista, (background:getWidth() * backgroundHeightScaleFactor) do
    love.graphics.draw(background, x, (love.graphics.getHeight() - alturaDaPista), 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  
  -- desenhar casa
  love.graphics.setColor(255,255,255)
  love.graphics.draw(casaImage, casaPosition[1] , casaPosition[2], 0, 2,2)
  
  -- funcao para o ourPhysics desenhar os objetos do physics
  ourPhysics.draw(ourPhysics.objects)
  
  -- pirntar HUD
  love.graphics.setColor(255,255,255)
  love.graphics.draw(framesTermometro[framesTermometroAtual], -10-dx, -dy, 0, .15, .15)
  love.graphics.print(string.sub(tostring(temperaturaDaPizza), 0, 3).."ºC", 50 - dx, 60 - dy)
  love.graphics.draw(relogioImagem, 100-dx, 20-dy, 0, .08, .08)
  love.graphics.print(string.sub(tostring(tempoDecorrido), 0, 3).."s", 165 - dx, 60 - dy)
  
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
    fase.reset = true
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

function fase.getXInicialCamera() 
  return cameraXPosition
end
function fase.getYInicialCamera() 
  return cameraYPosition
end

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

return fase