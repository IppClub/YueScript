# while 循环

&emsp;&emsp;在月之脚本中的 while 循环支持几种不同的写法：

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

<YueDisplay>

```yue
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

</YueDisplay>

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

<YueDisplay>

```yue
i = 10
until i == 0
  print i
  i -= 1
until running == false do my_function!
```

</YueDisplay>

&emsp;&emsp;像 for 循环的语法一样，while 循环也可以作为一个表达式使用。为了使函数返回 while 循环的累积列表值，必须明确使用返回语句返回 while 循环表达式。

## repeat 循环

&emsp;&emsp;repeat 循环是从 Lua 语言中搬过来的相似语法：

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

<YueDisplay>

```yue
i = 10
repeat
  print i
  i -= 1
until i == 0
```

</YueDisplay>
