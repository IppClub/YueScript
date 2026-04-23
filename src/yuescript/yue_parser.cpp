/* Copyright (c) 2017-2026 Li Jin <dragon-fly@qq.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#include "yuescript/yue_parser.h"

namespace pl = parserlib;

namespace yue {

std::unordered_set<std::string> LuaKeywords = {
	"and"s, "break"s, "do"s, "else"s, "elseif"s,
	"end"s, "false"s, "for"s, "function"s, "goto"s,
	"if"s, "in"s, "local"s, "nil"s, "not"s,
	"or"s, "repeat"s, "return"s, "then"s, "true"s,
	"until"s, "while"s};

std::unordered_set<std::string> Keywords = {
	"and"s, "break"s, "do"s, "else"s, "elseif"s,
	"end"s, "false"s, "for"s, "function"s, "goto"s,
	"if"s, "in"s, "local"s, "nil"s, "not"s,
	"or"s, "repeat"s, "return"s, "then"s, "true"s,
	"until"s, "while"s, // Lua keywords
	"as"s, "class"s, "continue"s, "export"s, "extends"s,
	"from"s, "global"s, "import"s, "macro"s, "switch"s,
	"try"s, "unless"s, "using"s, "when"s, "with"s // Yue keywords
};

class ParserError : public std::logic_error {
public:
	explicit ParserError(std::string_view msg, const pos* begin)
		: std::logic_error(std::string(msg))
		, line(begin->m_line)
		, col(begin->m_col) { }

	int line;
	int col;
};

#define RaiseError(msg, item) \
	do { \
		if (reinterpret_cast<State*>(item.user_data)->lax) { \
			return false; \
		} else { \
			throw ParserError(msg, item.begin); \
		} \
	} while (false)

#define RaiseErrorI(msg, item) \
	do { \
		if (reinterpret_cast<State*>(item.user_data)->lax) { \
			return -1; \
		} else { \
			throw ParserError(msg, item.begin); \
		} \
	} while (false)

// clang-format off
YueParser::YueParser() {
	plain_space = *set(" \t");
	line_break = nl(-expr('\r') >> '\n');
	plain_space_break = plain_space >> line_break;
	any_char = line_break | any();
	stop = line_break | eof();
	comment = "--" >> *(not_(set("\r\n")) >> any_char) >> and_(stop);
	multi_line_open = "--[[";
	multi_line_close = "]]";
	multi_line_content = *(not_(multi_line_close) >> any_char);
	multi_line_comment = multi_line_open >> multi_line_content >> multi_line_close;
	escape_new_line = '\\' >> *(set(" \t") | multi_line_comment) >> -comment >> line_break;
	space_one = set(" \t") | and_(set("-\\")) >> (multi_line_comment | escape_new_line);
	space = -(and_(set(" \t-\\")) >> *space_one >> -comment);
	space_break = space >> line_break;
	white = space >> *(line_break >> space);
	plain_white = plain_space >> *(line_break >> plain_space);
	alpha_num = range('a', 'z') | range('A', 'Z') | range('0', '9') | '_';
	not_alpha_num = not_(alpha_num);
	Name = (range('a', 'z') | range('A', 'Z') | '_') >> *alpha_num >> not_(larger(255));
	UnicodeName = (range('a', 'z') | range('A', 'Z') | '_' | larger(255)) >> *(larger(255) | alpha_num);
	must_num_char = num_char | invalid_number_literal_error;
	num_expo = set("eE") >> -set("+-") >> must_num_char;
	num_expo_hex = set("pP") >> -set("+-") >> must_num_char;
	lj_num = -set("uU") >> set("lL") >> set("lL");
	num_char = range('0', '9') >> *(range('0', '9') | '_' >> and_(range('0', '9')));
	num_char_hex = range('0', '9') | range('a', 'f') | range('A', 'F');
	num_lit = num_char_hex >> *(num_char_hex | '_' >> and_(num_char_hex));
	num_bin_lit = set("01") >> *(set("01") | '_' >> and_(set("01")));
	Num = (
		'0' >> (
			set("xX") >> (
				num_lit >> (
					'.' >> num_lit >> -num_expo_hex |
					num_expo_hex |
					lj_num |
					true_()
				) | (
					'.' >> num_lit >> -num_expo_hex
				) | invalid_number_literal_error
			) |
			set("bB") >> (num_bin_lit | invalid_number_literal_error)
		) |
		num_char >> (
			'.' >> must_num_char >> -num_expo |
			num_expo |
			lj_num |
			true_()
		)
	) >> -(and_(alpha_num) >> invalid_number_literal_error) |
	'.' >> num_char >> -num_expo >> -(and_(alpha_num) >> invalid_number_literal_error);

	cut = false_();
	Seperator = true_();

	auto expect_error = [](std::string_view msg) {
		return pl::user(true_(), [msg](const item_t& item) {
			RaiseError(msg, item);
			return false;
		});
	};

	empty_block_error = expect_error(
		"expected a valid statement or indented block"sv
	);
	export_expression_error = expect_error(
		"invalid export expression"sv
	);
	invalid_interpolation_error = expect_error(
		"invalid string interpolation"sv
	);
	confusing_unary_not_error = expect_error(
		"deprecated use for unary operator 'not' to be here"sv
	);
	table_key_pair_error = expect_error(
		"can not put hash pair in a list"sv
	);
	assignment_expression_syntax_error = expect_error(
		"use := for assignment expression"sv
	);
	braces_expression_error = expect_error(
		"syntax error in brace expression"sv
	);
	brackets_expression_error = expect_error(
		"unclosed bracket expression"sv
	);
	slice_expression_error = expect_error(
		"syntax error in slice expression"sv
	);
	unclosed_single_string_error = expect_error(
		"unclosed single-quoted string"sv
	);
	unclosed_double_string_error = expect_error(
		"unclosed double-quoted string"sv
	);
	unclosed_lua_string_error = expect_error(
		"unclosed Lua string"sv
	);
	unexpected_comma_error = expect_error(
		"got unexpected comma"sv
	);
	parenthesis_error = expect_error(
		"expected only one expression in parenthesis"sv
	);
	dangling_clause_error = expect_error(
		"dangling control clause"sv
	);
	keyword_as_label_error = expect_error(
		"keyword cannot be used as a label name"sv
	);
	vararg_position_error = expect_error(
		"vararg '...' must be the last parameter in function argument list"sv
	);
	invalid_import_syntax_error = expect_error(
		"invalid import syntax, expected `import \"X.mod\"`, `import \"X.mod\" as {:name}`, `from mod import name` or `import mod.name`"sv
	);
	invalid_import_as_syntax_error = expect_error(
		"invalid import syntax, expected `import \"X.mod\" as modname` or `import \"X.mod\" as {:name}`"sv
	);
	expected_expression_error = expect_error(
		"expected valid expression"sv
	);
	invalid_from_import_error = expect_error(
		"invalid import syntax, expected `from \"X.mod\" import name` or `from mod import name`"sv
	);
	invalid_export_syntax_error = expect_error(
		"invalid export syntax, expected `export item`, `export item = x`, `export.item = x` or `export default item`"sv
	);
	invalid_macro_definition_error = expect_error(
		"invalid macro definition, expected `macro Name = -> body` or `macro Name = $Name(...)`"sv
	);
	invalid_global_declaration_error = expect_error(
		"invalid global declaration, expected `global name`, `global name = ...`, `global *`, `global ^` or `global class ...`"sv
	);
	invalid_local_declaration_error = expect_error(
		"invalid local declaration, expected `local name`, `local name = ...`, `local *` or `local ^`"sv
	);
	invalid_with_syntax_error = expect_error(
		"invalid 'with' statement"sv
	);
	invalid_try_syntax_error = expect_error(
		"invalid 'try' expression, expected `try expr` or `try block` optionally followed by `catch err` with a handling block"sv
	);
	keyword_as_identifier_syntax_error = expect_error(
		"can not use keyword as identifier"sv
	);
	invalid_number_literal_error = expect_error(
		"invalid numeric literal"sv
	);
	invalid_import_literal_error = expect_error(
		"invalid import path literal, expected a dotted path like X.Y.Z"sv
	);
	expected_indentifier_error = expect_error(
		"expected valid identifer"sv
	);

	#define ensure(patt, finally) ((patt) >> (finally) | (finally) >> cut)

	#define key(str) (expr(str) >> not_alpha_num)

	#define disable_do_rule(patt) ( \
		disable_do >> ( \
			(patt) >> enable_do | \
			enable_do >> cut \
		) \
	)

	#define disable_chain_rule(patt) ( \
		disable_chain >> ( \
			(patt) >> enable_chain | \
			enable_chain >> cut \
		) \
	)

	#define disable_do_chain_arg_table_block_rule(patt) ( \
		disable_do_chain_arg_table_block >> ( \
			(patt) >> enable_do_chain_arg_table_block | \
			enable_do_chain_arg_table_block >> cut \
		) \
	)

	#define disable_arg_table_block_rule(patt) ( \
		disable_arg_table_block >> ( \
			(patt) >> enable_arg_table_block | \
			enable_arg_table_block >> cut \
		) \
	)

	#define disable_for_rule(patt) ( \
		disable_for >> ( \
			(patt) >> enable_for | \
			enable_for >> cut \
		) \
	)

	#define disable_until_rule(patt) ( \
		disable_until >> ( \
			(patt) >> enable_until | \
			enable_until >> cut \
		) \
	)

	#define body_with(str) ( \
		key(str) >> space >> (in_block | Statement) | \
		in_block | \
		empty_block_error \
	)

	#define opt_body_with(str) ( \
		key(str) >> space >> (in_block | Statement) | \
		in_block \
	)

	#define body (in_block | Statement | empty_block_error)

	Variable = pl::user(Name | UnicodeName, [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		for (auto it = item.begin->m_it; it != item.end->m_it; ++it) {
			if (*it > 255) {
				st->buffer.clear();
				return true;
			}
			st->buffer += static_cast<char>(*it);
		}
		auto isValid = Keywords.find(st->buffer) == Keywords.end();
		if (isValid) {
			if (st->buffer[0] == '_') {
				st->usedNames.insert(st->buffer);
			}
		}
		st->buffer.clear();
		return isValid;
	});

	LuaKeyword = pl::user(Name, [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		for (auto it = item.begin->m_it; it != item.end->m_it; ++it) st->buffer += static_cast<char>(*it);
		auto it = LuaKeywords.find(st->buffer);
		st->buffer.clear();
		return it != LuaKeywords.end();
	});

	Self = '@';
	SelfName = '@' >> (Name | UnicodeName);
	SelfClass = "@@";
	SelfClassName = "@@" >> (Name | UnicodeName);

	SelfItem = SelfClassName | SelfClass | SelfName | Self;
	KeyName = SelfItem | Name | UnicodeName;
	VarArgDef = "..." >> -(space >> Variable);
	VarArg = "...";

	auto getIndent = [](const item_t& item) -> int {
		if (item.begin->m_it == item.end->m_it) return 0;
		State* st = reinterpret_cast<State*>(item.user_data);
		bool useTab = false;
		if (st->useTab) {
			useTab = st->useTab.value();
		} else {
			useTab = *item.begin->m_it == '\t';
			st->useTab = useTab;
		}
		int indent = 0;
		if (useTab) {
			for (input_it i = item.begin->m_it; i != item.end->m_it; ++i) {
				switch (*i) {
					case '\t': indent += 4; break;
					default: RaiseErrorI("can not mix the use of tabs and spaces as indents"sv, item); break;
				}
			}
		} else {
			for (input_it i = item.begin->m_it; i != item.end->m_it; ++i) {
				switch (*i) {
					case ' ': indent++; break;
					default: RaiseErrorI("can not mix the use of tabs and spaces as indents"sv, item); break;
				}
			}
		}
		return indent;
	};

	check_indent = pl::user(plain_space, [getIndent](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->indents.top() == getIndent(item);
	});
	check_indent_match = and_(check_indent);

	advance = pl::user(plain_space, [getIndent](const item_t& item) {
		int indent = getIndent(item);
		State* st = reinterpret_cast<State*>(item.user_data);
		int top = st->indents.top();
		if (top != -1 && indent > top) {
			st->indents.push(indent);
			return true;
		}
		return false;
	});
	advance_match = and_(advance);

	push_indent = pl::user(plain_space >> not_(stop), [](const item_t& item) {
		int indent = 0;
		for (input_it i = item.begin->m_it; i != item.end->m_it; ++i) {
			switch (*i) {
				case ' ': indent++; break;
				case '\t': indent += 4; break;
			}
		}
		State* st = reinterpret_cast<State*>(item.user_data);
		if (st->indents.empty()) {
			RaiseError("unknown indent level"sv, item);
		}
		if (st->indents.top() > indent) {
			RaiseError("unexpected dedent"sv, item);
		}
		st->indents.push(indent);
		return true;
	});
	push_indent_match = and_(push_indent);

	prevent_indent = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->indents.push(-1);
		return true;
	});

	pop_indent = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->indents.pop();
		return true;
	});

	in_block = space_break >> *(*set(" \t") >> line_break) >> advance_match >> ensure(Block, pop_indent);

	LocalFlag = expr('*') | '^';
	LocalValues = NameList >> -(space >> '=' >> space >> (TableBlock | ExpList | expected_expression_error));
	Local = key("local") >> space >> (LocalFlag | LocalValues | invalid_local_declaration_error);

	ConstAttrib = key("const");
	CloseAttrib = key("close");
	local_const_item = Variable | SimpleTable | TableLit | Comprehension;
	LocalAttrib = (
		ConstAttrib >> Seperator >> space >> local_const_item >> *(space >> ',' >> space >> local_const_item) |
		CloseAttrib >> Seperator >> space >> must_variable >> *(space >> ',' >> space >> must_variable)
	) >> space >> Assign;

	ColonImportName = '\\' >> must_variable;
	import_name = not_(key("from")) >> (ColonImportName | must_variable);
	import_name_list = Seperator >> *space_break >> space >> import_name >> *(
		(+space_break | space >> ',' >> *space_break) >> space >> import_name
	);
	ImportFrom = import_name_list >> *space_break >> space >> key("from") >> space >> (ImportLiteral | not_(String) >> must_exp);
	from_import_name_list_line = import_name >> *(space >> ',' >> space >> not_(line_break) >> import_name);
	from_import_name_in_block = +space_break >> advance_match >> ensure(space >> from_import_name_list_line >> *(-(space >> ',') >> +space_break >> check_indent_match >> space >> from_import_name_list_line), pop_indent);
	FromImport = key("from") >> space >> (
			ImportLiteral | not_(String) >> Exp | invalid_from_import_error
		) >> *space_break >> space >> (
			key("import") | invalid_from_import_error
		) >> space >> Seperator >> (
			from_import_name_in_block |
			from_import_name_list_line >> -(space >> ',') >> -from_import_name_in_block |
			invalid_from_import_error
		);

	ImportLiteralInner = (range('a', 'z') | range('A', 'Z') | set("_-") | larger(255)) >> *(alpha_num | '-' | larger(255));
	import_literal_chain = Seperator >> ImportLiteralInner >> *('.' >> ImportLiteralInner);
	ImportLiteral = (
			'\'' >> import_literal_chain >> -(not_('\'') >> invalid_import_literal_error) >> '\''
		) | (
			'"' >> import_literal_chain >> -(not_('"') >> invalid_import_literal_error) >> '"'
		);

	MacroNamePair = MacroName >> ':' >> space >> MacroName;
	ImportAllMacro = '$' >> not_(UnicodeName);
	import_tab_item =
		VariablePair |
		NormalPair |
		':' >> MacroName |
		MacroNamePair |
		ImportAllMacro |
		MetaVariablePair |
		MetaNormalPair |
		Exp;
	import_tab_list = import_tab_item >> *(space >> ',' >> space >> import_tab_item);
	import_tab_line = (
		push_indent_match >> ensure(space >> import_tab_list, pop_indent)
	) | space;
	import_tab_lines = space_break >> import_tab_line >> *(-(space >> ',') >> space_break >> import_tab_line) >> -(space >> ',');
	import_tab_key_value = key_value | ':' >> MacroName | MacroNamePair | ImportAllMacro;
	ImportTabLit = (
		'{' >> Seperator >>
		-(space >> import_tab_list) >>
		-(space >> ',') >>
		-import_tab_lines >>
		white >>
		end_braces_expression
	) | (
		Seperator >> import_tab_key_value >> *(space >> ',' >> space >> import_tab_key_value)
	);

	ImportAs = ImportLiteral >> -(space >> key("as") >> space >> (
		ImportTabLit | Variable | ImportAllMacro | invalid_import_as_syntax_error
	));

	ImportGlobal = Seperator >> UnicodeName >> *('.' >> UnicodeName) >> space >> not_(',' | key("from")) >> -(key("as") >> space >> must_variable);

	ImportAllGlobal = key("global");

	Import = key("import") >> space >> (ImportAllGlobal | ImportGlobal | ImportAs | ImportFrom | invalid_import_syntax_error) | FromImport;

	Label = "::" >> (and_(LuaKeyword >> "::") >> keyword_as_label_error | UnicodeName >> "::");

	Goto = key("goto") >> space >> (and_(LuaKeyword >> not_alpha_num) >> keyword_as_label_error | UnicodeName);

	ShortTabAppending = "[]" >> space >> Assign;

	Break = key("break");
	Continue = key("continue");
	BreakLoop = (Break >> -(space >> ExpList) | Continue) >> not_alpha_num;

	Return = key("return") >> -(space >> (TableBlock | ExpList));

	must_exp = Exp | expected_expression_error;

	with_exp = ExpList >> -(space >> (':' >> Assign | and_('=') >> assignment_expression_syntax_error)) | expected_expression_error;

	With = key("with") >> -ExistentialOp >> space >> (
		disable_do_chain_arg_table_block_rule(with_exp) >> space >> body_with("do") |
		invalid_with_syntax_error
	);
	SwitchCase = key("when") >> space >> disable_chain_rule(disable_arg_table_block_rule(SwitchList)) >> space >> body_with("then");
	switch_else = key("else") >> space >> body;

	switch_block =
		*(line_break >> *space_break >> check_indent_match >> space >> SwitchCase) >>
		-(line_break >> *space_break >> check_indent_match >> space >> switch_else);

	exp_not_tab = not_(SimpleTable | TableLit) >> Exp;

	SwitchList = Seperator >> (
		and_(SimpleTable | TableLit) >> Exp |
		exp_not_tab >> *(space >> ',' >> space >> exp_not_tab) |
		expected_expression_error
	);
	Switch = key("switch") >> space >>
		must_exp >> -(space >> Assignment) >>
		space >> Seperator >> (
			SwitchCase >> space >> (
				switch_block |
				*(space >> SwitchCase) >> -(space >> switch_else)
			) |
			+space_break >> advance_match >> space >> SwitchCase >> switch_block >> pop_indent
		);

	Assignment = -(',' >> space >> ExpList >> space) >> (':' >> Assign | and_('=') >> assignment_expression_syntax_error);
	IfCond = disable_chain_rule(disable_arg_table_block_rule(Exp >> -(space >> Assignment))) | expected_expression_error;
	if_else_if = -(line_break >> *space_break >> check_indent_match) >> space >> key("elseif") >> space >> IfCond >> space >> body_with("then");
	if_else = -(line_break >> *space_break >> check_indent_match) >> space >> key("else") >> space >> body;
	IfType = (expr("if") | "unless") >> not_alpha_num;
	If = IfType >> space >> IfCond >> space >> opt_body_with("then") >> *if_else_if >> -if_else;

	WhileType = (expr("while") | pl::user("until", [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->noUntilStack.empty() || !st->noUntilStack.back();
	})) >> not_alpha_num;
	While = key(WhileType) >> space >> (disable_do_chain_arg_table_block_rule(Exp >> -(space >> Assignment)) | expected_expression_error) >> space >> opt_body_with("do");
	Repeat = key("repeat") >> space >> (
		in_block >> line_break >> *space_break >> check_indent_match |
		disable_until_rule(Statement)
	) >> space >> key("until") >> space >> must_exp;

	for_key = pl::user(key("for"), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->noForStack.empty() || !st->noForStack.back();
	});
	ForStepValue = ',' >> space >> must_exp;
	for_args = Variable >> space >> '=' >> space >> must_exp >> space >> ',' >> space >> must_exp >> space >> -ForStepValue;

	ForNum = disable_do_chain_arg_table_block_rule(for_args) >> space >> opt_body_with("do");

	for_in = StarExp | ExpList | expected_expression_error;

	ForEach = AssignableNameList >> space >> key("in") >> space >>
		disable_do_chain_arg_table_block_rule(for_in) >> space >> opt_body_with("do");

	For = for_key >> space >> (ForNum | ForEach);

	Do = pl::user(key("do"), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->noDoStack.empty() || !st->noDoStack.back();
	}) >> space >> Body;

	disable_do = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noDoStack.push_back(true);
		return true;
	});

	enable_do = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noDoStack.pop_back();
		return true;
	});

	disable_fun_lit = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->fnArrowAvailable = false;
		return true;
	});

	enable_fun_lit = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->fnArrowAvailable = true;
		return true;
	});

	disable_do_chain_arg_table_block = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noDoStack.push_back(true);
		st->noChainBlockStack.push_back(true);
		st->noTableBlockStack.push_back(true);
		return true;
	});

	enable_do_chain_arg_table_block = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noDoStack.pop_back();
		st->noChainBlockStack.pop_back();
		st->noTableBlockStack.pop_back();
		return true;
	});

	disable_arg_table_block = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noTableBlockStack.push_back(true);
		return true;
	});

	enable_arg_table_block = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noTableBlockStack.pop_back();
		return true;
	});

	disable_for = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noForStack.push_back(true);
		return true;
	});

	enable_for = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noForStack.pop_back();
		return true;
	});

	disable_until = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noUntilStack.push_back(true);
		return true;
	});

	enable_until = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noUntilStack.pop_back();
		return true;
	});

	CatchBlock = line_break >> *space_break >> check_indent_match >> space >> key("catch") >> space >> must_variable >> space >> (in_block | invalid_try_syntax_error);
	Try = key("try") >> -ExistentialOp >> space >> (in_block | Exp | invalid_try_syntax_error) >> -CatchBlock;

	list_value =
		and_(
			VariablePairDef |
			NormalPairDef |
			MetaVariablePairDef |
			MetaNormalPairDef
		) >> table_key_pair_error |
		SpreadListExp |
		NormalDef;

	list_value_list = +(space >> ',' >> space >> list_value);

	list_lit_line = (
		push_indent_match >> (space >> list_value >> -list_value_list >> pop_indent | pop_indent)
	) | (
		space
	);

	list_lit_lines = +space_break >> list_lit_line >> *(-(space >> ',') >> space_break >> list_lit_line) >> -(space >> ',');

	end_brackets_expression = ']' | brackets_expression_error;

	Comprehension = '[' >> not_('[') >>
		Seperator >> space >> (
			disable_for_rule(list_value) >> space >> (
				CompFor >> space >> end_brackets_expression |
				(list_value_list >> -(space >> ',') | space >> ',')  >> -list_lit_lines >> white >> end_brackets_expression
			) |
			list_lit_lines >> white >> end_brackets_expression |
			white >> ']' >> not_(space >> '=')
		);

	end_braces_expression = '}' | braces_expression_error;

	CompValue = ',' >> space >> must_exp;
	TblComprehension = '{' >> space >> disable_for_rule(Exp >> space >> -(CompValue >> space)) >> (CompFor | braces_expression_error) >> space >> end_braces_expression;

	CompFor = key("for") >> space >> Seperator >> (CompForNum | CompForEach) >> *(space >> comp_clause);
	StarExp = '*' >> space >> must_exp;
	CompForEach = AssignableNameList >> space >> key("in") >> space >> (StarExp | must_exp);
	CompForNum = Variable >> space >> '=' >> space >> must_exp >> space >> ',' >> space >> must_exp >> -ForStepValue;
	comp_clause = key("when") >> space >> must_exp | key("for") >> space >> (CompForNum | CompForEach);

	Assign = '=' >> space >> Seperator >> (
		With | If | Switch | TableBlock |
		(SpreadListExp | Exp) >> *(space >> set(",") >> space >> (SpreadListExp | Exp)) |
		expected_expression_error
	);

	UpdateOp =
		expr("..") | "//" | "or" | "and" |
		">>" | "<<" | "??" |
		set("+-*/%&|^");

	Update = UpdateOp >> '=' >> space >> must_exp;

	Assignable = AssignableChain | Variable | SelfItem;

	UnaryValue = +(UnaryOperator >> space) >> Value;

	exponential_operator = '^';
	expo_value = exponential_operator >> *space_break >> space >> Value;
	expo_exp = Value >> *(space >> expo_value);

	NotIn = true_();
	In = -(key("not") >> NotIn >> space) >> key("in") >> space >> (and_(key("not")) >> confusing_unary_not_error | Value);

	UnaryOperator =
		'-' >> not_(set(">=") | space_one) |
		'#' |
		'~' >> not_('=' | space_one) |
		key("not");
	UnaryExp = *(UnaryOperator >> space) >> expo_exp >> -(space >> In);

	pipe_operator = "|>";
	pipe_value = pipe_operator >> *space_break >> space >> must_unary_exp;
	pipe_exp = UnaryExp >> *(space >> pipe_value);

	BinaryOperator = (
		key("or") |
		key("and") |
		"<=" | ">=" | "~=" | "!=" | "==" |
		".." | "<<" | ">>" | "//" |
		set("+*/%>|&~") |
		'-' >> not_('>') |
		'<' >> not_('-')
	) >> not_('=');

	ExpOpValue = BinaryOperator >> *space_break >> space >> (pipe_exp | expected_expression_error);
	Exp = Seperator >> pipe_exp >> *(space >> ExpOpValue) >> -(space >> "??" >> not_('=') >> *space_break >> space >> must_exp);

	disable_chain = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noChainBlockStack.push_back(true);
		return true;
	});

	enable_chain = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->noChainBlockStack.pop_back();
		return true;
	});

	chain_line = check_indent_match >> space >> (chain_dot_chain | colon_chain) >> -InvokeArgs;
	chain_block = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->noChainBlockStack.empty() || !st->noChainBlockStack.back();
	}) >> +space_break >> advance_match >> ensure(
		chain_line >> *(+space_break >> chain_line), pop_indent);
	ChainValue = Seperator >> (
		(
			chain >>
			-ExistentialOp >>
			-(InvokeArgs | chain_block) >> -TableAppendingOp
		) | String >> -(
			and_(white >> set(".\\:")) >> (
				chain_items >> -(InvokeArgs | chain_block) >> -TableAppendingOp |
				chain_block >> -TableAppendingOp
			)
		)
	);

	inc_exp_level = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->expLevel++;
		const int max_exp_level = 100;
		if (st->expLevel > max_exp_level) {
			RaiseError("nesting expressions exceeds 100 levels"sv, item);
		}
		return true;
	});

	dec_exp_level = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->expLevel--;
		return true;
	});

	SimpleTable = Seperator >> key_value >> *(space >> ',' >> space >> key_value);
	Value = inc_exp_level >> ensure(SimpleValue | SimpleTable | ChainValue, dec_exp_level);

	single_string_inner = '\\' >> set("'\\") | not_('\'') >> any_char;
	SingleString = '\'' >> *single_string_inner >> ('\'' | unclosed_single_string_error);

	interp = "#{" >> space >> (Exp >> space >> '}' | invalid_interpolation_error);
	double_string_plain = '\\' >> set("\"\\#") | not_('"') >> any_char;
	DoubleStringInner = +(not_("#{") >> double_string_plain);
	DoubleStringContent = DoubleStringInner | interp;
	DoubleString = '"' >> Seperator >> *DoubleStringContent >> ('"' | unclosed_double_string_error);

	YAMLIndent = +set(" \t");
	YAMLLineInner = +('\\' >> set("\"\\#") | not_("#{" | stop) >> any_char);
	YAMLLineContent = YAMLLineInner | interp;
	YAMLLine = check_indent_match >> YAMLIndent >> +(YAMLLineContent) |
		advance_match >> YAMLIndent >> ensure(+YAMLLineContent, pop_indent);
	YAMLMultiline = '|' >> space >> Seperator >> +(*set(" \t") >> line_break) >> advance_match >> ensure(YAMLLine >> *(+(*set(" \t") >> line_break) >> YAMLLine), pop_indent);

	String = DoubleString | SingleString | LuaString | YAMLMultiline;

	lua_string_open = '[' >> *expr('=') >> '[';
	lua_string_close = ']' >> *expr('=') >> ']';

	LuaStringOpen = pl::user(lua_string_open, [](const item_t& item) {
		size_t count = std::distance(item.begin->m_it, item.end->m_it);
		State* st = reinterpret_cast<State*>(item.user_data);
		st->stringOpen = count;
		return true;
	});

	LuaStringClose = pl::user(lua_string_close, [](const item_t& item) {
		size_t count = std::distance(item.begin->m_it, item.end->m_it);
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->stringOpen == count;
	});

	LuaStringContent = *(not_(LuaStringClose) >> any_char);

	LuaString = LuaStringOpen >> -line_break >> LuaStringContent >> (LuaStringClose | unclosed_lua_string_error);

	Parens = '(' >> (*space_break >> space >> Exp >> *space_break >> space >> ')' | parenthesis_error);
	Callable = Variable | SelfItem | MacroName | Parens;

	fn_args_value_list = Exp >> *(space >> ',' >> space >> Exp);

	fn_args_lit_line = (
		push_indent_match >> ensure(space >> fn_args_value_list, pop_indent)
	) | (
		space
	);

	fn_args_lit_lines = space_break >> fn_args_lit_line >> *(-(space >> ',') >> space_break >> fn_args_lit_line) >> -(space >> ',');

	fn_args =
		'(' >> -(space >> fn_args_value_list >> -(space >> ',')) >>
		-fn_args_lit_lines >>
		white >> -(and_(',') >> unexpected_comma_error) >>')' | space >> '!' >> not_('=');

	meta_index = Name | index | String;
	Metatable = '<' >> space >> '>';
	Metamethod = '<' >> space >> meta_index >> space >> '>';

	ExistentialOp = '?' >> not_('?');
	TableAppendingOp = and_('[') >> "[]";
	PlainItem = +any_char;

	chain_call = Callable >> -ExistentialOp >> -chain_items;
	chain_index_chain = index >> -ExistentialOp >> -chain_items;
	chain_dot_chain = DotChainItem >> -ExistentialOp >> -chain_items;

	chain = chain_call | chain_dot_chain | colon_chain | chain_index_chain;

	chain_call_list = Callable >> -ExistentialOp >> chain_items;
	chain_list = chain_call_list | chain_dot_chain | colon_chain | chain_index_chain;

	AssignableChain = Seperator >> chain_list;

	chain_with_colon = +chain_item >> -colon_chain;
	chain_items = chain_with_colon | colon_chain;

	index = '[' >> not_('[') >> space >> (ReversedIndex >> and_(space >> ']') | Exp) >> space >> ']';
	ReversedIndex = '#' >> space >> -('-' >> space >> Exp);
	chain_item =
		Invoke >> -ExistentialOp |
		DotChainItem >> -ExistentialOp |
		Slice |
		index >> -ExistentialOp;
	DotChainItem = '.' >> (Name | Metatable | Metamethod | UnicodeName);
	ColonChainItem = (expr('\\') | "::") >> (LuaKeyword | Name | Metamethod | UnicodeName);
	invoke_chain = Invoke >> -ExistentialOp >> -chain_items;
	colon_chain = ColonChainItem >> -ExistentialOp >> -invoke_chain;

	DefaultValue = true_();
	Slice =
		'[' >> not_('[') >>
		space >> (Exp | DefaultValue) >>
		space >> ',' >>
		space >> (Exp | DefaultValue) >>
		space >> (',' >> space >> Exp | DefaultValue) >>
		space >> (']' | slice_expression_error);

	Invoke = Seperator >> (
		fn_args |
		SingleString |
		DoubleString |
		and_('[') >> LuaString |
		and_('{') >> TableLit
	);

	SpreadExp = "..." >> space >> Exp;
	SpreadListExp = "..." >> space >> Exp;

	table_value =
		VariablePairDef |
		NormalPairDef |
		MetaVariablePairDef |
		MetaNormalPairDef |
		SpreadExp |
		NormalDef;

	table_lit_line = -EmptyLine >> push_indent_match >> (
		space >> not_(line_break | '}') >> (table_value | expected_expression_error) >> *(space >> ',' >> space >> table_value) >> space >> -(',' >> space) >> pop_indent |
		YueComment >> pop_indent |
		pop_indent
	);

	table_lit_lines = +plain_space_break >> table_lit_line >> *(line_break >> table_lit_line);

	TableLit =
		'{' >> Seperator >>
		-(space >> table_value >> *(space >> ',' >> space >> table_value) >> -(space >> ',')) >> space >>
		(
			table_lit_lines >> white >> end_braces_expression |
			white >> '}'
		);

	table_block_inner = Seperator >> key_value_line >> *(line_break >> key_value_line);
	TableBlock = +plain_space_break >> advance_match >> ensure(table_block_inner, pop_indent);
	TableBlockIndent = ('*' | '-' >> space_one) >> Seperator >> disable_arg_table_block_rule(
		space >> key_value_list >> -(space >> ',') >>
		-(plain_space_break >> advance_match >> space >> ensure(key_value_list >> -(space >> ',') >> *(plain_space_break >> key_value_line), pop_indent)));

	ClassMemberList = Seperator >> key_value >> *(space >> ',' >> space >> key_value);
	class_line = -yue_comment_block >> check_indent_match >> space >> (ClassMemberList | Statement) >> -(space >> ',') >> space;
	ClassBlock =
		+plain_space_break >>
		advance_match >> Seperator >>
		class_line >> *(line_break >> class_line) >>
		pop_indent;

	ClassDecl =
		key("class") >> not_(':') >> disable_arg_table_block_rule(
			-(space >> Assignable) >>
			-(space >> key("extends") >> prevent_indent >> space >> ensure(must_exp, pop_indent)) >>
			-(space >> key("using") >> prevent_indent >> space >> ensure(ExpList | expected_expression_error, pop_indent))
		) >> space >> -ClassBlock;

	GlobalValues = NameList >> -(space >> '=' >> space >> (TableBlock | ExpList | expected_expression_error));
	GlobalOp = expr('*') | '^';
	Global = key("global") >> space >> (
		-(ConstAttrib >> space) >> ClassDecl |
		GlobalOp |
		-(ConstAttrib >> space) >> GlobalValues |
		invalid_global_declaration_error
	);

	ExportDefault = key("default");

	Export = pl::user(key("export"), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		st->exportCount++;
		return true;
	}) >> (
		pl::user(space >> ExportDefault >> space >> Exp, [](const item_t& item) {
			State* st = reinterpret_cast<State*>(item.user_data);
			if (st->exportDefault) {
				RaiseError("export default has already been declared"sv, item);
			}
			if (st->exportCount > 1) {
				RaiseError("there are items already being exported"sv, item);
			}
			st->exportDefault = true;
			return true;
		}) |
		not_(space >> ExportDefault) >> pl::user(true_(), [](const item_t& item) {
			State* st = reinterpret_cast<State*>(item.user_data);
			if (st->exportDefault && st->exportCount > 1) {
				RaiseError("can not export any more items when 'export default' is declared"sv, item);
			}
			return true;
		}) >> (
			and_(set(".[")) >> ((pl::user(and_('.' >> Metatable), [](const item_t& item) {
				State* st = reinterpret_cast<State*>(item.user_data);
				if (st->exportMetatable) {
					RaiseError("module metatable duplicated"sv, item);
				}
				if (st->exportMetamethod) {
					RaiseError("metatable should be exported before metamethod"sv, item);
				}
				st->exportMetatable = true;
				return true;
			}) | pl::user(and_(".<"), [](const item_t& item) {
				State* st = reinterpret_cast<State*>(item.user_data);
				st->exportMetamethod = true;
				return true;
			}) | true_()) >> (DotChainItem | index) >> space >> Assign | export_expression_error) |
			space >> ExpList >> -(space >> Assign)
		) |
		space >> pl::user(Macro, [](const item_t& item) {
			State* st = reinterpret_cast<State*>(item.user_data);
			st->exportMacro = true;
			return true;
		}) |
		invalid_export_syntax_error
	);

	VariablePair = ':' >> Variable;

	NormalPair =
		(
			KeyName |
			'[' >> not_('[') >> space >> Exp >> space >> ']' |
			String
		) >> ':' >> not_(':' | '=' >> not_('>')) >> space >>
		(Exp | TableBlock | +space_break >> space >> Exp | expected_expression_error);

	MetaVariablePair = ":<" >> space >> must_variable >> space >> '>';

	MetaNormalPair = '<' >> space >> -meta_index >> space >> ">:" >> space >>
		(Exp | TableBlock | +space_break >> space >> Exp | expected_expression_error);

	destruct_def = -(space >> '=' >> space >> Exp);
	VariablePairDef = VariablePair >> destruct_def;
	NormalPairDef = NormalPair >> destruct_def;
	MetaVariablePairDef = MetaVariablePair >> destruct_def;
	MetaNormalPairDef = MetaNormalPair >> destruct_def;
	NormalDef = Exp >> Seperator >> destruct_def;

	yue_comment_block = -EmptyLine >> YueComment >> *(line_break >> -EmptyLine >> YueComment) >> line_break >> -EmptyLine | EmptyLine;

	key_value =
		VariablePair |
		NormalPair |
		MetaVariablePair |
		MetaNormalPair;
	key_value_list = key_value >> *(space >> ',' >> space >> key_value);
	key_value_line = -yue_comment_block >>
		check_indent_match >> space >> (
			key_value_list >> -(space >> ',') |
			TableBlockIndent |
			('*' | '-' >> space_one) >> space >> (SpreadExp | Exp | TableBlock)
		) >> space;

	fn_arg_def_list = FnArgDef >> *(space >> ',' >> space >> FnArgDef);

	fn_arg_def_lit_line = (
		push_indent_match >> ensure(space >> fn_arg_def_list, pop_indent)
	) | (
		space
	);

	fn_arg_def_lit_lines = fn_arg_def_lit_line >> *(-(space >> ',') >> space_break >> fn_arg_def_lit_line);

	FnArgDef = (Variable | SelfItem >> -ExistentialOp) >> -(space >> '`' >> space >> Name) >> -(space >> '=' >> space >> Exp) | TableLit | SimpleTable | Comprehension;

	check_vararg_position = and_(white >> (')' | key("using"))) | white >> -(',' >> white) >> vararg_position_error;

	var_arg_def = (
		VarArgDef |
		+space_break >> push_indent_match >> ensure(space >> VarArgDef >> -(space >> '`' >> space >> Name), pop_indent)
	) >> check_vararg_position;

	FnArgDefList = Seperator >>
		-fn_arg_def_list >>
		-(-(space >> ',') >> +space_break >> fn_arg_def_lit_lines) >>
		-(-(space >> ',') >> space >> var_arg_def);

	OuterVarShadow = key("using") >> space >> (key("nil") | NameList);

	outer_var_shadow_def = OuterVarShadow |
		+space_break >> push_indent_match >> ensure(space >> OuterVarShadow, pop_indent);

	FnArgsDef = '(' >> space >> -FnArgDefList >> -(space >> outer_var_shadow_def) >> white >> -(and_(',') >> unexpected_comma_error) >> ')';
	FnArrow = expr("->") | "=>";
	FunLit = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->fnArrowAvailable;
	}) >> -(FnArgsDef >>
		-(':' >> space >>
			disable_fun_lit >> ensure(ExpList | DefaultValue, enable_fun_lit)
		)
	) >> space >> FnArrow >> -(space >> Body);

	MacroName = '$' >> UnicodeName;
	macro_args_def = '(' >> space >> -FnArgDefList >> white >> -(and_(',') >> unexpected_comma_error) >> ')';
	MacroLit = -(macro_args_def >> space) >> "->" >> space >> Body;
	MacroFunc = MacroName >> (Invoke | InvokeArgs);
	Macro = key("macro") >> space >> (
		UnicodeName >> space >> '=' >> space >> (MacroLit | MacroFunc | invalid_macro_definition_error) |
		invalid_macro_definition_error
	);
	MacroInPlace = '$' >> space >> "->" >> space >> Body;

	Annotation = "$[" >> space >> UnicodeName >> -(Invoke | InvokeArgs) >> space >> ']';

	must_variable = Variable | and_(LuaKeyword >> not_alpha_num) >> keyword_as_identifier_syntax_error | expected_indentifier_error;

	NameList = Seperator >> must_variable >> *(space >> ',' >> space >> must_variable);
	NameOrDestructure = Variable | TableLit | Comprehension | SimpleTable | expected_expression_error;
	AssignableNameList = Seperator >> NameOrDestructure >> *(space >> ',' >> space >> NameOrDestructure);

	FnArrowBack = '<' >> set("-=");
	Backcall = -(FnArgsDef >> space) >> FnArrowBack >> space >> ChainValue;
	SubBackcall = FnArrowBack >> space >> ChainValue;

	must_unary_exp = UnaryExp | expected_expression_error;

	PipeBody = Seperator >>
		pipe_operator >> space >> must_unary_exp >>
		*(+space_break >> check_indent_match >> space >> pipe_operator >> space >> must_unary_exp);

	ExpList = Seperator >> Exp >> *(space >> ',' >> space >> Exp);

	arg_line = check_indent_match >> space >> Exp >> *(space >> ',' >> space >> Exp);
	arg_block = arg_line >> *(space >> ',' >> space_break >> arg_line) >> pop_indent;

	arg_table_block = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->noTableBlockStack.empty() || !st->noTableBlockStack.back();
	}) >> TableBlock;

	invoke_args_with_table =
		',' >> (
			arg_table_block |
			space_break >> advance_match >> arg_block >> -(-(space >> ',') >> arg_table_block)
		) | arg_table_block;

	InvokeArgs =
		not_(set("-~") | "[]") >> space >> Seperator >> (
			Exp >> *(space >> ',' >> space >> Exp) >> -(space >> invoke_args_with_table) |
			arg_table_block
		);

	ConstValue = (expr("nil") | "true" | "false") >> not_alpha_num;

	SimpleValue =
		TableLit | ConstValue | If | Switch | Try | With |
		ClassDecl | For | While | Repeat | Do |
		UnaryValue | TblComprehension | Comprehension |
		FunLit | Num | VarArg;

	ExpListAssign = ExpList >> -(space >> (Update | Assign | SubBackcall)) >> not_(space >> '=');

	IfLine = IfType >> space >> IfCond;
	WhileLine = WhileType >> space >> Exp;

	ChainAssign = Seperator >> Exp >> +(space >> '=' >> space >> Exp >> space >> and_('=')) >> space >> Assign;

	StatementAppendix = IfLine | WhileLine | CompFor;
	Statement = (
		(
			Import | Export | Global | Macro | MacroInPlace | Annotation | Label
		) | (
			Local | While | Repeat | For | Return |
			BreakLoop | Goto | ShortTabAppending |
			LocalAttrib | Backcall | PipeBody | ExpListAssign | ChainAssign |
			StatementAppendix >> empty_block_error |
			and_(key("else") | key("elseif") | key("when")) >> dangling_clause_error
		) >> space >> -StatementAppendix
	) >> space;

	StatementSep = white >> (set("('\"") | "[[" | "[=");

	Body = in_block | Statement;

	YueLineComment = *(not_(set("\r\n")) >> any_char);
	yue_line_comment = "--" >> YueLineComment >> and_(stop);
	YueMultilineComment = multi_line_content;
	yue_multiline_comment = multi_line_open >> YueMultilineComment >> multi_line_close;
	comment_line =
		yue_multiline_comment >> *(set(" \t") | yue_multiline_comment) >> plain_space >> -yue_line_comment |
		yue_line_comment;
	YueComment =
		check_indent >> comment_line >> and_(stop) |
		advance >> ensure(comment_line, pop_indent) >> and_(stop);

	EmptyLine = +(*set(" \t") >> line_break);

	indentation_error = pl::user(not_(pipe_operator | eof()), [](const item_t& item) {
		RaiseError("unexpected indent"sv, item);
		return false;
	});

	is_lax = pl::user(true_(), [](const item_t& item) {
		State* st = reinterpret_cast<State*>(item.user_data);
		return st->lax;
	});

	line = -EmptyLine >> (
		check_indent_match >> space >> Statement >> *(';' >> space >> (Statement | not_(';'))) |
		YueComment |
		advance_match >> ensure(space >> (indentation_error | Statement), pop_indent)
	);
	Block = Seperator >> (
		is_lax >> lax_line >> *(line_break >> lax_line) |
		line >> *(line_break >> line)
	);

	shebang = "#!" >> *(not_(stop) >> any_char);
	BlockEnd = Block >> plain_white >> stop;
	File = -shebang >> -Block >> plain_white >> stop;

	lax_line = advance_match >> ensure(*(not_(stop) >> any()), pop_indent) |
		line >> and_(stop) |
		check_indent_match >> *(not_(stop) >> any());
}
// clang-format on

bool YueParser::startWith(std::string_view codes, rule& r) {
	std::unique_ptr<input> converted;
	if (codes.substr(0, 3) == "\xEF\xBB\xBF"sv) {
		codes = codes.substr(3);
	}
	try {
		if (!codes.empty()) {
			converted = std::make_unique<input>(utf8_decode({&codes.front(), &codes.back() + 1}));
		} else {
			converted = std::make_unique<input>();
		}
	} catch (const std::range_error&) {
		return false;
	}
	error_list errors;
	try {
		State state;
		return ::yue::start_with(*converted, r, errors, &state);
	} catch (const ParserError&) {
		return false;
	} catch (const std::logic_error&) {
		return false;
	}
	return true;
}

ParseInfo YueParser::parse(std::string_view codes, rule& r, bool lax) {
	ParseInfo res;
	if (codes.substr(0, 3) == "\xEF\xBB\xBF"sv) {
		codes = codes.substr(3);
	}
	try {
		if (!codes.empty()) {
			res.codes = std::make_unique<input>(utf8_decode({&codes.front(), &codes.back() + 1}));
		} else {
			res.codes = std::make_unique<input>();
		}
	} catch (const std::exception&) {
		res.error = {"invalid text encoding"s, 1, 1};
		return res;
	}
	error_list errors;
	try {
		State state;
		state.lax = lax;
		res.node.set(::yue::parse(*(res.codes), r, errors, &state));
		if (state.exportCount > 0) {
			int index = 0;
			std::string moduleName;
			auto moduleStr = "_module_"s;
			do {
				moduleName = moduleStr + std::to_string(index);
				index++;
			} while (state.usedNames.find(moduleName) != state.usedNames.end());
			state.usedNames.insert(moduleName);
			res.moduleName = moduleName;
			res.exportDefault = state.exportDefault;
			res.exportMacro = state.exportMacro;
			res.exportMetatable = !state.exportMetatable && state.exportMetamethod;
		}
		res.usedNames = std::move(state.usedNames);
	} catch (const ParserError& err) {
		res.error = {err.what(), err.line, err.col};
		return res;
	} catch (const std::logic_error& err) {
		res.error = {err.what(), 1, 1};
		return res;
	}
	if (!errors.empty()) {
		const error& err = errors.front();
		switch (err.m_type) {
			case ERROR_TYPE::ERROR_SYNTAX_ERROR:
				res.error = {"syntax error"s, err.m_begin.m_line, err.m_begin.m_col};
				break;
			case ERROR_TYPE::ERROR_INVALID_EOF:
				res.error = {"invalid EOF"s, err.m_begin.m_line, err.m_begin.m_col};
				break;
		}
	}
	return res;
}

ParseInfo YueParser::parse(std::string_view astName, std::string_view codes, bool lax) {
	auto it = _rules.find(astName);
	if (it != _rules.end()) {
		return parse(codes, *it->second, lax);
	}
	ParseInfo info{};
	info.error = ParseInfo::Error{"invalid rule: "s + std::string{astName}, 1, 1};
	return info;
}

bool YueParser::match(std::string_view astName, std::string_view codes) {
	auto it = _rules.find(astName);
	if (it != _rules.end()) {
		auto rEnd = rule(*it->second >> eof());
		return parse(codes, rEnd, false).node;
	}
	return false;
}

std::string YueParser::toString(ast_node* node) {
	return utf8_encode({node->m_begin.m_it, node->m_end.m_it});
}

std::string YueParser::toString(input::iterator begin, input::iterator end) {
	return utf8_encode({begin, end});
}

bool YueParser::hasAST(std::string_view name) const {
	return _rules.find(name) != _rules.end();
}

YueParser& YueParser::shared() {
	thread_local static YueParser parser;
	return parser;
}

namespace Utils {
void replace(std::string& str, std::string_view from, std::string_view to) {
	size_t start_pos = 0;
	while ((start_pos = str.find(from, start_pos)) != std::string::npos) {
		str.replace(start_pos, from.size(), to);
		start_pos += to.size();
	}
}

void trim(std::string& str) {
	if (str.empty()) return;
	str.erase(0, str.find_first_not_of(" \t\r\n"));
	str.erase(str.find_last_not_of(" \t\r\n") + 1);
}

std::string toLuaDoubleString(const std::string& input) {
	std::string luaStr = "\"";
	for (char c : input) {
		switch (c) {
			case '\"': luaStr += "\\\""; break;
			case '\\': luaStr += "\\\\"; break;
			case '\n': luaStr += "\\n"; break;
			case '\r': luaStr += "\\r"; break;
			case '\t': luaStr += "\\t"; break;
			default:
				luaStr += c;
				break;
		}
	}
	luaStr += "\"";
	return luaStr;
}
} // namespace Utils

std::string ParseInfo::errorMessage(std::string_view msg, int errLine, int errCol, int lineOffset) const {
	if (!codes) {
		std::ostringstream buf;
		buf << errLine + lineOffset << ": "sv << msg;
		return buf.str();
	}
	const int ASCII = 255;
	const int contextLines = 2;

	std::vector<std::pair<input::iterator, input::iterator>> lines;
	auto lineStart = codes->begin();

	for (auto it = codes->begin(); it != codes->end(); ++it) {
		if (*it == '\n') {
			lines.emplace_back(lineStart, it);
			lineStart = it + 1;
		}
	}

	if (lineStart != codes->end()) {
		lines.emplace_back(lineStart, codes->end());
	}

	int totalLines = static_cast<int>(lines.size());
	int startLine = std::max(1, errLine - contextLines);
	int endLine = std::min(totalLines, errLine + contextLines);

	int maxLineNum = endLine + lineOffset;
	int lineNumWidth = 1;
	int temp = maxLineNum;
	while (temp >= 10) {
		temp /= 10;
		lineNumWidth++;
	}

	std::ostringstream buf;
	buf << errLine + lineOffset << ": " << msg << '\n';

	int errorDisplayCol = 0;
	if (errLine >= 1 && errLine <= totalLines) {
		auto& errorLineRange = lines[errLine - 1];

		auto it = errorLineRange.first;
		int displayCol = 0;
		for (int i = 0; i < errCol && it != errorLineRange.second; ++i) {
			if (*it == '\t') {
				displayCol += 2;
			} else if (*it > ASCII) {
				displayCol += 2;
			} else {
				displayCol++;
			}
			++it;
		}
		errorDisplayCol = displayCol;
	}
	errorDisplayCol = std::max(errorDisplayCol, 1);

	for (int lineNum = startLine; lineNum <= endLine; ++lineNum) {
		int displayLineNum = lineNum + lineOffset;
		if (displayLineNum <= 0) continue;
		std::string lineNumStr = std::to_string(displayLineNum);

		int padding = lineNumWidth - static_cast<int>(lineNumStr.size());
		buf << std::string(padding, ' ') << lineNumStr << " | ";

		if (lineNum >= 1 && lineNum <= totalLines) {
			auto& lineRange = lines[lineNum - 1];
			std::string line = utf8_encode({lineRange.first, lineRange.second});
			Utils::replace(line, "\t"sv, "  "sv);
			buf << line;
		}
		buf << '\n';

		if (lineNum == errLine) {
			buf << std::string(lineNumWidth, ' ') << "   ";
			buf << std::string(errorDisplayCol - 1, ' ') << "^"sv << '\n';
		}
	}

	return buf.str();
}

} // namespace yue
