local class = require 'middleclass'

Msg = class('Msg')

function Msg:initialize(text, x, y, dx, dy)
  self.text = text
  self.x = x
  self.y = y
  self.a = 1
  self.dx = dx or love.math.random(-100, 100)/100
  self.dy = dy or love.math.random(-100, -20)/100
  self.alive = true
end

function Msg:update(dt)
  if self.a >= 0 then
    self.a = self.a - 0.3 * dt
    self.x = self.x + self.dx
    self.y = self.y + self.dy
  elseif self.a < 0 then
    self.alive = false
  end
end

function Msg:draw()
  if self.alive then
    love.graphics.setColor(1, 1, 1, self.a)
    love.graphics.print(self.text, self.x, self.y)
  end
end

return Msg
