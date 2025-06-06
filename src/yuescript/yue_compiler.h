/* Copyright (c) 2017-2025 Li Jin <dragon-fly@qq.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#pragma once

#include <functional>
#include <list>
#include <memory>
#include <optional>
#include <string>
#include <string_view>
#include <tuple>
#include <unordered_map>
#include <vector>

namespace yue {

extern const std::string_view version;
extern const std::string_view extension;

using Options = std::unordered_map<std::string, std::string>;

struct YueConfig {
	bool lintGlobalVariable = false;
	bool implicitReturnRoot = true;
	bool reserveLineNumber = true;
	bool useSpaceOverTab = false;
	bool reserveComment = false;
	bool lax = false;
	// internal options
	bool exporting = false;
	bool profiling = false;
	int lineOffset = 0;
	std::string module;
	Options options;
};

enum class AccessType {
	None,
	Read,
	Capture,
	Write
};

struct GlobalVar {
	std::string name;
	int line;
	int col;
	AccessType accessType;
};

using GlobalVars = std::vector<GlobalVar>;

struct CompileInfo {
	std::string codes;
	struct Error {
		std::string msg;
		int line;
		int col;
		std::string displayMessage;
	};
	std::optional<Error> error;
	std::unique_ptr<GlobalVars> globals;
	std::unique_ptr<Options> options;
	double parseTime;
	double compileTime;
	bool usedVar;

	CompileInfo() { }
	CompileInfo(
		std::string&& codes,
		std::optional<Error>&& error,
		std::unique_ptr<GlobalVars>&& globals,
		std::unique_ptr<Options>&& options,
		double parseTime,
		double compileTime,
		bool usedVar);
	CompileInfo(CompileInfo&& other);
	void operator=(CompileInfo&& other);
};

class YueCompilerImpl;

class YueCompiler {
public:
	YueCompiler(void* luaState = nullptr,
		const std::function<void(void*)>& luaOpen = nullptr,
		bool sameModule = false);
	virtual ~YueCompiler();
	CompileInfo compile(std::string_view codes, const YueConfig& config = {});
	static void clear(void* luaState);

private:
	std::unique_ptr<YueCompilerImpl> _compiler;
};

} // namespace yue
