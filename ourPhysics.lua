local ourPhysics = {}

function ourPhysics.setupWorld()
  love.physics.setMeter(64)
  return love.physics.newWorld(0, 9.81*64, true)
end

function ourPhysics.getObjects(world)
  
  local objects = {} -- tabela para armazenar os objetos
 
  -- ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, 800/2, 600-150/2) -- esse pontos são o centro do corpo, que tem 800 de largura e 150 de altura
  objects.ground.shape = love.physics.newRectangleShape(800, 150) -- faz o retangulo com largura 800 e altura 150
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.fixture:setUserData("pista")
  
  -- personagem
  objects.lucio = {}
  objects.lucio.body = love.physics.newBody(world, 800/2, 600/2, "dynamic") --  ponto incial desse body é o centro da tela e "dynamic" que possibilita o movimento
  objects.lucio.shape = love.physics.newCircleShape(20) -- 20 é o raio do circulo
  objects.lucio.fixture = love.physics.newFixture(objects.lucio.body, objects.lucio.shape, 1) -- Attach fixture to body and give it a density of 1
  objects.lucio.fixture:setUserData("personagem")
  
  
  return objects
  
end

function ourPhysics.draw(objects)
  
  -- ground
  love.graphics.setColor(0, 0, 0)
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
  
  -- personagem
  love.graphics.setColor(193, 47, 14)
  love.graphics.circle("fill", objects.lucio.body:getX(), objects.lucio.body:getY(), objects.lucio.shape:getRadius())
  
end


return ourPhysics