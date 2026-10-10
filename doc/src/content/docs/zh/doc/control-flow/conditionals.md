---
title: 条件语句
sidebar:
  order: 18
---

```yuescript
have_coins = false
if have_coins
  print "有硬币"
else
  print "没有硬币"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins
  print "有硬币"
else
  print "没有硬币"
```

</div>
</div>

&emsp;&emsp;对于简单的语句，也可以使用简短的语法：

```yuescript
have_coins = false
if have_coins then print "有硬币" else print "没有硬币"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins then print "有硬币" else print "没有硬币"
```

</div>
</div>

&emsp;&emsp;因为 if 语句可以用作表达式，所以也可以这样写：

```yuescript
have_coins = false
print if have_coins then "有硬币" else "没有硬币"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
print if have_coins then "有硬币" else "没有硬币"
```

</div>
</div>

&emsp;&emsp;条件语句也可以作为表达式用在返回语句和赋值语句中：

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "我很高"
else
  "我不是很高"

print message -- 打印: 我很高
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "我很高"
else
  "我不是很高"

print message -- 打印: 我很高
```

</div>
</div>

&emsp;&emsp;if 的反义词是 unless（相当于 if not，正如“如果”对应“除非”）：

```yuescript
unless os.date("%A") == "Monday"
  print "今天不是星期一！"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
unless os.date("%A") == "Monday"
  print "今天不是星期一！"
```

</div>
</div>

```yuescript
print "你真幸运！" unless math.random! > 0.1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "你真幸运！" unless math.random! > 0.1
```

</div>
</div>

## 范围表达式

&emsp;&emsp;你可以使用范围表达式来编写进行范围检查的代码。

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "检查离散值的相等性"

if a in list
  print "检查`a`是否在列表中"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "检查离散值的相等性"

if a in list
  print "检查`a`是否在列表中"
```

</div>
</div>

`in` 运算符也可以用于表，并支持 `not in` 变体来进行否定检查：

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a 在表中"

not_exist = item not in list

check = -> value not in table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a 在表中"

not_exist = item not in list

check = -> value not in table
```

</div>
</div>

单元素列表或表会检查与该元素的相等性：

```yuescript
-- [1,] 检查 value == 1
c = a in [1,]

-- {1} 也是检查 value == 1
c = a in {1}

-- 没有逗号，[1] 是索引访问（tb[1]）
with tb
  c = a in [1]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- [1,] 检查 value == 1
c = a in [1,]

-- {1} 也是检查 value == 1
c = a in {1}

-- 没有逗号，[1] 是索引访问（tb[1]）
with tb
  c = a in [1]
```

</div>
</div>
