# 月之脚本语言库

在 Lua 中使用 `local yue = require("yue")` 来访问。

## yue

**描述：**

月之脚本语言库。

### version

**类型：** 成员变量。

**描述：**

月之脚本版本。

**签名：**

```lua
version: string
```

### dirsep

**类型：** 成员变量。

**描述：**

当前平台的文件分隔符。

**签名：**

```lua
dirsep: string
```

### yue_compiled

**类型：** 成员变量。

**描述：**

编译模块代码缓存。

**签名：**

```lua
yue_compiled: {string: string}
```

### to_lua

**类型：** 函数。

**描述：**

月之脚本的编译函数。它将 YueScript 代码编译为 Lua 代码。

**签名：**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**参数：**

| 参数名 | 类型   | 描述                |
| ------ | ------ | ------------------- |
| code   | string | YueScript 代码。    |
| config | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型                            | 描述                                                                                       |
| ----------------------------------- | ------------------------------------------------------------------------------------------ |
| string \| nil                       | 编译后的 Lua 代码，如果编译失败则为 nil。                                                  |
| string \| nil                       | 错误消息，如果编译成功则为 nil。                                                           |
| {{string, integer, integer}} \| nil | 代码中出现的全局变量（带有名称、行和列），如果编译器选项 `lint_global` 为 false 则为 nil。 |

### file_exist

**类型：** 函数。

**描述：**

检查源文件是否存在的函数。可以覆盖该函数以自定义行为。

**签名：**

```lua
file_exist: function(filename: string): boolean
```

**参数：**

| 参数名   | 类型   | 描述     |
| -------- | ------ | -------- |
| filename | string | 文件名。 |

**返回值：**

| 返回类型 | 描述           |
| -------- | -------------- |
| boolean  | 文件是否存在。 |

### read_file

**类型：** 函数。

**描述：**

读取源文件的函数。可以覆盖该函数以自定义行为。

**签名：**

```lua
read_file: function(filename: string): string
```

**参数：**

| 参数名   | 类型   | 描述     |
| -------- | ------ | -------- |
| filename | string | 文件名。 |

**返回值：**

| 返回类型 | 描述       |
| -------- | ---------- |
| string   | 文件内容。 |

### insert_loader

**类型：** 函数。

**描述：**

将 YueScript 加载器插入到 Lua 包加载器（搜索器）中。

**签名：**

```lua
insert_loader: function(pos?: integer): boolean
```

**参数：**

| 参数名 | 类型    | 描述                                  |
| ------ | ------- | ------------------------------------- |
| pos    | integer | [可选] 要插入加载器的位置。默认为 3。 |

**返回值：**

| 返回类型 | 描述                                                 |
| -------- | ---------------------------------------------------- |
| boolean  | 是否成功插入加载器。如果加载器已经插入，则返回失败。 |

### remove_loader

**类型：** 函数。

**描述：**

从 Lua 包加载器（搜索器）中移除 YueScript 加载器。

**签名：**

```lua
remove_loader: function(): boolean
```

**返回值：**

| 返回类型 | 描述                                               |
| -------- | -------------------------------------------------- |
| boolean  | 是否成功移除加载器。如果加载器未插入，则返回失败。 |

### loadstring

**类型：** 函数。

**描述：**

将 YueScript 代码字符串加载为一个函数。

**签名：**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**参数：**

| 参数名    | 类型   | 描述                |
| --------- | ------ | ------------------- |
| input     | string | YueScript 代码。    |
| chunkname | string | 代码块的名称。      |
| env       | table  | 环境表。            |
| config    | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadstring

**类型：** 函数。

**描述：**

将 YueScript 代码字符串加载为一个函数。

**签名：**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**参数：**

| 参数名    | 类型   | 描述                |
| --------- | ------ | ------------------- |
| input     | string | YueScript 代码。    |
| chunkname | string | 代码块的名称。      |
| config    | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadstring

**类型：** 函数。

**描述：**

将 YueScript 代码字符串加载为一个函数。

**签名：**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**参数：**

| 参数名 | 类型   | 描述                |
| ------ | ------ | ------------------- |
| input  | string | YueScript 代码。    |
| config | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadfile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数。

**签名：**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| env      | table  | 环境表。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadfile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数。

**签名：**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### dofile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数并执行。

**签名：**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| env      | table  | 环境表。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型 | 描述                       |
| -------- | -------------------------- |
| any...   | 加载的函数执行后的返回值。 |

### dofile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数并执行。

**签名：**

```lua
dofile: function(filename: string, config?: Config): any...
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型 | 描述                       |
| -------- | -------------------------- |
| any...   | 加载的函数执行后的返回值。 |

### find_modulepath

**类型：** 函数。

**描述：**

将 YueScript 模块名解析为文件路径。

**签名：**

```lua
find_modulepath: function(name: string): string
```

**参数：**

| 参数名 | 类型   | 描述     |
| ------ | ------ | -------- |
| name   | string | 模块名。 |

**返回值：**

| 返回类型 | 描述       |
| -------- | ---------- |
| string   | 文件路径。 |

### pcall

**类型：** 函数。

**描述：**

在保护模式下调用一个函数。
会捕获任何错误，执行成功则返回成功状态和结果，否则为失败状态和错误信息。
当发生错误时，将错误信息中的代码行号重写为 YueScript 代码中的原始行号。

**签名：**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**参数：**

| 参数名 | 类型     | 描述                 |
| ------ | -------- | -------------------- |
| f      | function | 要调用的函数。       |
| ...    | any      | 要传递给函数的参数。 |

**返回值：**

| 返回类型     | 描述                         |
| ------------ | ---------------------------- |
| boolean, ... | 状态码和函数结果或错误信息。 |

### require

**类型：** 函数。

**描述：**

加载给定的模块。可以是 Lua 模块或 YueScript 模块。
如果模块是 YueScript 模块且加载失败，则将错误信息中的代码行号重写为 YueScript 代码中的原始行号。

**签名：**

```lua
require: function(name: string): any...
```

**参数：**

| 参数名  | 类型   | 描述             |
| ------- | ------ | ---------------- |
| modname | string | 要加载的模块名。 |

**返回值：**

| 返回类型 | 描述                                                                                                                                                 |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| any      | 如果模块已经加载，则返回 package.loaded[modname] 中存储的值。否则，尝试查找加载器并返回 package.loaded[modname] 的最终值和加载器数据作为第二个结果。 |

### p

**类型：** 函数。

**描述：**

检查传递的值的内部结构，并打印值出它的字符串表示。

**签名：**

```lua
p: function(...: any)
```

**参数：**

| 参数名 | 类型 | 描述         |
| ------ | ---- | ------------ |
| ...    | any  | 要检查的值。 |

### options

**类型：** 成员变量。

**描述：**

当前编译器选项。

**签名：**

```lua
options: Config.Options
```

### traceback

**类型：** 函数。

**描述：**

重写堆栈跟踪中的行号为 YueScript 代码中的原始行号的 traceback 函数。

**签名：**

```lua
traceback: function(message: string): string
```

**参数：**

| 参数名  | 类型   | 描述           |
| ------- | ------ | -------------- |
| message | string | 堆栈跟踪消息。 |

**返回值：**

| 返回类型 | 描述                   |
| -------- | ---------------------- |
| string   | 重写后的堆栈跟踪消息。 |

### is_ast

**类型：** 函数。

**描述：**

检查代码是否匹配指定的 AST。

**签名：**

```lua
is_ast: function(astName: string, code: string): boolean
```

**参数：**

| 参数名  | 类型   | 描述       |
| ------- | ------ | ---------- |
| astName | string | AST 名称。 |
| code    | string | 代码。     |

**返回值：**

| 返回类型 | 描述               |
| -------- | ------------------ |
| boolean  | 代码是否匹配 AST。 |

### AST

**类型：** 成员变量。

**描述：**

AST 类型定义，带有名称、行、列和子节点。

**签名：**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**类型：** 函数。

**描述：**

将代码转换为 AST。

**签名：**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**参数：**

| 参数名         | 类型    | 描述                                                                           |
| -------------- | ------- | ------------------------------------------------------------------------------ |
| code           | string  | 代码。                                                                         |
| flattenLevel   | integer | [可选] 扁平化级别。级别越高，会消除更多的 AST 结构的嵌套。默认为 0。最大为 2。 |
| astName        | string  | [可选] AST 名称。默认为 "File"。                                               |
| reserveComment | boolean | [可选] 是否保留原始注释。默认为 false。                                        |

**返回值：**

| 返回类型      | 描述                             |
| ------------- | -------------------------------- |
| AST \| nil    | AST，如果转换失败则为 nil。      |
| string \| nil | 错误消息，如果转换成功则为 nil。 |

### format

**类型：** 函数。

**描述：**

格式化 YueScript 代码。

**签名：**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**参数：**

| 参数名         | 类型    | 描述                                   |
| -------------- | ------- | -------------------------------------- |
| code           | string  | 代码。                                 |
| tabSize        | integer | [可选] 制表符大小。默认为 4。          |
| reserveComment | boolean | [可选] 是否保留原始注释。默认为 true。 |

**返回值：**

| 返回类型 | 描述             |
| -------- | ---------------- |
| string   | 格式化后的代码。 |

### \_\_call

**类型：** 元方法。

**描述：**

导入 YueScript 模块。
如果发生加载失败，则将错误信息中的代码行号重写为 YueScript 代码中的原始行号。

**签名：**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**参数：**

| 参数名 | 类型   | 描述     |
| ------ | ------ | -------- |
| module | string | 模块名。 |

**返回值：**

| 返回类型 | 描述     |
| -------- | -------- |
| any      | 模块值。 |

## Config

**描述：**

编译器编译选项。

### lint_global

**类型：** 成员变量。

**描述：**

编译器是否应该收集代码中出现的全局变量。

**签名：**

```lua
lint_global: boolean
```

### implicit_return_root

**类型：** 成员变量。

**描述：**

编译器是否应该对根层级的代码块进行隐式的表达式返回。

**签名：**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**类型：** 成员变量。

**描述：**

编译器是否应该在编译后的代码中保留原始行号。

**签名：**

```lua
reserve_line_number: boolean
```

### reserve_comment

**类型：** 成员变量。

**描述：**

编译器是否应该在编译后的代码中保留原始注释。

**签名：**

```lua
reserve_comment: boolean
```

### space_over_tab

**类型：** 成员变量。

**描述：**

编译器是否应该在编译后的代码中使用空格字符而不是制表符字符。

**签名：**

```lua
space_over_tab: boolean
```

### same_module

**类型：** 成员变量。

**描述：**

编译器是否应该将要编译的代码视为当前正在编译的模块。仅供编译器内部使用。

**签名：**

```lua
same_module: boolean
```

### line_offset

**类型：** 成员变量。

**描述：**

编译器错误消息是否应该包含行号偏移量。仅供编译器内部使用。

**签名：**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**类型：** 枚举。

**描述：**

目标 Lua 版本枚举。

**签名：**

```lua
enum LuaTarget
  "5.1"
  "5.2"
  "5.3"
  "5.4"
  "5.5"
end
```

### options

**类型：** 成员变量。

**描述：**

要传递给编译函数的额外选项。

**签名：**

```lua
options: Options
```

## Options

**描述：**

额外编译器选项定义。

### target

**类型：** 成员变量。

**描述：**

编译目标 Lua 版本。

**签名：**

```lua
target: LuaTarget
```

### path

**类型：** 成员变量。

**描述：**

额外模块搜索路径。

**签名：**

```lua
path: string
```

### dump_locals

**类型：** 成员变量。

**描述：**

是否在回溯错误消息中输出代码块的局部变量。默认为 false。

**签名：**

```lua
dump_locals: boolean
```

### simplified

**类型：** 成员变量。

**描述：**

是否简化输出的错误消息。默认为 true。

**签名：**

```lua
simplified: boolean
```
