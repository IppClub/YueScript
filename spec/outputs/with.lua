do
	local a
	a = function()
		local _with_0 = something
		print(_with_0.hello)
		print(hi)
		print("world")
		return _with_0
	end
end
do
	local _with_0 = leaf
	_with_0.world()
	_with_0.world(1, 2, 3)
	local g = _with_0.what.is.this
	_with_0.hi(1, 2, 3)
	_with_0:hi(1, 2).world(2323)
	_with_0:hi("yeah", "man")
	_with_0.world = 200
end
do
	local zyzyzy
	local _with_0 = something
	_with_0.set_state("hello world")
	zyzyzy = _with_0
end
do
	local x = 5 + (function()
		local _with_0 = Something()
		_with_0:write("hello world")
		return _with_0
	end)()
end
do
	local x = {
		hello = (function()
			local _with_0 = yeah
			_with_0:okay()
			return _with_0
		end)()
	}
end
do
	local _with_0 = foo
	local _ = _with_0:prop("something").hello
	_with_0.prop:send(one)
	_with_0.prop:send(one)
end
do
	do
		local _with_0 = a
		print(_with_0.world)
	end
	local mod
	do
		local _M = { }
		_M.Thing = "hi"
		mod = _M
	end
	do
		local a, b = something, pooh
		print(a.world)
	end
	local x
	do
		local a, b = 1, 2
		print(a + b)
		x = a
	end
	print((function()
		local a, b = 1, 2
		print(a + b)
		return a
	end)())
	local p
	local _with_0 = 1
	hello().x, world().y = _with_0, 2
	print(a + b)
	p = _with_0
end
do
	local x = "hello"
	x:upper()
end
do
	local k = "jo"
	print(k:upper())
end
do
	local a, b, c = "", "", ""
	print(a:upper())
end
do
	local a = "bunk"
	local b, c
	a, b, c = "", "", ""
	print(a:upper())
end
do
	local _with_0 = j
	print(_with_0:upper())
end
do
	local _with_0 = "jo"
	k.j = _with_0
	print(_with_0:upper())
end
do
	local _with_0 = a
	print(_with_0.b)
	local _with_1 = _with_0.c
	print(_with_1.d)
end
do
	local _with_0 = a
	local _with_1 = 2
	_with_0.b = _with_1
	print(_with_1.c)
end
do
	local _
	_ = function()
		local _with_0 = hi
		return _with_0.a, _with_0.b
	end
end
do
	local _with_0 = tb
	_with_0.x = item.field:func(123)
end
do
	local _with_0 = dad
	_with_0["if"]("yes")
	local y = _with_0["end"].of["function"]
end
do
	local _with_0 = tb
	do
		local _obj_0 = _with_0[2]
		if _obj_0 ~= nil then
			_with_0[1] = _obj_0:func()
		end
	end
	_with_0["%a-b-c%"] = 123
	_with_0[ [[x y z]]] = _with_0[var]
	print(_with_0[_with_0[3]])
	do
		local _with_1 = _with_0[4]
		_with_1[1] = 1
	end
	_with_0[#_with_0 + 1] = "abc"
	_with_0[#_with_0 + 1] = {
		type = "hello",
		{
			name = "xyz",
			value = 998
		}
	}
end
do
	do
		local _with_0 = SolidRect({
			width = w,
			height = h,
			color = 0x66000000
		})
		mask = _with_0
		if _with_0 ~= nil then
			_with_0.touchEnabled = true
			_with_0.swallowTouches = true
		end
	end
end
do
	local mask = SolidRect({
		width = w,
		height = h,
		color = 0x66000000
	})
	if mask ~= nil then
		mask.touchEnabled = true
		mask.swallowTouches = true
	end
end
do
	local f
	f = function()
		local _with_0 = { }
		return _with_0[123]
	end
end
return nil
