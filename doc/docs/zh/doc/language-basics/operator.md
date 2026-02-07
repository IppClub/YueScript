# 操作符

&emsp;&emsp;Lua 的所有二元和一元操作符在月之脚本中都是可用的。此外，**!=** 符号是 **~=** 的别名，而 **\\** 或 **::** 均可用于编写链式函数调用，如写作 `tb\func!` 或 `tb::func!`。此外月之脚本还提供了一些其他特殊的操作符，以编写更具表达力的代码。

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

<YueDisplay>

```yue
tb\func! if tb ~= nil
tb::func! if tb != nil
```

</YueDisplay>

## 链式比较

&emsp;&emsp;你可以在月之脚本中进行比较表达式的链式书写：

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- 输出：true

a = 5
print 1 <= a <= 10
-- 输出：true
```

<YueDisplay>

```yue
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- 输出：true

a = 5
print 1 <= a <= 10
-- 输出：true
```

</YueDisplay>

&emsp;&emsp;可以注意一下链式比较表达式的求值行为：

```yuescript
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  输出：
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  输出：
  2
  1
  false
]]
```

<YueDisplay>

```yue
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  输出：
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  输出：
  2
  1
  false
]]
```

</YueDisplay>

&emsp;&emsp;在上面的例子里，中间的表达式 `v(2)` 仅被计算一次，如果把表达式写成 `v(1) < v(2) and v(2) <= v(3)` 的方式，中间的 `v(2)` 才会被计算两次。在链式比较中，求值的顺序往往是未定义的。所以强烈建议不要在链式比较中使用具有副作用（比如做打印操作）的表达式。如果需要使用有副作用的函数，应明确使用短路 `and` 运算符来做连接。

## 表追加

&emsp;&emsp;**[] =** 操作符用于向 Lua 表的最后插入值。

```yuescript
tab = []
tab[] = "Value"
```

<YueDisplay>

```yue
tab = []
tab[] = "Value"
```

</YueDisplay>

&emsp;&emsp;你还可以使用展开操作符 `...` 来将一个列表中的所有元素追加到另一个列表中：

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA 现在为 [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA 现在为 [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

## 表扩展

&emsp;&emsp;你可以使用前置 `...` 操作符在 Lua 表中插入数组表或哈希表。

```yuescript
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

<YueDisplay>

```yue
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

</YueDisplay>

## 表反向索引

&emsp;&emsp;你可以使用 **#** 操作符来反向索引表中的元素。

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

<YueDisplay>

```yue
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

</YueDisplay>

## 元表

&emsp;&emsp;**<>** 操作符可提供元表操作的快捷方式。

### 元表创建

&emsp;&emsp;使用空括号 **<>** 或被 **<>** 包围的元方法键创建普通的 Lua 表。

```yuescript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
-- 使用与临时变量名相同的字段名，将临时变量赋值给元表
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "超出范围"
```

<YueDisplay>

```yue
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
-- 使用与临时变量名相同的字段名，将临时变量赋值给元表
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "超出范围"
```

</YueDisplay>

### 元表访问

&emsp;&emsp;使用 **<>** 或被 **<>** 包围的元方法名或在 **<>** 中编写某些表达式来访问元表。

```yuescript
-- 使用包含字段 "value" 的元表创建
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```

<YueDisplay>

```yue
-- 使用包含字段 "value" 的元表创建
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value
tb.<> = __index: {item: "hello"}
print tb.item
```

</YueDisplay>

### 元表解构

&emsp;&emsp;使用被 **<>** 包围的元方法键解构元表。

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

<YueDisplay>

```yue
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

</YueDisplay>

## 存在性

&emsp;&emsp;**?** 运算符可以在多种上下文中用来检查存在性。

```yuescript
func?!
print abc?["你好 世界"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "你好"
  \close!
```

<YueDisplay>

```yue
func?!
print abc?["你好 世界"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "你好"
  \close!
```

</YueDisplay>

## 管道

&emsp;&emsp;与其使用一系列嵌套的函数调用，你还可以考虑使用运算符 **|>** 来传递值。

```yuescript
"你好" |> print
1 |> print 2 -- 将管道项作为第一个参数插入
2 |> print 1, _, 3 -- 带有占位符的管道

-- 多行的管道表达式
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

<YueDisplay>

```yue
"你好" |> print
1 |> print 2 -- 将管道项作为第一个参数插入
2 |> print 1, _, 3 -- 带有占位符的管道
-- 多行的管道表达式
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

</YueDisplay>

## 空值合并

&emsp;&emsp;如果其左操作数不是 **nil**，则nil合并运算符 **??** 返回其左操作数的值；否则，它将计算右操作数并返回其结果。如果左操作数计算结果为非 nil 的值，**??** 运算符将不再计算其右操作数。

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

<YueDisplay>

```yue
local a, b, c, d
a = b ?? c ?? d
func a ?? {}
a ??= false
```

</YueDisplay>

## 隐式对象

&emsp;&emsp;你可以在表格块内使用符号 **\*** 或是 **-** 开始编写一系列隐式结构。如果你正在创建隐式对象，对象的字段必须具有相同的缩进。

```yuescript
-- 赋值时使用隐式对象
list =
  * 1
  * 2
  * 3

-- 函数调用时使用隐式对象
func
  * 1
  * 2
  * 3

-- 返回时使用隐式对象
f = ->
  return
    * 1
    * 2
    * 3

-- 表格时使用隐式对象
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }
```

<YueDisplay>

```yue
-- 赋值时使用隐式对象
list =
  * 1
  * 2
  * 3

-- 函数调用时使用隐式对象
func
  * 1
  * 2
  * 3

-- 返回时使用隐式对象
f = ->
  return
    * 1
    * 2
    * 3

-- 表格时使用隐式对象
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }
```

</YueDisplay>
