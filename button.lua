local class = require 'middleclass'

Button = class('Button')

function Button:initialize(x,y,w,h,func)
  self.x,self.y,self.w,self.h,self.text,self.price = x,y,w,h,text,price
  self.level = 1
  self.c = {1,1,1,1}
  self.isMaxed = false
  self.func = func
end
function Button:draw(tablelength)
  if self.isMaxed  == false then
    if love.mouse.getX() >= self.x and
       love.mouse.getX() <= self.x + self.w and
       love.mouse.getY() >= self.y and
       love.mouse.getY() <= self.y + self.h
    then--draw pressed button if cursor is over button
      self.c = {0.8,0.8,0.8}
      if love.mouse.isDown(1) then
        self.func()
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
