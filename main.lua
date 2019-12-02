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
  love.window.setTitle("Unendangerer - Save The Animals!") -- window title
  menufont = love.graphics.newImageFont("imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
  buttonfont = love.graphics.newFont("nimbusmono-regular.otf", 15)

  fullscreen = false
  lastLeftDown = false
  isLeftDown = false
  newClick = false
  showContractPanels = false
  showContractHelp = false

  energy = 0
  food = 0
  energyonclick = 1
  minchancefood = 3
  maxchancefood = 6
  producingenergy = 0
  producingfood = 0
  axolotls = 0
  fennecs = 0
  pangolins = 0
  kittens = 0
  otters = 0
  seals = 0
  hippos = 0
  pandas = 0
  messages = {}
  buttons = {}
  cooldowns = {}
  workers = {}

  local axox, axoy = 475, 90
  local cost = 10
  buttons["make_axolotl"] = Button:new(axox, axoy, 100, 50, "axolotl", "10 energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", axox,axoy-10))
      axolotls = axolotls + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", axox, axoy-15, 0, 0))
    end
  end)
  local fennecx,fennecy = 475,180
  local cost = 100
  buttons["make_fennec"] = Button:new(fennecx, fennecy, 100, 50, "fennec fox", "100 energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", fennecx,fennecy-10))
      fennecs = fennecs + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", fennecx, fennecy-15, 0, 0))
    end
  end)
  local pangox,pangoy = 475,270
  local cost = 1100
  buttons["make_pangolin"] = Button:new(pangox, pangoy, 100, 50, "pangolin", "1.1K energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", pangox,pangoy-10))
      pangolins = pangolins + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", pangox, pangoy-15, 0, 0))
    end
  end)
  local catx,caty = 475,360
  local cost = 12000
  buttons["make_kitten"] = Button:new(catx, caty, 100, 50, "sand kitten", "12K energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", catx,caty-10))
      kittens = kittens + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", catx, caty-15, 0, 0))
    end
  end)
  local otterx,ottery = 475,450
  local cost = 130000
  buttons["make_otter"] = Button:new(otterx, ottery, 100, 50, "sea otter", "130K energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", otterx,ottery-10))
      otters = otters + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", otterx, ottery-15, 0, 0))
    end
  end)
  local sealx,sealy = 475,540
  local cost = 1400000 -- 1.4 mil
  buttons["make_seal"] = Button:new(sealx, sealy, 100, 50, "harp seal", "1.4M energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", sealx,sealy-10))
      seals = seals + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", sealx, sealy-15, 0, 0))
    end
  end)
  local hippox,hippoy = 475,630
  local cost = 20000000 -- 20 mil
  buttons["make_hippo"] = Button:new(hippox, hippoy, 100, 50, "hippo", "20M energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", hippox,hippoy-10))
      hippos = hippos + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", hippox, hippoy-15, 0, 0))
    end
  end)
  local pandax,panday = 475,720
  local cost = 330000000 -- 330 mil
  buttons["make_panda"] = Button:new(pandax, panday, 100, 50, "giant panda", "330M energy", "single", function()
    if energy >= cost then
      table.insert(messages, Msg:new("happy birthday!", pandax,panday-10))
      pandas = pandas + 1
      energy = energy - cost
    elseif energy < cost then
      table.insert(messages, Msg:new("need energy!", pandax, panday-15, 0, 0))
    end
  end)
  buttons["make_fennec"].shown = false
  buttons["make_pangolin"].shown = false
  buttons["make_kitten"].shown = false
  buttons["make_otter"].shown = false
  buttons["make_seal"].shown = false
  buttons["make_hippo"].shown = false
  buttons["make_panda"].shown = false

  local foodx,foody = 330,180
  cooldowns["find_food"] = Cooldown:new(foodx, foody, 100, 50, "find food", 2.8, 0.4, function()
    local found = love.math.random(minchancefood, maxchancefood)
    food = food + found
    table.insert(messages, Msg:new("found "..found.." berries!", foodx, foody-10))
  end)
  local enx,eny = 330,90
  cooldowns["make_energy"] = Cooldown:new(enx, eny, 100, 50, "photosynthesize", 0.2, 0.1, function()
    energy = energy + energyonclick
    table.insert(messages, Msg:new(energyonclick .. " energy gained!", enx, eny-10))
  end)


  local cost = 15
  local x, y = 660, 76 + 34*(0)
  buttons["axo_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and axolotls >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("axolotl", "", 0.1, {1,0,0,0.9}))
      food = food - cost
      axolotls = axolotls - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif axolotls < 1 then
      table.insert(messages, Msg:new("need an axolotl!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 150
  local x, y = 660, 76 + 34*(1)
  buttons["fen_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and fennecs >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("fennec", "", 1, {1,0.5,0,0.9}))
      food = food - cost
      fennecs = fennecs - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif fennecs < 1 then
      table.insert(messages, Msg:new("need a fennec fox!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 1650
  local x, y = 660, 76 + 34*(2)
  buttons["pan_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and pangolins >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("pangolin", "", 8, {1,1,0,0.9}))
      food = food - cost
      pangolins = pangolins - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif pangolins < 1 then
      table.insert(messages, Msg:new("need a pangolin!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 1800
  local x, y = 660, 76 + 34*(3)
  buttons["cat_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and kittens >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("kitten", "", 47, {0,1,0,0.9}))
      food = food - cost
      kittens = kittens - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif kittens < 1 then
      table.insert(messages, Msg:new("need a sand kitty!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 195000
  local x, y = 660, 76 + 34*(4)
  buttons["ott_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and otters >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("otter", "", 260, {0,1,1,0.9}))
      food = food - cost
      otters = otters - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif otters < 1 then
      table.insert(messages, Msg:new("need a sea otter!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 2.1 * 1000000
  local x, y = 660, 76 + 34*(5)
  buttons["sea_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and seals >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("seal", "", 1400, {0,0,1,0.9}))
      food = food - cost
      seals = seals - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif seals < 1 then
      table.insert(messages, Msg:new("need a harp seal!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 30 * 1000000
  local x, y = 660, 76 + 34*(6)
  buttons["hip_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()

    if food >= cost and hippos >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("hippo", "", 7800, {0.5,0,1,0.9}))
      food = food - cost
      hippos = hippos - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif hippos < 1 then
      table.insert(messages, Msg:new("need a hippo!", x+22, y+2, 0, 0))
    end
  end)
  local cost = 495 * 1000000
  local x, y = 660, 76 + 34*(7)
  buttons["gia_worker"] = Button:new(x, y, 15, 15, "+", cost, "single", function()
    if food >= cost and pandas >= 1 then
      table.insert(messages, Msg:new("new worker!", x+22, y+2))
      table.insert(workers, Worker:new("panda", "", 44000, {1,0,1,0.9}))
      food = food - cost
      pandas = pandas - 1
    elseif food < cost then
      table.insert(messages, Msg:new("need " .. cost .. " food!", x+22, y+2, 0, 0))
    elseif pandas < 1 then
      table.insert(messages, Msg:new("need a panda!", x+22, y+2, 0, 0))
    end
  end)
  buttons["axo_worker"].shown = false
  buttons["fen_worker"].shown = false
  buttons["pan_worker"].shown = false
  buttons["cat_worker"].shown = false
  buttons["ott_worker"].shown = false
  buttons["sea_worker"].shown = false
  buttons["hip_worker"].shown = false
  buttons["gia_worker"].shown = false

  local prompt = "click for help"
  local x, y = 785, 28
  buttons["contract_help"] = Button:new(x, y, 15, 15, "?", "", "single", function()
    if showContractHelp == false then
      showContractHelp = true
    elseif showContractHelp == true then
      showContractHelp = false
    end
  end)

  local x,y = 330,270
  buttons["unlock_contracts"] = Button:new(330, 270, 100, 50, "unlock contracts", "", "single", function()
    if energy >= 50 and food >= 50 then
      showContractPanels = true
      energy = energy - 50
      food = food - 50
      buttons["unlock_contracts"].shown = false
    elseif energy < 50 or food < 50 then
      table.insert(messages, Msg:new("need 50 food and 50 energy!", x+107, y+19, 0, 0))
    end
  end)
  buttons["unlock_contracts"].shown = false

end

function love.update(dt)
  --checking clicky stuff to prevent repeat clicks
  lastLeftDown = isLeftDown
  isLeftDown = love.mouse.isDown(1)
  if lastLeftDown == false and isLeftDown == true then
    newClick = true
  else
    newClick = false
  end

  --updating moving messages and cooldown bars
  for k,v in pairs(messages) do
    messages[k]:update(dt)
  end
  for k,v in pairs(cooldowns) do
    cooldowns[k]:update(dt)
  end

  --making worker sprites move and calculating production
  producingenergy = 0
  producingfood = 0
  roaminganimals = 0
  for k,v in pairs(workers) do
    workers[k]:update(newClick)
    if v.job == "energy" then
      producingenergy = producingenergy + v.strength*8
      energy = energy + (v.strength*8 * dt)
    elseif v.job == "food" then
      producingfood = producingfood + v.strength*2
      food = food + (v.strength*2 * dt)
    elseif v.job == "" then
      roaminganimals = roaminganimals + v.strength*8
    end
  end
  maxchancefood = 6 + math.floor(roaminganimals/4)
  minchancefood = 3 + math.floor(roaminganimals/6)
  energyonclick = 1 + math.floor(roaminganimals/3)

  --keeping buttons hidden until certain events
  if buttons["make_fennec"].shown == false then
    if axolotls >= 1 then buttons["make_fennec"].shown = true end
  end
  if buttons["make_pangolin"].shown == false then
    if fennecs >= 1 then buttons["make_pangolin"].shown = true end
  end
  if buttons["make_kitten"].shown == false then
    if pangolins >= 1 then buttons["make_kitten"].shown = true end
  end
  if buttons["make_otter"].shown == false then
    if kittens >= 1 then buttons["make_otter"].shown = true end
  end
  if buttons["make_seal"].shown == false then
    if otters >= 1 then buttons["make_seal"].shown = true end
  end
  if buttons["make_hippo"].shown == false then
    if seals >= 1 then buttons["make_hippo"].shown = true end
  end
  if buttons["make_panda"].shown == false then
    if hippos >= 1 then buttons["make_panda"].shown = true end
  end

  if showContractPanels then
    if axolotls >= 1 then buttons["axo_worker"].shown = true
    else buttons["axo_worker"].shown = false end
    if fennecs >= 1 then buttons["fen_worker"].shown = true
    else buttons["fen_worker"].shown = false end
    if pangolins >= 1 then buttons["pan_worker"].shown = true
    else buttons["pan_worker"].shown = false end
    if kittens >= 1 then buttons["cat_worker"].shown = true
    else buttons["cat_worker"].shown = false end
    if otters >= 1 then buttons["ott_worker"].shown = true
    else buttons["ott_worker"].shown = false end
    if seals >= 1 then buttons["sea_worker"].shown = true
    else buttons["sea_worker"].shown = false end
    if hippos >= 1 then buttons["hip_worker"].shown = true
    else buttons["hip_worker"].shown = false end
    if pandas >= 1 then buttons["gia_worker"].shown = true
    else buttons["gia_worker"].shown = false end
  end

  if energy >= 10 and axolotls > 0 and buttons["unlock_contracts"].shown == false and showContractPanels == false then
    buttons["unlock_contracts"].shown = true
  end
  buttons["contract_help"].shown = showContractPanels
end

function love.draw()
  love.graphics.setFont(buttonfont)
  for k,v in pairs(buttons) do
    buttons[k]:draw()
  end
  for k,v in pairs(cooldowns) do
    cooldowns[k]:draw()
  end

  love.graphics.setFont(menufont)
  local mx, my = love.mouse.getPosition()
  for k,v in pairs(workers) do
    workers[k]:draw(mx,my)
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(menufont)


  --these numbers get big, so once theyre over 1M, we use scientific notation
  if energy > 1000000 then
    formattedenergy = string.format("energy: %.3e", energy)
  else
    formattedenergy = "energy: " .. math.floor(energy)
  end
  if food > 1000000 then
    formattedfood = string.format("food: %.3e", food)
  else
    formattedfood = "food: " .. math.floor(food)
  end

  --hiding stuff
  if axolotls > 0 then axotext = "\n\naxolotls: " .. axolotls
  else axotext = "" end
  if fennecs > 0 then fentext = "\n\nfennecs: " .. fennecs
  else fentext = "" end
  if pangolins > 0 then pantext = "\n\npangolins: " .. pangolins
  else pantext = "" end
  if kittens > 0 then cattext = "\n\nkittens: " .. kittens
  else cattext = "" end
  if otters > 0 then otttext = "\n\notters: " .. otters
  else otttext = "" end
  if seals > 0 then seatext = "\n\nseals: " .. seals
  else seatext = "" end
  if hippos > 0 then hiptext = "\n\nhippos: " .. hippos
  else hiptext = "" end
  if pandas > 0 then giatext = "\n\npandas: " .. pandas
  else giatext = "" end

  -- for the resources panel
  -- (printing it all complicated because bigger numbers
  -- will take up two rows of text)
  love.graphics.printf(
    "" .. formattedenergy
    .."\n\n" .. formattedfood
    ..axotext
    ..fentext
    ..pantext
    ..cattext
    ..otttext
    ..seatext
    ..hiptext
    ..giatext
  , 30, 80, 125, "left", 0,1.8)

  -- for the contract panel
  if showContractPanels then
    if axolotls > 0 then love.graphics.print("axo: ", 620, 75 + 34*(0)) end
    if fennecs > 0 then love.graphics.print("fen: ", 620, 75 + 34*(1)) end
    if pangolins > 0 then love.graphics.print("pan: ", 620, 75 + 34*(2)) end
    if kittens > 0 then love.graphics.print("cat: ", 620, 75 + 34*(3)) end
    if otters > 0 then love.graphics.print("ott: ", 620, 75 + 34*(4)) end
    if seals > 0 then love.graphics.print("sea: ", 620, 75 + 34*(5)) end
    if hippos > 0 then love.graphics.print("hip: ", 620, 75 + 34*(6)) end
    if pandas > 0 then love.graphics.print("pan: ", 620, 75 + 34*(7)) end
  end

  love.graphics.print("resources", 30, 20,0,2)
  love.graphics.line(0, 60, 2000, 60)
  love.graphics.line(300, 0, 300, 1200)
  love.graphics.print("gather", 330, 20,0,2)
  love.graphics.print("make", 485, 20,0,2)

  if showContractPanels then
    love.graphics.line(605, 0, 605, 1200)
    love.graphics.print("contract", 630, 20,0,2)
    love.graphics.line(606, 350, 2000, 350)
    love.graphics.print("energy", 620, 370,0,2)
    if producingenergy > 0 then
      if producingenergy > 1000000 then
        love.graphics.print(string.format("producing %.3e energy/sec", producingenergy), 620, 410,0,1)
      else
        love.graphics.print("producing " .. producingenergy .. " energy/sec", 620, 410,0,1)
      end
    end
    love.graphics.line(902, 350, 902, 1200)
    love.graphics.print("food", 917, 370,0,2)
    if producingfood > 0 then
      if producingfood > 1000000 then
        love.graphics.print(string.format("producing %.3e food/sec", producingfood), 917, 410,0,1)
      else
        love.graphics.print("producing " .. producingfood .. " food/sec", 917, 410,0,1)
      end
    end
    love.graphics.line(1205, 350, 1205, 1200)
    if roaminganimals > 0 then
      -- love.graphics.printf(roaminganimals, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)roaminganimals
    end
    if roaminganimals > 0 and showContractHelp == false then
      local x = 620
      local y = 75
      if axolotls > 0 then
        x = 700
      end
      if roaminganimals > 1000000 then
        love.graphics.print(string.format("roaming animal strength: %.3e", roaminganimals), x, y,0,1)
      else
        love.graphics.print("roaming animal strength: " .. roaminganimals, x, y,0,1)
      end
    end
  end


  love.graphics.setFont(buttonfont)
  if showContractHelp then
    love.graphics.printf("This is where you hire animals to help you. Once hired, drag them into the energy or food columns to assign them to those jobs. Animals left roaming with no jobs will aid you when you manually gather resources.", 800, 75, 200)
  end

  -- local mx, my = love.mouse.getPosition()
  -- love.graphics.print(mx .. ", " .. my, mx, my+20)

  for k,v in pairs(messages) do
    messages[k]:draw()
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
  if key == "f" then
    if fullscreen == false then
      love.window.setMode( 800, 600, {fullscreen = true} )
      fullscreen = true
    elseif fullscreen == true then
      love.window.setMode( 1200, 820, {resizable = true, minwidth=800, minheight=600})
      fullscreen = false
    end
  end
end
