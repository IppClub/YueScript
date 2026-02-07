# 函数字面量

&emsp;&emsp;所有函数都是使用月之脚本的函数表达式创建的。一个简单的函数可以用箭头表示为：**->**。

```yuescript
my_function = ->
my_function() -- 调用空函数
```

<YueDisplay>

```yue
my_function = ->
my_function() -- 调用空函数
```

</YueDisplay>

&emsp;&emsp;函数体可以是紧跟在箭头后的一个语句，或者是在后面的行上使用同样缩进的一系列语句：

```yuescript
func_a = -> print "你好，世界"

func_b = ->
  value = 100
  print "这个值是：", value
```

<YueDisplay>

```yue
func_a = -> print "你好，世界"

func_b = ->
  value = 100
  print "这个值是：", value
```

</YueDisplay>

&emsp;&emsp;如果一个函数没有参数，可以使用 **\!** 操作符调用它，而不是空括号。使用 **\!** 调用没有参数的函数是推荐的写法。

```yuescript
func_a!
func_b()
```

<YueDisplay>

```yue
func_a!
func_b()
```

</YueDisplay>

&emsp;&emsp;带有参数的函数可以通过在箭头前加上括号中的参数名列表来进行创建：

```yuescript
sum = (x, y) -> print "数字的和", x + y
```

<YueDisplay>

```yue
sum = (x, y) -> print "数字的和", x + y
```

</YueDisplay>

&emsp;&emsp;函数可以通过在函数名后列出参数来调用。当对函数做嵌套的调用时，后面列出的参数会应用于左侧最近的函数。

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

<YueDisplay>

```yue
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

</YueDisplay>

&emsp;&emsp;为了避免在调用函数时产生歧义，也可以使用括号将参数括起来。比如在以下的例子中是必需的，这样才能确保参数被传入到正确的函数。

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

<YueDisplay>

```yue
print "x:", sum(10, 20), "y:", sum(30, 40)
```

</YueDisplay>

&emsp;&emsp;注意：函数名与开始括号之间不能有任何空格。

&emsp;&emsp;函数会将函数体中的最后一个语句强制转换为返回语句，这被称作隐式返回：

```yuescript
sum = (x, y) -> x + y
print "数字的和是", sum 10, 20
```

<YueDisplay>

```yue
sum = (x, y) -> x + y
print "数字的和是", sum 10, 20
```

</YueDisplay>

&emsp;&emsp;如果你需要做显式返回，可以使用 return 关键字：

```yuescript
sum = (x, y) -> return x + y
```

<YueDisplay>

```yue
sum = (x, y) -> return x + y
```

</YueDisplay>

&emsp;&emsp;就像在Lua中一样，函数可以返回多个值。最后一个语句必须是由逗号分隔的值列表：

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

<YueDisplay>

```yue
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

</YueDisplay>

## 粗箭头

&emsp;&emsp;因为在 Lua 中调用方法时，经常习惯将对象作为第一个参数传入，所以月之脚本提供了一种特殊的语法来创建自动包含 self 参数的函数。

```yuescript
func = (num) => @value + num
```

<YueDisplay>

```yue
func = (num) => @value + num
```

</YueDisplay>

## 参数默认值

&emsp;&emsp;可以为函数的参数提供默认值。如果参数的值为 nil，则确定该参数为空。任何具有默认值的 nil 参数在函数体运行之前都会被替换。

```yuescript
my_function = (name = "某物", height = 100) ->
  print "你好，我是", name
  print "我的高度是", height
```

<YueDisplay>

```yue
my_function = (name = "某物", height = 100) ->
  print "你好，我是", name
  print "我的高度是", height
```

</YueDisplay>

&emsp;&emsp;函数参数的默认值表达式在函数体中会按参数声明的顺序进行计算。因此，在默认值的表达式中可以访问先前声明的参数。

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

<YueDisplay>

```yue
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

</YueDisplay>

## 注意事项

&emsp;&emsp;由于月之脚本支持无需括号的表达式式函数调用，因此为了避免因空白字符造成的解析歧义，需要进行一些限制。

&emsp;&emsp;减号（-）在表达式中既可以作为一元取反操作符，也可以作为二元减法操作符。请注意下面这些示例的编译方式：

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

<YueDisplay>

```yue
a = x - 10
b = x-10
c = x -y
d = x- z
```

</YueDisplay>

&emsp;&emsp;当函数调用的第一个参数是字符串字面量时，可以通过空白控制其优先级。在 Lua 中，常见的写法是调用仅有一个字符串或表字面量参数的函数时省略括号。

&emsp;&emsp;当变量名和字符串字面量之间没有空格时，函数的调用优先级高于后续表达式，因此此时无法再传入其他参数。

&emsp;&emsp;当变量名和字符串字面量之间有空格时，字符串字面量会作为后续表达式（如果存在）的参数，这样可以传递参数列表。

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```

<YueDisplay>

```yue
x = func"hello" + 100
y = func "hello" + 100
```

</YueDisplay>

## 多行参数

&emsp;&emsp;当调用接收大量参数的函数时，将参数列表分成多行是很方便的。由于月之脚本语言对空白字符的敏感性，做参数列表的分割时务必要小心。

&emsp;&emsp;如果要将参数列表写到下一行，那么当前行必须以逗号结束。并且下一行的缩进必须比当前的缩进多。一旦做了参数的缩进，所有其他参数列表的行必须保持相同的缩进级别，以成为参数列表的一部分。

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

<YueDisplay>

```yue
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

</YueDisplay>

&emsp;&emsp;这种调用方式可以做嵌套。并通过缩进级别来确定参数属于哪一个函数。

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

<YueDisplay>

```yue
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

</YueDisplay>

&emsp;&emsp;因为 Lua 表也使用逗号作为分隔符，这种缩进语法有助于让值成为参数列表的一部分，而不是 Lua 表的一部分。

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

<YueDisplay>

```yue
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

</YueDisplay>

&emsp;&emsp;有个不常见的写法可以注意一下，如果我们将在后面使用较低的缩进，我们可以为函数参数提供更深的缩进来区分列表的归属。

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

<YueDisplay>

```yue
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

</YueDisplay>

&emsp;&emsp;对于其它有代码块跟随的语句，比如条件语句，也可以通过小心安排缩进来做类似的事。比如我们可以通过调整缩进级别来控制一些值归属于哪个语句：

```yuescript
if func 1, 2, 3,
  "你好",
  "世界"
    print "你好"
    print "我在if内部"

if func 1, 2, 3,
    "你好",
    "世界"
  print "hello"
  print "我在if内部"
```

<YueDisplay>

```yue
if func 1, 2, 3,
  "你好",
  "世界"
    print "你好"
    print "我在if内部"

if func 1, 2, 3,
    "你好",
    "世界"
  print "你好"
  print "我在if内部"
```

</YueDisplay>

## 参数解构

&emsp;&emsp;月之脚本支持在函数形参位置对传入对象进行解构。适用两类解构表子面量：

- 使用 {} 包裹的字面量/对象形参，支持提供获得空字段时的默认值（例如 {:a, :b}、{a: a1 = 123}）。

- 无 {} 包裹、以键值/简写键序列开头，直至遇到其它表达式终止（例如 :a, b: b1, :c），表示从同一个对象中解构多个字段。

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

<YueDisplay>

```yue
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

</YueDisplay>

## 前置返回表达式

&emsp;&emsp;在深度嵌套的函数体中，为了提升返回值的可读性及编写便利性，我们新增了 “前置返回表达式” 语法。其形式如下：

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

<YueDisplay>

```yue
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

</YueDisplay>

&emsp;&emsp;这个写法等价于：

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

<YueDisplay>

```yue
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

</YueDisplay>

&emsp;&emsp;唯一的区别在于：你可以将函数的返回值表达式提前写在 `->` 或 `=>` 前，用以指示该函数应隐式返回该表达式的值。这样即使在多层循环或条件判断的场景下，也无需编写尾行悬挂的返回表达式，逻辑结构会更加直观清晰。

## 命名变长参数

&emsp;&emsp;你可以使用 `(...t) ->` 语法来将变长参数自动存储到一个命名表中。这个表会包含所有传入的参数（包括 `nil` 值），并且会在表的 `n` 字段中存储实际传入的参数个数（包括 `nil` 值在内的个数）。

```yuescript
f = (...t) ->
  print "参数个数:", t.n
  print "表长度:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- 处理包含 nil 的情况
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

<YueDisplay>

```yue
f = (...t) ->
  print "参数个数:", t.n
  print "表长度:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- 处理包含 nil 的情况
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

</YueDisplay>
