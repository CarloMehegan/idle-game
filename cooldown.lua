local class = require 'middleclass'

Cooldown = class('Cooldown') -- for buttons with cooldowns

function Cooldown:initialize(x,y,w,h,name,cooltimemax, clickbonus, func)
  self.x,self.y,self.w,self.h = x,y,w,h
  self.level = 1
  self.c = {1,1,1,1}
  self.isMaxed = false
  self.func = func
  self.name = name
  self.cooltimemax = cooltimemax
  self.cooltime = 0
  self.cooling = false
  self.clickbonus = clickbonus -- when cooling down and button is clicked, speeds up by this much
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
    mx, my = love.mouse.getPosition()
    mx, my = mx + camera.x, my + camera.y
    if mx >= self.x and
       mx <= self.x + self.w and
       my >= self.y and
       my <= self.y + self.h
    then--draw pressed button if cursor is over button
      self.c = {0.8,0.8,0.8}
      if love.mouse.isDown(1) and self.leftdown == false and self.cooling == false then
        self.cooling = true
        self.leftdown = true
      elseif love.mouse.isDown(1) and self.leftdown == false then
        self.cooltime = self.cooltime + self.clickbonus
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
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.w*math.min((self.cooltime/self.cooltimemax),1), self.h)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(self.name, self.x + 10, self.y + 10, self.w - 15, "left")
  else
    love.graphics.setColor(1,1,1)
    love.graphics.printf(self.name, self.x + 10, self.y + 10, self.w - 15, "left")
  end
  love.graphics.setColor(1,1,1)
end

return Cooldown
