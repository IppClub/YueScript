local _anon_func_0 = function(items)
	local _val_0 = 3
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_1 = function(items)
	local _val_0 = 10
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_2 = function(chars)
	local _val_0 = "b"
	for _index_0 = 1, #chars do
		if chars[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_3 = function(chars)
	local _val_0 = "z"
	for _index_0 = 1, #chars do
		if chars[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_4 = function(items)
	local _val_0 = 1
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_5 = function(items)
	local _val_0 = "two"
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_6 = function(items)
	local _val_0 = true
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_7 = function(items)
	local _val_0 = false
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_8 = function(empty)
	local _val_0 = 1
	for _index_0 = 1, #empty do
		if empty[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_9 = function(empty)
	local _val_0 = "test"
	for _index_0 = 1, #empty do
		if empty[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_10 = function(items)
	local _val_0 = 2
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_11 = function(items)
	local _val_0 = 4
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_12 = function(items)
	local _val_0 = 2
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_13 = function(nested)
	local _val_0 = {
		1,
		2
	}
	for _index_0 = 1, #nested do
		if nested[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_14 = function(nested)
	local _val_0 = {
		1,
		3
	}
	for _index_0 = 1, #nested do
		if nested[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_15 = function(bools)
	local _val_0 = true
	for _index_0 = 1, #bools do
		if bools[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_16 = function(bools)
	local _val_0 = false
	for _index_0 = 1, #bools do
		if bools[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_17 = function(i, items)
	for _index_0 = 1, #items do
		if items[_index_0] == i then
			return true
		end
	end
	return false
end
local _anon_func_18 = function(key1, tb)
	for _index_0 = 1, #tb do
		if tb[_index_0] == key1 then
			return true
		end
	end
	return false
end
local _anon_func_19 = function(key2, tb)
	for _index_0 = 1, #tb do
		if tb[_index_0] == key2 then
			return true
		end
	end
	return false
end
local _anon_func_20 = function(get_items)
	local _check_0 = get_items()
	local _val_0 = 2
	for _index_0 = 1, #_check_0 do
		if _check_0[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_21 = function(get_items)
	local _check_0 = get_items()
	local _val_0 = 5
	for _index_0 = 1, #_check_0 do
		if _check_0[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_22 = function(obj)
	local _val_0 = "name"
	for _index_0 = 1, #obj do
		if obj[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_23 = function(obj)
	local _val_0 = "value"
	for _index_0 = 1, #obj do
		if obj[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_24 = function(obj)
	local _val_0 = "missing"
	for _index_0 = 1, #obj do
		if obj[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_25 = function(items)
	local _val_0 = 2
	for _index_0 = 1, #items do
		if items[_index_0] == _val_0 then
			return true
		end
	end
	return false
end
local _anon_func_26 = function(allowed, item)
	for _index_0 = 1, #allowed do
		if allowed[_index_0] == item then
			return true
		end
	end
	return false
end
return describe("in expression", function()
	it("should check value in table", function()
		local items = {
			1,
			2,
			3,
			4,
			5
		}
		assert.is_true(_anon_func_0(items))
		return assert.is_false(_anon_func_1(items))
	end)
	it("should work with strings", function()
		local chars = {
			"a",
			"b",
			"c"
		}
		assert.is_true(_anon_func_2(chars))
		return assert.is_false(_anon_func_3(chars))
	end)
	it("should check in table literal", function()
		local x = 1
		local y = 2
		local z = 3
		local w = 4
		assert.is_true((x == x or y == x or z == x))
		assert.is_true((x == y or y == y or z == y))
		return assert.is_false((x == w or y == w or z == w))
	end)
	it("should work with mixed types", function()
		local items = {
			1,
			"two",
			true,
			nil
		}
		assert.is_true(_anon_func_4(items))
		assert.is_true(_anon_func_5(items))
		assert.is_true(_anon_func_6(items))
		return assert.is_false(_anon_func_7(items))
	end)
	it("should handle empty table", function()
		local empty = { }
		assert.is_false(_anon_func_8(empty))
		return assert.is_false(_anon_func_9(empty))
	end)
	it("should work in conditional", function()
		local items = {
			1,
			2,
			3
		}
		local result
		if _anon_func_10(items) then
			result = "found"
		else
			result = "not found"
		end
		return assert.same(result, "found")
	end)
	it("should support negation", function()
		local items = {
			1,
			2,
			3
		}
		assert.is_true(not (_anon_func_11(items)))
		return assert.is_false(not (_anon_func_12(items)))
	end)
	it("should work with nested tables", function()
		local eq
		eq = function(self, other)
			return self[1] == other[1] and self[2] == other[2]
		end
		local nested = {
			setmetatable({
				1,
				2
			}, {
				__eq = eq
			}),
			setmetatable({
				3,
				4
			}, {
				__eq = eq
			}),
			setmetatable({
				5,
				6
			}, {
				__eq = eq
			})
		}
		assert.is_true(_anon_func_13(nested))
		return assert.is_false(_anon_func_14(nested))
	end)
	it("should handle boolean values", function()
		local bools = {
			true,
			false
		}
		assert.is_true(_anon_func_15(bools))
		return assert.is_true(_anon_func_16(bools))
	end)
	it("should work in loop", function()
		local items = {
			1,
			2,
			3,
			4,
			5
		}
		local count = 0
		for i = 1, 10 do
			if (#items > 0 and _anon_func_17(i, items)) then
				count = count + 1
			end
		end
		return assert.same(count, 5)
	end)
	it("should support table as value", function()
		local key1 = {
			a = 1
		}
		local key2 = {
			b = 2
		}
		local tb = {
			key1,
			key2
		}
		assert.is_true((#tb > 0 and _anon_func_18(key1, tb)))
		return assert.is_true((#tb > 0 and _anon_func_19(key2, tb)))
	end)
	it("should work with function results", function()
		local get_items
		get_items = function()
			return {
				1,
				2,
				3
			}
		end
		assert.is_true(_anon_func_20(get_items))
		return assert.is_false(_anon_func_21(get_items))
	end)
	it("should work with string keys", function()
		local obj = {
			"name",
			"value"
		}
		assert.is_true(_anon_func_22(obj))
		assert.is_true(_anon_func_23(obj))
		return assert.is_false(_anon_func_24(obj))
	end)
	it("should support complex expressions", function()
		local items = {
			1,
			2,
			3
		}
		local result = (_anon_func_25(items)) and "yes" or "no"
		return assert.same(result, "yes")
	end)
	return it("should work in comprehension", function()
		local source = {
			1,
			2,
			3,
			4,
			5
		}
		local allowed = {
			2,
			4
		}
		local result
		do
			local _accum_0 = { }
			local _len_0 = 1
			for _index_0 = 1, #source do
				local item = source[_index_0]
				if (#allowed > 0 and _anon_func_26(allowed, item)) then
					_accum_0[_len_0] = item
					_len_0 = _len_0 + 1
				end
			end
			result = _accum_0
		end
		return assert.same(result, {
			2,
			4
		})
	end)
end)
