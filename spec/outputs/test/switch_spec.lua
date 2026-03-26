return describe("switch", function()
	it("should match single value", function()
		local value = "cool"
		local result
		if "cool" == value then
			result = "matched"
		else
			result = "not matched"
		end
		return assert.same(result, "matched")
	end)
	it("should match multiple values with or", function()
		local hi = "world"
		local matched = false
		if "one" == hi or "two" == hi then
			matched = true
		end
		assert.is_false(matched)
		hi = "one"
		if "one" == hi or "two" == hi then
			matched = true
		end
		return assert.is_true(matched)
	end)
	it("should execute else branch when no match", function()
		local value = "other"
		local result
		if "cool" == value then
			result = "matched cool"
		elseif "yeah" == value then
			result = "matched yeah"
		else
			result = "else branch"
		end
		return assert.same(result, "else branch")
	end)
	it("should destructure table with single key", function()
		local tb = {
			x = 100
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local x = tb.x
				if x ~= nil then
					_match_0 = true
					result = x
				end
			end
			if not _match_0 then
				result = "no match"
			end
		end
		return assert.same(result, 100)
	end)
	it("should destructure table with multiple keys", function()
		local tb = {
			x = 100,
			y = 200
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local x = tb.x
				local y = tb.y
				if x ~= nil and y ~= nil then
					_match_0 = true
					result = x + y
				end
			end
			if not _match_0 then
				result = "no match"
			end
		end
		return assert.same(result, 300)
	end)
	it("should destructure table with default values", function()
		local tb = {
			a = 1
		}
		local _type_0 = type(tb)
		local _tab_0 = "table" == _type_0 or "userdata" == _type_0
		if _tab_0 then
			local a = tb.a
			local b = tb.b
			if a == nil then
				a = 1
			end
			if b == nil then
				b = 2
			end
			assert.same(a, 1)
			return assert.same(b, 2)
		end
	end)
	it("should destructure nested tables", function()
		local dict = {
			{ },
			{
				1,
				2,
				3
			},
			a = {
				b = {
					c = 1
				}
			},
			x = {
				y = {
					z = 1
				}
			}
		}
		local matched = false
		do
			local _type_0 = type(dict)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			if _tab_0 then
				local first = dict[1]
				local one
				do
					local _obj_0 = dict[2]
					local _type_1 = type(_obj_0)
					if "table" == _type_1 or "userdata" == _type_1 then
						one = _obj_0[1]
					end
				end
				local two
				do
					local _obj_0 = dict[2]
					local _type_1 = type(_obj_0)
					if "table" == _type_1 or "userdata" == _type_1 then
						two = _obj_0[2]
					end
				end
				local three
				do
					local _obj_0 = dict[2]
					local _type_1 = type(_obj_0)
					if "table" == _type_1 or "userdata" == _type_1 then
						three = _obj_0[3]
					end
				end
				local c
				do
					local _obj_0 = dict.a
					local _type_1 = type(_obj_0)
					if "table" == _type_1 or "userdata" == _type_1 then
						do
							local _obj_1 = _obj_0.b
							local _type_2 = type(_obj_1)
							if "table" == _type_2 or "userdata" == _type_2 then
								c = _obj_1.c
							end
						end
					end
				end
				local z
				do
					local _obj_0 = dict.x
					local _type_1 = type(_obj_0)
					if "table" == _type_1 or "userdata" == _type_1 then
						do
							local _obj_1 = _obj_0.y
							local _type_2 = type(_obj_1)
							if "table" == _type_2 or "userdata" == _type_2 then
								z = _obj_1.z
							end
						end
					end
				end
				if first ~= nil and one ~= nil and two ~= nil and three ~= nil and c ~= nil and z ~= nil then
					matched = type(first) == 'table' and one == 1 and two == 2 and three == 3 and c == 1 and z == 1
				end
			end
		end
		return assert.is_true(matched)
	end)
	it("should destructure arrays with exact match", function()
		local tb = {
			1,
			2,
			3
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if 1 == tb[1] and 2 == tb[2] and 3 == tb[3] then
					_match_0 = true
					result = "exact match"
				end
			end
			if not _match_0 then
				result = "no match"
			end
		end
		return assert.same(result, "exact match")
	end)
	it("should destructure arrays with variables", function()
		local tb = {
			1,
			"b",
			3
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local b = tb[2]
				if 1 == tb[1] and b ~= nil and 3 == tb[3] then
					_match_0 = true
					result = b
				end
			end
			if not _match_0 then
				result = "no match"
			end
		end
		return assert.same(result, "b")
	end)
	it("should destructure arrays with defaults", function()
		local tb = {
			1,
			2
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local b = tb[3]
				if b == nil then
					b = 3
				end
				if 1 == tb[1] and 2 == tb[2] then
					_match_0 = true
					result = b
				end
			end
			if not _match_0 then
				result = "no match"
			end
		end
		return assert.same(result, 3)
	end)
	it("should match pattern with __class", function()
		local ClassA
		do
			local _class_0
			local _base_0 = { }
			if _base_0.__index == nil then
				_base_0.__index = _base_0
			end
			_class_0 = setmetatable({
				__init = function() end,
				__base = _base_0,
				__name = "ClassA"
			}, {
				__index = _base_0,
				__call = function(cls, ...)
					local _self_0 = setmetatable({ }, _base_0)
					cls.__init(_self_0, ...)
					return _self_0
				end
			})
			_base_0.__class = _class_0
			ClassA = _class_0
		end
		local ClassB
		do
			local _class_0
			local _base_0 = { }
			if _base_0.__index == nil then
				_base_0.__index = _base_0
			end
			_class_0 = setmetatable({
				__init = function() end,
				__base = _base_0,
				__name = "ClassB"
			}, {
				__index = _base_0,
				__call = function(cls, ...)
					local _self_0 = setmetatable({ }, _base_0)
					cls.__init(_self_0, ...)
					return _self_0
				end
			})
			_base_0.__class = _class_0
			ClassB = _class_0
		end
		local item = ClassA()
		local result
		do
			local _type_0 = type(item)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				ClassA = item.__class
				if ClassA ~= nil then
					_match_0 = true
					result = "Object A"
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					ClassB = item.__class
					if ClassB ~= nil then
						_match_1 = true
						result = "Object B"
					end
				end
				if not _match_1 then
					result = "unknown"
				end
			end
		end
		return assert.same(result, "Object A")
	end)
	it("should match pattern with metatable", function()
		local tb = setmetatable({ }, {
			__mode = "v"
		})
		local metatable_matched = false
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			if _tab_0 then
				local mt = getmetatable(tb)
				if mt ~= nil then
					metatable_matched = mt ~= nil
				end
			end
		end
		return assert.is_true(metatable_matched)
	end)
	it("should use switch as expression in assignment", function()
		local tb = {
			x = "abc"
		}
		local matched
		if 1 == tb then
			matched = "1"
		else
			do
				local _type_0 = type(tb)
				local _tab_0 = "table" == _type_0 or "userdata" == _type_0
				local _match_0 = false
				if _tab_0 then
					local x = tb.x
					if x ~= nil then
						_match_0 = true
						matched = x
					end
				end
				if not _match_0 then
					if false == tb then
						matched = "false"
					else
						matched = nil
					end
				end
			end
		end
		return assert.same(matched, "abc")
	end)
	it("should use switch in return statement", function()
		local fn
		fn = function(tb)
			if nil == tb then
				return "invalid"
			else
				local _type_0 = type(tb)
				local _tab_0 = "table" == _type_0 or "userdata" == _type_0
				local _match_0 = false
				if _tab_0 then
					local a = tb.a
					local b = tb.b
					if a ~= nil and b ~= nil then
						_match_0 = true
						return tostring(a + b)
					end
				end
				if not _match_0 then
					if 1 == tb or 2 == tb or 3 == tb or 4 == tb or 5 == tb then
						return "number 1 - 5"
					else
						return "should not reach here"
					end
				end
			end
		end
		assert.same(fn({
			a = 1,
			b = 2
		}), "3")
		assert.same(fn(3), "number 1 - 5")
		return assert.same(fn(nil), "invalid")
	end)
	it("should support pattern matching assignment with :=", function()
		local v = "hello"
		local matched = false
		do
			v = "hello"
			if "hello" == v then
				matched = true
			else
				matched = false
			end
		end
		assert.is_true(matched)
		return assert.same(v, "hello")
	end)
	it("should match with computed expressions", function()
		local hi = 4
		local matched = false
		if (3 + 1) == hi or (function()
			return 4
		end)() == hi or (5 - 1) == hi then
			matched = true
		end
		return assert.is_true(matched)
	end)
	it("should handle nested array destructuring", function()
		local tb = {
			{
				a = 1,
				b = 2
			},
			{
				a = 3,
				b = 4
			},
			{
				a = 5,
				b = 6
			},
			"fourth"
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local fourth = tb[4]
				local _val_0
				do
					local _obj_0 = tb[1]
					if _obj_0 ~= nil then
						_val_0 = _obj_0.a
					end
				end
				local _val_1
				do
					local _obj_0 = tb[1]
					if _obj_0 ~= nil then
						_val_1 = _obj_0.b
					end
				end
				local _val_2
				do
					local _obj_0 = tb[2]
					if _obj_0 ~= nil then
						_val_2 = _obj_0.a
					end
				end
				local _val_3
				do
					local _obj_0 = tb[2]
					if _obj_0 ~= nil then
						_val_3 = _obj_0.b
					end
				end
				local _val_4
				do
					local _obj_0 = tb[3]
					if _obj_0 ~= nil then
						_val_4 = _obj_0.a
					end
				end
				local _val_5
				do
					local _obj_0 = tb[3]
					if _obj_0 ~= nil then
						_val_5 = _obj_0.b
					end
				end
				if 1 == _val_0 and 2 == _val_1 and 3 == _val_2 and 4 == _val_3 and 5 == _val_4 and 6 == _val_5 and fourth ~= nil then
					_match_0 = true
					result = fourth
				end
			end
			if not _match_0 then
				result = "no match"
			end
		end
		return assert.same(result, "fourth")
	end)
	it("should match combined patterns", function()
		local tb = {
			success = true,
			result = "data"
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				result = tb.result
				if true == tb.success and result ~= nil then
					_match_0 = true
					result = {
						"success",
						result
					}
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					if false == tb.success then
						_match_1 = true
						result = {
							"failed",
							result
						}
					end
				end
				if not _match_1 then
					result = {
						"invalid"
					}
				end
			end
		end
		return assert.same(result, {
			"success",
			"data"
		})
	end)
	it("should match type discriminated patterns", function()
		local tb = {
			type = "success",
			content = "data"
		}
		local result
		do
			local _type_0 = type(tb)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local content = tb.content
				if "success" == tb.type and content ~= nil then
					_match_0 = true
					result = {
						"success",
						content
					}
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					local content = tb.content
					if "error" == tb.type and content ~= nil then
						_match_1 = true
						result = {
							"error",
							content
						}
					end
				end
				if not _match_1 then
					result = {
						"invalid"
					}
				end
			end
		end
		return assert.same(result, {
			"success",
			"data"
		})
	end)
	it("should match with wildcard array capture", function()
		local clientData = {
			"Meta",
			"CUST_1001",
			"CHK123"
		}
		local metadata = nil
		local customerId = nil
		local checksum = nil
		do
			local _type_0 = type(clientData)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			if _tab_0 then
				local capturedMetadata
				do
					local _accum_0 = { }
					local _len_0 = 1
					local _max_0 = #clientData + -3 + 1
					for _index_0 = 1, _max_0 do
						local _item_0 = clientData[_index_0]
						_accum_0[_len_0] = _item_0
						_len_0 = _len_0 + 1
					end
					capturedMetadata = _accum_0
				end
				customerId = clientData[#clientData - 1]
				checksum = clientData[#clientData]
				if customerId ~= nil and checksum ~= nil then
					metadata = capturedMetadata
				end
			end
		end
		assert.same(metadata, {
			"Meta"
		})
		assert.same(customerId, "CUST_1001")
		return assert.same(checksum, "CHK123")
	end)
	it("should work with complex tuple patterns", function()
		local handlePath
		handlePath = function(segments)
			local _type_0 = type(segments)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				local resource = segments[#segments - 1]
				local action = segments[#segments]
				if resource ~= nil and action ~= nil then
					_match_0 = true
					return {
						"Resource: " .. tostring(resource),
						"Action: " .. tostring(action)
					}
				end
			end
			if not _match_0 then
				return {
					"no match"
				}
			end
		end
		local result = handlePath({
			"admin",
			"logs",
			"view"
		})
		return assert.same(result, {
			"Resource: logs",
			"Action: view"
		})
	end)
	it("should match boolean false correctly", function()
		local items = {
			{
				x = 100,
				y = 200
			},
			{
				width = 300,
				height = 400
			},
			false
		}
		local results = { }
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
					table.insert(results, "Vec2")
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					local width = item.width
					local height = item.height
					if width ~= nil and height ~= nil then
						_match_1 = true
						table.insert(results, "Size")
					end
				end
				if not _match_1 then
					if false == item then
						table.insert(results, "None")
					end
				end
			end
		end
		return assert.same(results, {
			"Vec2",
			"Size",
			"None"
		})
	end)
	it("should handle switch with then syntax", function()
		local value = "cool"
		local result
		if "cool" == value then
			result = "matched cool"
		else
			result = "else branch"
		end
		return assert.same(result, "matched cool")
	end)
	it("should handle switch in function call", function()
		local something = 1
		local getValue
		getValue = function()
			if 1 == something then
				return "yes"
			else
				return "no"
			end
		end
		return assert.same(getValue(), "yes")
	end)
	it("should match empty list pattern with []", function()
		local emptyArray = { }
		local hashTable = {
			a = 1,
			b = 2
		}
		local arrayWithElements = {
			1,
			2,
			3
		}
		local result1
		do
			local _type_0 = type(emptyArray)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if #emptyArray == 0 then
					_match_0 = true
					result1 = "empty list"
				end
			end
			if not _match_0 then
				result1 = "not empty list"
			end
		end
		assert.same(result1, "empty list")
		local result2
		do
			local _type_0 = type(hashTable)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if #hashTable == 0 then
					_match_0 = true
					result2 = "empty list"
				end
			end
			if not _match_0 then
				result2 = "not empty list"
			end
		end
		assert.same(result2, "empty list")
		local result3
		do
			local _type_0 = type(arrayWithElements)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if #arrayWithElements == 0 then
					_match_0 = true
					result3 = "empty list"
				end
			end
			if not _match_0 then
				result3 = "not empty list"
			end
		end
		return assert.same(result3, "not empty list")
	end)
	it("should match empty table pattern with {}", function()
		local emptyTable = { }
		local hashTable = {
			a = 1
		}
		local arrayTable = {
			1
		}
		local result1
		do
			local _type_0 = type(emptyTable)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if next(emptyTable) == nil then
					_match_0 = true
					result1 = "empty table"
				end
			end
			if not _match_0 then
				result1 = "not empty table"
			end
		end
		assert.same(result1, "empty table")
		local result2
		do
			local _type_0 = type(hashTable)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if next(hashTable) == nil then
					_match_0 = true
					result2 = "empty table"
				end
			end
			if not _match_0 then
				result2 = "not empty table"
			end
		end
		assert.same(result2, "not empty table")
		local result3
		do
			local _type_0 = type(arrayTable)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if next(arrayTable) == nil then
					_match_0 = true
					result3 = "empty table"
				end
			end
			if not _match_0 then
				result3 = "not empty table"
			end
		end
		return assert.same(result3, "not empty table")
	end)
	it("should distinguish between [] and {} patterns", function()
		local classify
		classify = function(x)
			local _type_0 = type(x)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if next(x) == nil then
					_match_0 = true
					return "truly empty"
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					if #x == 0 then
						_match_1 = true
						return "no array elements"
					end
				end
				if not _match_1 then
					return "has elements"
				end
			end
		end
		assert.same(classify({ }), "truly empty")
		assert.same(classify({
			a = 1
		}), "no array elements")
		return assert.same(classify({
			1,
			2
		}), "has elements")
	end)
	it("should handle empty list pattern with then syntax", function()
		local result
		do
			local _exp_0 = { }
			local _type_0 = type(_exp_0)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if #_exp_0 == 0 then
					_match_0 = true
					result = "matched"
				end
			end
			if not _match_0 then
				result = "not matched"
			end
		end
		return assert.same(result, "matched")
	end)
	it("should handle empty table pattern with then syntax", function()
		local result
		do
			local _exp_0 = { }
			local _type_0 = type(_exp_0)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if next(_exp_0) == nil then
					_match_0 = true
					result = "matched"
				end
			end
			if not _match_0 then
				result = "not matched"
			end
		end
		return assert.same(result, "matched")
	end)
	return it("should match empty patterns with multiple when branches", function()
		local emptyArray = { }
		local emptyHash = { }
		local result1
		do
			local _type_0 = type(emptyArray)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if 1 == emptyArray[1] then
					_match_0 = true
					result1 = "has 1"
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					if #emptyArray == 0 then
						_match_1 = true
						result1 = "empty list"
					end
				end
				if not _match_1 then
					result1 = "other"
				end
			end
		end
		assert.same(result1, "empty list")
		local result2
		do
			local _type_0 = type(emptyHash)
			local _tab_0 = "table" == _type_0 or "userdata" == _type_0
			local _match_0 = false
			if _tab_0 then
				if 1 == emptyHash.a then
					_match_0 = true
					result2 = "has a"
				end
			end
			if not _match_0 then
				local _match_1 = false
				if _tab_0 then
					if next(emptyHash) == nil then
						_match_1 = true
						result2 = "empty table"
					end
				end
				if not _match_1 then
					result2 = "other"
				end
			end
		end
		return assert.same(result2, "empty table")
	end)
end)
