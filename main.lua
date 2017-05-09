
shouldPrint = false

require "camera"

function love.load()
  
  updateShouldPrint()
  
end

function love.update()
  
end

function love.draw()
  
  if shouldPrint then
    love.graphics.print("ola")
  end
  
end