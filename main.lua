local Button = require "button"

function love.load()
  button = Button:new(10,200,100,50, function()
    love.graphics.print("hi", 400,220)
  end)
end


function love.draw()
  button:draw()
end
