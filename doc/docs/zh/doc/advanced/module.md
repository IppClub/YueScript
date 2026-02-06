# 模块

## 导入

&emsp;&emsp;导入语句是一个语法糖，用于需要引入一个模块或者从已导入的模块中提取子项目。从模块导入的变量默认为不可修改的常量。

```yuescript
-- 用作表解构
do
  import insert, concat from table
  -- 当给 insert, concat 变量赋值时，编译器会报告错误
  import C, Ct, Cmt from require "lpeg"
  -- 快捷写法引入模块的子项
  import x, y, z from 'mymodule'
  -- 使用Python风格的导入
  from 'module' import a, b, c

-- 快捷地导入一个模块
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- 导入模块后起一个别名使用，或是进行导入模块表的解构
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```
<YueDisplay>

```yue
-- 用作表解构
do
  import insert, concat from table
  -- 当给 insert, concat 变量赋值时，编译器会报告错误
  import C, Ct, Cmt from require "lpeg"
  -- 快捷写法引入模块的子项
  import x, y, z from 'mymodule'
  -- 使用Python风格的导入
  from 'module' import a, b, c

-- 快捷地导入一个模块
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- 导入模块后起一个别名使用，或是进行导入模块表的解构
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

</YueDisplay>

## 导入全局变量

&emsp;&emsp;你可以使用 `import` 将指定的全局变量导入到本地变量中。当导入一系列对全局变量的链式访问时，最后一个访问的字段将被赋值给本地变量。

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```
<YueDisplay>

```yue
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

</YueDisplay>

### 自动全局变量导入

&emsp;&emsp;在一个代码块的顶部写 `import global`，会将当前作用域中尚未显式声明或赋值过的变量名，自动导入为本地常量，并在该语句的位置绑定到同名的全局变量。

&emsp;&emsp;但是在同一作用域中被显式声明为全局的变量不会被自动导入，因此可以继续进行赋值操作。

```yuescript
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- 报错：自动导入的全局变量为常量

do
  -- 被显式声明为全局的变量不会被自动导入
  import global
  global FLAG
  print FLAG
  FLAG = 123
```
<YueDisplay>

```yue
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- 报错：自动导入的全局变量是常量

do
  -- 被显式声明为全局的变量不会被自动导入
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

</YueDisplay>

## 导出

&emsp;&emsp;导出语句提供了一种简洁的方式来定义当前的模块。

### 命名导出

&emsp;&emsp;带命名的导出将定义一个局部变量，并在导出的表中添加一个同名的字段。

```yuescript
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```
<YueDisplay>

```yue
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

</YueDisplay>

&emsp;&emsp;使用解构进行命名导出。

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = '默认值'}} = tb
```
<YueDisplay>

```yue
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = '默认值'}} = tb
```

</YueDisplay>

&emsp;&emsp;从模块导出命名项目时，可以不用创建局部变量。

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```
<YueDisplay>

```yue
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

</YueDisplay>

### 未命名导出

&emsp;&emsp;未命名导出会将要导出的目标项目添加到导出表的数组部分。

```yuescript
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```
<YueDisplay>

```yue
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

</YueDisplay>

### 默认导出

&emsp;&emsp;在导出语句中使用 **default** 关键字，来替换导出的表为一个目标的对象。

```yuescript
export default ->
  print "你好"
  123
```
<YueDisplay>

```yue
export default ->
  print "你好"
  123
```

</YueDisplay>
