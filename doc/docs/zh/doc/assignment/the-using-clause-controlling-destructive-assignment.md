# 使用 using 语句：防止破坏性赋值

&emsp;&emsp;Lua 的变量作用域是降低代码复杂度的重要工具。然而，随着代码量的增加，维护这些变量可能变得更加困难。比如，看看下面的代码片段：

```yuescript
i = 100

-- 许多代码行...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- 将打印 0
```

<YueDisplay>

```yue
i = 100

-- 许多代码行...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- 将打印 0
```

</YueDisplay>

&emsp;&emsp;在 `my_func` 中，我们不小心覆盖了变量 `i` 的值。虽然在这个例子中这个问题很明显，但在一个庞大的或者是由多人共同维护的代码库中，很难追踪每个变量的声明情况。

&emsp;&emsp;如果我们可以明确指出哪些变量是我们想在当前作用域内修改的，并且防止我们不小心更改了其他作用域中同名的变量，那将大有裨益。

&emsp;&emsp;`using` 语句就是为此而生。`using nil` 确保函数内部的赋值不会意外地影响到外部作用域的变量。我们只需将 `using` 子句放在函数的参数列表之后；若函数没有参数，则直接放在括号内即可。

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- 这里创建了一个新的局部变量

my_func!
print i -- 打印 100，i 没有受到影响
```

<YueDisplay>

```yue
i = 100

my_func = (using nil) ->
  i = "hello" -- 这里创建了一个新的局部变量

my_func!
print i -- 打印 100，i 没有受到影响
```

</YueDisplay>

&emsp;&emsp;using子句中可以填写多个用逗号分隔名称。指定可以访问和修改的外部变量的名称：

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- 创建了一个新的局部tmp
  i += tmp
  k += tmp

my_func(22)
print i, k -- 这些已经被更新
```

<YueDisplay>

```yue
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- 创建了一个新的局部tmp
  i += tmp
  k += tmp

my_func(22)
print i, k -- 这些已经被更新
```

</YueDisplay>
