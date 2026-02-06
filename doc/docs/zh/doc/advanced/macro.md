# 宏

## 常见用法

&emsp;&emsp;宏函数用于在编译时执行一段代码来生成新的代码，并将生成的代码插入到最终编译结果中。

```yuescript
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'你好 世界'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- 宏函数参数传递的表达式会被转换为字符串
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```
<YueDisplay>

```yue
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'你好 世界'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- 宏函数参数传递的表达式会被转换为字符串
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

</YueDisplay>

## 直接插入代码

&emsp;&emsp;宏函数可以返回一个包含月之脚本代码的字符串，或是一个包含 Lua 代码字符串的配置表。

```yuescript
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "无法访问宏生成月之脚本里定义的变量"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "无法访问宏生成 Lua 代码里定义的变量"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- raw字符串的开始和结束符号会自动被去除了再传入宏函数
$lua[==[
-- 插入原始Lua代码
if cond then
  print("输出")
end
]==]
```
<YueDisplay>

```yue
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "无法访问宏生成月之脚本里定义的变量"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "无法访问宏生成 Lua 代码里定义的变量"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- raw字符串的开始和结束符号会自动被去除了再传入宏函数
$lua[==[
-- 插入原始Lua代码
if cond then
  print("输出")
end
]==]
```

</YueDisplay>

## 导出宏

&emsp;&emsp;宏函数可以从一个模块中导出，并在另一个模块中导入。你必须将导出的宏函数放在一个单独的文件中使用，而且只有宏定义、宏导入和宏展开可以放入这个宏导出模块中。

```yuescript
-- 文件: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- 文件 main.yue
import "utils" as {
  $, -- 表示导入所有宏的符号
  $foreach: $each -- 重命名宏 $foreach 为 $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```
<YueDisplay>

```yue
-- 文件: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- 文件 main.yue
-- 在浏览器中不支持import函数，请在真实环境中尝试
--[[
import "utils" as {
  $, -- 表示导入所有宏的符号
  $foreach: $each -- 重命名宏 $foreach 为 $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
]]
```

</YueDisplay>

## 内置宏

&emsp;&emsp;月之脚本中有一些内置可以直接使用的宏，但你可以通过声明相同名称的宏来覆盖它们。

```yuescript
print $FILE -- 获取当前模块名称的字符串
print $LINE -- 获取当前代码行数：2
```
<YueDisplay>

```yue
print $FILE -- 获取当前模块名称的字符串
print $LINE -- 获取当前代码行数：2
```

</YueDisplay>

## 用宏生成宏

&emsp;&emsp;在月之脚本中，宏函数允许你在编译时生成代码。通过嵌套的宏函数，你可以创建更复杂的生成模式。这个特性允许你定义一个宏函数，用它来生成另一个宏函数，从而实现更加动态的代码生成。

```yuescript
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "有效的枚举类型:", $BodyType Static
-- print "编译报错的枚举类型:", $BodyType Unknown
```
<YueDisplay>

```yue
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "有效的枚举类型:", $BodyType Static
-- print "编译报错的枚举类型:", $BodyType Unknown
```

</YueDisplay>

## 宏参数检查

&emsp;&emsp;可以直接在参数列表中声明期望的 AST 节点类型，并在编译时检查传入的宏参数是否符合预期。

```yuescript
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```
<YueDisplay>

```yue
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

</YueDisplay>

&emsp;&emsp;如果需要做更加灵活的参数检查操作，可以使用内置的 `$is_ast` 宏函数在合适的位置进行手动检查。

```yuescript
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```
<YueDisplay>

```yue
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

</YueDisplay>

&emsp;&emsp;更多关于可用 AST 节点的详细信息，请参考 [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp) 中大写的规则定义。
