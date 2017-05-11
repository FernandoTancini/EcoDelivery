local ourPhysics = {}

function ourPhysics.setupWorld()
  love.physics.setMeter(64)
  return love.physics.newWorld(0, 9.81*64, true)
end

function ourPhysics.getObjects(world, worldWidth, windowWidth, windowHeight, leftMarginForMoviment, rightMarginForMoviment, groundHeight)
  
  local objects = {} -- tabela para armazenar os objetos
  
  -- ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, worldWidth/2, windowHeight-groundHeight/2, "static") -- esse pontos são o centro do corpo, que tem 800 de largura e 150 de altura
  objects.ground.shape = love.physics.newRectangleShape(worldWidth, groundHeight) -- faz o retangulo com largura 800 e altura 150
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body
  objects.ground.fixture:setUserData("pista")
  
  -- personagem
  objects.lucio = {}
  objects.lucio.body = love.physics.newBody(world, leftMarginForMoviment + 20, windowHeight - groundHeight - 20, "static") --  ponto incial desse body é o centro da tela e "dynamic" que possibilita o movimento
  objects.lucio.shape = love.physics.newCircleShape(20) -- 20 é o raio do circulo
  objects.lucio.fixture = love.physics.newFixture(objects.lucio.body, objects.lucio.shape, 1) -- Attach fixture to body and give it a density of 1
  objects.lucio.fixture:setUserData("personagem")
  
  -- MarginForMoviment
  --[[ left
  objects.leftColider = {}
  objects.leftColider.body = love.physics.newBody(world, leftMarginForMoviment/2, windowHeight/2, "static")
  objects.leftColider.shape = love.physics.newRectangleShape(leftMarginForMoviment, windowHeight)
  objects.leftColider.fixture = love.physics.newFixture(objects.leftColider.body, objects.leftColider.shape)
  objects.leftColider.fixture:setUserData("leftColider")
  -- right
  objects.rightColider = {}
  objects.rightColider.body = love.physics.newBody(world, windowWidth - (rightMarginForMoviment/2) , windowHeight/2, "static")
  objects.rightColider.shape = love.physics.newRectangleShape(rightMarginForMoviment, windowHeight)
  objects.rightColider.fixture = love.physics.newFixture(objects.rightColider.body, objects.rightColider.shape)
  objects.rightColider.fixture:setUserData("rightColider")
  --]]
  
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