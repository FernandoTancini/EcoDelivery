local ourPhysics = {}

function ourPhysics.setupWorld()
  love.physics.setMeter(64)
  return love.physics.newWorld(0, 9.81*64, true)
end

function ourPhysics.getObjects(world, tamanhoDaPista, alturaDaPista)
  
  local objects = {} -- tabela para armazenar os objetos
 
  -- ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, tamanhoDaPista/2, 600-150/2) -- esse pontos são o centro do corpo, que tem 800 de largura e 150 de altura
  objects.ground.shape = love.physics.newRectangleShape(tamanhoDaPista, 150) -- faz o retangulo com largura 800 e altura 150
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.fixture:setUserData("pista")
  objects.ground.fixture:setFriction(0.1)
  
  
  -- personagem
  objects.lucioL = {}
  objects.lucioL.body = love.physics.newBody(world, 800/2, 600/2, "dynamic") --  ponto incial desse body é o centro da tela e "dynamic" que possibilita o movimento
  objects.lucioL.shape = love.physics.newCircleShape(20) -- 20 é o raio do circulo
  objects.lucioL.fixture = love.physics.newFixture(objects.lucioL.body, objects.lucioL.shape, 1) -- Attach fixture to body and give it a density of 1
  objects.lucioL.fixture:setUserData("personagemL")
  objects.lucioL.fixture:setFriction(0.5)
  
  objects.lucioR ={}
  objects.lucioR.body = love.physics.newBody(world, 880/2, 600/2, "dynamic")
  objects.lucioR.shape = love.physics.newCircleShape(20)
  objects.lucioR.fixture = love.physics.newFixture(objects.lucioR.body, objects.lucioR.shape, 1)
  objects.lucioR.fixture:setUserData("personagemR")
  objects.lucioR.fixture:setFriction(0.5)
  
  objects.lucioT = {}
  objects.lucioT.body = love.physics.newBody(world, objects.lucioL.body:getX()+20, objects.lucioL.body:getY()-20, "dynamic")
  objects.lucioT.shape = love.physics.newRectangleShape(40, 5)
  objects.lucioT.fixture = love.physics.newFixture(objects.lucioT.body, objects.lucioT.shape, 1)
  --objects.lucioT.body:setAngularVelocity(math.pi)
  objects.lucioT.fixture:setUserData("personagemT")
  objects.lucioT.fixture:setFriction(0.5)
  
  love.physics.newWeldJoint(objects.lucioL.body, objects.lucioR.body, objects.lucioL.body:getX()-20, objects.lucioL.body:getY())
  love.physics.newWeldJoint(objects.lucioL.body, objects.lucioT.body, objects.lucioT.body:getX(), objects.lucioT.body:getY())
  love.physics.newWeldJoint(objects.lucioR.body, objects.lucioT.body, objects.lucioT.body:getX()+40, objects.lucioT.body:getY())
  
  
  -- MarginForMoviment
  -- left
  objects.leftColider = {}
  objects.leftColider.body = love.physics.newBody(world, 50/2, 300)
  objects.leftColider.shape = love.physics.newRectangleShape(50, 600)
  objects.leftColider.fixture = love.physics.newFixture(objects.leftColider.body, objects.leftColider.shape)
  objects.leftColider.fixture:setUserData("leftColider")
  -- right
  objects.leftColider = {}
  objects.leftColider.body = love.physics.newBody(world, tamanhoDaPista - (50/2), 300)
  objects.leftColider.shape = love.physics.newRectangleShape(50, 600)
  objects.leftColider.fixture = love.physics.newFixture(objects.leftColider.body, objects.leftColider.shape)
  objects.leftColider.fixture:setUserData("rightColider")

  return objects
  
end

function ourPhysics.draw(objects)
  
  -- ground
  love.graphics.setColor(255, 0, 0)
  love.graphics.polygon("line", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
  
  -- personagem
  love.graphics.setColor(193, 47, 14)
  love.graphics.circle("line", objects.lucioL.body:getX(), objects.lucioL.body:getY(), objects.lucioL.shape:getRadius())
  love.graphics.circle("line", objects.lucioR.body:getX(), objects.lucioR.body:getY(), objects.lucioR.shape:getRadius())
  love.graphics.polygon("line", objects.lucioT.body:getWorldPoints(objects.lucioT.shape:getPoints()))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(objects.lucioL.body:getX(), lucioX, lucioY)
  love.graphics.print(objects.lucioL.body:getY(), lucioX, lucioY+10)

end


return ourPhysics