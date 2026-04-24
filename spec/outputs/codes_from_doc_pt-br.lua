do
	local var = "hello"
	print(var)
end
print(var)
local counter
do
	local i = 0
	counter = function()
		i = i + 1
		return i
	end
end
print(counter())
print(counter())
local tbl = {
	key = (function()
		print("assigning key!")
		return 1234
	end)()
}
local status, value
do
	repeat
		local n = 12
		if n > 10 then
			status, value = "large", n
			break
		end
		status, value = "small", n
		break
	until true
end
do
	local var = "hello"
	print(var)
end
print(var)
local counter
do
	local i = 0
	counter = function()
		i = i + 1
		return i
	end
end
print(counter())
print(counter())
local tbl = {
	key = (function()
		print("assigning key!")
		return 1234
	end)()
}
local status, value
do
	repeat
		local n = 12
		if n > 10 then
			status, value = "large", n
			break
		end
		status, value = "small", n
		break
	until true
end
if name == "Rob" then
	print("hello world")
end
local _list_0 = items
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	print("item: ", item)
end
while game:isRunning() do
	game:update()
end
while not reader:eof() do
	reader:parse_line()
end
if name == "Rob" then
	print("hello world")
end
local _list_0 = items
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	print("item: ", item)
end
while game:isRunning() do
	game:update()
end
while not reader:eof() do
	reader:parse_line()
end
local area = 6.2831853071796 * 5
print('hello world')
do
	assert(item ~= nil)
end
local value = item
if (f1() and f2() and f3()) then
	print("OK")
end
do
	local funcA
	funcA = function() end
end
local funcA
funcA = function()
	return "fail to assign to the Yue macro defined variable"
end
do
local function funcB() end
end
local funcB
funcB = function()
	return "fail to assign to the Lua macro defined variable"
end
do
-- inserção de códigos Lua brutos
if cond then
  print("output")
end
end
print("yuescript")
print(2)
print("Valid enum type:", "Static")
love.conf = function(t)
	do
		t.identity = 'LOVE'
		t.version = "11.5"
	end
end
love.conf = function(t)
	do
		t.identity = 'LOVE'
		t.version = "11.5"
	end
end
do
	print(123, "hello")
end
do
	print(123, "hello")
end
local myFunc
myFunc = function() end
do
	print("myFunc")
end
return
-- before:tableA
local tableA = { }
local tableB = { }
-- after:tableB
return
local registry = { }
local Worker
do
	local _class_0
	local _base_0 = {
		run = function(self)
			return "ok"
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Worker"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Worker = _class_0
end
do
	registry["Worker"] = Worker
end
return
local add
add = function(a, b)
	return a + b
end
do
	local __orig_add = add
	add = function(...)
		for i = 1, select("#", ...) do
			assert(type(select(i, ...)) == "number", "expected number for arg " .. tostring(i))
		end
		return __orig_add(...)
	end
end
local area = 6.2831853071796 * 5
print('hello world')
do
	assert(item ~= nil)
end
local value = item
if (f1() and f2() and f3()) then
	print("OK")
end
do
	local funcA
	funcA = function() end
end
local funcA
funcA = function()
	return "fail to assign to the Yue macro defined variable"
end
do
local function funcB() end
end
local funcB
funcB = function()
	return "fail to assign to the Lua macro defined variable"
end
do
-- inserção de códigos Lua brutos
if cond then
  print("output")
end
end
print("yuescript")
print(2)
print("Valid enum type:", "Static")
love.conf = function(t)
	do
		t.identity = 'LOVE'
		t.version = "11.5"
	end
end
love.conf = function(t)
	do
		t.identity = 'LOVE'
		t.version = "11.5"
	end
end
do
	print(123, "hello")
end
do
	print(123, "hello")
end
local myFunc
myFunc = function() end
do
	print("myFunc")
end
return
-- before:tableA
local tableA = { }
local tableB = { }
-- after:tableB
return
local registry = { }
local Worker
do
	local _class_0
	local _base_0 = {
		run = function(self)
			return "ok"
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Worker"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Worker = _class_0
end
do
	registry["Worker"] = Worker
end
return
local add
add = function(a, b)
	return a + b
end
do
	local __orig_add = add
	add = function(...)
		for i = 1, select("#", ...) do
			assert(type(select(i, ...)) == "number", "expected number for arg " .. tostring(i))
		end
		return __orig_add(...)
	end
end
xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return print(yue.traceback(err))
end)
local success, result = xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return yue.traceback(err)
end)
xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return print(yue.traceback(err))
end)
success, result = pcall(function()
	return func(1, 2, 3)
end)
pcall(function()
	print("trying")
	return func(1, 2, 3)
end)
success, result = xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return print(yue.traceback(err))
end)
if success then
	print(result)
end
local a, b, c
do
	local _ok_0, _ret_0, _ret_1, _ret_2 = pcall(function()
		return func()
	end)
	if _ok_0 then
		a, b, c = _ret_0, _ret_1, _ret_2
	end
end
do
	local _exp_0 = ((function()
		return (function(_arg_0, ...)
			local _ok_0 = _arg_0
			if _ok_0 then
				return ...
			end
		end)(pcall(function()
			return func()
		end))
	end)())
	if _exp_0 ~= nil then
		a = _exp_0
	else
		a = "default"
	end
end
f((function()
	return (function(_arg_0, ...)
		local _ok_0 = _arg_0
		if _ok_0 then
			return ...
		end
	end)(pcall(function()
		return func()
	end))
end)())
f((function()
	return (function(_arg_0, ...)
		local _ok_0 = _arg_0
		if _ok_0 then
			return ...
		end
	end)(xpcall(function()
		print(123)
		return func()
	end, function(e)
		print(e)
		return e
	end))
end)())
xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return print(yue.traceback(err))
end)
local success, result = xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return yue.traceback(err)
end)
xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return print(yue.traceback(err))
end)
success, result = pcall(function()
	return func(1, 2, 3)
end)
pcall(function()
	print("trying")
	return func(1, 2, 3)
end)
success, result = xpcall(function()
	return func(1, 2, 3)
end, function(err)
	return print(yue.traceback(err))
end)
if success then
	print(result)
end
local a, b, c
do
	local _ok_0, _ret_0, _ret_1, _ret_2 = pcall(function()
		return func()
	end)
	if _ok_0 then
		a, b, c = _ret_0, _ret_1, _ret_2
	end
end
do
	local _exp_0 = ((function()
		return (function(_arg_0, ...)
			local _ok_0 = _arg_0
			if _ok_0 then
				return ...
			end
		end)(pcall(function()
			return func()
		end))
	end)())
	if _exp_0 ~= nil then
		a = _exp_0
	else
		a = "default"
	end
end
f((function()
	return (function(_arg_0, ...)
		local _ok_0 = _arg_0
		if _ok_0 then
			return ...
		end
	end)(pcall(function()
		return func()
	end))
end)())
f((function()
	return (function(_arg_0, ...)
		local _ok_0 = _arg_0
		if _ok_0 then
			return ...
		end
	end)(xpcall(function()
		print(123)
		return func()
	end, function(e)
		print(e)
		return e
	end))
end)())
local some_values = {
	1,
	2,
	3,
	4
}
local some_values = {
	name = "Bill",
	age = 200,
	["favorite food"] = "rice"
}
local profile = {
	height = "4 feet",
	shoe_size = 13,
	favorite_foods = {
		"ice cream",
		"donuts"
	}
}
local values = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	name = "superman",
	occupation = "crime fighting"
}
my_function({
	dance = "Tango",
	partner = "none"
})
local y = {
	type = "dog",
	legs = 4,
	tails = 1
}
local tbl = {
	["do"] = "something",
	["end"] = "hunger"
}
local hair = "golden"
local height = 200
local person = {
	hair = hair,
	height = height,
	shoe_size = 40
}
print_table({
	hair = hair,
	height = height
})
local t = {
	[1 + 2] = "hello",
	["hello world"] = true
}
local some_values = {
	1,
	2,
	3,
	4
}
local list_with_one_element = {
	1
}
local some_values = {
	1,
	2,
	3,
	4
}
local some_values = {
	name = "Bill",
	age = 200,
	["favorite food"] = "rice"
}
local profile = {
	height = "4 feet",
	shoe_size = 13,
	favorite_foods = {
		"ice cream",
		"donuts"
	}
}
local values = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	name = "superman",
	occupation = "crime fighting"
}
my_function({
	dance = "Tango",
	partner = "none"
})
local y = {
	type = "dog",
	legs = 4,
	tails = 1
}
local tbl = {
	["do"] = "something",
	["end"] = "hunger"
}
local hair = "golden"
local height = 200
local person = {
	hair = hair,
	height = height,
	shoe_size = 40
}
print_table({
	hair = hair,
	height = height
})
local t = {
	[1 + 2] = "hello",
	["hello world"] = true
}
local some_values = {
	1,
	2,
	3,
	4
}
local list_with_one_element = {
	1
}
local items = {
	1,
	2,
	3,
	4
}
local doubled
local _accum_0 = { }
local _len_0 = 1
for i, item in ipairs(items) do
	_accum_0[_len_0] = item * 2
	_len_0 = _len_0 + 1
end
doubled = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
for i, item in ipairs(items) do
	if i > 1 and i < 3 then
		_accum_0[_len_0] = item
		_len_0 = _len_0 + 1
	end
end
slice = _accum_0
local doubled
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item * 2
	_len_0 = _len_0 + 1
end
doubled = _accum_0
local data = {
	a = {
		1,
		2,
		3
	},
	b = {
		4,
		5,
		6
	}
}
local flat
local _accum_0 = { }
for k, v in pairs(data) do
	local _len_0 = #_accum_0 + 1
	for _index_0 = 1, #v do
		local _elm_0 = v[_index_0]
		_accum_0[_len_0], _len_0 = _elm_0, _len_0 + 1
	end
end
flat = _accum_0
local x_coords = {
	4,
	5,
	6,
	7
}
local y_coords = {
	9,
	2,
	3
}
local points
local _accum_0 = { }
local _len_0 = 1
for _index_0 = 1, #x_coords do
	local x = x_coords[_index_0]
	for _index_1 = 1, #y_coords do
		local y = y_coords[_index_1]
		_accum_0[_len_0] = {
			x,
			y
		}
		_len_0 = _len_0 + 1
	end
end
points = _accum_0
local evens
local _accum_0 = { }
local _len_0 = 1
for i = 1, 100 do
	if i % 2 == 0 then
		_accum_0[_len_0] = i
		_len_0 = _len_0 + 1
	end
end
evens = _accum_0
local thing = {
	color = "red",
	name = "fast",
	width = 123
}
local thing_copy
local _tbl_0 = { }
for k, v in pairs(thing) do
	_tbl_0[k] = v
end
thing_copy = _tbl_0
local no_color
local _tbl_0 = { }
for k, v in pairs(thing) do
	if k ~= "color" then
		_tbl_0[k] = v
	end
end
no_color = _tbl_0
local numbers = {
	1,
	2,
	3,
	4
}
local sqrts
local _tbl_0 = { }
for _index_0 = 1, #numbers do
	local i = numbers[_index_0]
	_tbl_0[i] = math.sqrt(i)
end
sqrts = _tbl_0
local tuples = {
	{
		"hello",
		"world"
	},
	{
		"foo",
		"bar"
	}
}
local tbl
local _tbl_0 = { }
for _index_0 = 1, #tuples do
	local tuple = tuples[_index_0]
	local _key_0, _val_0 = unpack(tuple)
	_tbl_0[_key_0] = _val_0
end
tbl = _tbl_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
for _index_0 = 1, 5 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _max_0 = #_list_0
for _index_0 = 2, _max_0 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _max_0 = #_list_0
for _index_0 = 1, _max_0, 2 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _min_0 = #_list_0 + -4 + 1
local _max_0 = #_list_0 + -1 + 1
for _index_0 = _min_0, _max_0 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local reverse_slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _min_0 = #_list_0 + -1 + 1
for _index_0 = _min_0, 1, -1 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
reverse_slice = _accum_0
local sub_list
do
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = items
	for _index_0 = 2, 4 do
		local _item_0 = _list_0[_index_0]
		_accum_0[_len_0] = _item_0
		_len_0 = _len_0 + 1
	end
	sub_list = _accum_0
end
local last_four_items
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _min_0 = #_list_0 + -4 + 1
local _max_0 = #_list_0 + -1 + 1
for _index_0 = _min_0, _max_0 do
	local _item_0 = _list_0[_index_0]
	_accum_0[_len_0] = _item_0
	_len_0 = _len_0 + 1
end
last_four_items = _accum_0
local items = {
	1,
	2,
	3,
	4
}
local doubled
local _accum_0 = { }
local _len_0 = 1
for i, item in ipairs(items) do
	_accum_0[_len_0] = item * 2
	_len_0 = _len_0 + 1
end
doubled = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
for i, item in ipairs(items) do
	if i > 1 and i < 3 then
		_accum_0[_len_0] = item
		_len_0 = _len_0 + 1
	end
end
slice = _accum_0
local doubled
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item * 2
	_len_0 = _len_0 + 1
end
doubled = _accum_0
local data = {
	a = {
		1,
		2,
		3
	},
	b = {
		4,
		5,
		6
	}
}
local flat
local _accum_0 = { }
for k, v in pairs(data) do
	local _len_0 = #_accum_0 + 1
	for _index_0 = 1, #v do
		local _elm_0 = v[_index_0]
		_accum_0[_len_0], _len_0 = _elm_0, _len_0 + 1
	end
end
flat = _accum_0
local x_coords = {
	4,
	5,
	6,
	7
}
local y_coords = {
	9,
	2,
	3
}
local points
local _accum_0 = { }
local _len_0 = 1
for _index_0 = 1, #x_coords do
	local x = x_coords[_index_0]
	for _index_1 = 1, #y_coords do
		local y = y_coords[_index_1]
		_accum_0[_len_0] = {
			x,
			y
		}
		_len_0 = _len_0 + 1
	end
end
points = _accum_0
local evens
local _accum_0 = { }
local _len_0 = 1
for i = 1, 100 do
	if i % 2 == 0 then
		_accum_0[_len_0] = i
		_len_0 = _len_0 + 1
	end
end
evens = _accum_0
local thing = {
	color = "red",
	name = "fast",
	width = 123
}
local thing_copy
local _tbl_0 = { }
for k, v in pairs(thing) do
	_tbl_0[k] = v
end
thing_copy = _tbl_0
local no_color
local _tbl_0 = { }
for k, v in pairs(thing) do
	if k ~= "color" then
		_tbl_0[k] = v
	end
end
no_color = _tbl_0
local numbers = {
	1,
	2,
	3,
	4
}
local sqrts
local _tbl_0 = { }
for _index_0 = 1, #numbers do
	local i = numbers[_index_0]
	_tbl_0[i] = math.sqrt(i)
end
sqrts = _tbl_0
local tuples = {
	{
		"hello",
		"world"
	},
	{
		"foo",
		"bar"
	}
}
local tbl
local _tbl_0 = { }
for _index_0 = 1, #tuples do
	local tuple = tuples[_index_0]
	local _key_0, _val_0 = unpack(tuple)
	_tbl_0[_key_0] = _val_0
end
tbl = _tbl_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
for _index_0 = 1, 5 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _max_0 = #_list_0
for _index_0 = 2, _max_0 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _max_0 = #_list_0
for _index_0 = 1, _max_0, 2 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _min_0 = #_list_0 + -4 + 1
local _max_0 = #_list_0 + -1 + 1
for _index_0 = _min_0, _max_0 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
slice = _accum_0
local reverse_slice
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _min_0 = #_list_0 + -1 + 1
for _index_0 = _min_0, 1, -1 do
	local item = _list_0[_index_0]
	_accum_0[_len_0] = item
	_len_0 = _len_0 + 1
end
reverse_slice = _accum_0
local sub_list
do
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = items
	for _index_0 = 2, 4 do
		local _item_0 = _list_0[_index_0]
		_accum_0[_len_0] = _item_0
		_len_0 = _len_0 + 1
	end
	sub_list = _accum_0
end
local last_four_items
local _accum_0 = { }
local _len_0 = 1
local _list_0 = items
local _min_0 = #_list_0 + -4 + 1
local _max_0 = #_list_0 + -1 + 1
for _index_0 = _min_0, _max_0 do
	local _item_0 = _list_0[_index_0]
	_accum_0[_len_0] = _item_0
	_len_0 = _len_0 + 1
end
last_four_items = _accum_0
local Inventory
local _class_0
local _base_0 = {
	add_item = function(self, name)
		if self.items[name] then
			local _obj_0 = self.items
			_obj_0[name] = _obj_0[name] + 1
		else
			self.items[name] = 1
		end
	end
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function(self)
		self.items = { }
	end,
	__base = _base_0,
	__name = "Inventory"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Inventory = _class_0
local User
do
	local _class_0
	local _base_0 = {
		__tostring = function(self)
			return "User(" .. tostring(self.name) .. ")"
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, name)
			self.name = name
		end,
		__base = _base_0,
		__name = "User"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	User = _class_0
end
print(tostring(User("Yue")))
local inv = Inventory()
inv:add_item("t-shirt")
inv:add_item("pants")
local Person
do
	local _class_0
	local _base_0 = {
		clothes = { },
		give_item = function(self, name)
			return table.insert(self.clothes, name)
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Person"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Person = _class_0
end
local a = Person()
local b = Person()
a:give_item("pants")
b:give_item("shirt")
local _list_0 = a.clothes
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	print(item)
end
local Person
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function(self)
		self.clothes = { }
	end,
	__base = _base_0,
	__name = "Person"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Person = _class_0
local BackPack
local _class_0
local _parent_0 = Inventory
local _base_0 = {
	size = 10,
	add_item = function(self, name)
		if #self.items > size then
			error("backpack is full")
		end
		return _class_0.__parent.__base.add_item(self, name)
	end
}
for _key_0, _val_0 in pairs(_parent_0.__base) do
	if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
		_base_0[_key_0] = _val_0
	end
end
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
	__init = function(self, ...)
		return _class_0.__parent.__init(self, ...)
	end,
	__base = _base_0,
	__name = "BackPack",
	__parent = _parent_0
}, {
	__index = function(cls, name)
		local val = rawget(_base_0, name)
		if val == nil then
			local parent = rawget(cls, "__parent")
			if parent then
				return parent[name]
			end
		else
			return val
		end
	end,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
if _parent_0.__inherited then
	_parent_0.__inherited(_parent_0, _class_0)
end
BackPack = _class_0
local Shelf
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Shelf"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.__inherited = function(self, child)
		return print(self.__name, "was inherited by", child.__name)
	end
	Shelf = _class_0
end
local Cupboard
local _class_0
local _parent_0 = Shelf
local _base_0 = { }
for _key_0, _val_0 in pairs(_parent_0.__base) do
	if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
		_base_0[_key_0] = _val_0
	end
end
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
	__init = function(self, ...)
		return _class_0.__parent.__init(self, ...)
	end,
	__base = _base_0,
	__name = "Cupboard",
	__parent = _parent_0
}, {
	__index = function(cls, name)
		local val = rawget(_base_0, name)
		if val == nil then
			local parent = rawget(cls, "__parent")
			if parent then
				return parent[name]
			end
		else
			return val
		end
	end,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
if _parent_0.__inherited then
	_parent_0.__inherited(_parent_0, _class_0)
end
Cupboard = _class_0
local MyClass
local _class_0
local _parent_0 = ParentClass
local _base_0 = {
	a_method = function(self)
		_class_0.__parent.__base.a_method(self, "hello", "world")
		_class_0.__parent.a_method(self, "hello", "world")
		_class_0.__parent.a_method(self, "hello", "world")
		return assert(_class_0.__parent == ParentClass)
	end
}
for _key_0, _val_0 in pairs(_parent_0.__base) do
	if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
		_base_0[_key_0] = _val_0
	end
end
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
	__init = function(self, ...)
		return _class_0.__parent.__init(self, ...)
	end,
	__base = _base_0,
	__name = "MyClass",
	__parent = _parent_0
}, {
	__index = function(cls, name)
		local val = rawget(_base_0, name)
		if val == nil then
			local parent = rawget(cls, "__parent")
			if parent then
				return parent[name]
			end
		else
			return val
		end
	end,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
if _parent_0.__inherited then
	_parent_0.__inherited(_parent_0, _class_0)
end
MyClass = _class_0
local b = BackPack()
assert(b.__class == BackPack)
print(BackPack.size)
print(BackPack.__name)
local Things
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Things"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.some_func = function(self)
		return print("Hello from", self.__name)
	end
	Things = _class_0
end
Things:some_func()
assert(Things().some_func == nil)
local Counter
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self)
			self.__class.count = self.__class.count + 1
		end,
		__base = _base_0,
		__name = "Counter"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.count = 0
	Counter = _class_0
end
Counter()
Counter()
print(Counter.count)
self.__class:hello(1, 2, 3, 4)
local Things
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "Things"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
local self = _class_0;
self.class_var = "hello world"
Things = _class_0
local MoreThings
local _class_0
local secret, log
local _base_0 = {
	some_method = function(self)
		return log("hello world: " .. secret)
	end
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "MoreThings"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
local self = _class_0;
secret = 123
log = function(msg)
	return print("LOG:", msg)
end
MoreThings = _class_0
assert(self == self)
assert(self.__class == self.__class)
local some_instance_method
some_instance_method = function(self, ...)
	return self.__class(...)
end
local Something
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, foo, bar, biz, baz)
			self.foo = foo
			self.bar = bar
			self.__class.biz = biz
			self.__class.baz = baz
		end,
		__base = _base_0,
		__name = "Something"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Something = _class_0
end
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function(self, foo, bar, biz, baz)
		self.foo = foo
		self.bar = bar
		self.__class.biz = biz
		self.__class.baz = baz
	end,
	__base = _base_0,
	__name = "Something"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Something = _class_0
local new
new = function(self, fieldA, fieldB)
	self.fieldA = fieldA
	self.fieldB = fieldB
	return self
end
local obj = new({ }, 123, "abc")
print(obj)
local x
local Bucket
local _class_0
local _base_0 = {
	drops = 0,
	add_drop = function(self)
		self.drops = self.drops + 1
	end
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "Bucket"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Bucket = _class_0
x = _class_0
local BigBucket
do
	local _class_0
	local _parent_0 = Bucket
	local _base_0 = {
		add_drop = function(self)
			self.drops = self.drops + 10
		end
	}
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, ...)
			return _class_0.__parent.__init(self, ...)
		end,
		__base = _base_0,
		__name = "BigBucket",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	BigBucket = _class_0
end
assert(Bucket.__name == "BigBucket")
local x
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "x"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
x = _class_0
local MyIndex = {
	__index = {
		var = 1
	}
}
local X
do
	local _class_0
	local _base_0 = {
		func = function(self)
			return print(123)
		end
	}
	local _list_0 = {
		MyIndex
	}
	for _index_0 = 1, #_list_0 do
		local _item_0 = _list_0[_index_0]
		local _cls_0, _mixin_0 = (_item_0.__base ~= nil), _item_0.__base or _item_0
		for _key_0, _val_0 in pairs(_mixin_0) do
			if _base_0[_key_0] == nil and (not _cls_0 or not _key_0:match("^__")) then
				_base_0[_key_0] = _val_0
			end
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "X"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	X = _class_0
end
local x = X()
print(x.var)
local Y
do
	local _class_0
	local _base_0 = { }
	local _list_0 = {
		X
	}
	for _index_0 = 1, #_list_0 do
		local _item_0 = _list_0[_index_0]
		local _cls_0, _mixin_0 = (_item_0.__base ~= nil), _item_0.__base or _item_0
		for _key_0, _val_0 in pairs(_mixin_0) do
			if _base_0[_key_0] == nil and (not _cls_0 or not _key_0:match("^__")) then
				_base_0[_key_0] = _val_0
			end
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Y"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Y = _class_0
end
local y = Y()
y:func()
assert(y.__class.__parent ~= X)
local Inventory
local _class_0
local _base_0 = {
	add_item = function(self, name)
		if self.items[name] then
			local _obj_0 = self.items
			_obj_0[name] = _obj_0[name] + 1
		else
			self.items[name] = 1
		end
	end
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function(self)
		self.items = { }
	end,
	__base = _base_0,
	__name = "Inventory"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Inventory = _class_0
local User
do
	local _class_0
	local _base_0 = {
		__tostring = function(self)
			return "User(" .. tostring(self.name) .. ")"
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, name)
			self.name = name
		end,
		__base = _base_0,
		__name = "User"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	User = _class_0
end
print(tostring(User("Yue")))
local inv = Inventory()
inv:add_item("t-shirt")
inv:add_item("pants")
local Person
do
	local _class_0
	local _base_0 = {
		clothes = { },
		give_item = function(self, name)
			return table.insert(self.clothes, name)
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Person"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Person = _class_0
end
local a = Person()
local b = Person()
a:give_item("pants")
b:give_item("shirt")
local _list_0 = a.clothes
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	print(item)
end
local Person
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function(self)
		self.clothes = { }
	end,
	__base = _base_0,
	__name = "Person"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Person = _class_0
local BackPack
local _class_0
local _parent_0 = Inventory
local _base_0 = {
	size = 10,
	add_item = function(self, name)
		if #self.items > size then
			error("backpack is full")
		end
		return _class_0.__parent.__base.add_item(self, name)
	end
}
for _key_0, _val_0 in pairs(_parent_0.__base) do
	if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
		_base_0[_key_0] = _val_0
	end
end
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
	__init = function(self, ...)
		return _class_0.__parent.__init(self, ...)
	end,
	__base = _base_0,
	__name = "BackPack",
	__parent = _parent_0
}, {
	__index = function(cls, name)
		local val = rawget(_base_0, name)
		if val == nil then
			local parent = rawget(cls, "__parent")
			if parent then
				return parent[name]
			end
		else
			return val
		end
	end,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
if _parent_0.__inherited then
	_parent_0.__inherited(_parent_0, _class_0)
end
BackPack = _class_0
local Shelf
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Shelf"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.__inherited = function(self, child)
		return print(self.__name, "was inherited by", child.__name)
	end
	Shelf = _class_0
end
local Cupboard
local _class_0
local _parent_0 = Shelf
local _base_0 = { }
for _key_0, _val_0 in pairs(_parent_0.__base) do
	if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
		_base_0[_key_0] = _val_0
	end
end
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
	__init = function(self, ...)
		return _class_0.__parent.__init(self, ...)
	end,
	__base = _base_0,
	__name = "Cupboard",
	__parent = _parent_0
}, {
	__index = function(cls, name)
		local val = rawget(_base_0, name)
		if val == nil then
			local parent = rawget(cls, "__parent")
			if parent then
				return parent[name]
			end
		else
			return val
		end
	end,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
if _parent_0.__inherited then
	_parent_0.__inherited(_parent_0, _class_0)
end
Cupboard = _class_0
local MyClass
local _class_0
local _parent_0 = ParentClass
local _base_0 = {
	a_method = function(self)
		_class_0.__parent.__base.a_method(self, "hello", "world")
		_class_0.__parent.a_method(self, "hello", "world")
		_class_0.__parent.a_method(self, "hello", "world")
		return assert(_class_0.__parent == ParentClass)
	end
}
for _key_0, _val_0 in pairs(_parent_0.__base) do
	if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
		_base_0[_key_0] = _val_0
	end
end
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
setmetatable(_base_0, _parent_0.__base)
_class_0 = setmetatable({
	__init = function(self, ...)
		return _class_0.__parent.__init(self, ...)
	end,
	__base = _base_0,
	__name = "MyClass",
	__parent = _parent_0
}, {
	__index = function(cls, name)
		local val = rawget(_base_0, name)
		if val == nil then
			local parent = rawget(cls, "__parent")
			if parent then
				return parent[name]
			end
		else
			return val
		end
	end,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
if _parent_0.__inherited then
	_parent_0.__inherited(_parent_0, _class_0)
end
MyClass = _class_0
local b = BackPack()
assert(b.__class == BackPack)
print(BackPack.size)
print(BackPack.__name)
local Things
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Things"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.some_func = function(self)
		return print("Hello from", self.__name)
	end
	Things = _class_0
end
Things:some_func()
assert(Things().some_func == nil)
local Counter
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self)
			self.__class.count = self.__class.count + 1
		end,
		__base = _base_0,
		__name = "Counter"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.count = 0
	Counter = _class_0
end
Counter()
Counter()
print(Counter.count)
self.__class:hello(1, 2, 3, 4)
local Things
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "Things"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
local self = _class_0;
self.class_var = "hello world"
Things = _class_0
local MoreThings
local _class_0
local secret, log
local _base_0 = {
	some_method = function(self)
		return log("hello world: " .. secret)
	end
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "MoreThings"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
local self = _class_0;
secret = 123
log = function(msg)
	return print("LOG:", msg)
end
MoreThings = _class_0
assert(self == self)
assert(self.__class == self.__class)
local some_instance_method
some_instance_method = function(self, ...)
	return self.__class(...)
end
local Something
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, foo, bar, biz, baz)
			self.foo = foo
			self.bar = bar
			self.__class.biz = biz
			self.__class.baz = baz
		end,
		__base = _base_0,
		__name = "Something"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Something = _class_0
end
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function(self, foo, bar, biz, baz)
		self.foo = foo
		self.bar = bar
		self.__class.biz = biz
		self.__class.baz = baz
	end,
	__base = _base_0,
	__name = "Something"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Something = _class_0
local new
new = function(self, fieldA, fieldB)
	self.fieldA = fieldA
	self.fieldB = fieldB
	return self
end
local obj = new({ }, 123, "abc")
print(obj)
local x
local Bucket
local _class_0
local _base_0 = {
	drops = 0,
	add_drop = function(self)
		self.drops = self.drops + 1
	end
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "Bucket"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Bucket = _class_0
x = _class_0
local BigBucket
do
	local _class_0
	local _parent_0 = Bucket
	local _base_0 = {
		add_drop = function(self)
			self.drops = self.drops + 10
		end
	}
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, ...)
			return _class_0.__parent.__init(self, ...)
		end,
		__base = _base_0,
		__name = "BigBucket",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	BigBucket = _class_0
end
assert(Bucket.__name == "BigBucket")
local x
local _class_0
local _base_0 = { }
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "x"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
x = _class_0
local MyIndex = {
	__index = {
		var = 1
	}
}
local X
do
	local _class_0
	local _base_0 = {
		func = function(self)
			return print(123)
		end
	}
	local _list_0 = {
		MyIndex
	}
	for _index_0 = 1, #_list_0 do
		local _item_0 = _list_0[_index_0]
		local _cls_0, _mixin_0 = (_item_0.__base ~= nil), _item_0.__base or _item_0
		for _key_0, _val_0 in pairs(_mixin_0) do
			if _base_0[_key_0] == nil and (not _cls_0 or not _key_0:match("^__")) then
				_base_0[_key_0] = _val_0
			end
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "X"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	X = _class_0
end
local x = X()
print(x.var)
local Y
do
	local _class_0
	local _base_0 = { }
	local _list_0 = {
		X
	}
	for _index_0 = 1, #_list_0 do
		local _item_0 = _list_0[_index_0]
		local _cls_0, _mixin_0 = (_item_0.__base ~= nil), _item_0.__base or _item_0
		for _key_0, _val_0 in pairs(_mixin_0) do
			if _base_0[_key_0] == nil and (not _cls_0 or not _key_0:match("^__")) then
				_base_0[_key_0] = _val_0
			end
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Y"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Y = _class_0
end
local y = Y()
y:func()
assert(y.__class.__parent ~= X)
local _with_0 = Person()
_with_0.name = "Oswald"
_with_0:add_relative(my_dad)
_with_0:save()
print(_with_0.name)
local file
local _with_0 = File("favorite_foods.txt")
_with_0:set_encoding("utf8")
file = _with_0
local result
local _with_0 = obj
repeat
	result = _with_0.value
	break
until true
local a
do
	local _with_0 = obj
	_with_0.x = 1
	a = _with_0
end
local b
local _with_0 = obj
repeat
	b = _with_0.x
	break
until true
local create_person
create_person = function(name, relatives)
	local _with_0 = Person()
	_with_0.name = name
	for _index_0 = 1, #relatives do
		local relative = relatives[_index_0]
		_with_0:add_relative(relative)
	end
	return _with_0
end
local me = create_person("Leaf", {
	dad,
	mother,
	sister
})
local str = "Hello"
print("original:", str)
print("upper:", str:upper())
local _with_0 = tb
_with_0[1] = 1
print(_with_0[2])
do
	local _with_1 = _with_0[abc]
	_with_1[3] = _with_1[2]:func()
	_with_1["key-name"] = value
end
_with_0[#_with_0 + 1] = "abc"
local _with_0 = obj
if _with_0 ~= nil then
	print(_with_0.name)
end
local _with_0 = Person()
_with_0.name = "Oswald"
_with_0:add_relative(my_dad)
_with_0:save()
print(_with_0.name)
local file
local _with_0 = File("favorite_foods.txt")
_with_0:set_encoding("utf8")
file = _with_0
local result
local _with_0 = obj
repeat
	result = _with_0.value
	break
until true
local a
do
	local _with_0 = obj
	_with_0.x = 1
	a = _with_0
end
local b
local _with_0 = obj
repeat
	b = _with_0.x
	break
until true
local create_person
create_person = function(name, relatives)
	local _with_0 = Person()
	_with_0.name = name
	for _index_0 = 1, #relatives do
		local relative = relatives[_index_0]
		_with_0:add_relative(relative)
	end
	return _with_0
end
local me = create_person("Leaf", {
	dad,
	mother,
	sister
})
local str = "Hello"
print("original:", str)
print("upper:", str:upper())
local _with_0 = tb
_with_0[1] = 1
print(_with_0[2])
do
	local _with_1 = _with_0[abc]
	_with_1[3] = _with_1[2]:func()
	_with_1["key-name"] = value
end
_with_0[#_with_0 + 1] = "abc"
local _with_0 = obj
if _with_0 ~= nil then
	print(_with_0.name)
end
local hello = "world"
local a, b, c = 1, 2, 3
hello = 123
local x = 1
x = x + 1
x = x - 1
x = x * 10
x = x / 10
x = x % 10
local s = s .. "world"
local arg = arg or "valor padrão"
local a = 0
local b = 0
local c = 0
local d = 0
local e = 0
local x = f()
local y = x
local z = x
do
	local a = 1
	local x, y, z
	print("declarar antecipadamente todas as variáveis como locais")
	x = function()
		return 1 + y + z
	end
	y, z = 2, 3
	instance = Item:new()
end
do
	local X = 1
	local B
	print("declarar antecipadamente apenas variáveis em maiúsculas")
	local a = 1
	B = 2
end
do
	a = 1
	print("declarar todas as variáveis como globais")
	x = function()
		return 1 + y + z
	end
	y, z = 2, 3
end
do
	X = 1
	print("declarar apenas variáveis em maiúsculas como globais")
	local a = 1
	B = 2
	local Temp = "um valor local"
end
local hello = "world"
local a, b, c = 1, 2, 3
hello = 123
local x = 1
x = x + 1
x = x - 1
x = x * 10
x = x / 10
x = x % 10
local s = s .. "world"
local arg = arg or "valor padrão"
local a = 0
local b = 0
local c = 0
local d = 0
local e = 0
local x = f()
local y = x
local z = x
do
	local a = 1
	local x, y, z
	print("declarar antecipadamente todas as variáveis como locais")
	x = function()
		return 1 + y + z
	end
	y, z = 2, 3
	instance = Item:new()
end
do
	local X = 1
	local B
	print("declarar antecipadamente apenas variáveis em maiúsculas")
	local a = 1
	B = 2
end
do
	a = 1
	print("declarar todas as variáveis como globais")
	x = function()
		return 1 + y + z
	end
	y, z = 2, 3
end
do
	X = 1
	print("declarar apenas variáveis em maiúsculas como globais")
	local a = 1
	B = 2
	local Temp = "um valor local"
end
local list = {
	1,
	2,
	3,
	4,
	5
}
local fn
fn = function(ok)
	return ok, table.unpack(list)
end
(function(_arg_0, ...)
	local ok = _arg_0
	local count = select('#', ...)
	local first = select(1, ...)
	return print(ok, count, first)
end)(fn(true))
local list = {
	1,
	2,
	3,
	4,
	5
}
local fn
fn = function(ok)
	return ok, table.unpack(list)
end
(function(_arg_0, ...)
	local ok = _arg_0
	local count = select('#', ...)
	local first = select(1, ...)
	return print(ok, count, first)
end)(fn(true))
local user = database.find_user("moon")
if user then
	print(user.name)
end
local hello = os.getenv("hello")
if hello then
	print("Você tem hello", hello)
else
	local world = os.getenv("world")
	if world then
		print("você tem world", world)
	else
		print("nada :(")
	end
end
do
	local success, result = pcall(function()
		return "obter resultado sem problemas"
	end)
	if success then
		print(result)
	end
end
print("OK")
repeat
	local byte = stream:read_one()
	if byte then
		print(byte)
	else
		break
	end
until false
local user = database.find_user("moon")
if user then
	print(user.name)
end
local hello = os.getenv("hello")
if hello then
	print("Você tem hello", hello)
else
	local world = os.getenv("world")
	if world then
		print("você tem world", world)
	else
		print("nada :(")
	end
end
do
	local success, result = pcall(function()
		return "obter resultado sem problemas"
	end)
	if success then
		print(result)
	end
end
print("OK")
repeat
	local byte = stream:read_one()
	if byte then
		print(byte)
	else
		break
	end
until false
local thing = {
	1,
	2
}
local a, b = thing[1], thing[2]
print(a, b)
local obj = {
	hello = "world",
	day = "tuesday",
	length = 20
}
local hello, the_day = obj.hello, obj.day
print(hello, the_day)
local day = obj.day
local obj2 = {
	numbers = {
		1,
		2,
		3,
		4
	},
	properties = {
		color = "green",
		height = 13.5
	}
}
local first, second, color = obj2.numbers[1], obj2.numbers[2], obj2.properties.color
print(first, second, color)
local first, second, color
local _obj_0 = obj2
first, second, color = _obj_0.numbers[1], _obj_0.numbers[2], _obj_0.properties.color
local concat, insert
local _obj_0 = table
concat, insert = _obj_0.concat, _obj_0.insert
local mix, max, rand
local _obj_0 = math
mix, max, rand = _obj_0.mix, _obj_0.max, _obj_0.random
local name, job
local _obj_0 = person
name, job = _obj_0.name, _obj_0.job
if name == nil then
	name = "sem nome"
end
if job == nil then
	job = "sem emprego"
end
local two, four
local _obj_0 = items
two, four = _obj_0[2], _obj_0[4]
local orders = {
	"first",
	"second",
	"third",
	"fourth",
	"last"
}
local first, bulk, last = orders[1], (function()
	local _accum_0 = { }
	local _len_0 = 1
	local _max_0 = #orders + -2 + 1
	for _index_0 = 2, _max_0 do
		local _item_0 = orders[_index_0]
		_accum_0[_len_0] = _item_0
		_len_0 = _len_0 + 1
	end
	return _accum_0
end)(), orders[#orders]
print(first)
print(bulk)
print(last)
local first, rest
do
	local _obj_0 = orders
	first, rest = _obj_0[1], (function()
		local _accum_0 = { }
		local _len_0 = 1
		local _max_0 = #_obj_0
		for _index_0 = 2, _max_0 do
			local _item_0 = _obj_0[_index_0]
			_accum_0[_len_0] = _item_0
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)()
end
local start, last
do
	local _obj_0 = orders
	start, last = (function()
		local _accum_0 = { }
		local _len_0 = 1
		local _max_0 = #_obj_0 + -2 + 1
		for _index_0 = 1, _max_0 do
			local _item_0 = _obj_0[_index_0]
			_accum_0[_len_0] = _item_0
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)(), _obj_0[#_obj_0]
end
local _obj_0 = orders
first, last = _obj_0[1], _obj_0[#_obj_0]
local tuples = {
	{
		"hello",
		"world"
	},
	{
		"egg",
		"head"
	}
}
for _index_0 = 1, #tuples do
	local _des_0 = tuples[_index_0]
	local left, right = _des_0[1], _des_0[2]
	print(left, right)
end
local thing = {
	1,
	2
}
local a, b = thing[1], thing[2]
print(a, b)
local obj = {
	hello = "world",
	day = "tuesday",
	length = 20
}
local hello, the_day = obj.hello, obj.day
print(hello, the_day)
local day = obj.day
local obj2 = {
	numbers = {
		1,
		2,
		3,
		4
	},
	properties = {
		color = "green",
		height = 13.5
	}
}
local first, second, color = obj2.numbers[1], obj2.numbers[2], obj2.properties.color
print(first, second, color)
local first, second, color
local _obj_0 = obj2
first, second, color = _obj_0.numbers[1], _obj_0.numbers[2], _obj_0.properties.color
local concat, insert
local _obj_0 = table
concat, insert = _obj_0.concat, _obj_0.insert
local mix, max, rand
local _obj_0 = math
mix, max, rand = _obj_0.mix, _obj_0.max, _obj_0.random
local name, job
local _obj_0 = person
name, job = _obj_0.name, _obj_0.job
if name == nil then
	name = "sem nome"
end
if job == nil then
	job = "sem emprego"
end
local two, four
local _obj_0 = items
two, four = _obj_0[2], _obj_0[4]
local orders = {
	"first",
	"second",
	"third",
	"fourth",
	"last"
}
local first, bulk, last = orders[1], (function()
	local _accum_0 = { }
	local _len_0 = 1
	local _max_0 = #orders + -2 + 1
	for _index_0 = 2, _max_0 do
		local _item_0 = orders[_index_0]
		_accum_0[_len_0] = _item_0
		_len_0 = _len_0 + 1
	end
	return _accum_0
end)(), orders[#orders]
print(first)
print(bulk)
print(last)
local first, rest
do
	local _obj_0 = orders
	first, rest = _obj_0[1], (function()
		local _accum_0 = { }
		local _len_0 = 1
		local _max_0 = #_obj_0
		for _index_0 = 2, _max_0 do
			local _item_0 = _obj_0[_index_0]
			_accum_0[_len_0] = _item_0
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)()
end
local start, last
do
	local _obj_0 = orders
	start, last = (function()
		local _accum_0 = { }
		local _len_0 = 1
		local _max_0 = #_obj_0 + -2 + 1
		for _index_0 = 1, _max_0 do
			local _item_0 = _obj_0[_index_0]
			_accum_0[_len_0] = _item_0
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)(), _obj_0[#_obj_0]
end
local _obj_0 = orders
first, last = _obj_0[1], _obj_0[#_obj_0]
local tuples = {
	{
		"hello",
		"world"
	},
	{
		"egg",
		"head"
	}
}
for _index_0 = 1, #tuples do
	local _des_0 = tuples[_index_0]
	local left, right = _des_0[1], _des_0[2]
	print(left, right)
end
local i = 100
local my_func
my_func = function()
	i = 10
	while i > 0 do
		print(i)
		i = i - 1
	end
end
my_func()
print(i)
local i = 100
local my_func
my_func = function()
	local i = "hello"
end
my_func()
print(i)
local tmp = 1213
local i, k = 100, 50
local my_func
my_func = function(add)
	local tmp = tmp + add
	i = i + tmp
	k = k + tmp
end
my_func(22)
print(i, k)
local i = 100
local my_func
my_func = function()
	i = 10
	while i > 0 do
		print(i)
		i = i - 1
	end
end
my_func()
print(i)
local i = 100
local my_func
my_func = function()
	local i = "hello"
end
my_func()
print(i)
local tmp = 1213
local i, k = 100, 50
local my_func
my_func = function(add)
	local tmp = tmp + add
	i = i + tmp
	k = k + tmp
end
my_func(22)
print(i, k)
local _module_0 = { }
local p, to_lua
do
	local _obj_0 = require("yue")
	p, to_lua = _obj_0.p, _obj_0.to_lua
end
local inventory = {
	equipment = {
		"sword",
		"shield"
	},
	items = {
		{
			name = "potion",
			count = 10
		},
		{
			name = "bread",
			count = 3
		}
	}
}
local map
map = function(arr, action)
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #arr do
		local item = arr[_index_0]
		_accum_0[_len_0] = action(item)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local filter
filter = function(arr, cond)
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #arr do
		local item = arr[_index_0]
		if cond(item) then
			_accum_0[_len_0] = item
			_len_0 = _len_0 + 1
		end
	end
	return _accum_0
end
local reduce
reduce = function(arr, init, action)
	for _index_0 = 1, #arr do
		local item = arr[_index_0]
		init = action(init, item)
	end
	return init
end
print(reduce(filter(map({
	1,
	2,
	3
}, function(x)
	return x * 2
end), function(x)
	return x > 4
end), 0, function(a, b)
	return a + b
end))
local apple = setmetatable({
	size = 15
}, {
	__index = {
		color = 0x00ffff
	}
})
if (getmetatable(apple) ~= nil) then
	p(apple.size, apple.color, getmetatable(apple).__index)
end
local _u1f31b = "Script da Lua"
_module_0["🌛"] = _u1f31b
return _module_0
local _module_0 = { }
local p, to_lua
do
	local _obj_0 = require("yue")
	p, to_lua = _obj_0.p, _obj_0.to_lua
end
local inventory = {
	equipment = {
		"sword",
		"shield"
	},
	items = {
		{
			name = "potion",
			count = 10
		},
		{
			name = "bread",
			count = 3
		}
	}
}
local map
map = function(arr, action)
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #arr do
		local item = arr[_index_0]
		_accum_0[_len_0] = action(item)
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
local filter
filter = function(arr, cond)
	local _accum_0 = { }
	local _len_0 = 1
	for _index_0 = 1, #arr do
		local item = arr[_index_0]
		if cond(item) then
			_accum_0[_len_0] = item
			_len_0 = _len_0 + 1
		end
	end
	return _accum_0
end
local reduce
reduce = function(arr, init, action)
	for _index_0 = 1, #arr do
		local item = arr[_index_0]
		init = action(init, item)
	end
	return init
end
print(reduce(filter(map({
	1,
	2,
	3
}, function(x)
	return x * 2
end), function(x)
	return x > 4
end), 0, function(a, b)
	return a + b
end))
local apple = setmetatable({
	size = 15
}, {
	__index = {
		color = 0x00ffff
	}
})
if (getmetatable(apple) ~= nil) then
	p(apple.size, apple.color, getmetatable(apple).__index)
end
local _u1f31b = "Script da Lua"
_module_0["🌛"] = _u1f31b
return _module_0
local have_coins = false
if have_coins then
	print("Tem moedas")
else
	print("Sem moedas")
end
local have_coins = false
if have_coins then
	print("Tem moedas")
else
	print("Sem moedas")
end
local have_coins = false
print((function()
	if have_coins then
		return "Tem moedas"
	else
		return "Sem moedas"
	end
end)())
local is_tall
is_tall = function(name)
	if name == "Rob" then
		return true
	else
		return false
	end
end
local message
if is_tall("Rob") then
	message = "Sou muito alto"
else
	message = "Não sou tão alto"
end
print(message)
if not (os.date("%A") == "Monday") then
	print("não é segunda-feira!")
end
if not (math.random() > 0.1) then
	print("Você tem sorte!")
end
local a = 5
if (1 == a or 3 == a or 5 == a or 7 == a) then
	print("verificando igualdade com valores discretos")
end
if (function()
	local _check_0 = list
	for _index_0 = 1, #_check_0 do
		if _check_0[_index_0] == a then
			return true
		end
	end
	return false
end)() then
	print("verificando se `a` está na lista")
end
local has
do
	local _val_0 = "foo"
	has = "bar" == _val_0 or "foo" == _val_0
end
if (function()
	local _val_0 = a
	return 1 == _val_0 or 2 == _val_0 or 3 == _val_0
end)() then
	print("a está na tabela")
end
local not_exist
do
	local _check_0 = list
	local _val_0 = item
	local _find_0 = false
	for _index_0 = 1, #_check_0 do
		local _item_0 = _check_0[_index_0]
		if _item_0 == _val_0 then
			_find_0 = true
			break
		end
	end
	not_exist = not _find_0
end
local check
check = function()
	local _check_0 = table
	local _val_0 = value
	for _index_0 = 1, #_check_0 do
		if _check_0[_index_0] == _val_0 then
			return false
		end
	end
	return true
end
local c
do
	local _val_0 = a
	c = 1 == _val_0
end
do
	local _val_0 = a
	c = 1 == _val_0
end
local _with_0 = tb
do
	local _check_0 = _with_0[1]
	local _val_0 = a
	local _find_0 = false
	for _index_0 = 1, #_check_0 do
		local _item_0 = _check_0[_index_0]
		if _item_0 == _val_0 then
			_find_0 = true
			break
		end
	end
	c = _find_0
end
local have_coins = false
if have_coins then
	print("Tem moedas")
else
	print("Sem moedas")
end
local have_coins = false
if have_coins then
	print("Tem moedas")
else
	print("Sem moedas")
end
local have_coins = false
print((function()
	if have_coins then
		return "Tem moedas"
	else
		return "Sem moedas"
	end
end)())
local is_tall
is_tall = function(name)
	if name == "Rob" then
		return true
	else
		return false
	end
end
local message
if is_tall("Rob") then
	message = "Sou muito alto"
else
	message = "Não sou tão alto"
end
print(message)
if not (os.date("%A") == "Monday") then
	print("não é segunda-feira!")
end
if not (math.random() > 0.1) then
	print("Você tem sorte!")
end
local a = 5
if (1 == a or 3 == a or 5 == a or 7 == a) then
	print("verificando igualdade com valores discretos")
end
if (function()
	local _check_0 = list
	for _index_0 = 1, #_check_0 do
		if _check_0[_index_0] == a then
			return true
		end
	end
	return false
end)() then
	print("verificando se `a` está na lista")
end
local has
do
	local _val_0 = "foo"
	has = "bar" == _val_0 or "foo" == _val_0
end
if (function()
	local _val_0 = a
	return 1 == _val_0 or 2 == _val_0 or 3 == _val_0
end)() then
	print("a está na tabela")
end
local not_exist
do
	local _check_0 = list
	local _val_0 = item
	local _find_0 = false
	for _index_0 = 1, #_check_0 do
		local _item_0 = _check_0[_index_0]
		if _item_0 == _val_0 then
			_find_0 = true
			break
		end
	end
	not_exist = not _find_0
end
local check
check = function()
	local _check_0 = table
	local _val_0 = value
	for _index_0 = 1, #_check_0 do
		if _check_0[_index_0] == _val_0 then
			return false
		end
	end
	return true
end
local c
do
	local _val_0 = a
	c = 1 == _val_0
end
do
	local _val_0 = a
	c = 1 == _val_0
end
local _with_0 = tb
do
	local _check_0 = _with_0[1]
	local _val_0 = a
	local _find_0 = false
	for _index_0 = 1, #_check_0 do
		local _item_0 = _check_0[_index_0]
		if _item_0 == _val_0 then
			_find_0 = true
			break
		end
	end
	c = _find_0
end
for i = 10, 20 do
	print(i)
end
for k = 1, 15, 2 do
	print(k)
end
for key, value in pairs(object) do
	print(key, value)
end
local _list_0 = items
for _index_0 = 2, 4 do
	local item = _list_0[_index_0]
	print(item)
end
local _list_0 = items
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	print(item)
end
for j = 1, 10, 3 do
	print(j)
end
local doubled_evens
local _accum_0 = { }
local _len_0 = 1
for i = 1, 20 do
	if i % 2 == 0 then
		_accum_0[_len_0] = i * 2
		_len_0 = _len_0 + 1
	else
		_accum_0[_len_0] = i
		_len_0 = _len_0 + 1
	end
end
doubled_evens = _accum_0
local first_large
local _list_0 = numbers
for _index_0 = 1, #_list_0 do
	local n = _list_0[_index_0]
	if n > 10 then
		first_large = n
		break
	end
end
local key, score
for k, v in pairs(data) do
	if k == "target" then
		key, score = k, v * 10
		break
	end
end
local func_a
func_a = function()
	for i = 1, 10 do
		print(i)
	end
end
local func_b
func_b = function()
	local _accum_0 = { }
	local _len_0 = 1
	for i = 1, 10 do
		_accum_0[_len_0] = i
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
print(func_a())
print(func_b())
for i = 10, 20 do
	print(i)
end
for k = 1, 15, 2 do
	print(k)
end
for key, value in pairs(object) do
	print(key, value)
end
local _list_0 = items
for _index_0 = 2, 4 do
	local item = _list_0[_index_0]
	print(item)
end
local _list_0 = items
for _index_0 = 1, #_list_0 do
	local item = _list_0[_index_0]
	print(item)
end
for j = 1, 10, 3 do
	print(j)
end
local doubled_evens
local _accum_0 = { }
local _len_0 = 1
for i = 1, 20 do
	if i % 2 == 0 then
		_accum_0[_len_0] = i * 2
		_len_0 = _len_0 + 1
	else
		_accum_0[_len_0] = i
		_len_0 = _len_0 + 1
	end
end
doubled_evens = _accum_0
local first_large
local _list_0 = numbers
for _index_0 = 1, #_list_0 do
	local n = _list_0[_index_0]
	if n > 10 then
		first_large = n
		break
	end
end
local key, score
for k, v in pairs(data) do
	if k == "target" then
		key, score = k, v * 10
		break
	end
end
local func_a
func_a = function()
	for i = 1, 10 do
		print(i)
	end
end
local func_b
func_b = function()
	local _accum_0 = { }
	local _len_0 = 1
	for i = 1, 10 do
		_accum_0[_len_0] = i
		_len_0 = _len_0 + 1
	end
	return _accum_0
end
print(func_a())
print(func_b())
local i = 0
while i < 10 do
	i = i + 1
	if i % 2 == 0 then
		goto _continue_0
	end
	print(i)
	::_continue_0::
end
local my_numbers = {
	1,
	2,
	3,
	4,
	5,
	6
}
local odds
local _accum_0 = { }
local _len_0 = 1
for _index_0 = 1, #my_numbers do
	local x = my_numbers[_index_0]
	if x % 2 == 1 then
		goto _continue_0
	end
	_accum_0[_len_0] = x
	_len_0 = _len_0 + 1
	::_continue_0::
end
odds = _accum_0
local i = 0
while i < 10 do
	i = i + 1
	if i % 2 == 0 then
		goto _continue_0
	end
	print(i)
	::_continue_0::
end
local my_numbers = {
	1,
	2,
	3,
	4,
	5,
	6
}
local odds
local _accum_0 = { }
local _len_0 = 1
for _index_0 = 1, #my_numbers do
	local x = my_numbers[_index_0]
	if x % 2 == 1 then
		goto _continue_0
	end
	_accum_0[_len_0] = x
	_len_0 = _len_0 + 1
	::_continue_0::
end
odds = _accum_0
local name = "Dan"
if "Robert" == name then
	print("Você é Robert")
elseif "Dan" == name or "Daniel" == name then
	print("Seu nome é Dan")
else
	print("Não sei quem você é com o nome " .. tostring(name))
end
local b = 1
local next_number
if 1 == b then
	next_number = 2
elseif 2 == b then
	next_number = 3
else
	next_number = error("não consigo contar tão alto!")
end
local msg
local _exp_0 = math.random(1, 5)
if 1 == _exp_0 then
	msg = "você tem sorte"
elseif 2 == _exp_0 then
	msg = "você quase tem sorte"
else
	msg = "não tão sortudo"
end
do
	local _exp_0 = math.random(1, 5)
	if 1 == _exp_0 then
		print("você tem sorte")
	else
		print("não tão sortudo")
	end
end
local _exp_0 = math.random(1, 5)
if 1 == _exp_0 then
	print("você tem sorte")
else
	print("não tão sortudo")
end
local items = {
	{
		x = 100,
		y = 200
	},
	{
		width = 300,
		height = 400
	}
}
for _index_0 = 1, #items do
	local item = items[_index_0]
	local _type_0 = type(item)
	local _tab_0 = "table" == _type_0 or "userdata" == _type_0
	local _match_0 = false
	if _tab_0 then
		local x = item.x
		local y = item.y
		if x ~= nil and y ~= nil then
			_match_0 = true
			print("Vec2 " .. tostring(x) .. ", " .. tostring(y))
		end
	end
	if not _match_0 then
		if _tab_0 then
			local width = item.width
			local height = item.height
			if width ~= nil and height ~= nil then
				print("tamanho " .. tostring(width) .. ", " .. tostring(height))
			end
		end
	end
end
local item = { }
local x, y = item.pos.x, item.pos.y
if x == nil then
	x = 50
end
if y == nil then
	y = 200
end
local _type_0 = type(item)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
if _tab_0 then
	do
		local _obj_0 = item.pos
		local _type_1 = type(_obj_0)
		if "table" == _type_1 or "userdata" == _type_1 then
			x = _obj_0.x
		end
	end
	do
		local _obj_0 = item.pos
		local _type_1 = type(_obj_0)
		if "table" == _type_1 or "userdata" == _type_1 then
			y = _obj_0.y
		end
	end
	if x == nil then
		x = 50
	end
	if y == nil then
		y = 200
	end
	print("Vec2 " .. tostring(x) .. ", " .. tostring(y))
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
local _match_0 = false
if _tab_0 then
	if 1 == _exp_0[1] and 2 == _exp_0[2] and 3 == _exp_0[3] then
		_match_0 = true
		print("1, 2, 3")
	end
end
if not _match_0 then
	local _match_1 = false
	if _tab_0 then
		local b = _exp_0[2]
		if 1 == _exp_0[1] and b ~= nil and 3 == _exp_0[3] then
			_match_1 = true
			print("1, " .. tostring(b) .. ", 3")
		end
	end
	if not _match_1 then
		if _tab_0 then
			local b = _exp_0[3]
			if b == nil then
				b = 3
			end
			if 1 == _exp_0[1] and 2 == _exp_0[2] then
				print("1, 2, " .. tostring(b))
			end
		end
	end
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
local _match_0 = false
if _tab_0 then
	local result = _exp_0.result
	if true == _exp_0.success and result ~= nil then
		_match_0 = true
		print("sucesso", result)
	end
end
if not _match_0 then
	local _match_1 = false
	if _tab_0 then
		if false == _exp_0.success then
			_match_1 = true
			print("falhou", result)
		end
	end
	if not _match_1 then
		print("inválido")
	end
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
local _match_0 = false
if _tab_0 then
	local content
	do
		local _obj_0 = _exp_0.data
		local _type_1 = type(_obj_0)
		if "table" == _type_1 or "userdata" == _type_1 then
			content = _obj_0.content
		end
	end
	local _val_0
	do
		local _obj_0 = _exp_0.data
		if _obj_0 ~= nil then
			_val_0 = _obj_0.type
		end
	end
	if "success" == _val_0 and content ~= nil then
		_match_0 = true
		print("sucesso", content)
	end
end
if not _match_0 then
	local _match_1 = false
	if _tab_0 then
		local content
		do
			local _obj_0 = _exp_0.data
			local _type_1 = type(_obj_0)
			if "table" == _type_1 or "userdata" == _type_1 then
				content = _obj_0.content
			end
		end
		local _val_0
		do
			local _obj_0 = _exp_0.data
			if _obj_0 ~= nil then
				_val_0 = _obj_0.type
			end
		end
		if "error" == _val_0 and content ~= nil then
			_match_1 = true
			print("erro", content)
		end
	end
	if not _match_1 then
		print("inválido")
	end
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
if _tab_0 then
	local fourth = _exp_0[4]
	local _val_0
	do
		local _obj_0 = _exp_0[1]
		if _obj_0 ~= nil then
			_val_0 = _obj_0.a
		end
	end
	local _val_1
	do
		local _obj_0 = _exp_0[1]
		if _obj_0 ~= nil then
			_val_1 = _obj_0.b
		end
	end
	local _val_2
	do
		local _obj_0 = _exp_0[2]
		if _obj_0 ~= nil then
			_val_2 = _obj_0.a
		end
	end
	local _val_3
	do
		local _obj_0 = _exp_0[2]
		if _obj_0 ~= nil then
			_val_3 = _obj_0.b
		end
	end
	local _val_4
	do
		local _obj_0 = _exp_0[3]
		if _obj_0 ~= nil then
			_val_4 = _obj_0.a
		end
	end
	local _val_5
	do
		local _obj_0 = _exp_0[3]
		if _obj_0 ~= nil then
			_val_5 = _obj_0.b
		end
	end
	if 1 == _val_0 and 2 == _val_1 and 3 == _val_2 and 4 == _val_3 and 5 == _val_4 and 6 == _val_5 and fourth ~= nil then
		print("correspondido", fourth)
	end
end
local segments = {
	"admin",
	"users",
	"logs",
	"view"
}
local _type_0 = type(segments)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
if _tab_0 then
	local groups
	do
		local _accum_0 = { }
		local _len_0 = 1
		local _max_0 = #segments + -3 + 1
		for _index_0 = 1, _max_0 do
			local _item_0 = segments[_index_0]
			_accum_0[_len_0] = _item_0
			_len_0 = _len_0 + 1
		end
		groups = _accum_0
	end
	local resource = segments[#segments - 1]
	local action = segments[#segments]
	if resource ~= nil and action ~= nil then
		print("Grupo:", groups)
		print("Recurso:", resource)
		print("Ação:", action)
	end
end
local name = "Dan"
if "Robert" == name then
	print("Você é Robert")
elseif "Dan" == name or "Daniel" == name then
	print("Seu nome é Dan")
else
	print("Não sei quem você é com o nome " .. tostring(name))
end
local b = 1
local next_number
if 1 == b then
	next_number = 2
elseif 2 == b then
	next_number = 3
else
	next_number = error("não consigo contar tão alto!")
end
local msg
local _exp_0 = math.random(1, 5)
if 1 == _exp_0 then
	msg = "você tem sorte"
elseif 2 == _exp_0 then
	msg = "você quase tem sorte"
else
	msg = "não tão sortudo"
end
do
	local _exp_0 = math.random(1, 5)
	if 1 == _exp_0 then
		print("você tem sorte")
	else
		print("não tão sortudo")
	end
end
local _exp_0 = math.random(1, 5)
if 1 == _exp_0 then
	print("você tem sorte")
else
	print("não tão sortudo")
end
local items = {
	{
		x = 100,
		y = 200
	},
	{
		width = 300,
		height = 400
	}
}
for _index_0 = 1, #items do
	local item = items[_index_0]
	local _type_0 = type(item)
	local _tab_0 = "table" == _type_0 or "userdata" == _type_0
	local _match_0 = false
	if _tab_0 then
		local x = item.x
		local y = item.y
		if x ~= nil and y ~= nil then
			_match_0 = true
			print("Vec2 " .. tostring(x) .. ", " .. tostring(y))
		end
	end
	if not _match_0 then
		if _tab_0 then
			local width = item.width
			local height = item.height
			if width ~= nil and height ~= nil then
				print("tamanho " .. tostring(width) .. ", " .. tostring(height))
			end
		end
	end
end
local item = { }
local x, y = item.pos.x, item.pos.y
if x == nil then
	x = 50
end
if y == nil then
	y = 200
end
local _type_0 = type(item)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
if _tab_0 then
	do
		local _obj_0 = item.pos
		local _type_1 = type(_obj_0)
		if "table" == _type_1 or "userdata" == _type_1 then
			x = _obj_0.x
		end
	end
	do
		local _obj_0 = item.pos
		local _type_1 = type(_obj_0)
		if "table" == _type_1 or "userdata" == _type_1 then
			y = _obj_0.y
		end
	end
	if x == nil then
		x = 50
	end
	if y == nil then
		y = 200
	end
	print("Vec2 " .. tostring(x) .. ", " .. tostring(y))
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
local _match_0 = false
if _tab_0 then
	if 1 == _exp_0[1] and 2 == _exp_0[2] and 3 == _exp_0[3] then
		_match_0 = true
		print("1, 2, 3")
	end
end
if not _match_0 then
	local _match_1 = false
	if _tab_0 then
		local b = _exp_0[2]
		if 1 == _exp_0[1] and b ~= nil and 3 == _exp_0[3] then
			_match_1 = true
			print("1, " .. tostring(b) .. ", 3")
		end
	end
	if not _match_1 then
		if _tab_0 then
			local b = _exp_0[3]
			if b == nil then
				b = 3
			end
			if 1 == _exp_0[1] and 2 == _exp_0[2] then
				print("1, 2, " .. tostring(b))
			end
		end
	end
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
local _match_0 = false
if _tab_0 then
	local result = _exp_0.result
	if true == _exp_0.success and result ~= nil then
		_match_0 = true
		print("sucesso", result)
	end
end
if not _match_0 then
	local _match_1 = false
	if _tab_0 then
		if false == _exp_0.success then
			_match_1 = true
			print("falhou", result)
		end
	end
	if not _match_1 then
		print("inválido")
	end
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
local _match_0 = false
if _tab_0 then
	local content
	do
		local _obj_0 = _exp_0.data
		local _type_1 = type(_obj_0)
		if "table" == _type_1 or "userdata" == _type_1 then
			content = _obj_0.content
		end
	end
	local _val_0
	do
		local _obj_0 = _exp_0.data
		if _obj_0 ~= nil then
			_val_0 = _obj_0.type
		end
	end
	if "success" == _val_0 and content ~= nil then
		_match_0 = true
		print("sucesso", content)
	end
end
if not _match_0 then
	local _match_1 = false
	if _tab_0 then
		local content
		do
			local _obj_0 = _exp_0.data
			local _type_1 = type(_obj_0)
			if "table" == _type_1 or "userdata" == _type_1 then
				content = _obj_0.content
			end
		end
		local _val_0
		do
			local _obj_0 = _exp_0.data
			if _obj_0 ~= nil then
				_val_0 = _obj_0.type
			end
		end
		if "error" == _val_0 and content ~= nil then
			_match_1 = true
			print("erro", content)
		end
	end
	if not _match_1 then
		print("inválido")
	end
end
local _exp_0 = tb
local _type_0 = type(_exp_0)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
if _tab_0 then
	local fourth = _exp_0[4]
	local _val_0
	do
		local _obj_0 = _exp_0[1]
		if _obj_0 ~= nil then
			_val_0 = _obj_0.a
		end
	end
	local _val_1
	do
		local _obj_0 = _exp_0[1]
		if _obj_0 ~= nil then
			_val_1 = _obj_0.b
		end
	end
	local _val_2
	do
		local _obj_0 = _exp_0[2]
		if _obj_0 ~= nil then
			_val_2 = _obj_0.a
		end
	end
	local _val_3
	do
		local _obj_0 = _exp_0[2]
		if _obj_0 ~= nil then
			_val_3 = _obj_0.b
		end
	end
	local _val_4
	do
		local _obj_0 = _exp_0[3]
		if _obj_0 ~= nil then
			_val_4 = _obj_0.a
		end
	end
	local _val_5
	do
		local _obj_0 = _exp_0[3]
		if _obj_0 ~= nil then
			_val_5 = _obj_0.b
		end
	end
	if 1 == _val_0 and 2 == _val_1 and 3 == _val_2 and 4 == _val_3 and 5 == _val_4 and 6 == _val_5 and fourth ~= nil then
		print("correspondido", fourth)
	end
end
local segments = {
	"admin",
	"users",
	"logs",
	"view"
}
local _type_0 = type(segments)
local _tab_0 = "table" == _type_0 or "userdata" == _type_0
if _tab_0 then
	local groups
	do
		local _accum_0 = { }
		local _len_0 = 1
		local _max_0 = #segments + -3 + 1
		for _index_0 = 1, _max_0 do
			local _item_0 = segments[_index_0]
			_accum_0[_len_0] = _item_0
			_len_0 = _len_0 + 1
		end
		groups = _accum_0
	end
	local resource = segments[#segments - 1]
	local action = segments[#segments]
	if resource ~= nil and action ~= nil then
		print("Grupo:", groups)
		print("Recurso:", resource)
		print("Ação:", action)
	end
end
local i = 10
while i > 0 do
	print(i)
	i = i - 1
end
while running == true do
	my_function()
end
local i = 10
while not (i == 0) do
	print(i)
	i = i - 1
end
while not (running == false) do
	my_function()
end
local value, doubled
local _val_0, _val_1
while true do
	local n = get_next()
	if n > 10 then
		_val_0, _val_1 = n, n * 2
		break
	end
end
value, doubled = _val_0, _val_1
local i = 10
repeat
	print(i)
	i = i - 1
until i == 0
local i = 1
local value, scaled
local _val_0, _val_1
repeat
	if i > 3 then
		_val_0, _val_1 = i, i * 100
		break
	end
	i = i + 1
until false
value, scaled = _val_0, _val_1
local i = 10
while i > 0 do
	print(i)
	i = i - 1
end
while running == true do
	my_function()
end
local i = 10
while not (i == 0) do
	print(i)
	i = i - 1
end
while not (running == false) do
	my_function()
end
local value, doubled
local _val_0, _val_1
while true do
	local n = get_next()
	if n > 10 then
		_val_0, _val_1 = n, n * 2
		break
	end
end
value, doubled = _val_0, _val_1
local i = 10
repeat
	print(i)
	i = i - 1
until i == 0
local i = 1
local value, scaled
local _val_0, _val_1
repeat
	if i > 3 then
		_val_0, _val_1 = i, i * 100
		break
	end
	i = i + 1
until false
value, scaled = _val_0, _val_1
local my_object = {
	value = 1000,
	write = function(self)
		return print("the value:", self.value)
	end
}
local run_callback
run_callback = function(func)
	print("running callback...")
	return func()
end
run_callback(my_object.write)
run_callback((function()
	local _base_0 = my_object
	local _fn_0 = _base_0.write
	return _fn_0 and function(...)
		return _fn_0(_base_0, ...)
	end
end)())
local my_object = {
	value = 1000,
	write = function(self)
		return print("the value:", self.value)
	end
}
local run_callback
run_callback = function(func)
	print("running callback...")
	return func()
end
run_callback(my_object.write)
run_callback((function()
	local _base_0 = my_object
	local _fn_0 = _base_0.write
	return _fn_0 and function(...)
		return _fn_0(_base_0, ...)
	end
end)())
f(function(x)
	return print("hello" .. x)
end)
f(function(self)
	return print(self.value)
end)
map(function(x)
	return x * 2
end, {
	1,
	2,
	3
})
local result, msg
do
	result, msg = readAsync("filename.txt", function(data)
		print(data)
		return processAsync(data, function(info)
			return check(info)
		end)
	end)
end
print(result, msg)
f(function(x)
	return print("hello" .. x)
end)
f(function(self)
	return print(self.value)
end)
map(function(x)
	return x * 2
end, {
	1,
	2,
	3
})
local result, msg
do
	result, msg = readAsync("filename.txt", function(data)
		print(data)
		return processAsync(data, function(info)
			return check(info)
		end)
	end)
end
print(result, msg)
local my_function
my_function = function() end
my_function()
local func_a
func_a = function()
	return print("hello world")
end
local func_b
func_b = function()
	local value = 100
	return print("The value:", value)
end
func_a()
func_b()
local sum
sum = function(x, y)
	return print("sum", x + y)
end
sum(10, 20)
print(sum(10, 20))
a(b(c("a", "b", "c")))
print("x:", sum(10, 20), "y:", sum(30, 40))
local sum
sum = function(x, y)
	return x + y
end
print("The sum is ", sum(10, 20))
local sum
sum = function(x, y)
	return x + y
end
local mystery
mystery = function(x, y)
	return x + y, x - y
end
local a, b = mystery(10, 20)
local func
func = function(self, num)
	return self.value + num
end
local my_function
my_function = function(name, height)
	if name == nil then
		name = "something"
	end
	if height == nil then
		height = 100
	end
	print("Hello I am", name)
	return print("My height is", height)
end
local some_args
some_args = function(x, y)
	if x == nil then
		x = 100
	end
	if y == nil then
		y = x + 1000
	end
	return print(x + y)
end
local a = x - 10
local b = x - 10
local c = x(-y)
local d = x - z
local x = func("hello") + 100
local y = func("hello" + 100)
my_func(5, 4, 3, 8, 9, 10)
cool_func(1, 2, 3, 4, 5, 6, 7, 8)
my_func(5, 6, 7, 6, another_func(6, 7, 8, 9, 1, 2), 5, 4)
local x = {
	1,
	2,
	3,
	4,
	a_func(4, 5, 5, 6),
	8,
	9,
	10
}
local y = {
	my_func(1, 2, 3, 4, 5),
	5,
	6,
	7
}
if func(1, 2, 3, "hello", "world") then
	print("hello")
	print("I am inside if")
end
if func(1, 2, 3, "hello", "world") then
	print("hello")
	print("I am inside if")
end
local f1
f1 = function(_arg_0)
	local a, b, c
	a, b, c = _arg_0.a, _arg_0.b, _arg_0.c
	return print(a, b, c)
end
f1({
	a = 1,
	b = "2",
	c = { }
})
local f2
f2 = function(_arg_0, c)
	local a1, b
	a1, b = _arg_0.a, _arg_0.b
	if a1 == nil then
		a1 = 123
	end
	if b == nil then
		b = 'abc'
	end
	if c == nil then
		c = { }
	end
	return print(a1, b, c)
end
local arg1 = {
	a = 0
}
f2(arg1, arg2)
local findFirstEven
findFirstEven = function(list)
	for _index_0 = 1, #list do
		local item = list[_index_0]
		if type(item) == "table" then
			for _index_1 = 1, #item do
				local sub = item[_index_1]
				if sub % 2 == 0 then
					return sub
				end
			end
		end
	end
	return nil
end
local findFirstEven
findFirstEven = function(list)
	for _index_0 = 1, #list do
		local item = list[_index_0]
		if type(item) == "table" then
			for _index_1 = 1, #item do
				local sub = item[_index_1]
				if sub % 2 == 0 then
					return sub
				end
			end
		end
	end
	return nil
end
local f
f = function(...)
	local t = {
		n = select("#", ...),
		...
	}
	print("contagem de argumentos:", t.n)
	print("comprimento da tabela:", #t)
	for i = 1, t.n do
		print(t[i])
	end
end
f(1, 2, 3)
f("a", "b", "c", "d")
f()
local process
process = function(...)
	local args = {
		n = select("#", ...),
		...
	}
	local sum = 0
	for i = 1, args.n do
		if args[i] ~= nil and type(args[i]) == "number" then
			sum = sum + args[i]
		end
	end
	return sum
end
process(1, nil, 3, nil, 5)
local my_function
my_function = function() end
my_function()
local func_a
func_a = function()
	return print("hello world")
end
local func_b
func_b = function()
	local value = 100
	return print("The value:", value)
end
func_a()
func_b()
local sum
sum = function(x, y)
	return print("sum", x + y)
end
sum(10, 20)
print(sum(10, 20))
a(b(c("a", "b", "c")))
print("x:", sum(10, 20), "y:", sum(30, 40))
local sum
sum = function(x, y)
	return x + y
end
print("The sum is ", sum(10, 20))
local sum
sum = function(x, y)
	return x + y
end
local mystery
mystery = function(x, y)
	return x + y, x - y
end
local a, b = mystery(10, 20)
local func
func = function(self, num)
	return self.value + num
end
local my_function
my_function = function(name, height)
	if name == nil then
		name = "something"
	end
	if height == nil then
		height = 100
	end
	print("Hello I am", name)
	return print("My height is", height)
end
local some_args
some_args = function(x, y)
	if x == nil then
		x = 100
	end
	if y == nil then
		y = x + 1000
	end
	return print(x + y)
end
local a = x - 10
local b = x - 10
local c = x(-y)
local d = x - z
local x = func("hello") + 100
local y = func("hello" + 100)
my_func(5, 4, 3, 8, 9, 10)
cool_func(1, 2, 3, 4, 5, 6, 7, 8)
my_func(5, 6, 7, 6, another_func(6, 7, 8, 9, 1, 2), 5, 4)
local x = {
	1,
	2,
	3,
	4,
	a_func(4, 5, 5, 6),
	8,
	9,
	10
}
local y = {
	my_func(1, 2, 3, 4, 5),
	5,
	6,
	7
}
if func(1, 2, 3, "hello", "world") then
	print("hello")
	print("I am inside if")
end
if func(1, 2, 3, "hello", "world") then
	print("hello")
	print("I am inside if")
end
local f1
f1 = function(_arg_0)
	local a, b, c
	a, b, c = _arg_0.a, _arg_0.b, _arg_0.c
	return print(a, b, c)
end
f1({
	a = 1,
	b = "2",
	c = { }
})
local f2
f2 = function(_arg_0, c)
	local a1, b
	a1, b = _arg_0.a, _arg_0.b
	if a1 == nil then
		a1 = 123
	end
	if b == nil then
		b = 'abc'
	end
	if c == nil then
		c = { }
	end
end
print(a1, b, c)
local arg1 = {
	a = 0
}
f2(arg1, arg2)
local findFirstEven
findFirstEven = function(list)
	for _index_0 = 1, #list do
		local item = list[_index_0]
		if type(item) == "table" then
			for _index_1 = 1, #item do
				local sub = item[_index_1]
				if sub % 2 == 0 then
					return sub
				end
			end
		end
	end
	return nil
end
local findFirstEven
findFirstEven = function(list)
	for _index_0 = 1, #list do
		local item = list[_index_0]
		if type(item) == "table" then
			for _index_1 = 1, #item do
				local sub = item[_index_1]
				if sub % 2 == 0 then
					return sub
				end
			end
		end
	end
	return nil
end
local f
f = function(...)
	local t = {
		n = select("#", ...),
		...
	}
	print("contagem de argumentos:", t.n)
	print("comprimento da tabela:", #t)
	for i = 1, t.n do
		print(t[i])
	end
end
f(1, 2, 3)
f("a", "b", "c", "d")
f()
local process
process = function(...)
	local args = {
		n = select("#", ...),
		...
	}
	local sum = 0
	for i = 1, args.n do
		if args[i] ~= nil and type(args[i]) == "number" then
			sum = sum + args[i]
		end
	end
	return sum
end
process(1, nil, 3, nil, 5)
local a = 1
local b = 2
print(a + b)
Rx.Observable.fromRange(1, 8):filter(function(x)
	return x % 2 == 0
end):concat(Rx.Observable.of('who do we appreciate')):map(function(value)
	return value .. '!'
end):subscribe(print)
local a = 1
local b = 2
print(a + b)
Rx.Observable.fromRange(1, 8):filter(function(x)
	return x % 2 == 0
end):concat(Rx.Observable.of('who do we appreciate')):map(function(value)
	return value .. '!'
end):subscribe(print)
local str = strA .. strB .. strC
func(3000, "192.168.1.1")
local str = strA .. strB .. strC
func(3000, "192.168.1.1")
local a <const> = 123
local _ <close> = setmetatable({ }, {
	__close = function()
		return print("Fora do escopo.")
	end
})
local a, b, c, d
local _obj_0 = tb
a, b, c, d = _obj_0.a, _obj_0.b, _obj_0[1], _obj_0[2]
Constant = 123
local a <const> = 123
local _ <close> = setmetatable({ }, {
	__close = function()
		return print("Fora do escopo.")
	end
})
local a, b, c, d
local _obj_0 = tb
a, b, c, d = _obj_0.a, _obj_0.b, _obj_0[1], _obj_0[2]
Constant = 123
if tb ~= nil then
	tb:func()
end
if tb ~= nil then
	tb:func()
end
print(1 < 2 and 2 <= 2 and 2 < 3 and 3 == 3 and 3 > 2 and 2 >= 1 and 1 == 1 and 1 < 3 and 3 ~= 5)
local a = 5
print(1 <= a and a <= 10)
local v
v = function(x)
	print(x)
	return x
end
print((function()
	local _cond_0 = v(2)
	if not (v(1) < _cond_0) then
		return false
	else
		return _cond_0 <= v(3)
	end
end)())
print((function()
	local _cond_0 = v(2)
	if not (v(1) > _cond_0) then
		return false
	else
		return _cond_0 <= v(3)
	end
end)())
local tab = { }
tab[#tab + 1] = "Value"
local tbA = {
	1,
	2,
	3
}
local tbB = {
	4,
	5,
	6
}
local _len_0 = #tbA + 1
for _index_0 = 1, #tbB do
	local _elm_0 = tbB[_index_0]
	tbA[_len_0], _len_0 = _elm_0, _len_0 + 1
end
local parts = {
	"shoulders",
	"knees"
}
local lyrics
do
	local _tab_0 = {
		"head"
	}
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(parts) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0[#_tab_0 + 1] = "and"
	_tab_0[#_tab_0 + 1] = "toes"
	lyrics = _tab_0
end
local copy
do
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(other) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	copy = _tab_0
end
local a = {
	1,
	2,
	3,
	x = 1
}
local b = {
	4,
	5,
	y = 1
}
local merge
local _tab_0 = { }
local _idx_0 = 1
for _key_0, _value_0 in pairs(a) do
	if _idx_0 == _key_0 then
		_tab_0[#_tab_0 + 1] = _value_0
		_idx_0 = _idx_0 + 1
	else
		_tab_0[_key_0] = _value_0
	end
end
local _idx_1 = 1
for _key_0, _value_0 in pairs(b) do
	if _idx_1 == _key_0 then
		_tab_0[#_tab_0 + 1] = _value_0
		_idx_1 = _idx_1 + 1
	else
		_tab_0[_key_0] = _value_0
	end
end
merge = _tab_0
local source = {
	1,
	2,
	3,
	name = "Yue"
}
local fullCopy
do
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(source) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	fullCopy = _tab_0
end
local listCopy
local _tab_0 = { }
local _idx_0 = #_tab_0 + 1
for _index_0 = 1, #source do
	local _value_0 = source[_index_0]
	_tab_0[_idx_0] = _value_0
	_idx_0 = _idx_0 + 1
end
listCopy = _tab_0
local last
do
	local _item_0 = data.items
	last = _item_0[#_item_0]
end
local second_last
do
	local _item_0 = data.items
	second_last = _item_0[#_item_0 - 1]
end
local _obj_0 = data.items
_obj_0[#_obj_0] = 1
local mt = { }
local add
add = function(self, right)
	return setmetatable({
		value = self.value + right.value
	}, mt)
end
mt.__add = add
local a = setmetatable({
	value = 1
}, mt)
local b = setmetatable({
	value = 2
}, {
	__add = add
})
local c = setmetatable({
	value = 3
}, {
	__add = mt.__add
})
local d = a + b + c
print(d.value)
local _ <close> = setmetatable({ }, {
	__close = function()
		return print("fora do escopo")
	end
})
local tb = setmetatable({ }, {
	["value"] = 123
})
getmetatable(tb).__index = getmetatable(tb)
print(tb.value)
setmetatable(tb, {
	__index = {
		item = "hello"
	}
})
print(tb.item)
local item, new, close, getter
do
	local _obj_0 = tb
	item, new = _obj_0[1], _obj_0.new
	do
		local _obj_1 = getmetatable(_obj_0)
		close, getter = _obj_1.__close, _obj_1.__index
	end
end
print(item, new, close, getter)
do
	local _obj_0 = func
	if _obj_0 ~= nil then
		_obj_0()
	end
end
print((function()
	local _obj_0 = abc
	if _obj_0 ~= nil then
		local _obj_1 = _obj_0["hello world"]
		if _obj_1 ~= nil then
			return _obj_1.xyz
		end
		return nil
	end
	return nil
end)())
local x
do
	local _obj_0 = tab
	if _obj_0 ~= nil then
		x = _obj_0.value
	end
end
local len = (function()
	local _obj_0 = utf8
	if _obj_0 ~= nil then
		return _obj_0.len
	end
	return nil
end)() or (function()
	local _obj_0 = string
	if _obj_0 ~= nil then
		return _obj_0.len
	end
	return nil
end)() or function(o)
	return #o
end
if print and (x ~= nil) then
	print(x)
end
local _with_0 = io.open("test.txt", "w")
if _with_0 ~= nil then
	_with_0:write("hello")
	_with_0:close()
end
print("hello")
print(1, 2)
print(1, 2, 3)
print(render(emit(parse(extract(readFile("example.txt"), language, { }), language))))
local a, b, c, d
if b ~= nil then
	a = b
else
	if c ~= nil then
		a = c
	else
		a = d
	end
end
func((function()
	if a ~= nil then
		return a
	else
		return { }
	end
end)())
if a == nil then
	a = false
end
local list = {
	1,
	2,
	3
}
func({
	1,
	2,
	3
})
local f
f = function()
	return {
		1,
		2,
		3
	}
end
local tb = {
	name = "abc",
	values = {
		"a",
		"b",
		"c"
	},
	objects = {
		{
			name = "a",
			value = 1,
			func = function(self)
				return self.value + 1
			end,
			tb = {
				fieldA = 1
			}
		},
		{
			name = "b",
			value = 2,
			func = function(self)
				return self.value + 2
			end,
			tb = { }
		}
	}
}
if tb ~= nil then
	tb:func()
end
if tb ~= nil then
	tb:func()
end
print(1 < 2 and 2 <= 2 and 2 < 3 and 3 == 3 and 3 > 2 and 2 >= 1 and 1 == 1 and 1 < 3 and 3 ~= 5)
local a = 5
print(1 <= a and a <= 10)
local v
v = function(x)
	print(x)
	return x
end
print((function()
	local _cond_0 = v(2)
	if not (v(1) < _cond_0) then
		return false
	else
		return _cond_0 <= v(3)
	end
end)())
print((function()
	local _cond_0 = v(2)
	if not (v(1) > _cond_0) then
		return false
	else
		return _cond_0 <= v(3)
	end
end)())
local tab = { }
tab[#tab + 1] = "Value"
local tbA = {
	1,
	2,
	3
}
local tbB = {
	4,
	5,
	6
}
local _len_0 = #tbA + 1
for _index_0 = 1, #tbB do
	local _elm_0 = tbB[_index_0]
	tbA[_len_0], _len_0 = _elm_0, _len_0 + 1
end
local parts = {
	"shoulders",
	"knees"
}
local lyrics
do
	local _tab_0 = {
		"head"
	}
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(parts) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	_tab_0[#_tab_0 + 1] = "and"
	_tab_0[#_tab_0 + 1] = "toes"
	lyrics = _tab_0
end
local copy
do
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(other) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	copy = _tab_0
end
local a = {
	1,
	2,
	3,
	x = 1
}
local b = {
	4,
	5,
	y = 1
}
local merge
local _tab_0 = { }
local _idx_0 = 1
for _key_0, _value_0 in pairs(a) do
	if _idx_0 == _key_0 then
		_tab_0[#_tab_0 + 1] = _value_0
		_idx_0 = _idx_0 + 1
	else
		_tab_0[_key_0] = _value_0
	end
end
local _idx_1 = 1
for _key_0, _value_0 in pairs(b) do
	if _idx_1 == _key_0 then
		_tab_0[#_tab_0 + 1] = _value_0
		_idx_1 = _idx_1 + 1
	else
		_tab_0[_key_0] = _value_0
	end
end
merge = _tab_0
local source = {
	1,
	2,
	3,
	name = "Yue"
}
local fullCopy
do
	local _tab_0 = { }
	local _idx_0 = 1
	for _key_0, _value_0 in pairs(source) do
		if _idx_0 == _key_0 then
			_tab_0[#_tab_0 + 1] = _value_0
			_idx_0 = _idx_0 + 1
		else
			_tab_0[_key_0] = _value_0
		end
	end
	fullCopy = _tab_0
end
local listCopy
local _tab_0 = { }
local _idx_0 = #_tab_0 + 1
for _index_0 = 1, #source do
	local _value_0 = source[_index_0]
	_tab_0[_idx_0] = _value_0
	_idx_0 = _idx_0 + 1
end
listCopy = _tab_0
local last
do
	local _item_0 = data.items
	last = _item_0[#_item_0]
end
local second_last
do
	local _item_0 = data.items
	second_last = _item_0[#_item_0 - 1]
end
local _obj_0 = data.items
_obj_0[#_obj_0] = 1
local mt = { }
local add
add = function(self, right)
	return setmetatable({
		value = self.value + right.value
	}, mt)
end
mt.__add = add
local a = setmetatable({
	value = 1
}, mt)
local b = setmetatable({
	value = 2
}, {
	__add = add
})
local c = setmetatable({
	value = 3
}, {
	__add = mt.__add
})
local d = a + b + c
print(d.value)
local _ <close> = setmetatable({ }, {
	__close = function()
		return print("fora do escopo")
	end
})
local tb = setmetatable({ }, {
	["value"] = 123
})
getmetatable(tb).__index = getmetatable(tb)
print(tb.value)
setmetatable(tb, {
	__index = {
		item = "hello"
	}
})
print(tb.item)
local item, new, close, getter
do
	local _obj_0 = tb
	item, new = _obj_0[1], _obj_0.new
	do
		local _obj_1 = getmetatable(_obj_0)
		close, getter = _obj_1.__close, _obj_1.__index
	end
end
print(item, new, close, getter)
do
	local _obj_0 = func
	if _obj_0 ~= nil then
		_obj_0()
	end
end
print((function()
	local _obj_0 = abc
	if _obj_0 ~= nil then
		local _obj_1 = _obj_0["hello world"]
		if _obj_1 ~= nil then
			return _obj_1.xyz
		end
		return nil
	end
	return nil
end)())
local x
do
	local _obj_0 = tab
	if _obj_0 ~= nil then
		x = _obj_0.value
	end
end
local len = (function()
	local _obj_0 = utf8
	if _obj_0 ~= nil then
		return _obj_0.len
	end
	return nil
end)() or (function()
	local _obj_0 = string
	if _obj_0 ~= nil then
		return _obj_0.len
	end
	return nil
end)() or function(o)
	return #o
end
if print and (x ~= nil) then
	print(x)
end
local _with_0 = io.open("test.txt", "w")
if _with_0 ~= nil then
	_with_0:write("hello")
	_with_0:close()
end
print("hello")
print(1, 2)
print(1, 2, 3)
print(render(emit(parse(extract(readFile("example.txt"), language, { }), language))))
local a, b, c, d
if b ~= nil then
	a = b
else
	if c ~= nil then
		a = c
	else
		a = d
	end
end
func((function()
	if a ~= nil then
		return a
	else
		return { }
	end
end)())
if a == nil then
	a = false
end
local list = {
	1,
	2,
	3
}
func({
	1,
	2,
	3
})
local f
f = function()
	return {
		1,
		2,
		3
	}
end
local tb = {
	name = "abc",
	values = {
		"a",
		"b",
		"c"
	},
	objects = {
		{
			name = "a",
			value = 1,
			func = function(self)
				return self.value + 1
			end,
			tb = {
				fieldA = 1
			}
		},
		{
			name = "b",
			value = 2,
			func = function(self)
				return self.value + 2
			end,
			tb = { }
		}
	}
}
local some_string = "Aqui está uma string\n  que tem uma quebra de linha."
print("Tenho " .. tostring(math.random() * 100) .. "% de certeza.")
local integer = 1000000
local hex = 0xEFBBBF
local binary = 19
local str = "key: value\nlist:\n  - item1\n  - " .. tostring(expr)
local fn
fn = function()
	local str = "foo:\n  bar: baz"
	return str
end
local str = "path: \"C:\\Program Files\\App\"\nnote: 'Ele disse: \"" .. tostring(Hello) .. "!\"'"
local some_string = "Aqui está uma string\n  que tem uma quebra de linha."
print("Tenho " .. tostring(math.random() * 100) .. "% de certeza.")
local integer = 1000000
local hex = 0xEFBBBF
local binary = 19
local str = "key: value\nlist:\n  - item1\n  - " .. tostring(expr)
local fn
fn = function()
	local str = "foo:\n  bar: baz"
	return str
end
local str = "path: \"C:\\Program Files\\App\"\nnote: 'Ele disse: \"" .. tostring(Hello) .. "!\"'"
do
	local insert, concat = table.insert, table.concat
	local C, Ct, Cmt
	do
		local _obj_0 = require("lpeg")
		C, Ct, Cmt = _obj_0.C, _obj_0.Ct, _obj_0.Cmt
	end
	local x, y, z
	do
		local _obj_0 = require('mymodule')
		x, y, z = _obj_0.x, _obj_0.y, _obj_0.z
	end
	local a, b, c
	local _obj_0 = require('module')
	a, b, c = _obj_0.a, _obj_0.b, _obj_0.c
end
do
	local module = require('module')
	local module_x = require('module_x')
	local d_a_s_h_e_s = require("d-a-s-h-e-s")
	local part = require("module.part")
end
do
	local PlayerModule = require("player")
	local C, Ct, Cmt
	do
		local _obj_0 = require("lpeg")
		C, Ct, Cmt = _obj_0.C, _obj_0.Ct, _obj_0.Cmt
	end
	local one, two, ch
	local _obj_0 = require("export")
	one, two, ch = _obj_0[1], _obj_0[2], _obj_0.Something.umm[1]
end
do
	local tostring <const> = tostring
	local concat <const> = table.concat
	print(concat({
		"a",
		tostring(1)
	}))
end
do
	local print <const> = print
	local math <const> = math
	print("hello")
	math.random(3)
end
do
	local print <const> = print
	print(FLAG)
	FLAG = 123
end
local _module_0 = { }
local a, b, c = 1, 2, 3
_module_0["a"], _module_0["b"], _module_0["c"] = a, b, c
local cool = "cat"
_module_0["cool"] = cool
local What
if this then
	What = "abc"
else
	What = "def"
end
_module_0["What"] = What
local y
y = function()
	local hallo = 3434
end
_module_0["y"] = y
local Something
local _class_0
local _base_0 = {
	umm = "cool"
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "Something"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Something = _class_0
_module_0["Something"] = Something
return _module_0
local _module_0 = { }
local loadstring, tolua
do
	local _obj_0 = yue
	loadstring, tolua = _obj_0.loadstring, _obj_0.to_lua
end
_module_0["loadstring"], _module_0["tolua"] = loadstring, tolua
local fieldA = tb.itemA.fieldA
if fieldA == nil then
	fieldA = 'default'
end
_module_0["fieldA"] = fieldA
return _module_0
local _module_0 = setmetatable({ }, { })
_module_0.itemA = tb
getmetatable(_module_0).__index = items
_module_0["a-b-c"] = 123
return _module_0
local _module_0 = { }
local d, e, f = 3, 2, 1
_module_0[#_module_0 + 1] = d
_module_0[#_module_0 + 1] = e
_module_0[#_module_0 + 1] = f
if this then
	_module_0[#_module_0 + 1] = 123
else
	_module_0[#_module_0 + 1] = 456
end
local _with_0 = tmp
local j = 2000
_module_0[#_module_0 + 1] = _with_0
return _module_0
local _module_0 = nil
_module_0 = function()
	print("hello")
	return 123
end
return _module_0
do
	local insert, concat = table.insert, table.concat
	local C, Ct, Cmt
	do
		local _obj_0 = require("lpeg")
		C, Ct, Cmt = _obj_0.C, _obj_0.Ct, _obj_0.Cmt
	end
	local x, y, z
	do
		local _obj_0 = require('mymodule')
		x, y, z = _obj_0.x, _obj_0.y, _obj_0.z
	end
	local a, b, c
	local _obj_0 = require('module')
	a, b, c = _obj_0.a, _obj_0.b, _obj_0.c
end
do
	local module = require('module')
	local module_x = require('module_x')
	local d_a_s_h_e_s = require("d-a-s-h-e-s")
	local part = require("module.part")
end
do
	local PlayerModule = require("player")
	local C, Ct, Cmt
	do
		local _obj_0 = require("lpeg")
		C, Ct, Cmt = _obj_0.C, _obj_0.Ct, _obj_0.Cmt
	end
	local one, two, ch
	local _obj_0 = require("export")
	one, two, ch = _obj_0[1], _obj_0[2], _obj_0.Something.umm[1]
end
do
	local tostring <const> = tostring
	local concat <const> = table.concat
	print(concat({
		"a",
		tostring(1)
	}))
end
do
	local print <const> = print
	local math <const> = math
	print("hello")
	math.random(3)
end
do
	local print <const> = print
	print(FLAG)
	FLAG = 123
end
local _module_0 = { }
local a, b, c = 1, 2, 3
_module_0["a"], _module_0["b"], _module_0["c"] = a, b, c
local cool = "cat"
_module_0["cool"] = cool
local What
if this then
	What = "abc"
else
	What = "def"
end
_module_0["What"] = What
local y
y = function()
	local hallo = 3434
end
_module_0["y"] = y
local Something
local _class_0
local _base_0 = {
	umm = "cool"
}
if _base_0.__index == nil then
	_base_0.__index = _base_0
end
_class_0 = setmetatable({
	__init = function() end,
	__base = _base_0,
	__name = "Something"
}, {
	__index = _base_0,
	__call = function(cls, ...)
		local _self_0 = setmetatable({ }, _base_0)
		cls.__init(_self_0, ...)
		return _self_0
	end
})
_base_0.__class = _class_0
Something = _class_0
_module_0["Something"] = Something
return _module_0
local _module_0 = { }
local loadstring, tolua
do
	local _obj_0 = yue
	loadstring, tolua = _obj_0.loadstring, _obj_0.to_lua
end
_module_0["loadstring"], _module_0["tolua"] = loadstring, tolua
local fieldA = tb.itemA.fieldA
if fieldA == nil then
	fieldA = 'default'
end
_module_0["fieldA"] = fieldA
return _module_0
local _module_0 = setmetatable({ }, { })
_module_0.itemA = tb
getmetatable(_module_0).__index = items
_module_0["a-b-c"] = 123
return _module_0
local _module_0 = { }
local d, e, f = 3, 2, 1
_module_0[#_module_0 + 1] = d
_module_0[#_module_0 + 1] = e
_module_0[#_module_0 + 1] = f
if this then
	_module_0[#_module_0 + 1] = 123
else
	_module_0[#_module_0 + 1] = 456
end
local _with_0 = tmp
local j = 2000
_module_0[#_module_0 + 1] = _with_0
return _module_0
local _module_0 = nil
_module_0 = function()
	print("hello")
	return 123
end
return _module_0
