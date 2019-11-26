-- Idle Game for AP Comp Sci Principles
-- Carlo Mehegan
-- November 2019

local Button = require "button"
local Cooldown = require "cooldown"
local Msg = require "messages"
local Worker = require "worker"

function love.load()
  love.window.setMode(1200, 820, {resizable = true, minwidth=800, minheight=600}) --sets size of window
  love.graphics.setDefaultFilter('nearest', 'nearest') -- makes images not blurry
  love.window.setTitle("Idle Game") -- window title
  menufont = love.graphics.newImageFont("imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
  buttonfont = love.graphics.newFont("nimbusmono-regular.otf", 15)

  energy = 1000
  food = 0
  axolotls = 0
  fennecs = 0
  pangolins = 0
  kittens = 0
  otters = 0
  seals = 0
  hippos = 0
  leopards = 0
  tigers = 0
  pandas = 0
  messages = {}
  buttons = {}
  cooldowns = {}
  workers = {}

  local axox, axoy = 475, 90
  buttons["make_axolotl"] = Button:new(axox, axoy, 100, 50, "axolotl", "10 energy", "single", function()
    if energy >= 10 then
      table.insert(messages, Msg:new("happy birthday!", axox,axoy-10))
      axolotls = axolotls + 1
      energy = energy - 10
    elseif energy < 10 then
      table.insert(messages, Msg:new("insufficient energy!", axox, axoy-15, 0, 0))
    end
  end)
  local fennecx,fennecy = 475,180
  buttons["make_fennec"] = Button:new(fennecx, fennecy, 100, 50, "fennec fox", "200 energy", "single", function()
    if energy >= 200 then
      table.insert(messages, Msg:new("happy birthday!", fennecx,fennecy-10))
      fennecs = fennecs + 1
      energy = energy - 200
    elseif energy < 200 then
      table.insert(messages, Msg:new("insufficient energy!", fennecx, fennecy-15, 0, 0))
    end
  end)
  local pangox,pangoy = 475,270
  buttons["make_pangolin"] = Button:new(pangox, pangoy, 100, 50, "pangolin", "1000 energy", "single", function()
    if energy >= 1000 then
      table.insert(messages, Msg:new("happy birthday!", pangox,pangoy-10))
      pangolins = pangolins + 1
      energy = energy - 1000
    elseif energy < 1000 then
      table.insert(messages, Msg:new("insufficient energy!", pangox, pangoy-15, 0, 0))
    end
  end)
  local catx,caty = 475,360
  buttons["make_kitten"] = Button:new(catx, caty, 100, 50, "sand kitten", "5000 energy", "single", function()
    if energy >= 5000 then
      table.insert(messages, Msg:new("happy birthday!", catx,caty-10))
      kittens = kittens + 1
      energy = energy - 5000
    elseif energy < 5000 then
      table.insert(messages, Msg:new("insufficient energy!", catx, caty-15, 0, 0))
    end
  end)
  local otterx,ottery = 475,450
  buttons["make_otter"] = Button:new(otterx, ottery, 100, 50, "sea otter", "30000 energy", "single", function()
    if energy >= 5000 then
      table.insert(messages, Msg:new("happy birthday!", otterx,ottery-10))
      otters = otters + 1
      energy = energy - 5000
    elseif energy < 5000 then
      table.insert(messages, Msg:new("insufficient energy!", otterx, ottery-15, 0, 0))
    end
  end)
  local sealx,sealy = 475,540
  buttons["make_seal"] = Button:new(sealx, sealy, 100, 50, "harp seal", "30000 energy", "single", function()
    if energy >= 5000 then
      table.insert(messages, Msg:new("happy birthday!", sealx,sealy-10))
      seals = seals + 1
      energy = energy - 5000
    elseif energy < 5000 then
      table.insert(messages, Msg:new("insufficient energy!", sealx, sealy-15, 0, 0))
    end
  end)
  local hippox,hippoy = 475,630
  buttons["make_hippo"] = Button:new(hippox, hippoy, 100, 50, "hippo", "30000 energy", "single", function()
    if energy >= 5000 then
      table.insert(messages, Msg:new("happy birthday!", hippox,hippoy-10))
      hippos = hippos + 1
      energy = energy - 5000
    elseif energy < 5000 then
      table.insert(messages, Msg:new("insufficient energy!", hippox, hippoy-15, 0, 0))
    end
  end)
  local pandax,panday = 475,720
  buttons["make_panda"] = Button:new(pandax, panday, 100, 50, "giant panda", "30000 energy", "single", function()
    if energy >= 5000 then
      table.insert(messages, Msg:new("happy birthday!", pandax,panday-10))
      pandas = pandas + 1
      energy = energy - 5000
    elseif energy < 5000 then
      table.insert(messages, Msg:new("insufficient energy!", pandax, panday-15, 0, 0))
    end
  end)

  local foodx,foody = 330,180
  cooldowns["find_food"] = Cooldown:new(foodx, foody, 100, 50, "find food", 3, function()
    local found = love.math.random(2, 5)
    food = food + found
    table.insert(messages, Msg:new("found "..found.." worms!", foodx, foody-10))
  end)
  local enx,eny = 330,90
  cooldowns["make_energy"] = Cooldown:new(enx, eny, 100, 50, "photosynthesize", 0.2, function()
    energy = energy + 5
    table.insert(messages, Msg:new("energy gained!", enx, eny-10))
  end)
  for i=1,10 do
    table.insert(workers, Worker:new("mars", "energy", 10))
  end

end

function love.update(dt)

  for k,v in pairs(messages) do
    messages[k]:update(dt)
  end
  for k,v in pairs(cooldowns) do
    cooldowns[k]:update(dt)
  end
  for k,v in pairs(workers) do
    workers[k]:update()
    if v.job == "energy" then
      energy = energy + (v.strength * dt)
    end
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
  for k,v in pairs(workers) do
    workers[k]:draw()
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(menufont)
  love.graphics.print("resources", 30, 20,0,2)
  love.graphics.line(0, 60, 2000, 60)

  -- love.graphics.printf("energy: " .. math.floor(energy), 30, 80, 125, "left", 0,1.8)
  -- love.graphics.print("food: " .. food, 30, 170,0,2)
  -- if axolotls > 0 then love.graphics.print("axolotls: " .. axolotls, 30, 200,0,2) end
  -- if fennecs > 0 then love.graphics.print("fennecs: " .. fennecs, 30, 260,0,2) end
  -- if pangolins > 0 then love.graphics.print("pangolins: " .. pangolins, 30, 320,0,2) end
  -- if kittens > 0 then love.graphics.print("kittens: " .. kittens, 30, 380,0,2) end
  -- if otters > 0 then love.graphics.print("otters: " .. otters, 30, 440,0,2) end
  -- if seals > 0 then love.graphics.print("seals: " .. seals, 30, 500,0,2) end
  -- if hippos > 0 then love.graphics.print("hippos: " .. hippos, 30, 560,0,2) end
  -- if pandas > 0 then love.graphics.print("pandas: " .. pandas, 30, 620,0,2) end
  love.graphics.printf(
    "energy: " .. math.floor(energy)
    .."\n\nfood: " .. math.floor(food)
    .."\n\naxolotls: " .. axolotls
    .."\n\nfennecs: " .. fennecs
    .."\n\npangolins: " .. pangolins
    .."\n\nkittens: " .. kittens
    .."\n\notters: " .. otters
    .."\n\nseals: " .. seals
    .."\n\nhippos: " .. hippos
    .."\n\npandas: " .. pandas
  , 30, 80, 125, "left", 0,1.8)

  love.graphics.printf(
    "axolotls: " .. axolotls
    .."\n\nfennecs: " .. fennecs
    .."\n\npangolins: " .. pangolins
    .."\n\nkittens: " .. kittens
    .."\n\notters: " .. otters
    .."\n\nseals: " .. seals
    .."\n\nhippos: " .. hippos
    .."\n\npandas: " .. pandas
  , 620, 75, 125, "left", 0,1)

  love.graphics.line(300, 0, 300, 1200)
  love.graphics.print("gather", 330, 20,0,2)
  love.graphics.print("make", 485, 20,0,2)
  love.graphics.line(605, 0, 610, 1200)
  love.graphics.print("contract", 640, 20,0,2)
  love.graphics.line(608, 350, 2000, 350)


  local mx, my = love.mouse.getPosition()
  love.graphics.print(mx .. ", " .. my, mx, my+20)

  love.graphics.setFont(buttonfont)
  for k,v in pairs(messages) do
    messages[k]:draw()
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end
