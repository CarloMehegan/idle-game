local class = require 'middleclass'

Cooldown = class('Cooldown') -- for buttons with cooldowns

function Cooldown:initialize(x,y,w,h,name,cooltimemax,func)
  self.x,self.y,self.w,self.h = x,y,w,h
  self.level = 1
  self.c = {1,1,1,1}
  self.isMaxed = false
  self.func = func
  self.name = name
  self.cooltimemax = cooltimemax
  self.cooltime = 0
  self.cooling = false
  self.leftdown = true
end

function Cooldown:update(dt)
  if self.cooling == true then
    if self.cooltime < self.cooltimemax then
      self.cooltime = self.cooltime + 1 * dt
      self.c = {0.5, 0.5, 0.5}
    elseif self.cooltime >= self.cooltimemax then
      self.cooltime = 0
      self.cooling = false
      self.func()
    end
  end
end

function Cooldown:draw()
  if self.isMaxed  == false then
    if love.mouse.getX() >= self.x and
       love.mouse.getX() <= self.x + self.w and
       love.mouse.getY() >= self.y and
       love.mouse.getY() <= self.y + self.h
    then--draw pressed button if cursor is over button
      self.c = {0.8,0.8,0.8}
      if love.mouse.isDown(1) and self.leftdown == false and self.cooling == false then
        self.cooling = true
        self.leftdown = true
      elseif self.leftdown == true then
        if love.mouse.isDown(1) == false then
          self.leftdown = false
        end
      end
    else--draw unpressed button
      self.c = {1,1,1}
    end
  elseif self.isMaxed == true then
    self.c = {0.988, 0.816, 0.181}
  end

  love.graphics.setColor(self.c)
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
  if self.cooling == true then
    -- self.c = {0.5, 0.5, 0.5}
    love.graphics.rectangle("fill", self.x, self.y, self.w*(self.cooltime/self.cooltimemax), self.h)
  end
  love.graphics.setColor(1,1,1)
  love.graphics.printf(self.name, self.x + 10, self.y + 10, self.w - 15, "left")
  love.graphics.setColor(1,1,1)
end

return Cooldown
