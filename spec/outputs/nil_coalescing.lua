do
	local a
	local _exp_0 = b
	if _exp_0 ~= nil then
		a = _exp_0
	else
		a = c
	end
end
do
	local a
	local _exp_0 = b
	if _exp_0 ~= nil then
		a = _exp_0.a
	else
		a = c.a
	end
end
do
	local a = func()
	if a == nil then
		a = false
	end
end
do
	local a
	if a == nil then
		a = func()
	end
end
do
	local a, b, c, d, e
	if b ~= nil then
		a = b
	else
		if c ~= nil then
			a = c
		else
			if d ~= nil then
				a = d
			else
				a = e
			end
		end
	end
end
do
	local a
	local _exp_0 = b
	if _exp_0 ~= nil then
		a = _exp_0
	else
		do
			local _exp_1 = c
			if _exp_1 ~= nil then
				a = _exp_1
			else
				do
					local _exp_2 = d
					if _exp_2 ~= nil then
						a = _exp_2
					else
						a = e
					end
				end
			end
		end
	end
end
do
	func((function()
		local _exp_0 = x
		if _exp_0 ~= nil then
			return _exp_0
		else
			return "hello"
		end
	end)())
end
do
	local _with_0
	local _exp_0 = funcA()
	if _exp_0 ~= nil then
		_with_0 = _exp_0
	else
		_with_0 = funcB()
	end
	print(_with_0.field)
end
do
	local a = 1 + 2 + (function()
		local _exp_0 = b
		if _exp_0 ~= nil then
			return _exp_0
		else
			return c + 3 + 4
		end
	end)()
end
do
	local a = 1 + 2 + ((function()
		local _exp_0 = b
		if _exp_0 ~= nil then
			return _exp_0
		else
			return c
		end
	end)()) + 3 + 4
end
do
	local a, b
	do
		local _obj_0 = func()
		a, b = _obj_0.a, _obj_0.b
	end
	a = a or 1
	if b == nil then
		do
			local _exp_0 = c
			if _exp_0 ~= nil then
				b = _exp_0
			else
				b = 2
			end
		end
	end
end
do
	local a
	local _exp_0 = 1
	if _exp_0 ~= nil then
		a = _exp_0
	else
		do
			local _exp_1 = 2
			if _exp_1 ~= nil then
				a = _exp_1
			else
				a = 3
			end
		end
	end
end
do
	local _obj_0 = a.b
	if _obj_0.c == nil then
		_obj_0.c = 1
	end
	local a
	do
		local _exp_0 = b.x
		if _exp_0 ~= nil then
			a = _exp_0
		else
			do
				local _exp_1 = c.x
				if _exp_1 ~= nil then
					a = _exp_1
				else
					a = d.x
				end
			end
		end
	end
	if a.c == nil then
		a.c = 1
	end
end
return nil
