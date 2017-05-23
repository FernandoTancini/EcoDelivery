--lalalalala

local background
local lucio
local ourPhysics
local world
local objects

local lucioVelXMax = 500
local tamanhoDaPista = 2000

local isPersonagemTocandoPistaL = false
local isPersonagemTocandoPistaR = false
local isPersonagemTocandoPistaT = false
local reset = false

hero = {
hero_walk = {},
hero_anim_frame = 1,
hero_pos_x = 400,
hero_pos_y = 300,
hero_anim_time = 0 ,
}


function love.load()
  
  for x = 1, 4, 1 do
    hero.hero_walk[x] = love.graphics.newImage ("imagens/lucio0" .. x .. ".png")
  end
  
  -- requires
  ourPhysics = require "ourPhysics"
  
  -- background
  background = love.graphics.newImage("imagens/cenario.png")
  backgroundHeightScaleFactor = love.graphics.getHeight() / background:getHeight()
  
  -- world
  world = ourPhysics.setupWorld()
  objects = ourPhysics.getObjects(world, tamanhoDaPista)
  world:setCallbacks(beginContact, endContact)

end

function love.update(dt)
  
  if objects.lucioL.body:getY() > 1500 then
    reset = true
    objects.lucioL.body:setLinearVelocity(0, 0)
    objects.lucioR.body:setLinearVelocity(0, 0)
    objects.lucioT.body:setLinearVelocity(0, 0)
    objects.lucioT2.body:setLinearVelocity(0, 0)
    
    else reset = false
  end
  
  world:update(dt) -- Ã© preciso chamar essa funcao para o phisics atuar com o "seu update"
  
  -- pegar velocidades para usa abaixo
  local lucioVelX, lucioVelY = objects.lucioL.body:getLinearVelocity()
  lucioX, lucioY = objects.lucioL.body:getPosition()
  
  -- eventos de teclas pressioandas
  if love.keyboard.isDown("q") or reset then
    reset = false
    objects.lucioL.body:setAngularVelocity(0)
    objects.lucioR.body:setAngularVelocity(0)
    objects.lucioT.body:setAngularVelocity(0)
    objects.lucioT2.body:setAngularVelocity(0)
    objects.lucioL.body:setAngle(0)
    objects.lucioR.body:setAngle(0)
    objects.lucioT.body:setAngle(0)
    objects.lucioT2.body:setAngle(0)
    objects.lucioL.body:setLinearVelocity(0, 0)
    objects.lucioR.body:setLinearVelocity(0, 0)
    objects.lucioT.body:setLinearVelocity(0, 0)
    objects.lucioT2.body:setLinearVelocity(0, 0)
    objects.lucioL.body:setPosition(800/2, 600/2)
    objects.lucioR.body:setPosition(800/2+40, 600/2)
    objects.lucioT.body:setPosition(objects.lucioL.body:getX()-10, objects.lucioL.body:getY()-60)
    objects.lucioT2.body:setPosition(objects.lucioL.body:getX()+20, objects.lucioL.body:getY()-25)
    
  end
  
  
  if love.keyboard.isDown("up") then
    objects.lucioL.body:applyForce(200, 0)
    objects.lucioR.body:applyForce(200, 0)
    objects.lucioT.body:setAngularVelocity(0)
    
    
    hero.hero_anim_time = hero.hero_anim_time + dt --incrementa o tempo usando dt
      if hero.hero_anim_time > 0.1 then --quando acumular mais de 0.1
        hero.hero_anim_frame = hero.hero_anim_frame + 1 --avana para proximo frame
          if hero.hero_anim_frame > 4 then
            hero.hero_anim_frame = 1
          end
        hero.hero_anim_time = 0                
                --reinicializa a contagem do tempo
      end
    

  end
  if love.keyboard.isDown("down") then
    objects.lucioL.body:applyForce(-200, 0)
    objects.lucioR.body:applyForce(-200, 0)
    objects.lucioT.body:setAngularVelocity(0)

  end

  if love.keyboard.isDown("right") then
    objects.lucioT2.body:setAngularVelocity(math.pi*1)
  end
  
  if love.keyboard.isDown("left") then
    objects.lucioT2.body:setAngularVelocity(-math.pi*2)
  end
  
  
  if love.keyboard.isDown("space") and (isPersonagemTocandoPistaL or isPersonagemTocandoPistaR) then
    objects.lucioL.body:applyForce(0, -3500)
    objects.lucioR.body:applyForce(0, -3500)
    objects.lucioT.body:applyForce(0, 000)

  end
  
  -- regular velocidade maxima
  if lucioVelX > lucioVelXMax then
    objects.lucioL.body:setLinearVelocity(lucioVelXMax, lucioVelY)
  elseif lucioVelX < - lucioVelXMax then
    objects.lucioL.body:setLinearVelocity(-lucioVelXMax, lucioVelY)
  end
  
  hero.hero_pos_x = objects.lucioT.body:getX()
  hero.hero_pos_y = objects.lucioT.body:getY() -- hero.hero_walk[1]:getHeight()
  
  
end

function love.draw()
  
  
  
  --love.graphics.translate(0, -lucioY+450)
  if objects.lucioL.body:getX()>200 then
  love.graphics.translate(-lucioX+200, -lucioY+450)
else
  love.graphics.translate(0, -lucioY+450)
  end
  
  -- background
  love.graphics.setColor(255,255,255)
  for x=0, tamanhoDaPista, background:getWidth() do
  love.graphics.draw(background, x, 0, 0, backgroundHeightScaleFactor, backgroundHeightScaleFactor)
  end
  ourPhysics.draw(objects)
  
  
  
  
end

--[[function math.round(objects.lucio.body:getX(),4)
  return objects.lucio.body:getX()
end]]

function beginContact(a, b,  coll)
  if (a:getUserData() == "personagemL" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemL") then
    -- teve contato entre pista e personagem
    isPersonagemTocandoPistaL = true
  end
  if (a:getUserData() == "personagemR" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemR") then
    -- teve contato entre pista e personagem
    isPersonagemTocandoPistaR = true
  end
  if (a:getUserData() == "personagemT2" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemT2") then
    -- teve contato entre pista e personagem
    reset = true
  end
end
 
function endContact(a, b, coll)
  if (a:getUserData() == "personagemL" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemL") then
    -- acabaou contato entre pista e personagem
    isPersonagemTocandoPistaL = false
  end
  if (a:getUserData() == "personagemR" and b:getUserData() == "pista") or (a:getUserData() == "pista" and b:getUserData() == "personagemR") then
    -- acabaou contato entre pista e personagem
    isPersonagemTocandoPistaR = false
  end
end

 





















