---
title: for 循环
sidebar:
  order: 19
---

&emsp;&emsp;Lua 中有两种 for 循环形式，数字型和通用型：

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- 提供了一个遍历的步长
  print k

for key, value in pairs object
  print key, value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for i = 10, 20
  print i

for k = 1, 15, 2 -- 提供了一个遍历的步长
  print k

for key, value in pairs object
  print key, value
```

</div>
</div>

&emsp;&emsp;可以使用切片和 **\*** 操作符，就像在列表推导中一样：

```yuescript
for item in *items[2, 4]
  print item
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items[2, 4]
  print item
```

</div>
</div>

&emsp;&emsp;当代码语句只有一行时，循环语句也都可以写作更短的语法：

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items do print item

for j = 1, 10, 3 do print j
```

</div>
</div>

&emsp;&emsp;for 循环也可以用作表达式。for 循环主体中的最后一条语句会被强制转换为一个返回值的表达式，并会将表达式计算结果的值追加到一个作为结果的数组表中。

&emsp;&emsp;将每个偶数加倍：

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

</div>
</div>

&emsp;&emsp;此外，for 循环还支持带返回值的 break 语句，这样循环本身就可以作为一个表达式，在满足条件时提前退出并返回有意义的结果。for 循环表达式支持 `break` 返回多个值。

&emsp;&emsp;例如，查找第一个大于 10 的数字：

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
first_large = for n in *numbers
  break n if n > 10
```

</div>
</div>

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

</div>
</div>

&emsp;&emsp;你还可以结合 for 循环表达式与 continue 语句来过滤值。

&emsp;&emsp;注意出现在函数体末尾的 for 循环，不会被当作是一个表达式并将循环结果累积到一个列表中作为返回值（相反，函数将返回 nil）。如果要函数末尾的循环转换为列表表达式，可以显式地使用返回语句加 for 循环表达式。

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- 打印 nil
print func_b! -- 打印 table 对象
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- 打印 nil
print func_b! -- 打印 table 对象
```

</div>
</div>

&emsp;&emsp;这样做是为了避免在不需要返回循环结果的函数，创建无效的返回值表格。
