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
  self.leftdown = true
  self.pricelabel = price
end

function Button:draw()
  if self.isMaxed  == false then
    if love.mouse.getX() >= self.x and
       love.mouse.getX() <= self.x + self.w and
       love.mouse.getY() >= self.y and
       love.mouse.getY() <= self.y + self.h
    then--draw pressed button if cursor is over button
      self.c = {0.8,0.8,0.8}

      if self.clicktype == "single" then
        if love.mouse.isDown(1) and self.leftdown == false then
          self.c = {0.5, 0.5, 0.5}
          self.func()
          self.leftdown = true
        elseif self.leftdown == true then
          if love.mouse.isDown(1) == false then
            self.leftdown = false
          end
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
  elseif self.isMaxed == true then
    self.c = {0.988, 0.816, 0.181}
  end
  love.graphics.setColor(self.c)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
  love.graphics.setColor(0,0,0)

  if self.name == "+" or self.name == "-" then
    love.graphics.printf(self.name, self.x, self.y + 2, self.w, "center")
    mx, my = love.mouse.getPosition()
    if mx >= self.x and
       mx <= self.x + self.w and
       my >= self.y and
       my <= self.y + self.h
    then
      love.graphics.setColor(1,1,1)
      --print twice because it wont show up thick enough
      love.graphics.print("need " .. self.pricelabel .. " food", self.x + 22, self.y + 2)
      love.graphics.print("need " .. self.pricelabel .. " food", self.x + 22, self.y + 2)
    end
  elseif self.name == "?" then
    love.graphics.printf(self.name, self.x, self.y + 2, self.w, "center")
    mx, my = love.mouse.getPosition()
    if mx >= self.x and
       mx <= self.x + self.w and
       my >= self.y and
       my <= self.y + self.h
    then
      love.graphics.setColor(1,1,1)
      love.graphics.print("press for help", self.x + 22, self.y + 2)
      -- love.graphics.print("need " .. self.pricelabel .. " food", self.x + 22, self.y + 2)
    end
  else
    love.graphics.printf(self.name, self.x + 10, self.y + 10, self.w - 15, "left")
    love.graphics.setColor(1,1,1)
    love.graphics.print(self.pricelabel, self.x, self.y + self.h + 5)
  end

  love.graphics.setColor(1,1,1)
end

return Button
