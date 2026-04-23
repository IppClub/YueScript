local files = {
	"spec/inputs/import_global.yue",
	"spec/inputs/nil_coalesce_precedence.yue",
	"spec/inputs/macro_export.yue",
	"spec/inputs/props.yue",
	"spec/inputs/attrib.yue",
	"spec/inputs/upvalue_func.yue",
	"spec/inputs/macro.yue",
	"spec/inputs/export_mixed.yue",
	"spec/inputs/using.yue",
	"spec/inputs/whitespace.yue",
	"spec/inputs/nil_coalescing.yue",
	"spec/inputs/stub.yue",
	"spec/inputs/pipe.yue",
	"spec/inputs/teal_lang.yue",
	"spec/inputs/string.yue",
	"spec/inputs/local.yue",
	"spec/inputs/tables.yue",
	"spec/inputs/pipe_chain_combo.yue",
	"spec/inputs/operators.yue",
	"spec/inputs/lists.yue",
	"spec/inputs/compile_doc.yue",
	"spec/inputs/switch.yue",
	"spec/inputs/multiline_chain.yue",
	"spec/inputs/existential.yue",
	"spec/inputs/export_default.yue",
	"spec/inputs/with_scope_shadow.yue",
	"spec/inputs/assign.yue",
	"spec/inputs/annotation.yue",
	"spec/inputs/annotation_before.yue",
	"spec/inputs/literals.yue",
	"spec/inputs/luarocks_upload.yue",
	"spec/inputs/comprehension_nested.yue",
	"spec/inputs/ambiguous.yue",
	"spec/inputs/bubbling.yue",
	"spec/inputs/try_catch.yue",
	"spec/inputs/funcs.yue",
	"spec/inputs/do.yue",
	"spec/inputs/with.yue",
	"spec/inputs/export.yue",
	"spec/inputs/macro_todo.yue",
	"spec/inputs/backcall.yue",
	"spec/inputs/cond.yue",
	"spec/inputs/in_expression.yue",
	"spec/inputs/comprehension.yue",
	"spec/inputs/macro_teal.yue",
	"spec/inputs/import.yue",
	"spec/inputs/unless_else.yue",
	"spec/inputs/destructure.yue",
	"spec/inputs/return.yue",
	"spec/inputs/loops.yue",
	"spec/inputs/class.yue",
	"spec/inputs/vararg.yue",
	"spec/inputs/destructure_defaults.yue",
	"spec/inputs/goto.yue",
	"spec/inputs/metatable.yue",
	"spec/inputs/syntax.yue",
	"spec/inputs/global.yue",
	"spec/inputs/plus.yue",
	"spec/inputs/test/string_interpolation_spec.yue",
	"spec/inputs/test/with_spec.yue",
	"spec/inputs/test/try_catch_spec.yue",
	"spec/inputs/test/operator_advanced_spec.yue",
	"spec/inputs/test/with_statement_spec.yue",
	"spec/inputs/test/literals_spec.yue",
	"spec/inputs/test/continue_spec.yue",
	"spec/inputs/test/varargs_assignment_spec.yue",
	"spec/inputs/test/advanced_macro_spec.yue",
	"spec/inputs/test/annotation_spec.yue",
	"spec/inputs/test/pipe_spec.yue",
	"spec/inputs/test/export_spec.yue",
	"spec/inputs/test/existential_spec.yue",
	"spec/inputs/test/metatable_spec.yue",
	"spec/inputs/test/multiline_args_spec.yue",
	"spec/inputs/test/format_spec.yue",
	"spec/inputs/test/do_statement_spec.yue",
	"spec/inputs/test/class_spec.yue",
	"spec/inputs/test/stub_spec.yue",
	"spec/inputs/test/whitespace_spec.yue",
	"spec/inputs/test/in_expression_spec.yue",
	"spec/inputs/test/param_destructure_spec.yue",
	"spec/inputs/test/operators_spec.yue",
	"spec/inputs/test/comprehension_spec.yue",
	"spec/inputs/test/attrib_spec.yue",
	"spec/inputs/test/using_spec.yue",
	"spec/inputs/test/nil_coalescing_spec.yue",
	"spec/inputs/test/table_comprehension_spec.yue",
	"spec/inputs/test/slicing_spec.yue",
	"spec/inputs/test/close_attribute_spec.yue",
	"spec/inputs/test/named_varargs_spec.yue",
	"spec/inputs/test/export_import_interactions_spec.yue",
	"spec/inputs/test/table_spreading_spec.yue",
	"spec/inputs/test/macro_spec.yue",
	"spec/inputs/test/chaining_comparison_spec.yue",
	"spec/inputs/test/table_append_spec.yue",
	"spec/inputs/test/destructure_spec.yue",
	"spec/inputs/test/vararg_spec.yue",
	"spec/inputs/test/string_spec.yue",
	"spec/inputs/test/anonymous_class_spec.yue",
	"spec/inputs/test/implicit_object_spec.yue",
	"spec/inputs/test/constructor_promotion_spec.yue",
	"spec/inputs/test/backcall_spec.yue",
	"spec/inputs/test/while_assignment_spec.yue",
	"spec/inputs/test/switch_spec.yue",
	"spec/inputs/test/class_expression_spec.yue",
	"spec/inputs/test/functions_advanced_spec.yue",
	"spec/inputs/test/config_spec.yue",
	"spec/inputs/test/yaml_string_spec.yue",
	"spec/inputs/test/const_attribute_spec.yue",
	"spec/inputs/test/cond_spec.yue",
	"spec/inputs/test/import_spec.yue",
	"spec/inputs/test/reverse_index_spec.yue",
	"spec/inputs/test/prefixed_return_spec.yue",
	"spec/inputs/test/goto_spec.yue",
	"spec/inputs/test/return_spec.yue",
	"spec/inputs/test/loops_spec.yue",
	"spec/inputs/test/if_assignment_spec.yue",
	"spec/inputs/test/tables_advanced_spec.yue",
	"spec/inputs/test/break_multiple_values_spec.yue",
	"spec/inputs/unicode/macro_export.yue",
	"spec/inputs/unicode/attrib.yue",
	"spec/inputs/unicode/macro.yue",
	"spec/inputs/unicode/using.yue",
	"spec/inputs/unicode/whitespace.yue",
	"spec/inputs/unicode/nil_coalescing.yue",
	"spec/inputs/unicode/stub.yue",
	"spec/inputs/unicode/pipe.yue",
	"spec/inputs/unicode/string.yue",
	"spec/inputs/unicode/local.yue",
	"spec/inputs/unicode/tables.yue",
	"spec/inputs/unicode/pipe_chain_combo.yue",
	"spec/inputs/unicode/operators.yue",
	"spec/inputs/unicode/lists.yue",
	"spec/inputs/unicode/switch.yue",
	"spec/inputs/unicode/multiline_chain.yue",
	"spec/inputs/unicode/existential.yue",
	"spec/inputs/unicode/export_default.yue",
	"spec/inputs/unicode/assign.yue",
	"spec/inputs/unicode/literals.yue",
	"spec/inputs/unicode/ambiguous.yue",
	"spec/inputs/unicode/bubbling.yue",
	"spec/inputs/unicode/try_catch.yue",
	"spec/inputs/unicode/funcs.yue",
	"spec/inputs/unicode/do.yue",
	"spec/inputs/unicode/with.yue",
	"spec/inputs/unicode/export.yue",
	"spec/inputs/unicode/macro_todo.yue",
	"spec/inputs/unicode/backcall.yue",
	"spec/inputs/unicode/cond.yue",
	"spec/inputs/unicode/in_expression.yue",
	"spec/inputs/unicode/comprehension.yue",
	"spec/inputs/unicode/import.yue",
	"spec/inputs/unicode/unless_else.yue",
	"spec/inputs/unicode/destructure.yue",
	"spec/inputs/unicode/return.yue",
	"spec/inputs/unicode/loops.yue",
	"spec/inputs/unicode/class.yue",
	"spec/inputs/unicode/vararg.yue",
	"spec/inputs/unicode/goto.yue",
	"spec/inputs/unicode/metatable.yue",
	"spec/inputs/unicode/syntax.yue",
	"spec/inputs/unicode/global.yue",
	"spec/inputs/unicode/plus.yue"
}
local yue = require("yue")
local rewriteLineCol
rewriteLineCol = function(item)
	item[2] = 0
	item[3] = 0
	item[4] = 0
	item[5] = 0
	for i = 6, #item do
		local _exp_0 = type(item[i])
		if "table" == _exp_0 then
			if item[i][1] == "comment" then
				table.remove(item, i)
				rewriteLineCol(item)
				return
			end
			rewriteLineCol(item[i])
		end
	end
end
return describe("format", function()
	for _index_0 = 1, #files do
		local file = files[_index_0]
		it(file, function()
			local f = io.open(file)
			local code = f:read("a*")
			f:close()
			local original_ast, err = yue.to_ast(code)
			assert.is_nil(err)
			assert.is_not_nil(original_ast)
			rewriteLineCol(original_ast)
			local formated = yue.format(code, 0, true)
			local ast
			ast, err = yue.to_ast(formated)
			assert.is_nil(err)
			assert.is_not_nil(ast)
			rewriteLineCol(ast)
			return assert.same(original_ast, ast)
		end)
	end
end)
