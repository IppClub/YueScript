local A
do
	local _class_0
	local _base_0 = {
		setAdd = function(self, x, y)
			self.x = x
			self.y = y
			return self.x + self.y
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, x, y)
			if x == nil then
				x = 0
			end
			if y == nil then
				y = 0
			end
			self.x = x
			self.y = y
		end,
		__base = _base_0,
		__name = "A"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	A = _class_0
end
---@class A
---@field x number
---@field y number
---@field setAdd fun(self: A, x: number, y: number): number Set fields and add number values.
---@class AClass
---@operator call:A
---@cast A AClass
local a = A()
local res = a:setAdd(1, 2)
print(a.x, a.y, a.y, res)
return
