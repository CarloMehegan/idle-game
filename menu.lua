
local mouseIsDown = false

function drawCrosshair()
  if love.keyboard.isDown("lshift") then
    love.graphics.setColor(0,0,0)
  else
    love.graphics.setColor(1,1,1)
  end
  mx, my = love.mouse.getX(), love.mouse.getY()
  love.graphics.line(mx, my - 10, mx, my - 5)
  love.graphics.line(mx, my + 10, mx, my + 5)
  love.graphics.line(mx - 10, my, mx - 5, my)
  love.graphics.line(mx + 10, my, mx + 5, my)
end

function isClicked(btn)
  if mouseIsDown == false then
    if love.mouse.getX() >= btn.x and
       love.mouse.getX() <= btn.x + btn.w and
       love.mouse.getY() >= btn.y and
       love.mouse.getY() <= btn.y + btn.h and
       love.mouse.isDown(1)
    then--draw pressed button if cursor is over button
      mouseIsDown = true
      return true
    else
      return false
    end
  elseif mouseIsDown == true then
    if love.mouse.isDown(1) ~= true then
      mouseIsDown = false
    end
    return false
  end
end

function newButton(x,y,w,h,text,price)
  local btn = {}
  btn.x,btn.y,btn.w,btn.h,btn.text,btn.price = x,y,w,h,text,price
  btn.level = 1
  btn.c = {1,1,1,1}
  btn.isMaxed = false
  function btn:Draw()
    if btn.isMaxed  == false then
      if love.mouse.getX() >= self.x and
         love.mouse.getX() <= self.x + self.w and
         love.mouse.getY() >= self.y and
         love.mouse.getY() <= self.y + self.h
      then--draw pressed button if cursor is over button
        self.c = {0.8,0.8,0.8}
      else--draw unpressed button
        self.c = {1,1,1}
      end
    elseif btn.isMaxed == true then
      self.c = {0.988, 0.816, 0.181}
    end
    love.graphics.setColor(self.c)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.printf(self.text, self.x + 10, self.y + 10, self.w - 15, "left")
    love.graphics.print(self.price, self.x + 10, self.y + 40)
  end

  return btn
end

menu = {}
menu.x = 75
menu.y = 50
menu.w = love.graphics.getWidth() - 150
menu.h = love.graphics.getHeight() - 150

texts = {
  "Speed",
  "Jumps",
  "Damage",
  "Luck",
  "Trump",
  "Cannon 1",
  "Cannon 2",
  "Cannon 3",
  "Cannon 4",
  "Bridge",
}
prices = {
  50,
  100,
  20,
  50,
  5000,
  200,
  200,
  200,
  200,
  10000
}

buttons = {}
local i = 0
for gy=0,1 do
  for gx=0,4 do
    i = i + 1
    table.insert(buttons, newButton(menu.x + 30 + (120 * gx), menu.y + 20 + (80 * gy), 110, 70, texts[i], prices[i]))
  end
end


function menu:Update(dt)
  if love.keyboard.isDown("lshift") then
    -- SPEED UPGRADING
    if isClicked(buttons[1]) then
      if buttons[1].level <= 9 then
        if buttons[1].price < score then
          score = score - buttons[1].price
          buttons[1].level = buttons[1].level + 1
          buttons[1].text = "Speed " .. buttons[1].level
          buttons[1].price = math.floor(buttons[1].price * 1.8)
          player.speed = player.speed + 25
        end
        if buttons[1].level == 10 then
          buttons[1].price = ""
          buttons[1].isMaxed = true
        end
      end
    end
    --DAMAGE UPDRADING
    if isClicked(buttons[3]) then
      if buttons[3].level <= 9 then
        if buttons[3].price < score then
          score = score - buttons[3].price
          buttons[3].level = buttons[3].level + 1
          buttons[3].text = "Damage " .. buttons[3].level
          buttons[3].price = math.floor(buttons[3].price * 8)
          player.dmg = player.dmg + 1
        end
        if buttons[3].level == 10 then
          buttons[3].price = ""
          buttons[3].isMaxed = true
        end
      end
    end
  end
end

function menu:Draw()
  if love.keyboard.isDown("lshift") then
    love.graphics.setColor(1, 1, 1, 0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    for k,v in pairs(buttons) do
      v:Draw()
    end
  end
end
