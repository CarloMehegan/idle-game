local Button = require "button"

function love.load()
  energy = 0
  axolotls = 0

  buttons = {}
  buttons["make_axolotl"] = Button:new(10, 200, 100, 50, "make axolotl", "repeat", function()
    if energy >= 10 then
      love.graphics.print("happy birthday!", 25,175)
      axolotls = axolotls + 1
      energy = energy - 10
    end
  end)
  buttons["newbuttons_button"] = Button:new(10, 300, 100, 50, "new button", "single", function()
    createfunc()
  end)
end

createfunc = function()
  table.insert(buttons, Button:new(love.math.random(200,690), love.math.random(10,540), 100, 50, "new button", "single", function()
    createfunc()
  end))
end

function love.update(dt)
  energy = energy + (5 * dt)
end

function love.draw()
  for k,v in pairs(buttons) do
    buttons[k]:draw()
  end
  love.graphics.print("energy: " .. math.floor(energy), 10, 10)
  love.graphics.print("axolotls: " .. axolotls, 10, 40)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
