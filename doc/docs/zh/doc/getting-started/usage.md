# 使用方法

## Lua 模块

&emsp;&emsp;在 Lua 中使用月之脚本模块：

* **用法 1**

	&emsp;&emsp;在 Lua 中引入 "你的脚本入口文件.yue"。

	```Lua
	require("yue")("你的脚本入口文件")
	```

	&emsp;&emsp;当你在同一路径下把 "你的脚本入口文件.yue" 编译成了 "你的脚本入口文件.lua" 时，仍然可以使用这个代码加载 .lua 代码文件。在其余的月之脚本文件中，只需正常使用 **require** 或 **import** 进行脚本引用即可。错误消息中的代码行号也会被正确处理。

* **用法 2**

	&emsp;&emsp;手动引入月之脚本模块并重写错误消息来帮助调试。
	```lua
	local yue = require("yue")
	yue.insert_loaders()
	local success, result = xpcall(function()
	  return require("yuescript_module_name")
	end, function(err)
	  return yue.traceback(err)
	end)
	```

* **用法 3**

	&emsp;&emsp;在 Lua 中使用月之脚本编译器功能。
	```lua
	local yue = require("yue")
	local codes, err, globals = yue.to_lua([[
	f = ->
	  print "hello world"
	f!
	]],{
	  implicit_return_root = true,
	  reserve_line_number = true,
	  lint_global = true,
	  space_over_tab = false,
	  options = {
	    target = "5.4",
	    path = "/script"
	  }
	})
	```

## 月之脚本编译工具

&emsp;&emsp;使用月之脚本编译工具：

```shell
> yue -h
命令行用法: yue
         [选项] [<文件/目录>] ...
         yue -e <代码或文件> [参数...]
         yue -w [<目录>] [选项]
         yue -

说明:
   - '-' 或 '--' 必须作为唯一且第一个参数，用于读取标准输入。
   - '-o/--output' 不能与多个输入文件一起使用。
   - '-w/--watch' 仅能用于目录，不能用于单个文件。
   - 使用 '-e/--execute' 时，后续的参数将作为脚本参数传递。

选项:
   -h, --help                 显示帮助信息并退出
   -e <字符串>, --execute <字符串>  执行文件或原始代码
   -m, --minify               生成压缩（最小化）代码
   -r, --rewrite              重写输出以匹配原始代码行号
   -t <目标路径>, --output-to <目标路径>
                              指定编译后文件的输出路径
   -o <文件>, --output <文件>  将输出写入文件
   -p, --print                输出到标准输出
   -b, --benchmark            输出编译耗时（不写入文件）
   -g, --globals              显示用到的全局变量及其所在的名称、行号、列号
   -s, --spaces               用空格代替制表符(tab)输出代码
   -l, --line-numbers         输出源代码的行号
   -j, --no-implicit-return   禁用文件末尾的隐式返回
   -c, --reserve-comments     保留源代码中的注释
   -w [<目录>], --watch [<目录>]
                              监视目录变化并自动编译
   -v, --version              显示版本信息
   -                          从标准输入读取，输出到标准输出（仅能作为唯一参数）
   --                         等同于 '-'，为兼容旧版本保留

   --target <版本>            指定生成代码的 Lua 版本 (只能为 5.1 ~ 5.5)
   --path <路径字符串>         附加一个 Lua 搜索路径到 package.path
   --<键>=<值>                以 key=value 形式传递编译器选项（保持已有用法）

   不带选项直接运行可进入交互模式（REPL），在交互模式里输入单独的符号 '$'
   可用于开始或结束多行模式。
```

&emsp;&emsp;使用案例：

&emsp;&emsp;递归编译当前路径下扩展名为 **.yue** 的每个月之脚本文件： **yue .**

&emsp;&emsp;编译并将结果保存到目标路径： **yue -t /target/path/ .**

&emsp;&emsp;编译并保留调试信息： **yue -l .**

&emsp;&emsp;编译并生成压缩代码： **yue -m .**

&emsp;&emsp;直接执行代码： **yue -e 'print 123'**

&emsp;&emsp;执行一个月之脚本文件： **yue -e main.yue**
