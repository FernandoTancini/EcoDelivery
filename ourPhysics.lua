local ourPhysics = {}
local world 
local objects = {} -- tabela para armazenar os objetos

local pistaFriction = 0.1

function ourPhysics.setupWorld()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 9.81*64, true)
  return world
end

function ourPhysics.getObjects(world, tamanhoDaPista)
 
  -- ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, tamanhoDaPista/2, 600-150/2) -- esse pontos são o centro do corpo, que tem 800 de largura e 150 de altura
  objects.ground.shape = love.physics.newRectangleShape(tamanhoDaPista, 150) -- faz o retangulo com largura 800 e altura 150
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.fixture:setUserData("pista")
  objects.ground.fixture:setFriction(pistaFriction)
  objects.ground.fixture:setFilterData(1, 1, 1)
  
  
  -- personagem
  
  -- roda esquerda do personagem
  objects.lucioLeftWheel = {}
  objects.lucioLeftWheel.body = love.physics.newBody(world, 800/2, 600/2, "dynamic") --  ponto incial desse body é o centro da tela e "dynamic" que possibilita o movimento
  objects.lucioLeftWheel.shape = love.physics.newCircleShape(10) -- 10 é o raio do circulo
  objects.lucioLeftWheel.fixture = love.physics.newFixture(objects.lucioLeftWheel.body, objects.lucioLeftWheel.shape, 5) -- Attach fixture to body and give it a density of 1
  objects.lucioLeftWheel.fixture:setUserData("personagemWheels")
  objects.lucioLeftWheel.fixture:setFriction(0.5)
  objects.lucioLeftWheel.fixture:setFilterData(1, 1, 1)
  
  -- roda direita do personagem
  objects.lucioRightWheel ={}
  objects.lucioRightWheel.body = love.physics.newBody(world, 880/2, 600/2, "dynamic")
  objects.lucioRightWheel.shape = love.physics.newCircleShape(10)
  objects.lucioRightWheel.fixture = love.physics.newFixture(objects.lucioRightWheel.body, objects.lucioRightWheel.shape, 5)
  objects.lucioRightWheel.fixture:setUserData("personagemWheels")
  objects.lucioRightWheel.fixture:setFriction(0.5)
  objects.lucioRightWheel.fixture:setFilterData(1, 1, 1)
  
  -- top do personagem
  -- fixador de sprite
  objects.lucioFixadorDaSprite = {}
  objects.lucioFixadorDaSprite.body = love.physics.newBody(world, objects.lucioLeftWheel.body:getX()-15, objects.lucioLeftWheel.body:getY()-55, "dynamic")
  objects.lucioFixadorDaSprite.shape = love.physics.newRectangleShape(1, 50)
  objects.lucioFixadorDaSprite.fixture = love.physics.newFixture(objects.lucioFixadorDaSprite.body, objects.lucioFixadorDaSprite.shape, 0.1)
  objects.lucioFixadorDaSprite.fixture:setUserData("personagemRodador")
  objects.lucioFixadorDaSprite.fixture:setFriction(0.5)
  objects.lucioFixadorDaSprite.fixture:setFilterData(0, 0, 0)
  -- topo do personagem
  objects.lucioTop = {}
  objects.lucioTop.body = love.physics.newBody(world, objects.lucioLeftWheel.body:getX()+20, objects.lucioLeftWheel.body:getY()-25, "dynamic")
  objects.lucioTop.shape = love.physics.newRectangleShape(40,50)
  objects.lucioTop.fixture = love.physics.newFixture(objects.lucioTop.body, objects.lucioTop.shape, 0.1)
  objects.lucioTop.fixture:setUserData("personagemTop")
  objects.lucioTop.fixture:setFriction(0)
  objects.lucioTop.fixture:setFilterData(1, 1, 1)
  
  -- frames do personagem lucio
  objects.lucio = {
    framesDeMovimento = {},
    frameAtual = 1,
    timer = 0 
    }
  
  -- juntar os objetos
  love.physics.newWeldJoint(objects.lucioLeftWheel.body, objects.lucioRightWheel.body, objects.lucioLeftWheel.body:getX() + 20, objects.lucioLeftWheel.body:getY())
  love.physics.newWeldJoint(objects.lucioLeftWheel.body, objects.lucioTop.body, objects.lucioTop.body:getX(), objects.lucioLeftWheel.body:getY())
  love.physics.newWeldJoint(objects.lucioRightWheel.body, objects.lucioTop.body, objects.lucioTop.body:getX() + 40 , objects.lucioRightWheel.body:getY())
  -- juntar com fixador da sprite
  love.physics.newWeldJoint(objects.lucioLeftWheel.body, objects.lucioFixadorDaSprite.body, objects.lucioFixadorDaSprite.body:getX(), objects.lucioFixadorDaSprite.body:getY())
  love.physics.newWeldJoint(objects.lucioRightWheel.body, objects.lucioFixadorDaSprite.body, objects.lucioFixadorDaSprite.body:getX()+40, objects.lucioFixadorDaSprite.body:getY())
  love.physics.newWeldJoint(objects.lucioTop.body, objects.lucioFixadorDaSprite.body, objects.lucioFixadorDaSprite.body:getX(), objects.lucioFixadorDaSprite.body:getY()+5)
  love.physics.newWeldJoint(objects.lucioTop.body, objects.lucioFixadorDaSprite.body, objects.lucioFixadorDaSprite.body:getX()+40, objects.lucioFixadorDaSprite.body:getY()+5)

  -- MarginForMoviment 
  -- left
  objects.leftColider = {}
  objects.leftColider.body = love.physics.newBody(world, 50/2, 300)
  objects.leftColider.shape = love.physics.newRectangleShape(50, 600)
  objects.leftColider.fixture = love.physics.newFixture(objects.leftColider.body, objects.leftColider.shape)
  objects.leftColider.fixture:setUserData("leftColider")
  -- right
  objects.rightColider = {}
  objects.rightColider.body = love.physics.newBody(world, tamanhoDaPista - (50/2), 300)
  objects.rightColider.shape = love.physics.newRectangleShape(50, 600)
  objects.rightColider.fixture = love.physics.newFixture(objects.rightColider.body, objects.rightColider.shape)
  objects.rightColider.fixture:setUserData("rightColider")
  
  -- set pista (vazia)
  objects.pista = {}

  return objects
  
end

function ourPhysics.updatePista(xInicialCamera, xFinalCamera)
  
  local shouldDestroy = {}
  local shouldCreate = {}
  
  -- atualizar se os obstaculos devem aparecer ou nao
  for key,value in pairs(objects.pista) do --actualcode
    if value.xInicial > xFinalCamera or value.xFinal < xInicialCamera then
      -- esta fora da camera
      
      -- checar se esta true e, por isso, devera ser removido
      if objects.pista[key].shouldAppear == true then table.insert(shouldDestroy, key) end
      
      objects.pista[key].shouldAppear = false
    else
      -- esta dentro da camera
      
      -- checar se esta false e, por isso, devera ser crido
      if objects.pista[key].shouldAppear == false then table.insert(shouldCreate, key) end
      
      objects.pista[key].shouldAppear = true
    end
  end
  
  -- remover os corpos que precisam ser removidos
  for key, value in pairs(shouldDestroy) do
    objects.pista[value].obstaculo.body:destroy()
  end
  
  -- criar os corpos que precisam ser criados
  for key, value in pairs(shouldCreate) do
    
    objects.pista[value].obstaculo.body = love.physics.newBody(world, objects.pista[value].xDoCentro, objects.pista[value].yDoCentro)
    objects.pista[value].obstaculo.shape = love.physics.newRectangleShape(objects.pista[value].comprimento, 1)
    --objects.pista[value].obstaculo.shape = love.physics.newRectangleShape(objects.pista[value].xDoCentro, objects.pista[value].yDoCentro, objects.pista[value].comprimento, 1, objects.pista[value].angulacao)
    objects.pista[value].obstaculo.fixture = love.physics.newFixture(objects.pista[value].obstaculo.body, objects.pista[value].obstaculo.shape, 5)
    objects.pista[value].obstaculo.fixture:setUserData("pista")
    objects.pista[value].obstaculo.fixture:setFriction(pistaFriction)
    objects.pista[value].obstaculo.fixture:setFilterData(1, 1, 1)
    objects.pista[value].obstaculo.body:setAngle(objects.pista[value].angulacao)
  end
end

--[[function ourPhysics.updatePista(xInicialCamera, xFinalCamera)
  
  local shouldDestroy = {}
  local shouldCreate = {}
  
  -- atualizar se os obstaculos devem aparecer ou nao
  for key,value in pairs(objects.pista) do --actualcode
    if value.xInicial > xFinalCamera or value.xFinal < xInicialCamera then
      -- esta fora da camera
      
      -- checar se esta true e, por isso, devera ser removido
      if objects.pista[key].shouldAppear == true then table.insert(shouldDestroy, key) end
      
      objects.pista[key].shouldAppear = false
    else
      -- esta dentro da camera
      
      -- checar se esta false e, por isso, devera ser crido
      if objects.pista[key].shouldAppear == false then table.insert(shouldCreate, key) end
      
      objects.pista[key].shouldAppear = true
    end
  end
  
  -- remover os corpos que precisam ser removidos
  for key, value in pairs(shouldDestroy) do
    for k, v in pairs(objects.pista[value].obstaculo) do
      objects.pista[value].obstaculo[k].body:destroy()
    end
  end
  
  -- criar os corpos que precisam ser criados
  for key, value in pairs(shouldCreate) do
    
    for k, v in pairs(objects.pista[value].obstaculo) do
      objects.pista[value].obstaculo[k].body = love.physics.newBody(world, objects.pista[value].obstaculo[k].x, objects.pista[value].obstaculo[k].y)
      objects.pista[value].obstaculo[k].shape = love.physics.newCircleShape(objects.pista[value].obstaculo[k].raio)
      objects.pista[value].obstaculo[k].fixture = love.physics.newFixture(objects.pista[value].obstaculo[k].body, objects.pista[value].obstaculo[k].shape, 5)
      objects.pista[value].obstaculo[k].fixture:setUserData("pista")
      objects.pista[value].obstaculo[k].fixture:setFriction(pistaFriction)
      objects.pista[value].obstaculo[k].fixture:setFilterData(1, 1, 1)
    end
    
  end
end--]]

function ourPhysics.draw(objects)
  
  -- ground
  love.graphics.setColor(255, 0, 0)
  love.graphics.polygon("line", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
  love.graphics.polygon("line", objects.leftColider.body:getWorldPoints(objects.leftColider.shape:getPoints()))
  love.graphics.polygon("line", objects.rightColider.body:getWorldPoints(objects.leftColider.shape:getPoints()))
  
  -- personagem
  love.graphics.setColor(193, 47, 14)
  
  love.graphics.circle("line", objects.lucioLeftWheel.body:getX(), objects.lucioLeftWheel.body:getY(), objects.lucioLeftWheel.shape:getRadius())
  love.graphics.circle("line", objects.lucioRightWheel.body:getX(), objects.lucioRightWheel.body:getY(), objects.lucioRightWheel.shape:getRadius())
  love.graphics.polygon("line", objects.lucioTop.body:getWorldPoints(objects.lucioTop.shape:getPoints()))
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(objects.lucio.framesDeMovimento[objects.lucio.frameAtual], objects.lucioFixadorDaSprite.body:getX() ,objects.lucioFixadorDaSprite.body:getY(), objects.lucioFixadorDaSprite.body:getAngle(), 1.5, 1.5)
  -- TODO (to do): tentar nao precisar mais do lucioFixadorDaSprite. Segue exemplo na linha abaixo, mas que aualmwente nao da certo.
  --love.graphics.draw(objects.lucio.framesDeMovimento[objects.lucio.frameAtual], objects.lucioTop.body:getX() ,objects.lucioTop.body:getY(), objects.lucioTop.body:getAngle(), 1.5, 1.5)
  
  -- desenhar a pista
  love.graphics.setColor(255, 0, 0)
  for key,value in pairs(objects.pista) do --actualcode
    
    -- verificar se é pra desenhar esse obstaculo
    if value.shouldAppear then
        love.graphics.polygon("fill", value.obstaculo.body:getWorldPoints(value.obstaculo.shape:getPoints()))
    end
    
    
  end

end


return ourPhysics