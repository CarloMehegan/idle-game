local class = require 'middleclass'

Button = class('Button')

function Button:initialize(x,y,w,h,name,price,clicktype,func)
  self.x,self.y,self.w,self.h = x,y,w,h
  self.level = 1
  self.c = {1,1,1,1}
  self.isMaxed = false
  self.func = func
  self.name = name
  self.clicktype = clicktype
  self.leftdown = false
  self.pricelabel = price
  self.shown = true
end

function Button:draw(newClick)
  if self.shown == true then
    mx, my = love.mouse.getPosition()
    mx, my = mx + camera.x, my + camera.y
    if mx >= self.x and
       mx <= self.x + self.w and
       my >= self.y and
       my <= self.y + self.h
    then--draw pressed button if cursor is over button
      self.c = {0.8,0.8,0.8}

      if self.clicktype == "single" then
        if newClick then
          self.c = {0.5, 0.5, 0.5}
          self.func()
        end
      elseif self.clicktype == "repeat" then
        if love.mouse.isDown(1) then
          self.c = {0.5, 0.5, 0.5}
          self.func()
        end
      end

    else--draw unpressed button
      self.c = {1,1,1}
    end

    love.graphics.setColor(self.c)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0,0,0)

    --some special settings for different kinds of buttons
    if self.name == "+" or self.name == "-" then
      love.graphics.printf(self.name, self.x, self.y + 2, self.w, "center")
      mx, my = love.mouse.getPosition()
      mx, my = mx + camera.x, my + camera.y
      if mx >= self.x and
         mx <= self.x + self.w and
         my >= self.y and
         my <= self.y + self.h
      then
        love.graphics.setColor(1,1,1)
        --print twice because it wont show up thick enough
        local x = 705
        local y = 75
        if roaminganimals > 0 and showContractHelp == false then
          x = 705
          y = 95
        end
        love.graphics.print("need " .. self.pricelabel .. " food", x, y)
        love.graphics.print("need " .. self.pricelabel .. " food", x, y)
      end
    elseif self.name == "?" then
      love.graphics.printf(self.name, self.x, self.y + 2, self.w, "center")
      mx, my = love.mouse.getPosition()
      mx, my = mx + camera.x, my + camera.y
      if mx >= self.x and
         mx <= self.x + self.w and
         my >= self.y and
         my <= self.y + self.h
      then
        love.graphics.setColor(1,1,1)
        love.graphics.print("press for help", self.x + 22, self.y + 2)
        -- love.graphics.print("need " .. self.pricelabel .. " food", self.x + 22, self.y + 2)
      end
    elseif self.name == "v" or self.name == "^" or self.name == ">" or self.name == "<" then --the movement buttons
      love.graphics.printf(self.name, self.x, self.y + 2, self.w, "center")
      mx, my = love.mouse.getPosition()
      mx, my = mx + camera.x, my + camera.y
      if mx >= self.x and
         mx <= self.x + self.w and
         my >= self.y and
         my <= self.y + self.h
      then
        love.graphics.setColor(1,1,1)
        --print twice because it wont show up thick enough
        love.graphics.print(self.pricelabel, 620, 358)
        love.graphics.print(self.pricelabel, 620, 358)
      end
    else
      love.graphics.printf(self.name, self.x + 10, self.y + 10, self.w - 15, "left")
      love.graphics.setColor(1,1,1)
      love.graphics.print(self.pricelabel, self.x, self.y + self.h + 5)
    end

    love.graphics.setColor(1,1,1)
  end
end

return Button
