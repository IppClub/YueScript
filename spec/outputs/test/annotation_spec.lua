local to_lua
do
	local _obj_0 = require("yue")
	to_lua = _obj_0.to_lua
end
local compile_and_run
compile_and_run = function(code, config)
	if config == nil then
		config = { }
	end
	local lua_code, err = to_lua(code, config)
	assert.is_nil(err)
	assert.is_not_nil(lua_code)
	local chunk, load_err = load(lua_code)
	assert.is_nil(load_err)
	assert.is_not_nil(chunk)
	return chunk()
end
return describe("annotation", function()
	it("should append generated text after annotated class by default", function()
		local code = [[macro ClsDef = (code`ClassDecl) ->
	className = code\match "^class%s+(%w+)"
	return
		type: "text"
		before: false
		code: "-- after:" .. className

$[ClsDef]
class A
	getName: => "A"

return
]]
		local result, err = to_lua(code)
		assert.is_nil(err)
		assert.is_not_nil(result)
		assert.is_true(result:find("__name = \"A\"") ~= nil)
		assert.is_true(result:find("%-%- after:A") ~= nil)
		return assert.is_true(result:find("__name = \"A\"") < result:find("%-%- after:A"))
	end)
	it("should place generated text before the annotated statement when before is true", function()
		local code = [[macro Before = (code`ClassDecl) ->
	className = code\match "^class%s+(%w+)"
	return
		type: "text"
		before: true
		code: "-- before:" .. className

$[Before]
class B
	getName: => "B"

return
]]
		local result, err = to_lua(code)
		assert.is_nil(err)
		assert.is_not_nil(result)
		assert.is_true(result:find("%-%- before:B") ~= nil)
		assert.is_true(result:find("local B") ~= nil)
		return assert.is_true(result:find("%-%- before:B") < result:find("local B"))
	end)
	it("should support annotation invocation arguments", function()
		local code = [[macro Tag = (tag, code`ClassDecl) ->
	className = code\match "^class%s+(%w+)"
	return
		type: "text"
		before: false
		code: "-- " .. tag .. ":" .. className

$[Tag("entity")]
class C
	getName: => "C"

return
]]
		local result, err = to_lua(code)
		assert.is_nil(err)
		assert.is_not_nil(result)
		return assert.is_true(result:find("%-%- \"entity\":C") ~= nil)
	end)
	it("should report an error when annotation is not followed by a statement", function()
		local code = [[macro Invalid = (code) -> ""
$[Invalid]
]]
		local result, err = to_lua(code)
		assert.is_nil(result)
		return assert.is_true(err:match("annotation must be followed by a statement") ~= nil)
	end)
	it("should wrap annotated function to validate numeric arguments", function()
		local code = [[macro ValidateNumberArgs = (code) ->
	funcName = code\match "^(%w+)%s*="
	return
		type: "text"
		before: false
		code: table.concat {
			"local __orig_#{funcName} = #{funcName}"
			"#{funcName} = function(a, b)"
			"\tassert(type(a) == \"number\", \"expected number for a\")"
			"\tassert(type(b) == \"number\", \"expected number for b\")"
			"\treturn __orig_#{funcName}(a, b)"
			"end"
		}, "\n"

$[ValidateNumberArgs]
add = (a, b) -> a + b

ok, value = pcall -> add 3, 4
bad_ok, bad_err = pcall -> add "3", 4
return ok, value, bad_ok, bad_err
]]
		local ok, value, bad_ok, bad_err = compile_and_run(code)
		assert.is_true(ok)
		assert.same(value, 7)
		assert.is_false(bad_ok)
		return assert.is_true(bad_err:match("expected number for a") ~= nil)
	end)
	it("should wrap annotated function to validate return value", function()
		local code = [[macro ValidateNumberReturn = (code) ->
	funcName = code\match "^(%w+)%s*="
	return
		type: "text"
		before: false
		code: table.concat {
			"local __orig_#{funcName} = #{funcName}"
			"#{funcName} = function(...)"
			"\tlocal result = __orig_#{funcName}(...)"
			"\tassert(type(result) == \"number\", \"expected numeric return\")"
			"\treturn result"
			"end"
		}, "\n"

$[ValidateNumberReturn]
toText = (value) -> tostring value

ok, err = pcall -> toText 42
return ok, err
]]
		local ok, err = compile_and_run(code)
		assert.is_false(ok)
		return assert.is_true(err:match("expected numeric return") ~= nil)
	end)
	return it("should use annotation arguments to register annotated classes", function()
		local code = [[macro Register = (registry, code`ClassDecl) ->
	className = code\match "^class%s+(%w+)"
	return
		type: "text"
		before: false
		code: "#{registry}[\"#{className}\"] = #{className}"

registry = {}

$[Register(registry)]
class Worker
	run: => "ok"

return registry.Worker != nil, registry.Worker!\run!
]]
		local exists, result = compile_and_run(code)
		assert.is_true(exists)
		return assert.same(result, "ok")
	end)
end)
