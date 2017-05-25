

 local fase
 
-- LOAD --------------------------------------------------
function love.load()
  fase = require "fase"
  
  -- inicializar a fase, indicando a largura e altura da pista (apenas isso por enquanto)
  fase.init(8000, 740)
  
  -- realizar o load() da fase
  fase.load()
end

-- update --------------------------------------------------
function love.update(dt)
  -- realizar o update() da fase
  fase.update(dt)
end
-- update --------------------------------------------------
function love.draw()
  -- realizar o draw() da fase
  fase.draw()
end