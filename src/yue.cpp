/* Copyright (c) 2017-2026 Li Jin <dragon-fly@qq.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#include "yuescript/yue_compiler.h"
#include "yuescript/yue_parser.h"

#include <algorithm>
#include <chrono>
#include <condition_variable>
#include <cstdlib>
#include <deque>
#include <fstream>
#include <functional>
#include <future>
#include <iomanip>
#include <iostream>
#include <limits>
#include <memory>
#include <mutex>
#include <sstream>
#include <stdexcept>
#include <string_view>
#include <thread>
#include <tuple>
#include <vector>
using namespace std::string_view_literals;
using namespace std::string_literals;
using namespace std::chrono_literals;
#ifndef YUE_NO_WATCHER
#include "efsw/efsw.hpp"
#endif // YUE_NO_WATCHER
#include "ghc/fs_std.hpp"
#include "linenoise.hpp"

#if __has_include(<pthread.h>)
#include <pthread.h>
#endif

class AsyncPool {
public:
	explicit AsyncPool(size_t workerCount) {
		workerCount = std::max<size_t>(workerCount, 1);
#if __has_include(<pthread.h>)
		pthread_attr_t attr;
		pthread_attr_init(&attr);
		pthread_attr_setstacksize(&attr, 8 * 1024 * 1024);
		_workers.reserve(workerCount);
		for (size_t i = 0; i < workerCount; i++) {
			pthread_t worker;
			const int result = pthread_create(&worker, &attr, [](void* data) -> void* {
				static_cast<AsyncPool*>(data)->run();
				return nullptr;
			}, this);
			if (result != 0) {
				{
					std::lock_guard<std::mutex> lock(_mutex);
					_stopping = true;
				}
				_condition.notify_all();
				for (auto createdWorker : _workers) {
					pthread_join(createdWorker, nullptr);
				}
				pthread_attr_destroy(&attr);
				throw std::runtime_error("failed to create compiler worker thread");
			}
			_workers.push_back(worker);
		}
		pthread_attr_destroy(&attr);
#else
		_workers.reserve(workerCount);
		for (size_t i = 0; i < workerCount; i++) {
			_workers.emplace_back([this]() { run(); });
		}
#endif
	}

	~AsyncPool() {
		{
			std::lock_guard<std::mutex> lock(_mutex);
			_stopping = true;
		}
		_condition.notify_all();
#if __has_include(<pthread.h>)
		for (auto worker : _workers) {
			pthread_join(worker, nullptr);
		}
#else
		for (auto& worker : _workers) {
			worker.join();
		}
#endif
	}

	template<class R>
	std::future<R> async(const std::function<R()>& f) {
		auto task = std::make_shared<std::packaged_task<R()>>(f);
		auto result = task->get_future();
		{
			std::lock_guard<std::mutex> lock(_mutex);
			_tasks.emplace_back([task]() { (*task)(); });
		}
		_condition.notify_one();
		return result;
	}

private:
	void run() {
		while (true) {
			std::function<void()> task;
			{
				std::unique_lock<std::mutex> lock(_mutex);
				_condition.wait(lock, [this]() {
					return _stopping || !_tasks.empty();
				});
				if (_stopping && _tasks.empty()) return;
				task = std::move(_tasks.front());
				_tasks.pop_front();
			}
			task();
		}
	}

	std::mutex _mutex;
	std::condition_variable _condition;
	std::deque<std::function<void()>> _tasks;
	bool _stopping = false;
#if __has_include(<pthread.h>)
	std::vector<pthread_t> _workers;
#else
	std::vector<std::thread> _workers;
#endif
};

#if not(defined YUE_NO_MACRO && defined YUE_COMPILER_ONLY)
#define _DEFER(code, line) std::shared_ptr<void> _defer_##line(nullptr, [&](auto) { \
	code; \
})
#define DEFER(code) _DEFER(code, __LINE__)
extern "C" {
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"
int luaopen_yue(lua_State* L);
int luaopen_colibc_json(lua_State* L);
} // extern "C"

static void openlibs(void* state) {
	lua_State* L = static_cast<lua_State*>(state);
	int top = lua_gettop(L);
	DEFER(lua_settop(L, top));
	luaL_openlibs(L);
#if LUA_VERSION_NUM > 501
	luaL_requiref(L, "yue", luaopen_yue, 0);
	luaL_requiref(L, "cojson", luaopen_colibc_json, 0);
#else
	lua_pushcfunction(L, luaopen_yue);
	lua_call(L, 0, 0);
	lua_pushcfunction(L, luaopen_colibc_json);
	lua_call(L, 0, 0);
#endif
}

void pushYue(lua_State* L, std::string_view name) {
	lua_getglobal(L, "package"); // package
	lua_getfield(L, -1, "loaded"); // package loaded
	lua_getfield(L, -1, "yue"); // package loaded yue
	lua_pushlstring(L, &name.front(), name.size()); // package loaded yue name
	lua_gettable(L, -2); // loaded[name], package loaded yue item
	lua_insert(L, -4); // item package loaded yue
	lua_pop(L, 3); // item
}

void pushOptions(lua_State* L, int lineOffset) {
	lua_newtable(L);
	lua_pushliteral(L, "lint_global");
	lua_pushboolean(L, 0);
	lua_rawset(L, -3);
	lua_pushliteral(L, "implicit_return_root");
	lua_pushboolean(L, 1);
	lua_rawset(L, -3);
	lua_pushliteral(L, "reserve_line_number");
	lua_pushboolean(L, 1);
	lua_rawset(L, -3);
	lua_pushliteral(L, "space_over_tab");
	lua_pushboolean(L, 0);
	lua_rawset(L, -3);
	lua_pushliteral(L, "same_module");
	lua_pushboolean(L, 1);
	lua_rawset(L, -3);
	lua_pushliteral(L, "line_offset");
	lua_pushinteger(L, lineOffset);
	lua_rawset(L, -3);
}
#endif // not (defined YUE_NO_MACRO && defined YUE_COMPILER_ONLY)

#ifndef YUE_NO_MACRO
#define YUE_ARGS nullptr, openlibs
#else
#define YUE_ARGS
#endif // YUE_NO_MACRO

#ifndef YUE_COMPILER_ONLY
#include "luaminify_lua.h"

static void pushLuaminify(lua_State* L) {
	if (luaL_loadbuffer(L, luaminify_lua, sizeof(luaminify_lua) / sizeof(luaminify_lua[0]), "=(luaminify)") != 0) {
		std::string err = "failed to load luaminify module.\n"s + lua_tostring(L, -1);
		luaL_error(L, err.c_str());
	} else if (lua_pcall(L, 0, 1, 0) != 0) {
		std::string err = "failed to init luaminify module.\n"s + lua_tostring(L, -1);
		luaL_error(L, err.c_str());
	}
}
#endif // YUE_COMPILER_ONLY

fs::path getTargetFile(const fs::path& file, const fs::path& workPath, const fs::path& targetPath) {
	auto srcFile = fs::absolute(file);
	auto ext = srcFile.extension().string();
	for (auto& ch : ext) ch = std::tolower(ch);
	if (!ext.empty() && ext.substr(1) == yue::extension) {
		auto targetFile = targetPath / srcFile.lexically_relative(workPath);
		targetFile.replace_extension("lua"s);
		if (fs::exists(targetFile)) {
			return targetFile;
		}
	}
	return fs::path();
}

fs::path getTargetFileDirty(const fs::path& file, const fs::path& workPath, const fs::path& targetPath) {
	if (!fs::exists(file)) return fs::path();
	auto srcFile = fs::absolute(file);
	auto ext = srcFile.extension().string();
	for (auto& ch : ext) ch = std::tolower(ch);
	if (!fs::is_directory(srcFile) && !ext.empty() && ext.substr(1) == yue::extension) {
		auto targetFile = targetPath / srcFile.lexically_relative(workPath);
		targetFile.replace_extension("lua"s);
		if (fs::exists(targetFile)) {
			auto time = fs::last_write_time(targetFile);
			auto targetTime = fs::last_write_time(srcFile);
			if (time < targetTime) {
				return targetFile;
			}
		} else {
			return targetFile;
		}
	}
	return fs::path();
}

#ifndef YUE_NO_WATCHER

#ifndef YUE_COMPILER_ONLY
static std::string compileFile(const fs::path& file, yue::YueConfig conf, const fs::path& workPath, const fs::path& targetPath, bool minify, bool rewrite) {
#else
static std::string compileFile(const fs::path& file, yue::YueConfig conf, const fs::path& workPath, const fs::path& targetPath) {
#endif // YUE_COMPILER_ONLY
	auto srcFile = fs::absolute(file);
	auto targetFile = getTargetFileDirty(srcFile, workPath, targetPath);
	if (targetFile.empty()) return std::string();
	std::ifstream input(srcFile, std::ios::in);
	if (input) {
		std::string s(
			(std::istreambuf_iterator<char>(input)),
			std::istreambuf_iterator<char>());
		auto modulePath = srcFile.lexically_relative(workPath);
		if (modulePath.empty()) {
			modulePath = srcFile;
		}
		conf.module = modulePath.string();
		if (!workPath.empty()) {
			auto it = conf.options.find("path");
			if (it != conf.options.end()) {
				if (!it->second.empty()) {
					it->second += ';';
				}
				it->second += (fs::path(workPath) / "?.lua"sv).string();
			} else {
				conf.options["path"] = (fs::path(workPath) / "?.lua"sv).string();
			}
		}
		auto result = yue::YueCompiler{YUE_ARGS}.compile(s, conf);
		if (!result.error) {
			std::string targetExtension("lua"sv);
			if (result.options) {
				auto it = result.options->find("target_extension"s);
				if (it != result.options->end()) {
					targetExtension = it->second;
				}
			}
			if (targetFile.has_parent_path()) {
				fs::create_directories(targetFile.parent_path());
			}
			if (result.codes.empty()) {
				return "Built "s + modulePath.string() + '\n';
			}
			std::ofstream output(targetFile, std::ios::trunc | std::ios::out);
			if (output) {
				const auto& codes = result.codes;
#ifndef YUE_COMPILER_ONLY
				if (minify || rewrite) {
					lua_State* L = luaL_newstate();
					DEFER(lua_close(L));
					luaL_openlibs(L);
					pushLuaminify(L);
					lua_getfield(L, -1, rewrite ? "FormatYue" : "FormatMini");
					lua_pushlstring(L, codes.c_str(), codes.size());
					if (lua_pcall(L, 1, 1, 0) != 0) {
						std::string err = lua_tostring(L, -1);
						return (rewrite ? "Failed to rewrite: "s : "Failed to minify: "s) + modulePath.string() + '\n' + err + '\n';
					} else {
						size_t size = 0;
						const char* transformedCodes = lua_tolstring(L, -1, &size);
						output.write(transformedCodes, size);
						output.close();
						return (rewrite ? "Rewritten built "s : "Minified built "s) + modulePath.string() + '\n';
					}
				}
#endif // YUE_COMPILER_ONLY
				if (conf.reserveLineNumber) {
					auto head = "-- [yue]: "s + modulePath.string() + '\n';
					output.write(head.c_str(), head.size());
				}
				output.write(codes.c_str(), codes.size());
				return "Built "s + modulePath.string() + '\n';
			} else {
				return "Failed to write file: "s + targetFile.string() + '\n';
			}
		} else {
			return "Failed to compile: "s + modulePath.string() + '\n' + result.error.value().displayMessage + '\n';
		}
	} else {
		return "Failed to read file: "s + srcFile.string() + '\n';
	}
}
#endif // YUE_NO_WATCHER

#ifndef YUE_NO_WATCHER
class UpdateListener : public efsw::FileWatchListener {
public:
	void handleFileAction(efsw::WatchID, const std::string& dir, const std::string& filename, efsw::Action action, std::string) override {
		switch (action) {
			case efsw::Actions::Add:
#ifndef YUE_COMPILER_ONLY
				if (auto res = compileFile(fs::path(dir) / filename, config, workPath, targetPath, minify, rewrite); !res.empty()) {
#else // YUE_COMPILER_ONLY
				if (auto res = compileFile(fs::path(dir) / filename, config, workPath, targetPath); !res.empty()) {
#endif // YUE_COMPILER_ONLY
					std::cout << res;
				}
				break;
			case efsw::Actions::Delete: {
				auto targetFile = getTargetFile(fs::path(dir) / filename, workPath, targetPath);
				if (!targetFile.empty()) {
					fs::remove(targetFile);
					auto moduleFile = targetFile.lexically_relative(targetPath);
					if (moduleFile.empty()) {
						moduleFile = targetFile;
					}
					std::cout << "Deleted " << moduleFile.string() << '\n';
				}
				break;
			}
			case efsw::Actions::Modified:
#ifndef YUE_COMPILER_ONLY
				if (auto res = compileFile(fs::path(dir) / filename, config, workPath, targetPath, minify, rewrite); !res.empty()) {
#else // YUE_COMPILER_ONLY
				if (auto res = compileFile(fs::path(dir) / filename, config, workPath, targetPath); !res.empty()) {
#endif // YUE_COMPILER_ONLY
					std::cout << res;
				}
				break;
			case efsw::Actions::Moved:
				break;
			default:
				break;
		}
	}
	yue::YueConfig config;
	fs::path workPath;
	fs::path targetPath;
#ifndef YUE_COMPILER_ONLY
	bool rewrite = false;
	bool minify = false;
#endif // YUE_COMPILER_ONLY
};
#endif // YUE_NO_WATCHER

int main(int narg, const char** args) {
	const char* help =
		"Usage: yue\n"
		"       [options] [<file/directory>] ...\n"
#ifndef YUE_COMPILER_ONLY
		"       yue -e <code_or_file> [args...]\n"
#endif // YUE_COMPILER_ONLY
#ifndef YUE_NO_WATCHER
		"       yue -w [<directory>] [options]\n"
#endif // YUE_NO_WATCHER
		"       yue -\n\n"
		"Notes:\n"
		"   - '-' / '--' must be the first and only argument.\n"
		"   - '-o/--output' can not be used with multiple input files.\n"
#ifndef YUE_NO_WATCHER
		"   - '-w/--watch' can not be used with file input (directory only).\n"
#endif // YUE_NO_WATCHER
#ifndef YUE_COMPILER_ONLY
		"   - with '-e/--execute', remaining tokens are treated as script args.\n\n"
#else
		"\n"
#endif // YUE_COMPILER_ONLY
		"Options:\n"
		"   -h, --help                 Show this help message and exit.\n"
#ifndef YUE_COMPILER_ONLY
		"   -e <str>, --execute <str>  Execute a file or raw codes\n"
		"   -m, --minify               Generate minified codes\n"
		"   -r, --rewrite              Rewrite output to match original line numbers\n"
#endif // YUE_COMPILER_ONLY
		"   -t <output_to>, --output-to <output_to>\n"
		"                              Specify where to place compiled files\n"
		"   -o <file>, --output <file> Write output to file\n"
		"   -p, --print                Write output to standard out\n"
		"   -b, --benchmark            Dump compile time (doesn't write output)\n"
		"   -g, --globals              Dump global variables used in NAME LINE COLUMN\n"
		"   -s, --spaces               Use spaces in generated codes instead of tabs\n"
		"   -l, --line-numbers         Write line numbers from source codes\n"
		"   -j, --no-implicit-return   Disable implicit return at end of file\n"
		"   -c, --reserve-comments     Reserve comments before statement from source codes\n"
#ifndef YUE_NO_WATCHER
		"   -w [<dir>], --watch [<dir>]\n"
		"                              Watch changes and compile every file under directory\n"
#endif // YUE_NO_WATCHER
		"   -v, --version              Print version\n"
#ifndef YUE_COMPILER_ONLY
		"   -                          Read from standard in, print to standard out\n"
		"                              (Must be first and only argument)\n"
		"   --                         Same as '-' (kept for backward compatibility)\n\n"
		"   --target <version>         Specify the Lua version that codes will be generated to\n"
		"                              (version can only be 5.1 to 5.5)\n"
		"   --path <path_str>          Append an extra Lua search path string to package.path\n"
		"   --<key>=<value>            Pass compiler option in key=value form (existing behavior)\n\n"
		"   Execute without options to enter REPL, type symbol '$'\n"
		"   in a single line to start/stop multi-line mode\n"
#endif // YUE_COMPILER_ONLY
		;
#ifndef YUE_COMPILER_ONLY
	if (narg == 1) {
		linenoise::SetMultiLine(false);
		linenoise::SetCompletionCallback([](const char* editBuffer, std::vector<std::string>& completions) {
			std::string buf = editBuffer;
			std::string tmp = buf;
			yue::Utils::trim(tmp);
			if (tmp.empty()) return;
			std::string pre;
			auto pos = buf.find_first_not_of(" \t\n");
			if (pos != std::string::npos) {
				pre = buf.substr(0, pos);
			}
			switch (tmp[0]) {
				case 'b':
					completions.push_back(pre + "break");
					break;
				case 'c':
					completions.push_back(pre + "class ");
					completions.push_back(pre + "continue");
					break;
				case 'e':
					completions.push_back(pre + "else");
					completions.push_back(pre + "export ");
					break;
				case 'i':
					completions.push_back(pre + "import \"");
					break;
				case 'g':
					completions.push_back(pre + "global ");
					break;
				case 'l':
					completions.push_back(pre + "local ");
					break;
				case 'm':
					completions.push_back(pre + "macro ");
					break;
				case 's':
					completions.push_back(pre + "switch ");
					break;
				case 'u':
					completions.push_back(pre + "unless ");
					break;
				case 'w':
					completions.push_back(pre + "with ");
					completions.push_back(pre + "when ");
					break;
			}
		});
		lua_State* L = luaL_newstate();
		openlibs(L);
		DEFER(lua_close(L));
		pushYue(L, "insert_loader"sv);
		if (lua_pcall(L, 0, 0, 0) != 0) {
			std::cout << lua_tostring(L, -1) << '\n';
			return 1;
		}
		int count = 0;
		std::cout << "Yuescript "sv << yue::version << '\n';
		while (true) {
			count++;
			std::string codes;
			bool quit = linenoise::Readline("> ", codes);
			if (quit) return 0;
			linenoise::AddHistory(codes.c_str());
			yue::Utils::trim(codes);
			if (codes == "$"sv) {
				codes.clear();
				for (std::string line; !(quit = linenoise::Readline("", line));) {
					auto temp = line;
					yue::Utils::trim(temp);
					if (temp == "$"sv) {
						break;
					}
					codes += '\n';
					codes += line;
					linenoise::AddHistory(line.c_str());
					yue::Utils::trim(codes);
				}
				if (quit) return 0;
			}
			codes.insert(0, "global *\n"sv);
			int top = lua_gettop(L);
			DEFER(lua_settop(L, top));
			pushYue(L, "loadstring"sv);
			lua_pushlstring(L, codes.c_str(), codes.size());
			lua_pushstring(L, ("=(repl "s + std::to_string(count) + ')').c_str());
			pushOptions(L, -1);
			const std::string_view Err = "\033[35m"sv, Val = "\033[33m"sv, Stop = "\033[0m\n"sv;
			if (lua_pcall(L, 3, 2, 0) != 0) {
				std::cout << Err << lua_tostring(L, -1) << Stop;
				continue;
			}
			if (lua_isnil(L, -2) != 0) {
				std::string err = lua_tostring(L, -1);
				auto modName = "(repl "s + std::to_string(count) + "):"s;
				if (err.substr(0, modName.size()) == modName) {
					err = err.substr(modName.size());
				}
				std::cout << Err << err << Stop;
				continue;
			}
			lua_pop(L, 1);
			pushYue(L, "pcall"sv);
			lua_insert(L, -2);
			int last = lua_gettop(L) - 2;
			if (lua_pcall(L, 1, LUA_MULTRET, 0) != 0) {
				std::cout << Err << lua_tostring(L, -1) << Stop;
				continue;
			}
			int cur = lua_gettop(L);
			int retCount = cur - last;
			bool success = lua_toboolean(L, -retCount) != 0;
			if (success) {
				if (retCount > 1) {
					for (int i = 1; i < retCount; ++i) {
#if LUA_VERSION_NUM > 501
						std::cout << Val << luaL_tolstring(L, -retCount + i, nullptr) << Stop;
#else // LUA_VERSION_NUM
						lua_getglobal(L, "tostring");
						lua_pushvalue(L, -retCount + i - 1);
						lua_call(L, 1, 1);
						std::cout << Val << lua_tostring(L, -1) << Stop;
#endif // LUA_VERSION_NUM
						lua_pop(L, 1);
					}
				}
			} else {
				std::cout << Err << lua_tostring(L, -1) << Stop;
			}
		}
		std::cout << '\n';
		return 0;
	}
	bool minify = false;
	bool rewrite = false;
#endif // YUE_COMPILER_ONLY
	yue::YueConfig config;
	config.implicitReturnRoot = true;
	config.lintGlobalVariable = false;
	config.reserveLineNumber = false;
	config.useSpaceOverTab = false;
	bool writeToFile = true;
	bool dumpCompileTime = false;
	bool lintGlobal = false;
	bool watchFiles = false;
	std::string targetPath;
	std::string resultFile;
	std::string workPath;
	std::list<std::pair<std::string, std::string>> files;

	auto takeValue = [&](int& i, std::string_view arg, std::string_view optName) -> std::string {
		// supports: --opt=value, --opt value, -o value, -t value, etc.
		if (auto eq = arg.find('='); eq != std::string_view::npos) {
			return std::string(arg.substr(eq + 1));
		}
		if (i + 1 < narg) {
			++i;
			return std::string(args[i]);
		}
		std::cout << help;
		(void)optName;
		return std::string();
	};

	for (int i = 1; i < narg; ++i) {
		std::string arg = args[i];
		if (arg == "-"sv || arg == "--"sv) {
			if (i != 1) {
				std::cout << help;
				return 1;
			}
			if (narg != 2) {
				std::cout << help;
				return 1;
			}
			char ch;
			std::string codes;
			while ((ch = std::cin.get()) && !std::cin.eof()) {
				codes += ch;
			}
			yue::YueConfig conf;
			conf.implicitReturnRoot = true;
			conf.lintGlobalVariable = false;
			conf.reserveLineNumber = false;
			conf.useSpaceOverTab = true;
			auto result = yue::YueCompiler{YUE_ARGS}.compile(codes, conf);
			if (!result.error) {
				std::cout << result.codes;
				return 0;
			} else {
				std::ostringstream buf;
				std::cout << result.error.value().displayMessage << '\n';
				return 1;
			}
#ifndef YUE_COMPILER_ONLY
		} else if (arg == "-e"sv || arg == "--execute"sv || arg.rfind("--execute="sv, 0) == 0) {
			auto evalStr = takeValue(i, arg, "execute"sv);
			if (!evalStr.empty()) {
				lua_State* L = luaL_newstate();
				openlibs(L);
				DEFER(lua_close(L));
				pushYue(L, "insert_loader"sv);
				if (lua_pcall(L, 0, 0, 0) != 0) {
					std::cout << lua_tostring(L, -1) << '\n';
					return 1;
				}
				i++;
				auto setArgTable = [&](std::string_view scriptName, int tokensBeforeScript) {
					lua_newtable(L);
					for (int j = i, index = 1; j < narg; j++) {
						lua_pushstring(L, args[j]);
						lua_rawseti(L, -2, index);
						index++;
					}
					if (!scriptName.empty()) {
						lua_pushlstring(L, scriptName.data(), scriptName.size());
						lua_rawseti(L, -2, 0);
						for (int j = 0, index = -tokensBeforeScript; j < tokensBeforeScript; j++, index++) {
							lua_pushstring(L, args[j]);
							lua_rawseti(L, -2, index);
						}
					}
					lua_setglobal(L, "arg");
				};
				std::ifstream input(evalStr, std::ios::in);
				int argNum = 2;
				if (input) {
					setArgTable(evalStr, i - 1);
					auto ext = fs::path(evalStr).extension().string();
					for (auto& ch : ext) ch = std::tolower(ch);
					if (ext == ".lua") {
						lua_getglobal(L, "load");
					} else {
						pushYue(L, "loadstring"sv);
					}
					std::string s(
						(std::istreambuf_iterator<char>(input)),
						std::istreambuf_iterator<char>());
					lua_pushlstring(L, s.c_str(), s.size());
					lua_pushlstring(L, evalStr.c_str(), evalStr.size());
					if (ext != ".lua") {
						argNum = 3;
						lua_newtable(L);
						lua_newtable(L);
						for (int j = i; j < narg; j++) {
							std::string argItem = args[j];
							if (argItem.size() > 2 && argItem.substr(0, 2) == "--"sv && argItem.substr(2, 1) != "-"sv) {
								auto argStr = argItem.substr(2);
								yue::Utils::trim(argStr);
								size_t idx = argStr.find('=');
								if (idx != std::string::npos) {
									auto key = argStr.substr(0, idx);
									auto value = argStr.substr(idx + 1);
									yue::Utils::trim(key);
									yue::Utils::trim(value);
									lua_pushlstring(L, key.c_str(), key.size());
									lua_pushlstring(L, value.c_str(), value.size());
								} else {
									lua_pushlstring(L, argStr.c_str(), argStr.size());
									lua_pushliteral(L, "");
								}
								lua_rawset(L, -3);
							}
						}
						lua_setfield(L, -2, "options");
					}
				} else {
					setArgTable({ }, 0);
					pushYue(L, "loadstring"sv);
					lua_pushlstring(L, evalStr.c_str(), evalStr.size());
					lua_pushliteral(L, "=(eval str)");
				}
				if (lua_pcall(L, argNum, 2, 0) != 0) {
					std::cout << lua_tostring(L, -1) << '\n';
					return 1;
				}
				if (lua_isnil(L, -2) != 0) {
					std::cout << lua_tostring(L, -1) << '\n';
					return 1;
				}
				lua_pop(L, 1);
				pushYue(L, "pcall"sv);
				lua_insert(L, -2);
				int argCount = 0;
				while (i < narg) {
					argCount++;
					lua_pushstring(L, args[i]);
					i++;
				}
				if (lua_pcall(L, 1 + argCount, 2, 0) != 0) {
					std::cout << lua_tostring(L, -1) << '\n';
					return 1;
				}
				bool success = lua_toboolean(L, -2) != 0;
				if (!success) {
					std::cout << lua_tostring(L, -1) << '\n';
					return 1;
				}
				return 0;
			} else {
				return 1;
			}
		} else if (arg == "-m"sv || arg == "--minify"sv) {
			minify = true;
		} else if (arg == "-r"sv || arg == "--rewrite"sv) {
			rewrite = true;
#endif // YUE_COMPILER_ONLY
		} else if (arg == "-s"sv || arg == "--spaces"sv) {
			config.useSpaceOverTab = true;
		} else if (arg == "-l"sv || arg == "--line-numbers"sv) {
			config.reserveLineNumber = true;
		} else if (arg == "-c"sv || arg == "--reserve-comments"sv) {
			config.reserveComment = true;
		} else if (arg == "-j"sv || arg == "--no-implicit-return"sv) {
			config.implicitReturnRoot = false;
		} else if (arg == "-p"sv || arg == "--print"sv) {
			writeToFile = false;
		} else if (arg == "-g"sv || arg == "--globals"sv) {
			writeToFile = false;
			lintGlobal = true;
		} else if (arg == "-t"sv || arg == "--output-to"sv || arg.rfind("--output-to="sv, 0) == 0) {
			targetPath = takeValue(i, arg, "output-to"sv);
			if (targetPath.empty()) return 1;
		} else if (arg == "-b"sv || arg == "--benchmark"sv) {
			dumpCompileTime = true;
		} else if (arg == "-h"sv || arg == "--help"sv) {
			std::cout << help;
			return 0;
		} else if (arg == "-v"sv || arg == "--version"sv) {
			std::cout << "Yuescript version: "sv << yue::version << '\n';
			return 0;
		} else if (arg == "-o"sv || arg == "--output"sv || arg.rfind("--output="sv, 0) == 0) {
			resultFile = takeValue(i, arg, "output"sv);
			if (resultFile.empty()) return 1;
		} else if (arg == "-w"sv || arg == "--watch"sv || arg.rfind("--watch="sv, 0) == 0) {
#ifndef YUE_NO_WATCHER
			auto isOptionToken = [](std::string_view s) {
				return !s.empty() && (s[0] == '-' || (s.size() >= 2 && s.substr(0, 2) == "--"sv));
			};
			watchFiles = true;
			// accept optional directory value: -w <dir> / --watch <dir> / --watch=<dir>
			if (arg != "-w"sv) {
				auto watchDir = takeValue(i, arg, "watch"sv);
				if (watchDir.empty()) return 1;
				arg = watchDir;
				// fall through to directory/file handling below by re-processing as positional
				if (fs::is_directory(arg)) {
					workPath = arg;
					for (auto item : fs::recursive_directory_iterator(arg)) {
						if (!item.is_directory()) {
							auto ext = item.path().extension().string();
							for (char& ch : ext) ch = std::tolower(ch);
							if (!ext.empty() && ext.substr(1) == yue::extension) {
								files.emplace_back(item.path().string(), item.path().lexically_relative(arg).string());
							}
						}
					}
				} else if (!arg.empty()) {
					std::cout << help;
					return 1;
				}
				continue;
			} else if (i + 1 < narg && !isOptionToken(args[i + 1])) {
				// support -w <dir> while keeping old "-w <dir as positional>" behavior
				auto watchDir = takeValue(i, arg, "watch"sv);
				if (!watchDir.empty()) {
					arg = watchDir;
					if (fs::is_directory(arg)) {
						workPath = arg;
						for (auto item : fs::recursive_directory_iterator(arg)) {
							if (!item.is_directory()) {
								auto ext = item.path().extension().string();
								for (char& ch : ext) ch = std::tolower(ch);
								if (!ext.empty() && ext.substr(1) == yue::extension) {
									files.emplace_back(item.path().string(), item.path().lexically_relative(arg).string());
								}
							}
						}
					} else {
						std::cout << help;
						return 1;
					}
					continue;
				}
			}
#else
			std::cout << "Error: -w is not supported\n"sv;
			return 1;
#endif // YUE_NO_WATCHER
		} else if (arg == "--target"sv || arg.rfind("--target="sv, 0) == 0) {
			auto v = takeValue(i, arg, "target"sv);
			if (v.empty()) return 1;
			config.options["target"s] = v;
		} else if (arg == "--path"sv || arg.rfind("--path="sv, 0) == 0) {
			auto v = takeValue(i, arg, "path"sv);
			if (v.empty()) return 1;
			config.options["path"s] = v;
		} else if (arg.size() > 2 && arg.substr(0, 2) == "--"sv && arg.substr(2, 1) != "-"sv) {
			auto argStr = arg.substr(2);
			yue::Utils::trim(argStr);
			size_t idx = argStr.find('=');
			if (idx != std::string::npos) {
				auto key = argStr.substr(0, idx);
				auto value = argStr.substr(idx + 1);
				yue::Utils::trim(key);
				yue::Utils::trim(value);
				config.options[key] = value;
			} else {
				config.options[argStr] = std::string();
			}
		} else {
			if (fs::is_directory(arg)) {
				workPath = arg;
				for (auto item : fs::recursive_directory_iterator(arg)) {
					if (!item.is_directory()) {
						auto ext = item.path().extension().string();
						for (char& ch : ext) ch = std::tolower(ch);
						if (!ext.empty() && ext.substr(1) == yue::extension) {
							files.emplace_back(item.path().string(), item.path().lexically_relative(arg).string());
						}
					}
				}
			} else if (watchFiles) {
				std::cout << "Error: -w can not be used with file\n"sv;
				return 1;
			} else {
				workPath = fs::path(arg).parent_path().string();
				files.emplace_back(arg, arg);
			}
		}
	}
	if (!watchFiles && files.empty()) {
		std::cout << "no input files\n"sv;
		return 0;
	}
	if (!resultFile.empty() && files.size() > 1) {
		std::cout << "Error: -o can not be used with multiple input files\n"sv;
		return 1;
	}
#ifndef YUE_COMPILER_ONLY
	if (minify || rewrite) {
		if (minify) {
			rewrite = false;
		}
		if (rewrite) {
			config.reserveLineNumber = true;
		}
	}
#endif // YUE_COMPILER_ONLY
	const size_t workerCount = std::min(
		files.size(),
		static_cast<size_t>(std::max(1u, std::thread::hardware_concurrency())));
	AsyncPool pool(workerCount);
#ifndef YUE_NO_WATCHER
	if (watchFiles) {
		auto fullWorkPath = fs::absolute(fs::path(workPath)).string();
		auto fullTargetPath = fullWorkPath;
		if (!targetPath.empty()) {
			fullTargetPath = fs::absolute(fs::path(targetPath)).string();
		}
		std::list<std::future<std::string>> results;
		for (const auto& file : files) {
			auto task = pool.async<std::string>([=]() {
#ifndef YUE_COMPILER_ONLY
				return compileFile(fs::absolute(file.first), config, fullWorkPath, fullTargetPath, minify, rewrite);
#else
					return compileFile(fs::absolute(file.first), config, fullWorkPath, fullTargetPath);
#endif // YUE_COMPILER_ONLY
			});
			results.push_back(std::move(task));
		}
		for (auto& result : results) {
			std::string msg = result.get();
			if (!msg.empty()) {
				std::cout << msg;
			}
		}
		efsw::FileWatcher fileWatcher{};
		UpdateListener listener{};
		listener.config = config;
		listener.workPath = fullWorkPath;
		listener.targetPath = fullTargetPath;
#ifndef YUE_COMPILER_ONLY
		listener.minify = minify;
		if (minify) {
			listener.rewrite = false;
		} else {
			listener.rewrite = rewrite;
		}
#endif // YUE_COMPILER_ONLY
		fileWatcher.addWatch(workPath, &listener, true);
		fileWatcher.watch();
		while (true) {
			std::this_thread::sleep_for(10000ms);
		}
		return 0;
	}
#endif // YUE_NO_WATCHER
	std::list<std::future<std::tuple<int, std::string, std::string>>> results;
	for (const auto& file : files) {
		auto task = pool.async<std::tuple<int, std::string, std::string>>([=]() {
			std::ifstream input(file.first, std::ios::in);
			if (input) {
				std::string s(
					(std::istreambuf_iterator<char>(input)),
					std::istreambuf_iterator<char>());
				auto conf = config;
				conf.module = file.first;
				if (!workPath.empty()) {
					auto it = conf.options.find("path");
					if (it != conf.options.end()) {
						if (!it->second.empty()) {
							it->second += ';';
						}
						it->second += (fs::path(workPath) / "?.lua"sv).string();
					} else {
						conf.options["path"] = (fs::path(workPath) / "?.lua"sv).string();
					}
				}
				if (dumpCompileTime) {
					conf.profiling = true;
					auto result = yue::YueCompiler{YUE_ARGS}.compile(s, conf);
					if (!result.error) {
						std::ostringstream buf;
						buf << file.first << " \n"sv;
						buf << "Parse time:     "sv << std::setprecision(5) << result.parseTime * 1000 << " ms\n";
						buf << "Compile time:   "sv << std::setprecision(5) << result.compileTime * 1000 << " ms\n\n";
						return std::tuple{0, file.first, buf.str()};
					} else {
						std::ostringstream buf;
						buf << "Failed to compile: "sv << file.first << '\n';
						buf << result.error.value().displayMessage << '\n';
						return std::tuple{1, file.first, buf.str()};
					}
				}
				conf.lintGlobalVariable = lintGlobal;
				auto result = yue::YueCompiler{YUE_ARGS}.compile(s, conf);
				if (!result.error) {
					if (!writeToFile) {
						if (lintGlobal) {
							std::ostringstream buf;
							for (const auto& global : *result.globals) {
								buf << global.name << ' ' << global.line << ' ' << global.col << '\n';
							}
							return std::tuple{0, file.first, buf.str() + '\n'};
						} else {
							return std::tuple{0, file.first, result.codes + '\n'};
						}
					} else {
						std::string targetExtension("lua"sv);
						if (result.options) {
							auto it = result.options->find("target_extension"s);
							if (it != result.options->end()) {
								targetExtension = it->second;
							}
						}
						fs::path targetFile;
						if (!resultFile.empty()) {
							targetFile = resultFile;
						} else {
							if (!targetPath.empty()) {
								targetFile = fs::path(targetPath) / file.second;
							} else {
								targetFile = file.first;
							}
							targetFile.replace_extension('.' + targetExtension);
						}
						if (targetFile.has_parent_path()) {
							fs::create_directories(targetFile.parent_path());
						}
						if (result.codes.empty()) {
							return std::tuple{0, targetFile.string(), "Built "s + file.first + '\n'};
						}
						std::ofstream output(targetFile, std::ios::trunc | std::ios::out);
						if (output) {
							const auto& codes = result.codes;
							if (config.reserveLineNumber) {
								auto head = "-- [yue]: "s + file.first + '\n';
								output.write(head.c_str(), head.size());
							}
							output.write(codes.c_str(), codes.size());
							return std::tuple{0, targetFile.string(), "Built "s + file.first + '\n'};
						} else {
							return std::tuple{1, std::string(), "Failed to write file: "s + targetFile.string() + '\n'};
						}
					}
				} else {
					std::ostringstream buf;
					buf << "Failed to compile: "sv << file.first << '\n';
					buf << result.error.value().displayMessage << '\n';
					return std::tuple{1, std::string(), buf.str()};
				}
			} else {
				return std::tuple{1, std::string(), "Failed to read file: "s + file.first + '\n'};
			}
		});
		results.push_back(std::move(task));
	}
	int ret = 0;
#ifndef YUE_COMPILER_ONLY
	lua_State* L = nullptr;
	DEFER({
		if (L) lua_close(L);
	});
	if (minify || rewrite) {
		L = luaL_newstate();
		luaL_openlibs(L);
		pushLuaminify(L);
	}
#endif // YUE_COMPILER_ONLY
	std::list<std::string> errs;
	for (auto& result : results) {
		int val = 0;
		std::string file;
		std::string msg;
		try {
			std::tie(val, file, msg) = result.get();
		} catch (const std::range_error&) {
			std::cout << "invalid text encoding" << std::endl;
			return 1;
		}
		if (val != 0) {
			ret = val;
			errs.push_back(msg);
		} else {
#ifndef YUE_COMPILER_ONLY
			if (minify || rewrite) {
				std::ifstream input(file, std::ios::in);
				if (input) {
					std::string s;
					if (writeToFile) {
						s = std::string(
							(std::istreambuf_iterator<char>(input)),
							std::istreambuf_iterator<char>());
					} else {
						s = msg;
					}
					input.close();
					int top = lua_gettop(L);
					DEFER(lua_settop(L, top));
					lua_getfield(L, -1, rewrite ? "FormatYue" : "FormatMini");
					lua_pushlstring(L, s.c_str(), s.size());
					if (lua_pcall(L, 1, 1, 0) != 0) {
						ret = 2;
						std::string err = lua_tostring(L, -1);
						errs.push_back((rewrite ? "Failed to rewrite: "s : "Failed to minify: "s) + file + '\n' + err + '\n');
					} else {
						size_t size = 0;
						const char* transformedCodes = lua_tolstring(L, -1, &size);
						if (writeToFile) {
							std::ofstream output(file, std::ios::trunc | std::ios::out);
							output.write(transformedCodes, size);
							output.close();
							std::cout << (rewrite ? "Rewritten built "sv : "Minified built "sv) << file << '\n';
						} else {
							std::cout << transformedCodes << '\n';
						}
					}
				}
			} else {
				std::cout << msg;
			}
#else
			std::cout << msg;
#endif // YUE_COMPILER_ONLY
		}
	}
	for (const auto& err : errs) {
		std::cout << err;
	}
	return ret;
}
