rockspec_format = "3.0"
package = "E"
version = "dev-1"
source = {
	url = "git+https://github.com/pigpigyyy/E"
}
description = {
	summary = "E is a Moonscript dialect.",
	detailed = [[
	E is a Moonscript dialect. It is derived from Moonscript language 0.5.0 and continuously adopting new features to be more up to date. ]],
	homepage = "https://github.com/pigpigyyy/E",
	maintainer = "Li Jin <dragon-fly@qq.com>",
	labels = {"e","cpp","transpiler","moonscript"},
	license = "MIT"
}
dependencies = {
	"lua >= 5.1",
}
build = {
	type = "cmake",
	variables = {
		LUA = "$(LUA)",
		LUA_INCDIR = "$(LUA_INCDIR)",
		CMAKE_BUILD_TYPE="Release"
	},
	install = {
		lib = {
			"build.luarocks/e.so"
		},
		bin = {
			"build.luarocks/e"
		}
	}
}
