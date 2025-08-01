/* Copyright (c) 2017-2025 Li Jin <dragon-fly@qq.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#pragma once

#include <algorithm>
#include <list>
#include <memory>
#include <optional>
#include <sstream>
#include <stack>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>

#include "yuescript/ast.hpp"
#include "yuescript/yue_ast.h"

namespace yue {
using namespace std::string_view_literals;
using namespace std::string_literals;
using namespace parserlib;
using namespace parserlib::yue;

struct ParseInfo {
	struct Error {
		std::string msg;
		int line;
		int col;
	};
	ast_ptr<false, ast_node> node;
	std::optional<Error> error;
	std::unique_ptr<input> codes;
	bool exportDefault = false;
	bool exportMacro = false;
	bool exportMetatable = false;
	std::string moduleName;
	std::unordered_set<std::string> usedNames;
	std::string errorMessage(std::string_view msg, int errLine, int errCol, int lineOffset = 0) const;
};

template <typename T>
struct identity {
	typedef T type;
};

#ifdef NDEBUG
#define NONE_AST_RULE(type) \
	rule type;

#define AST_RULE(type) \
	rule type; \
	ast<type##_t> type##_impl{collect(ast_name<type##_t>(), type)}; \
	inline rule& getRule(identity<type##_t>) { return type; }
#else // NDEBUG
#define NONE_AST_RULE(type) \
	rule type{#type, rule::initTag{}};

#define AST_RULE(type) \
	rule type{#type, rule::initTag{}}; \
	ast<type##_t> type##_impl{collect(ast_name<type##_t>(), type)}; \
	inline rule& getRule(identity<type##_t>) { return type; }
#endif // NDEBUG

extern std::unordered_set<std::string> LuaKeywords;
extern std::unordered_set<std::string> Keywords;

class YueParser {
public:
	template <class AST>
	ParseInfo parse(std::string_view codes, bool lax) {
		return parse(codes, getRule<AST>(), lax);
	}

	ParseInfo parse(std::string_view astName, std::string_view codes, bool lax);

	template <class AST>
	bool match(std::string_view codes) {
		auto rEnd = rule(getRule<AST>() >> eof());
		return parse(codes, rEnd, false).node;
	}

	bool match(std::string_view astName, std::string_view codes);

	template <class AST>
	bool startWith(std::string_view codes) {
		return startWith(codes, getRule<AST>());
	}

	std::string toString(ast_node* node);
	std::string toString(input::iterator begin, input::iterator end);

	bool hasAST(std::string_view name) const;

	static YueParser& shared();

protected:
	YueParser();
	ParseInfo parse(std::string_view codes, rule& r, bool lax);
	bool startWith(std::string_view codes, rule& r);

	struct State {
		State() {
			indents.push(0);
		}
		bool lax = false;
		bool exportDefault = false;
		bool exportMacro = false;
		bool exportMetatable = false;
		bool exportMetamethod = false;
		bool fnArrowAvailable = true;
		int exportCount = 0;
		int expLevel = 0;
		size_t stringOpen = 0;
		std::string buffer;
		std::stack<int> indents;
		std::vector<bool> noDoStack;
		std::vector<bool> noChainBlockStack;
		std::vector<bool> noTableBlockStack;
		std::vector<bool> noForStack;
		std::vector<bool> noUntilStack;
		std::unordered_set<std::string> usedNames;
	};

	template <class T>
	inline rule& getRule() {
		return getRule(identity<T>());
	}

private:
	Converter _converter;
	std::unordered_map<std::string_view, rule*> _rules;

	template <class T>
	inline rule& getRule(identity<T>) {
		assert(false);
		return cut;
	}

	inline rule& collect(std::string_view name, rule& rule) {
		_rules[name] = rule.this_ptr();
		return rule;
	}

	NONE_AST_RULE(empty_block_error);
	NONE_AST_RULE(leading_spaces_error);
	NONE_AST_RULE(indentation_error);
	NONE_AST_RULE(braces_expression_error);
	NONE_AST_RULE(brackets_expression_error);
	NONE_AST_RULE(slice_expression_error);
	NONE_AST_RULE(export_expression_error);
	NONE_AST_RULE(invalid_interpolation_error);
	NONE_AST_RULE(confusing_unary_not_error);
	NONE_AST_RULE(table_key_pair_error);
	NONE_AST_RULE(assignment_expression_syntax_error);

	NONE_AST_RULE(inc_exp_level);
	NONE_AST_RULE(dec_exp_level);

	NONE_AST_RULE(num_char);
	NONE_AST_RULE(num_char_hex);
	NONE_AST_RULE(num_lit);
	NONE_AST_RULE(num_bin_lit);
	NONE_AST_RULE(num_expo);
	NONE_AST_RULE(num_expo_hex);
	NONE_AST_RULE(lj_num);
	NONE_AST_RULE(plain_space);
	NONE_AST_RULE(line_break);
	NONE_AST_RULE(any_char);
	NONE_AST_RULE(white);
	NONE_AST_RULE(stop);
	NONE_AST_RULE(comment);
	NONE_AST_RULE(multi_line_open);
	NONE_AST_RULE(multi_line_close);
	NONE_AST_RULE(multi_line_content);
	NONE_AST_RULE(multi_line_comment);
	NONE_AST_RULE(escape_new_line);
	NONE_AST_RULE(space_one);
	NONE_AST_RULE(space);
	NONE_AST_RULE(space_break);
	NONE_AST_RULE(alpha_num);
	NONE_AST_RULE(not_alpha_num);
	NONE_AST_RULE(cut);
	NONE_AST_RULE(check_indent_match);
	NONE_AST_RULE(check_indent);
	NONE_AST_RULE(advance_match);
	NONE_AST_RULE(advance);
	NONE_AST_RULE(push_indent_match);
	NONE_AST_RULE(push_indent);
	NONE_AST_RULE(prevent_indent);
	NONE_AST_RULE(pop_indent);
	NONE_AST_RULE(in_block);
	NONE_AST_RULE(import_name);
	NONE_AST_RULE(import_name_list);
	NONE_AST_RULE(from_import_name_list_line);
	NONE_AST_RULE(from_import_name_in_block);
	NONE_AST_RULE(import_literal_chain);
	NONE_AST_RULE(import_tab_item);
	NONE_AST_RULE(import_tab_list);
	NONE_AST_RULE(import_tab_line);
	NONE_AST_RULE(import_tab_lines);
	NONE_AST_RULE(import_tab_key_value);
	NONE_AST_RULE(with_exp);
	NONE_AST_RULE(disable_do);
	NONE_AST_RULE(enable_do);
	NONE_AST_RULE(disable_chain);
	NONE_AST_RULE(enable_chain);
	NONE_AST_RULE(disable_do_chain_arg_table_block);
	NONE_AST_RULE(enable_do_chain_arg_table_block);
	NONE_AST_RULE(disable_arg_table_block);
	NONE_AST_RULE(enable_arg_table_block);
	NONE_AST_RULE(disable_for);
	NONE_AST_RULE(enable_for);
	NONE_AST_RULE(enable_fun_lit);
	NONE_AST_RULE(disable_fun_lit);
	NONE_AST_RULE(disable_until);
	NONE_AST_RULE(enable_until);
	NONE_AST_RULE(switch_else);
	NONE_AST_RULE(switch_block);
	NONE_AST_RULE(if_else_if);
	NONE_AST_RULE(if_else);
	NONE_AST_RULE(for_key);
	NONE_AST_RULE(for_args);
	NONE_AST_RULE(for_in);
	NONE_AST_RULE(list_value);
	NONE_AST_RULE(list_value_list);
	NONE_AST_RULE(list_lit_line);
	NONE_AST_RULE(list_lit_lines);
	NONE_AST_RULE(comp_clause);
	NONE_AST_RULE(chain);
	NONE_AST_RULE(chain_list);
	NONE_AST_RULE(key_value);
	NONE_AST_RULE(single_string_inner);
	NONE_AST_RULE(interp);
	NONE_AST_RULE(double_string_plain);
	NONE_AST_RULE(lua_string_open);
	NONE_AST_RULE(lua_string_close);
	NONE_AST_RULE(fn_args_value_list);
	NONE_AST_RULE(fn_args_lit_line);
	NONE_AST_RULE(fn_args_lit_lines);
	NONE_AST_RULE(fn_args);
	NONE_AST_RULE(fn_arg_def_list);
	NONE_AST_RULE(fn_arg_def_lit_line);
	NONE_AST_RULE(fn_arg_def_lit_lines);
	NONE_AST_RULE(destruct_def);
	NONE_AST_RULE(macro_args_def);
	NONE_AST_RULE(chain_call);
	NONE_AST_RULE(chain_call_list);
	NONE_AST_RULE(chain_index_chain);
	NONE_AST_RULE(chain_items);
	NONE_AST_RULE(chain_dot_chain);
	NONE_AST_RULE(colon_chain);
	NONE_AST_RULE(chain_with_colon);
	NONE_AST_RULE(chain_item);
	NONE_AST_RULE(chain_line);
	NONE_AST_RULE(chain_block);
	NONE_AST_RULE(meta_index);
	NONE_AST_RULE(index);
	NONE_AST_RULE(invoke_chain);
	NONE_AST_RULE(table_value);
	NONE_AST_RULE(table_lit_lines);
	NONE_AST_RULE(table_lit_line);
	NONE_AST_RULE(table_value_list);
	NONE_AST_RULE(table_block_inner);
	NONE_AST_RULE(class_line);
	NONE_AST_RULE(key_value_line);
	NONE_AST_RULE(key_value_list);
	NONE_AST_RULE(arg_line);
	NONE_AST_RULE(arg_block);
	NONE_AST_RULE(invoke_args_with_table);
	NONE_AST_RULE(arg_table_block);
	NONE_AST_RULE(pipe_operator);
	NONE_AST_RULE(exponential_operator);
	NONE_AST_RULE(pipe_value);
	NONE_AST_RULE(pipe_exp);
	NONE_AST_RULE(expo_value);
	NONE_AST_RULE(expo_exp);
	NONE_AST_RULE(exp_not_tab);
	NONE_AST_RULE(local_const_item);
	NONE_AST_RULE(empty_line_break);
	NONE_AST_RULE(yue_comment);
	NONE_AST_RULE(yue_line_comment);
	NONE_AST_RULE(line);
	NONE_AST_RULE(shebang);
	NONE_AST_RULE(lax_line);

	AST_RULE(Num);
	AST_RULE(Name);
	AST_RULE(UnicodeName);
	AST_RULE(Variable);
	AST_RULE(LabelName);
	AST_RULE(LuaKeyword);
	AST_RULE(Self);
	AST_RULE(SelfName);
	AST_RULE(SelfClass);
	AST_RULE(SelfClassName);
	AST_RULE(SelfItem);
	AST_RULE(KeyName);
	AST_RULE(VarArg);
	AST_RULE(Seperator);
	AST_RULE(NameList);
	AST_RULE(LocalFlag);
	AST_RULE(LocalValues);
	AST_RULE(Local);
	AST_RULE(ConstAttrib);
	AST_RULE(CloseAttrib);
	AST_RULE(LocalAttrib);
	AST_RULE(ColonImportName);
	AST_RULE(ImportLiteralInner);
	AST_RULE(ImportLiteral);
	AST_RULE(ImportFrom);
	AST_RULE(FromImport);
	AST_RULE(MacroNamePair);
	AST_RULE(ImportAllMacro);
	AST_RULE(ImportTabLit);
	AST_RULE(ImportAs);
	AST_RULE(ImportGlobal);
	AST_RULE(Import);
	AST_RULE(Label);
	AST_RULE(Goto);
	AST_RULE(ShortTabAppending);
	AST_RULE(FnArrowBack);
	AST_RULE(Backcall);
	AST_RULE(SubBackcall);
	AST_RULE(PipeBody);
	AST_RULE(ExpListLow);
	AST_RULE(ExpList);
	AST_RULE(Return);
	AST_RULE(With);
	AST_RULE(SwitchList);
	AST_RULE(SwitchCase);
	AST_RULE(Switch);
	AST_RULE(Assignment);
	AST_RULE(IfCond);
	AST_RULE(IfType);
	AST_RULE(If);
	AST_RULE(WhileType);
	AST_RULE(While);
	AST_RULE(Repeat);
	AST_RULE(ForStepValue);
	AST_RULE(For);
	AST_RULE(ForEach);
	AST_RULE(Do);
	AST_RULE(CatchBlock);
	AST_RULE(Try);
	AST_RULE(Comprehension);
	AST_RULE(CompValue);
	AST_RULE(TblComprehension);
	AST_RULE(StarExp);
	AST_RULE(CompForEach);
	AST_RULE(CompFor);
	AST_RULE(CompInner);
	AST_RULE(Assign);
	AST_RULE(UpdateOp);
	AST_RULE(Update);
	AST_RULE(BinaryOperator);
	AST_RULE(UnaryOperator);
	AST_RULE(Assignable);
	AST_RULE(AssignableChain);
	AST_RULE(ExpOpValue);
	AST_RULE(Exp);
	AST_RULE(Callable);
	AST_RULE(ReversedIndex);
	AST_RULE(ChainValue);
	AST_RULE(SimpleTable);
	AST_RULE(SimpleValue);
	AST_RULE(Value);
	AST_RULE(LuaStringOpen);
	AST_RULE(LuaStringContent);
	AST_RULE(LuaStringClose);
	AST_RULE(LuaString);
	AST_RULE(SingleString);
	AST_RULE(DoubleStringInner);
	AST_RULE(DoubleStringContent);
	AST_RULE(DoubleString);
	AST_RULE(YAMLIndent);
	AST_RULE(YAMLLineInner);
	AST_RULE(YAMLLineContent);
	AST_RULE(YAMLLine);
	AST_RULE(YAMLMultiline);
	AST_RULE(String);
	AST_RULE(Parens);
	AST_RULE(DotChainItem);
	AST_RULE(ColonChainItem);
	AST_RULE(Metatable);
	AST_RULE(Metamethod);
	AST_RULE(DefaultValue);
	AST_RULE(Slice);
	AST_RULE(Invoke);
	AST_RULE(ExistentialOp);
	AST_RULE(TableAppendingOp);
	AST_RULE(PlainItem);
	AST_RULE(SpreadExp);
	AST_RULE(SpreadListExp);
	AST_RULE(TableLit);
	AST_RULE(TableBlock);
	AST_RULE(TableBlockIndent);
	AST_RULE(ClassMemberList);
	AST_RULE(ClassBlock);
	AST_RULE(ClassDecl);
	AST_RULE(GlobalValues);
	AST_RULE(GlobalOp);
	AST_RULE(Global);
	AST_RULE(ExportDefault);
	AST_RULE(Export);
	AST_RULE(VariablePair);
	AST_RULE(NormalPair);
	AST_RULE(MetaVariablePair);
	AST_RULE(MetaNormalPair);
	AST_RULE(VariablePairDef);
	AST_RULE(NormalPairDef);
	AST_RULE(NormalDef);
	AST_RULE(MetaVariablePairDef);
	AST_RULE(MetaNormalPairDef);
	AST_RULE(FnArgDef);
	AST_RULE(FnArgDefList);
	AST_RULE(OuterVarShadow);
	AST_RULE(FnArgsDef);
	AST_RULE(FnArrow);
	AST_RULE(FunLit);
	AST_RULE(MacroName);
	AST_RULE(MacroLit);
	AST_RULE(MacroFunc);
	AST_RULE(Macro);
	AST_RULE(MacroInPlace);
	AST_RULE(NameOrDestructure);
	AST_RULE(AssignableNameList);
	AST_RULE(InvokeArgs);
	AST_RULE(ConstValue);
	AST_RULE(UnaryValue);
	AST_RULE(UnaryExp);
	AST_RULE(NotIn);
	AST_RULE(In);
	AST_RULE(ExpListAssign);
	AST_RULE(IfLine);
	AST_RULE(WhileLine);
	AST_RULE(Break);
	AST_RULE(Continue);
	AST_RULE(BreakLoop);
	AST_RULE(StatementAppendix);
	AST_RULE(Statement);
	AST_RULE(StatementSep);
	AST_RULE(YueLineComment);
	AST_RULE(MultilineCommentInner);
	AST_RULE(YueMultilineComment);
	AST_RULE(ChainAssign);
	AST_RULE(Body);
	AST_RULE(Block);
	AST_RULE(BlockEnd);
	AST_RULE(File);
};

namespace Utils {
void replace(std::string& str, std::string_view from, std::string_view to);
void trim(std::string& str);
std::string toLuaDoubleString(const std::string& input);
} // namespace Utils

} // namespace yue
