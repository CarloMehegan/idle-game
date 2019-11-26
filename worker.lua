local class = require 'middleclass'

Worker = class('Worker')

function Worker:initialize(type, job, strength)
  self.strength = strength
  self.job = job
  self.type = type
  self.img = love.graphics.newImage("sprites/Mars Background - Copy.png")
  self.s = 1
  self.w = 32 * self.s
  self.h = 32 * self.s
  self.x = love.math.random(765, 1195 - self.w)
  self.y = love.math.random(65, 345 - self.h)
  self.dx = love.math.random(1,2)
  if self.dx == 2 then self.dx = -1 end
  self.dy = love.math.random(-1,1)
  if self.dy == 2 then self.dy = -1 end
end

function Worker:update()
  self.x = self.x + self.dx
  self.y = self.y + self.dy
  if self.x < 765 then
    self.x = 765
    self.dx = -self.dx
  end
  if self.x + self.w > 1195 then
    self.x = 1195 - self.w
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

function Worker:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, self.s)
end

return Worker
