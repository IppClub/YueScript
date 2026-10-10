---
title: while 循环
sidebar:
  order: 20
---

&emsp;&emsp;在月之脚本中的 while 循环支持几种不同的写法：

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

</div>
</div>

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
until i == 0
  print i
  i -= 1
until running == false do my_function!
```

</div>
</div>

&emsp;&emsp;像 for 循环的语法一样，while 循环也可以作为一个表达式使用。while / until 循环表达式支持 `break` 返回多个值。

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

</div>
</div>

&emsp;&emsp;为了使函数返回 while 循环的累积列表值，必须明确使用返回语句返回 while 循环表达式。

## repeat 循环

&emsp;&emsp;repeat 循环是从 Lua 语言中搬过来的相似语法：

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
repeat
  print i
  i -= 1
until i == 0
```

</div>
</div>

&emsp;&emsp;repeat 循环表达式同样支持 `break` 返回多个值：

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

</div>
</div>
