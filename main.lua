-- Idle Game for AP Comp Sci Principles
-- Carlo Mehegan
-- November 2019

local Button = require "button"
local Cooldown = require "cooldown"
local Msg = require "messages"

function love.load()
  love.window.setMode(1200, 800, {resizable = true, minwidth=800, minheight=600}) --sets size of window
  love.graphics.setDefaultFilter('nearest', 'nearest') -- makes images not blurry
  love.window.setTitle("Idle Game") -- window title
  menufont = love.graphics.newImageFont("imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
  buttonfont = love.graphics.newFont("nimbusmono-regular.otf", 15)

  energy = 0
  food = 0
  axolotls = 0
  messages = {}
  buttons = {}
  cooldowns = {}

  buttons["make_axolotl"] = Button:new(475, 80, 100, 50, "make axolotl", "10 energy", "single", function()
    if energy >= 10 then
      table.insert(messages, Msg:new("happy birthday!", 475,70))
      axolotls = axolotls + 1
      energy = energy - 10
    elseif energy < 10 then
      table.insert(messages, Msg:new("insufficient energy!", 475, 65, 0, 0))
    end
  end)

  buttons["test"] = Button:new(475, 500, 100, 50, "test", "50 energy", "single", function()
    if energy >= 10 then
      table.insert(messages, Msg:new("happy birthday!", 475,70))
      axolotls = axolotls + 1
      energy = energy - 10
    elseif energy < 10 then
      table.insert(messages, Msg:new("insufficient energy!", 475, 65, 0, 0))
    end
  end)

  buttons["upgrade_axo_lv2"] = Button:new(475, 165, 100, 50, "upgrade axolotl", "50 energy", "single", function()
    if axolotls >= 1 and energy >= 50 then
      table.insert(messages, Msg:new("swole!", 475,150))
      axolotls = axolotls - 1
      energy = energy - 50
    elseif axolotls < 1 then
      table.insert(messages, Msg:new("insufficient axolotls!", 475, 150, 0, 0))
    elseif energy < 50 then
      table.insert(messages, Msg:new("insufficient energy!", 475, 150, 0, 0))
    end
  end)

  cooldowns["find_food"] = Cooldown:new(330, 165, 100, 50, "find food", 3, function()
    local found = love.math.random(2, 5)
    food = food + found
    table.insert(messages, Msg:new("found "..found.." worms!", 330, 155))
  end)

  cooldowns["make_energy"] = Cooldown:new(330, 80, 100, 50, "photosynthesize", 0.2, function()
    energy = energy + 5
    table.insert(messages, Msg:new("energy gained!", 330, 70))
  end)

end

function love.update(dt)
  -- energy = energy + (1 * dt)
  for k,v in pairs(messages) do
    messages[k]:update(dt)
  end
  for k,v in pairs(cooldowns) do
    cooldowns[k]:update(dt)
  end
end

function love.draw()
  love.graphics.setFont(buttonfont)
  for k,v in pairs(buttons) do
    buttons[k]:draw()
  end
  for k,v in pairs(cooldowns) do
    cooldowns[k]:draw()
  end
  for k,v in pairs(messages) do
    messages[k]:draw()
  end
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(menufont)
  -- love.graphics.print("energy: " .. math.floor(energy), 10, 10)
  -- love.graphics.print("food: " .. food, 10, 40)
  -- love.graphics.print("axolotls: " .. axolotls, 10, 70)
  love.graphics.print("energy: " .. math.floor(energy), 30, 20,0,2)
  love.graphics.print("food: " .. food, 30, 80,0,2)
  love.graphics.print("axolotls: " .. axolotls, 30, 140,0,2)
  love.graphics.line(300, 0, 300, 1200)


  local mx, my = love.mouse.getPosition()
  love.graphics.print(mx .. ", " .. my, mx, my+20)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
