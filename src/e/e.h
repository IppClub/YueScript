R"e_codes(
--[[
Copyright (C) 2020 by Leaf Corcoran, modified by Li Jin, 2022

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.]]

local e = select(1, ...)
local concat, insert = table.concat, table.insert
local unpack = unpack or table.unpack
e.e_compiled = { }
e.file_exist = function(fname)
	local file = io.open(fname)
	if file then
		file:close()
		return true
	else
		return false
	end
end
e.read_file = function(fname)
	local file, err = io.open(fname)
	if not file then
		return nil, err
	end
	local text = assert(file:read("*a"))
	file:close()
	return text
end
local function get_options(...)
	local count = select("#", ...)
	local opts = select(count, ...)
	if type(opts) == "table" then
		return opts, unpack({
			...
		}, nil, count - 1)
	else
		return { }, ...
	end
end
local function find_modulepath(name)
	local suffix = "." .. e.options.extension
	local dirsep = e.options.dirsep
	local name_path
	if name:match("[\\/]") then
		name_path = name:gsub("%" .. suffix .. "$", "")
	else
		name_path = name:gsub("%.", dirsep)
	end
	local file_exist, file_path
	local tried = {}
	local paths = {}
	paths[#paths + 1] = e.options.path
	paths[#paths + 1] = package.path
	for i = 1, #paths do
		local e_path = paths[i]
		for path in e_path:gmatch("[^;]+") do
			file_path = path:gsub("?", name_path):gsub("%.lua$", suffix)
			file_exist = e.file_exist(file_path)
			if file_exist then
				break
			else
				tried[#tried + 1] = file_path
			end
		end
	end
	if file_exist then
		return file_path
	else
		return nil, tried
	end
end
local e_loadstring
local function e_loader(name)
	local file_path, tried = e.find_modulepath(name)
	if file_path then
		local text = e.read_file(file_path)
		if text then
			local res, err = e_loadstring(text, file_path)
			if not res then
				error(file_path .. ": " .. err)
			end
			return res
		else
			return "no file '" .. file_path .. "'"
		end
	end
	for i = 1, #tried do
		tried[i] = "no file '" .. tried[i] .. "'"
	end
	return concat(tried, "\n\t")
end
local function e_call(f, ...)
	local args = {...}
	return xpcall(function()
		return f(unpack(args))
	end, function(err)
		return e.traceback(err, 2)
	end)
end
e_loadstring = function(...)
	local options, str, chunk_name, env = get_options(...)
	chunk_name = chunk_name or "=(e.loadstring)"
	options.module = chunk_name
	local code, err = e.to_lua(str, options)
	if not code then
		return nil, err
	end
	if chunk_name then
		e.e_compiled["@" .. chunk_name] = code
	end
	return (loadstring or load)(code, chunk_name, "t", unpack({env}))
end
local function e_loadfile(fname, ...)
	local res, err = e.read_file(fname)
	if not res then
		return nil, err
	end
	return e_loadstring(res, fname, ...)
end
local function e_dofile(...)
	local f = assert(e_loadfile(...))
	return f()
end
local function insert_loader(pos)
	if pos == nil then
		pos = 3
	end
	local loaders = package.loaders or package.searchers
	for i = 1, #loaders do
		local loader = loaders[i]
		if loader == e_loader then
			return false
		end
	end
	insert(loaders, pos, e_loader)
	return true
end
e.options.dump_locals = false
e.options.simplified = true
local load_stacktraceplus = e.load_stacktraceplus
e.load_stacktraceplus = nil
local stp
local function e_traceback(err, level)
	if not stp then
		stp = load_stacktraceplus()
	end
	stp.dump_locals = e.options.dump_locals
	stp.simplified = e.options.simplified
	return stp.stacktrace(err, level)
end
setmetatable(e, {
	__call = function(self, name)
		insert_loader()
		local success, res = xpcall(function()
			return require(name)
		end, function(err)
			return e_traceback(err, 3)
		end)
		if success then
			return res
		else
			print(res)
			return nil
		end
	end
})
local function dump(what)
	local seen = { }
	local _dump
	_dump = function(what, depth)
		depth = depth or 0
		local t = type(what)
		if "string" == t then
			return "\"" .. tostring(what) .. "\""
		elseif "table" == t then
			if seen[what] then
				return "recursion(" .. tostring(what) .. ")..."
			end
			seen[what] = true
			depth = depth + 1
			local lines = {}
			for k, v in pairs(what) do
				insert(lines, ('\t'):rep(depth) .. "[" .. tostring(k) .. "] = " .. _dump(v, depth))
			end
			seen[what] = false
			return "{\n" .. concat(lines, "\n") .. "\n" .. ('\t'):rep(depth - 1) .. "}"
		else
			return tostring(what)
		end
	end
	return _dump(what)
end
local function p(...)
	local args = {...}
	for i = 1, #args do
		args[i] = dump(args[i])
	end
	print(concat(args))
end
e.find_modulepath = find_modulepath
e.insert_loader = insert_loader
e.dofile = e_dofile
e.loadfile = e_loadfile
e.loadstring = e_loadstring
e.pcall = e_call
e.require = e_require
e.p = p
e.traceback = e_traceback
e.macro_env = setmetatable({e = e}, {
	__index = _G,
	__newindex = function(_, k, v)
		_G[k] = v
	end
})
)e_codes";
