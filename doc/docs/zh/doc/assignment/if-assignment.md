# If 赋值

&emsp;&emsp;`if` 和 `elseif` 代码块可以在条件表达式的位置进行赋值。在代码执行到要计算条件时，会首先进行赋值计算，并使用赋与的值作为分支判断的条件。赋值的变量仅在条件分支的代码块内有效，这意味着如果值不是真值，那么它就不会被用到。注意，你必须使用“海象运算符” `:=` 而不是 `=` 来做赋值。

```yuescript
if user := database.find_user "moon"
  print user.name
```

<YueDisplay>

```yue
if user := database.find_user "moon"
  print user.name
```

</YueDisplay>

```yuescript
if hello := os.getenv "hello"
  print "你有 hello", hello
elseif world := os.getenv "world"
  print "你有 world", world
else
  print "什么都没有 :("
```

<YueDisplay>

```yue
if hello := os.getenv "hello"
  print "你有 hello", hello
elseif world := os.getenv "world"
  print "你有 world", world
else
  print "什么都没有 :("
```

</YueDisplay>

&emsp;&emsp;使用多个返回值的 If 赋值。只有第一个值会被检查，其他值都有同样的作用域。

```yuescript
if success, result := pcall -> "无报错地获取结果"
  print result -- 变量 result 是有作用域的
print "好的"
```

<YueDisplay>

```yue
if success, result := pcall -> "无报错地获取结果"
  print result -- 变量 result 是有作用域的
print "好的"
```

</YueDisplay>

## While 赋值

&emsp;&emsp;你可以在 while 循环中同样使用赋值来获取循环条件的值。

```yuescript
while byte := stream\read_one!
  -- 对 byte 做一些操作
  print byte
```

<YueDisplay>

```yue
while byte := stream\read_one!
  -- 对 byte 做一些操作
  print byte
```

</YueDisplay>
