local class = require 'middleclass'

Button = class('Button')

function Button:initialize(x,y,w,h,clicktype,func)
  self.x,self.y,self.w,self.h = x,y,w,h
  self.level = 1
  self.c = {1,1,1,1}
  self.isMaxed = false
  self.func = func
  self.clicktype = clicktype
  self.leftdown = true
end
function Button:draw(tablelength)
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
  -- love.graphics.printf(self.text, self.x + 10, self.y + 10, self.w - 15, "left")
  -- love.graphics.print(self.price, self.x + 10, self.y + 40)
  love.graphics.setColor(1,1,1)
end

return Button
