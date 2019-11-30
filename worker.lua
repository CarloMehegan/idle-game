local class = require 'middleclass'

Worker = class('Worker')

function Worker:initialize(type, job, strength, color)
  self.strength = strength
  self.job = job
  self.type = type
  self.color = color
  self.img = love.graphics.newImage("sprites/Mars Background - Copy.png")
  self.s = 1
  self.w = 32 * self.s
  self.h = 32 * self.s
  self.x = love.math.random(690, 1195 - self.w)
  self.y = love.math.random(65, 345 - self.h)
  self.dx = love.math.random(1,2)
  if self.dx == 2 then self.dx = -1 end
  self.dy = love.math.random(1,2)
  if self.dy == 2 then self.dy = -1 end
  self.speed = love.math.random(80,120)/100
  self.isGrabbed = false
  self.isWorking = false
end

function Worker:update(isNewClick)
  local mx, my = love.mouse.getPosition()

  if mx > self.x and
    mx < self.x + self.w and
    my > self.y and
    my < self.y + self.h and
    isNewClick
  then
    self.isGrabbed = true
  end

  if self.isGrabbed then
    self.x = mx - self.w/2
    self.y = my - self.h/2
    if love.mouse.isDown(1) == false then
      self.isGrabbed = false
      if self.y > 350 and self.x > 605 then
        self.isWorking = true
      end
    end


  elseif self.isWorking then -- working pools
    if self.y < 345 or self.x < 605 then
      self.isWorking = false
      self.job = ""
    end
    if self.y > 345 and self.x > 605 and self.x < 902 then
      self.job = "energy"
    elseif self.y > 345 and self.x > 902 and self.x < 1200 then
      self.job = "food"
    end

  else -- in contract pool
    self.x = self.x + self.dx*self.speed
    self.y = self.y + self.dy*self.speed
    if self.x < 690 then
      self.x = 690
      self.dx = -self.dx
    end
    if self.x + self.w > love.graphics.getWidth() - 5 then
      self.x = love.graphics.getWidth() - 5 - self.w
      self.dx = -self.dx
    end
    if self.y < 65 then
      self.y = 65
      self.dy = -self.dy
    end
    if self.y + self.h > 345 then
      self.y = 345 - self.h
      self.dy = -self.dy
    end
  end
end

function Worker:draw(mx,my)
  love.graphics.setColor(self.color)
  -- love.graphics.draw(self.img, self.x, self.y, 0, self.s)
  love.graphics.circle("line", self.x + self.w/2, self.y + self.h/2, 16)
  if mx > self.x and
    mx < self.x + self.w and
    my > self.y and
    my < self.y + self.h
  then
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.print(self.type, mx, my + 20)
  end
end

return Worker
