do
	print(123)
	do
		print(6.2831853071796)
	end
	print(456)
	do
		do
-- TODO: "todo in a do block"
		end
	end
end
do
	(leak)()
end
print("AlwaysAutoResize")
print({
	"NoNav",
	"NoDecoration",
	"NoTitleBar",
	"NoResize",
	"NoMove",
	"NoScrollbar"
})
print({
	123,
	'xyz'
})
do
	assert(item == nil)
end
local v = (item == nil)
if f1() then
	print("OK")
end
if (f1() and f2() and f3()) then
	print("OK")
end
local item
do
	local _src_, _dst_
	_dst_ = {
		pos = { },
		flags = flags:tonumber()
	}
	_src_ = self
	_dst_.id = _src_.id
	_dst_.connections = _src_.connections
	_dst_.pos.x = _src_.pos.x
	_dst_.pos.y = _src_.pos.y
	_dst_.pos.z = _src_.pos.z
	item = _dst_
end
if (x == "Apple" or x == "Pig" or x == "Dog") then
	print("exist")
end
do
	local _list_0 = (function()
		local _accum_0 = { }
		local _len_0 = 1
		local _list_0 = (function()
			local _accum_1 = { }
			local _len_1 = 1
			local _list_0 = {
				1,
				2,
				3
			}
			for _index_0 = 1, #_list_0 do
				local _ = _list_0[_index_0]
				_accum_1[_len_1] = _ * 2
				_len_1 = _len_1 + 1
			end
			return _accum_1
		end)()
		for _index_0 = 1, #_list_0 do
			local _ = _list_0[_index_0]
			if _ > 4 then
				_accum_0[_len_0] = _
				_len_0 = _len_0 + 1
			end
		end
		return _accum_0
	end)()
	for _index_0 = 1, #_list_0 do
		local _ = _list_0[_index_0]
		print(_)
	end
end
do
	local _list_0 = (function()
		local _accum_0 = { }
		local _len_0 = 1
		local _list_0 = (function()
			local _accum_1 = { }
			local _len_1 = 1
			local _list_0 = {
				1,
				2,
				3
			}
			for _index_0 = 1, #_list_0 do
				local _ = _list_0[_index_0]
				_accum_1[_len_1] = _ * 2
				_len_1 = _len_1 + 1
			end
			return _accum_1
		end)()
		for _index_0 = 1, #_list_0 do
			local _ = _list_0[_index_0]
			if _ > 4 then
				_accum_0[_len_0] = _
				_len_0 = _len_0 + 1
			end
		end
		return _accum_0
	end)()
	for _index_0 = 1, #_list_0 do
		local _ = _list_0[_index_0]
		print(_)
	end
end
local val
do
	local _2
	do
		local _accum_0 = { }
		local _len_0 = 1
		local _list_0 = {
			1,
			2,
			3
		}
		for _index_0 = 1, #_list_0 do
			local _ = _list_0[_index_0]
			_accum_0[_len_0] = _ * 2
			_len_0 = _len_0 + 1
		end
		_2 = _accum_0
	end
	local _3
	do
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = 1, #_2 do
			local _ = _2[_index_0]
			if _ > 4 then
				_accum_0[_len_0] = _
				_len_0 = _len_0 + 1
			end
		end
		_3 = _accum_0
	end
	local _4
	if #_3 == 0 then
		_4 = 0
	else
		local _1 = 0
		for _index_0 = 1, #_3 do
			local _2 = _3[_index_0]
			_1 = _1 + _2
		end
		_4 = _1
	end
	val = _4
end
do
	(1 + 2):call(123)
end
local res = (1 + 2)
local f
f = function(x)
	return function(y)
		return function(z)
			return print(x, y, z)
		end
	end
end
do
	local a = 8
	do
		a = 1
		a = a + 1
	end
	a = a + (function()
		a = 1
		return a + 1
	end)()
	print(a)
end
do
	local a = 8
	a = (function()
		local a = 1
		return a + 1
	end)()
	a = a + (function()
		local a = 1
		return a + 1
	end)()
	print(a)
end
local x = 0
do
local function f(a)
	return a + 1
end
x = x + f(3)
end
do
function tb:func()
	print(123)
end
end
print(x)
local sel
sel = function(a, b, c)
	if a then
		return b
	else
		return c
	end
end
do
local function sel(a, b, c)
	if a then
		return b
	else
		return c
	end
end
end
do
local function dummy()
	
end
end
do
-- a comment here
end
local _ = require('underscore')
local a = ((((_({
	1,
	2,
	3,
	4,
	-2,
	3
})):chain()):map(function(self)
	return self * 2
end)):filter(function(self)
	return self > 3
end)):value()
do
	((((_({
		1,
		2,
		3,
		4,
		-2,
		3
	})):chain()):map(function(self)
		return self * 2
	end)):filter(function(self)
		return self > 3
	end)):each(function(self)
		return print(self)
	end)
end
local result = ((((((origin.transform.root.gameObject:Parents()):Descendants()):SelectEnable()):SelectVisible()):TagEqual("fx")):Where(function(x)
	return x.name:EndsWith("(Clone)")
end)):Destroy()
do
	do
		local _1 = origin.transform.root.gameObject:Parents()
		local _2 = _1:Descendants()
		local _3 = _2:SelectEnable()
		local _4 = _3:SelectVisible()
		local _5 = _4:TagEqual("fx")
		local _6 = _5:Where(function(x)
			return x.name:EndsWith("(Clone)")
		end)
		_6:Destroy()
	end
end
do
origin.transform.root.gameObject:Parents():Descendants():SelectEnable():SelectVisible():TagEqual("fx"):Where(function(x)
	return x.name:EndsWith("(Clone)")
end):Destroy()
end
print((setmetatable({
	'abc',
	a = 123,
}, {
	__call = function(self)
		return 998
	end
}))[1], (setmetatable({
	'abc',
	a = 123,
}, {
	__call = function(self)
		return 998
	end
})).a, (setmetatable({
	'abc',
	a = 123,
}, {
	__call = function(self)
		return 998
	end
}))(), setmetatable({
	'abc',
	a = 123,
}, {
	__call = function(self)
		return 998
	end
}))
print("current line: " .. tostring(323))
do
	do
-- TODO
	end
end
do
	print(1)
end
local _1
_1 = function()
	print(1)
	local _accum_0 = { }
	local _len_0 = 1
	while false do
		break
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
do
	f = function()
		x = (tb:func(123)):bar(456)
		return (tb:func(123))
	end
	local f1
	f1 = function()
		do
tb:func(123)
		end
		return
	end
end
do
	print('abc')
	return 123
end
