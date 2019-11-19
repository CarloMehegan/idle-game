

function const(table)
  local meta_table = {
    __index = function(self, key)
      if table[key] == nil then
        error("attempt to access a nonexistent field: " .. key)
      else
        return table[key]
      end
    end,

    __newindex = function(self, key, value)
      error("attempt to modify constant value: " .. key .. value)
    end
  }
  return setmetatable({}, meta_table)
end

local Constant = const{
  GRAVITY = 200,
  SPEED = 45
}

-- purposeful errors for checking
-- Constant.GRAVITY = 10
-- local vy = Constant.SPEEDD


local vec2_meta = {

  __add = function(a,b)
    return Vec2(
      a.x + b.x,
      a.y + b.y
    )
  end,

  __tostring = function(self)
    return "{" .. self.x .. ", " .. self.y .. "}"
  end,

  __newindex = function(self, index)

  end

}


local myTable = {1,2,3}
setmetatable(myTable, vec2_meta)
myTable[2] = 213

function Vec2(x,y)
  local v = {
    x = x or 0,
    y = y or 0
  }

  setmetatable(v, vec2_meta)

  return v
end




function love.load()
  p = yes(function(x) return math.sin(x*2*math.pi) end, 1)

  a = Vec2(10,2)
  b = Vec2(23,1)
  c = Vec2(0,0)



  c = a + b
end


function love.draw()
  love.graphics.print(p, 10,10)

  love.graphics.print(c.x, 10, 30)
  love.graphics.print(tostring(c), 40, 30)
end


function yes(fun,x)
  return fun(x)
end
