#include <iostream>
#include <string>
#include <string_view>

#include "yuescript/yue_compiler.h"

extern "C" {
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"
int luaopen_yue(lua_State* L);
}

namespace {

size_t moduleCount(lua_State* L) {
	lua_pushliteral(L, "__yue_modules__");
	lua_rawget(L, LUA_REGISTRYINDEX);
#if LUA_VERSION_NUM > 501
	const size_t count = lua_isnil(L, -1) ? 0 : lua_rawlen(L, -1);
#else
	const size_t count = lua_isnil(L, -1) ? 0 : lua_objlen(L, -1);
#endif
	lua_pop(L, 1);
	return count;
}

bool expect(bool condition, std::string_view message) {
	if (!condition) {
		std::cerr << "same_module state test failed: " << message << '\n';
	}
	return condition;
}

} // namespace

int main() {
	constexpr std::string_view defineAndUse =
		"macro double = (x) -> \"#{x} * 2\"\n"
		"result = $double 5\n";
	constexpr std::string_view failAfterMacro =
		"macro double = (x) -> \"#{x} * 2\"\n"
		"result = $missing 5\n";
	constexpr std::string_view useOnly = "result = $double 7\n";

	lua_State* L = luaL_newstate();
	if (!expect(L != nullptr, "failed to create Lua state")) return 1;
	luaL_openlibs(L);
#if LUA_VERSION_NUM > 501
	luaL_requiref(L, "yue", luaopen_yue, 0);
#else
	lua_pushcfunction(L, luaopen_yue);
	lua_call(L, 0, 1);
#endif
	lua_pop(L, 1);

	yue::YueConfig config;
	bool passed = true;
	{
		yue::YueCompiler compiler(L, nullptr, true);
		std::string expectedCodes;
		for (int i = 0; i < 500; i++) {
			auto result = compiler.compile(defineAndUse, config);
			passed &= expect(!result.error, "repeated compilation returned an error");
			if (i == 0) {
				expectedCodes = result.codes;
			} else {
				passed &= expect(result.codes == expectedCodes, "repeated compilation changed its output");
			}
		}
		passed &= expect(moduleCount(L) == 1, "repeated compilation grew the module registry");
	}

	yue::YueCompiler::clear(L);
	{
		yue::YueCompiler compiler(L, nullptr, true);
		auto failed = compiler.compile(failAfterMacro, config);
		passed &= expect(failed.error.has_value(), "expected macro expansion failure");
		auto next = compiler.compile(useOnly, config);
		passed &= expect(next.error.has_value(), "failed compilation leaked a macro into the next compilation");
		passed &= expect(moduleCount(L) == 1, "failed compilation grew the module registry");
	}

	yue::YueCompiler::clear(L);
	{
		yue::YueCompiler compiler(L, nullptr, true);
		passed &= expect(!compiler.compile(defineAndUse, config).error, "initial live-clear compilation failed");
		yue::YueCompiler::clear(L);
		passed &= expect(!compiler.compile(defineAndUse, config).error, "compiler did not rebuild a cleared registry");
		passed &= expect(moduleCount(L) == 1, "rebuilt registry has an unexpected module count");
	}

	yue::YueCompiler::clear(L);
	{
		yue::YueCompiler compiler(L, nullptr, false);
		passed &= expect(!compiler.compile(defineAndUse, config).error, "isolated compilation failed");
		passed &= expect(moduleCount(L) == 0, "sameModule=false retained a module");
	}

	yue::YueCompiler::clear(L);
	lua_close(L);
	if (passed) {
		std::cout << "same_module state test passed\n";
		return 0;
	}
	return 1;
}
