xpcall(_u51fd_u6570, function(_u9519_u8bef)
	return _u6253_u5370(_u9519_u8bef)
end, 1, 2, 3)
xpcall(_u51fd_u6570, function(_u9519_u8bef)
	return _u6253_u5370(_u9519_u8bef)
end, 1, 2, 3)
pcall(function()
	_u6253_u5370("正在try")
	return _u51fd_u6570(1, 2, 3)
end)
do
	local _u6210_u529f, _u7ed3_u679c = xpcall(_u51fd_u6570, function(_u9519_u8bef)
		return _u6253_u5370(_u9519_u8bef)
	end, 1, 2, 3)
	_u6210_u529f, _u7ed3_u679c = pcall(_u51fd_u6570, 1, 2, 3)
end
pcall(function()
	return _u8868["函数"]
end)
pcall(function()
	return _u8868["函数"]()
end)
pcall(function()
	return _u8868["函数"]()
end)
pcall(function()
	return _u8868["函数"]()
end)
pcall(function()
	local _call_0 = _u8868
	return _call_0["函数"](_call_0, 1, 2, 3)
end)
pcall(function()
	return _u8868["函数"](1)
end)
pcall(function()
	return _u8868["函数"](1)
end)
if (xpcall(_u51fd_u6570, function(_u9519_u8bef)
	return _u6253_u5370(_u9519_u8bef)
end, 1)) then
	_u6253_u5370("好的")
end
if xpcall((_u51fd_u6570), function(_u9519_u8bef)
	return _u6253_u5370(_u9519_u8bef)
end, 1) then
	_u6253_u5370("好的")
end
do
	do
		local _u6210_u529f, _u7ed3_u679c = pcall(_u51fd_u6570, "abc", 123)
		if _u6210_u529f then
			_u6253_u5370(_u7ed3_u679c)
		end
	end
	local _u6210_u529f, _u7ed3_u679c = xpcall(_u51fd_u6570, function(_u9519_u8bef)
		return _u6253_u5370(_u9519_u8bef)
	end, "abc", 123)
	_u6210_u529f, _u7ed3_u679c = xpcall(_u51fd_u6570, function(_u9519_u8bef)
		return _u6253_u5370(_u9519_u8bef)
	end, "abc", 123)
	if _u6210_u529f then
		_u6253_u5370(_u7ed3_u679c)
	end
end
do
	pcall(_u51fd_u6570, 1, 2, 3)
	pcall(_u51fd_u6570, 1, 2, 3)
end
return nil
