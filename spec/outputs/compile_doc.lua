local outputFolder = ...
local getFiles
getFiles = function(locale)
	if locale == "en" then
		locale = ""
	else
		locale = tostring(locale) .. "/"
	end
	return {
		"doc/src/content/docs/" .. tostring(locale) .. "doc/index.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/advanced/do.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/advanced/line-decorators.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/advanced/macro.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/advanced/try.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/data-structures/table-literals.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/data-structures/comprehensions.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/objects/object-oriented-programming.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/objects/with-statement.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/assignment/assignment.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/assignment/varargs-assignment.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/assignment/if-assignment.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/assignment/destructuring-assignment.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/assignment/the-using-clause-controlling-destructive-assignment.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/getting-started/usage.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/getting-started/introduction.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/getting-started/installation.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/control-flow/conditionals.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/control-flow/for-loop.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/control-flow/continue.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/control-flow/switch.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/control-flow/while-loop.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/functions/function-stubs.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/functions/backcalls.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/functions/function-literals.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/language-basics/whitespace.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/language-basics/comment.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/language-basics/attributes.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/language-basics/operator.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/language-basics/literals.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/language-basics/module.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/extras/license-mit.md",
		"doc/src/content/docs/" .. tostring(locale) .. "doc/advanced/the-yuescript-library.md"
	}
end
local docs
do
	local _accum_0 = { }
	local _len_0 = 1
	local _list_0 = {
		"en",
		"zh",
		"pt-br",
		"de",
		"id-id"
	}
	for _index_0 = 1, #_list_0 do
		local locale = _list_0[_index_0]
		_accum_0[_len_0] = {
			"codes_from_doc_" .. tostring(locale) .. ".lua",
			getFiles(locale)
		}
		_len_0 = _len_0 + 1
	end
	docs = _accum_0
end
for _index_0 = 1, #docs do
	local _des_0 = docs[_index_0]
	local compiledFile, docFiles = _des_0[1], _des_0[2]
	local codes = { }
	for _index_1 = 1, #docFiles do
		local docFile = docFiles[_index_1]
		local input
		local _with_0 = io.open(docFile)
		if _with_0 ~= nil then
			local to_lua = require("yue").to_lua
			local text = _with_0:read("*a")
			for code in text:gmatch("```yuescript[\r\n]+(.-)```[^%w]") do
				local result, err = to_lua(code, {
					implicit_return_root = false,
					reserve_line_number = false
				})
				if result then
					codes[#codes + 1] = result
				elseif not err:match("macro exporting module only accepts macro definition") then
					print(err)
					os.exit(1)
				end
			end
			for code in text:gmatch("```yue[\r\n]+(.-)```[^%w]") do
				local result, err = to_lua(code, {
					implicit_return_root = false,
					reserve_line_number = false
				})
				if result then
					codes[#codes + 1] = result
				else
					print(err)
					os.exit(1)
				end
			end
		end
		input = _with_0
		local _close_0 <close> = input
	end
	local output
	local _with_0 = io.open(tostring(outputFolder) .. "/" .. tostring(compiledFile), "w+")
	_with_0:write(table.concat(codes))
	output = _with_0
	local _close_0 <close> = output
end
