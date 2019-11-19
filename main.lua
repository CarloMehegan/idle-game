local Button = require "button"

function love.load()
  buttons = {}
  buttons["hi_single"] = Button:new(10, 200, 100, 50, "single", function()
    love.graphics.print("hi", 400,220)
  end)
  buttons["hi_repeat"] = Button:new(10, 300, 100, 50, "repeat", function()
    love.graphics.print("hi", 400,220)
  end)
end


function love.draw()
  -- for i = 1, #buttons do
  --   buttons[i]:draw()
  -- end
  for k,v in pairs(buttons) do
    buttons[k]:draw()
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
