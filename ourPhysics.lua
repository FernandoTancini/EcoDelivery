local ourPhysics = {}
local world 
ourPhysics.objects = {} -- tabela para armazenar os objetos

local pistaFriction = 0.1

function ourPhysics.setupWorld()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)
  return world
end

function ourPhysics.setObjects(world, tamanhoDaPista, xInicialLucio)
  
  -- personagem
  
  -- roda esquerda do personagem
  ourPhysics.objects.lucioLeftWheel = {}
  ourPhysics.objects.lucioLeftWheel.body = love.physics.newBody(world, xInicialLucio, 400, "dynamic") --  ponto incial desse body é o centro da tela e "dynamic" que possibilita o movimento
  ourPhysics.objects.lucioLeftWheel.shape = love.physics.newCircleShape(10) -- 10 é o raio do circulo
  ourPhysics.objects.lucioLeftWheel.fixture = love.physics.newFixture(ourPhysics.objects.lucioLeftWheel.body, ourPhysics.objects.lucioLeftWheel.shape, 5) -- Attach fixture to body and give it a density of 1
  ourPhysics.objects.lucioLeftWheel.fixture:setUserData("personagemLeftWheel")
  ourPhysics.objects.lucioLeftWheel.fixture:setFriction(0.5)
  ourPhysics.objects.lucioLeftWheel.fixture:setFilterData(1, 1, 1)
  
  -- roda direita do personagem
  ourPhysics.objects.lucioRightWheel ={}
  ourPhysics.objects.lucioRightWheel.body = love.physics.newBody(world, ourPhysics.objects.lucioLeftWheel.body:getX()+40, 400, "dynamic")
  ourPhysics.objects.lucioRightWheel.shape = love.physics.newCircleShape(10)
  ourPhysics.objects.lucioRightWheel.fixture = love.physics.newFixture(ourPhysics.objects.lucioRightWheel.body, ourPhysics.objects.lucioRightWheel.shape, 5)
  ourPhysics.objects.lucioRightWheel.fixture:setUserData("personagemRightWheels")
  ourPhysics.objects.lucioRightWheel.fixture:setFriction(0.5)
  ourPhysics.objects.lucioRightWheel.fixture:setFilterData(1, 1, 1)
  
  -- top do personagem
  -- fixador de sprite
  ourPhysics.objects.lucioFixadorDaSprite = {}
  ourPhysics.objects.lucioFixadorDaSprite.body = love.physics.newBody(world, ourPhysics.objects.lucioLeftWheel.body:getX()-15, ourPhysics.objects.lucioLeftWheel.body:getY()-55, "dynamic")
  ourPhysics.objects.lucioFixadorDaSprite.shape = love.physics.newRectangleShape(1, 50)
  ourPhysics.objects.lucioFixadorDaSprite.fixture = love.physics.newFixture(ourPhysics.objects.lucioFixadorDaSprite.body, ourPhysics.objects.lucioFixadorDaSprite.shape, 0.1)
  ourPhysics.objects.lucioFixadorDaSprite.fixture:setUserData("personagemRodador")
  ourPhysics.objects.lucioFixadorDaSprite.fixture:setFriction(0.5)
  ourPhysics.objects.lucioFixadorDaSprite.fixture:setFilterData(0, 0, 0)
  -- topo do personagem
  ourPhysics.objects.lucioTop = {}
  ourPhysics.objects.lucioTop.body = love.physics.newBody(world, ourPhysics.objects.lucioLeftWheel.body:getX()+20, ourPhysics.objects.lucioLeftWheel.body:getY()-25, "dynamic")
  ourPhysics.objects.lucioTop.shape = love.physics.newRectangleShape(40,50)
  ourPhysics.objects.lucioTop.fixture = love.physics.newFixture(ourPhysics.objects.lucioTop.body, ourPhysics.objects.lucioTop.shape, 0.1)
  ourPhysics.objects.lucioTop.fixture:setUserData("personagemTop")
  ourPhysics.objects.lucioTop.fixture:setFriction(0)
  ourPhysics.objects.lucioTop.fixture:setFilterData(1, 1, 1)
  -- barra de protecao da parte de baixo do topo do personagem
  ourPhysics.objects.lucioMorteColider = {}
  ourPhysics.objects.lucioMorteColider.body = love.physics.newBody(world, ourPhysics.objects.lucioLeftWheel.body:getX()+20, ourPhysics.objects.lucioLeftWheel.body:getY()-30, "dynamic")
  ourPhysics.objects.lucioMorteColider.shape = love.physics.newRectangleShape(42,41)
  ourPhysics.objects.lucioMorteColider.fixture = love.physics.newFixture(ourPhysics.objects.lucioMorteColider.body, ourPhysics.objects.lucioMorteColider.shape, 0.1)
  ourPhysics.objects.lucioMorteColider.fixture:setUserData("personagemMorteColider")
  ourPhysics.objects.lucioMorteColider.fixture:setFriction(0)
  ourPhysics.objects.lucioMorteColider.fixture:setFilterData(1, 1, 1)
  ourPhysics.objects.lucioMorteColider.body:setMass(0.001)
  
  -- frames do personagem lucio
  ourPhysics.objects.lucio = {
    framesDeMovimento = {},
    frameAtual = 1,
    timer = 0 
    }
  
  -- juntar os objetos
  love.physics.newWeldJoint(ourPhysics.objects.lucioLeftWheel.body, ourPhysics.objects.lucioRightWheel.body, ourPhysics.objects.lucioLeftWheel.body:getX() + 20, ourPhysics.objects.lucioLeftWheel.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioLeftWheel.body, ourPhysics.objects.lucioTop.body, ourPhysics.objects.lucioTop.body:getX(), ourPhysics.objects.lucioLeftWheel.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioRightWheel.body, ourPhysics.objects.lucioTop.body, ourPhysics.objects.lucioTop.body:getX() + 40 , ourPhysics.objects.lucioRightWheel.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioLeftWheel.body, ourPhysics.objects.lucioMorteColider.body, ourPhysics.objects.lucioLeftWheel.body:getX(), ourPhysics.objects.lucioLeftWheel.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioRightWheel.body, ourPhysics.objects.lucioMorteColider.body, ourPhysics.objects.lucioRightWheel.body:getX(), ourPhysics.objects.lucioRightWheel.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioMorteColider.body, ourPhysics.objects.lucioTop.body, ourPhysics.objects.lucioMorteColider.body:getX(), ourPhysics.objects.lucioMorteColider.body:getY(), ourPhysics.objects.lucioMorteColider.body:getX(), ourPhysics.objects.lucioMorteColider.body:getY(), false, 0)
  
  -- juntar com fixador da sprite
  love.physics.newWeldJoint(ourPhysics.objects.lucioLeftWheel.body, ourPhysics.objects.lucioFixadorDaSprite.body, ourPhysics.objects.lucioFixadorDaSprite.body:getX(), ourPhysics.objects.lucioFixadorDaSprite.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioRightWheel.body, ourPhysics.objects.lucioFixadorDaSprite.body, ourPhysics.objects.lucioFixadorDaSprite.body:getX()+40, ourPhysics.objects.lucioFixadorDaSprite.body:getY())
  love.physics.newWeldJoint(ourPhysics.objects.lucioTop.body, ourPhysics.objects.lucioFixadorDaSprite.body, ourPhysics.objects.lucioFixadorDaSprite.body:getX(), ourPhysics.objects.lucioFixadorDaSprite.body:getY()+5)
  love.physics.newWeldJoint(ourPhysics.objects.lucioTop.body, ourPhysics.objects.lucioFixadorDaSprite.body, ourPhysics.objects.lucioFixadorDaSprite.body:getX()+40, ourPhysics.objects.lucioFixadorDaSprite.body:getY()+5)

  -- MarginForMoviment 
  -- left
  ourPhysics.objects.leftColider = {}
  ourPhysics.objects.leftColider.body = love.physics.newBody(world, 50/2, 300)
  ourPhysics.objects.leftColider.shape = love.physics.newRectangleShape(50, 600)
  ourPhysics.objects.leftColider.fixture = love.physics.newFixture(ourPhysics.objects.leftColider.body, ourPhysics.objects.leftColider.shape)
  ourPhysics.objects.leftColider.fixture:setUserData("leftColider")
  -- right
  ourPhysics.objects.rightColider = {}
  ourPhysics.objects.rightColider.body = love.physics.newBody(world, tamanhoDaPista - (50/2), 300)
  ourPhysics.objects.rightColider.shape = love.physics.newRectangleShape(50, 600)
  ourPhysics.objects.rightColider.fixture = love.physics.newFixture(ourPhysics.objects.rightColider.body, ourPhysics.objects.rightColider.shape)
  ourPhysics.objects.rightColider.fixture:setUserData("rightColider")
  
  -- set pista (vazia)
  ourPhysics.objects.pista = {}

  
end

function ourPhysics.updatePista(xInicialCamera, xFinalCamera)
  local shouldDestroy = {}
  local shouldCreate = {}
  
  -- atualizar se os obstaculos devem aparecer ou nao
  for key,value in pairs(ourPhysics.objects.pista) do
    if value.xInicial > xFinalCamera or value.xFinal < xInicialCamera then
      -- esta fora da camera
      
      -- checar se esta true e, por isso, devera ser removido
      if ourPhysics.objects.pista[key].shouldAppear == true then table.insert(shouldDestroy, key) end
      
      ourPhysics.objects.pista[key].shouldAppear = false
    else
      -- esta dentro da camera
      
      -- checar se esta false e, por isso, devera ser crido
      if ourPhysics.objects.pista[key].shouldAppear == false then table.insert(shouldCreate, key) end
      
      ourPhysics.objects.pista[key].shouldAppear = true
    end
  end
  
  -- remover os corpos que precisam ser removidos
  for key, value in pairs(shouldDestroy) do
    ourPhysics.objects.pista[value].obstaculo.body:destroy()
  end
  
  -- criar os corpos que precisam ser criados
  for key, value in pairs(shouldCreate) do
    
    ourPhysics.objects.pista[value].obstaculo.body = love.physics.newBody(world, ourPhysics.objects.pista[value].xDoCentro, ourPhysics.objects.pista[value].yDoCentro)
    ourPhysics.objects.pista[value].obstaculo.shape = love.physics.newRectangleShape(ourPhysics.objects.pista[value].comprimento, 2)
    --ourPhysics.objects.pista[value].obstaculo.shape = love.physics.newRectangleShape(ourPhysics.objects.pista[value].xDoCentro, ourPhysics.objects.pista[value].yDoCentro, ourPhysics.objects.pista[value].comprimento, 1, ourPhysics.objects.pista[value].angulacao)
    ourPhysics.objects.pista[value].obstaculo.fixture = love.physics.newFixture(ourPhysics.objects.pista[value].obstaculo.body, ourPhysics.objects.pista[value].obstaculo.shape, 5)
    ourPhysics.objects.pista[value].obstaculo.fixture:setUserData({"pista", value})
    ourPhysics.objects.pista[value].obstaculo.fixture:setFriction(pistaFriction)
    ourPhysics.objects.pista[value].obstaculo.fixture:setFilterData(1, 1, 1)
    ourPhysics.objects.pista[value].obstaculo.body:setAngle(ourPhysics.objects.pista[value].angulacao)
    
  end
end

function ourPhysics.draw()
  
  -- personagem
  love.graphics.setColor(193, 47, 14)
  
  --love.graphics.circle("line", ourPhysics.objects.lucioLeftWheel.body:getX(), ourPhysics.objects.lucioLeftWheel.body:getY(), ourPhysics.objects.lucioLeftWheel.shape:getRadius())
  --love.graphics.circle("line", ourPhysics.objects.lucioRightWheel.body:getX(), ourPhysics.objects.lucioRightWheel.body:getY(), ourPhysics.objects.lucioRightWheel.shape:getRadius())
  --love.graphics.polygon("line", ourPhysics.objects.lucioTop.body:getWorldPoints(ourPhysics.objects.lucioTop.shape:getPoints()))
  
  love.graphics.setColor(255,0,0)
  --love.graphics.polygon("line", ourPhysics.objects.lucioMorteColider.body:getWorldPoints(ourPhysics.objects.lucioMorteColider.shape:getPoints()))
  
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(ourPhysics.objects.lucio.framesDeMovimento[ourPhysics.objects.lucio.frameAtual], ourPhysics.objects.lucioFixadorDaSprite.body:getX() ,ourPhysics.objects.lucioFixadorDaSprite.body:getY(), ourPhysics.objects.lucioFixadorDaSprite.body:getAngle(), 1.5, 1.5)
  
  -- desenhar a pista
  love.graphics.setColor(255, 0, 0)
  for key,value in pairs(ourPhysics.objects.pista) do
    
    -- verificar se eh pra desenhar esse obstaculo
    if value.shouldAppear then
        love.graphics.polygon("fill", value.obstaculo.body:getWorldPoints(value.obstaculo.shape:getPoints()))
    end
    
    
  end

end


return ourPhysics