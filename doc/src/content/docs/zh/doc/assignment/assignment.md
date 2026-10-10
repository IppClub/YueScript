---
title: 赋值
sidebar:
  order: 10
---

&emsp;&emsp;月之脚本中定义的变量是动态类型的，并默认为局部变量。但你可以通过 **local** 和 **global** 声明来改变声明变量的作用范围。

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- 访问现有的变量
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- 访问现有的变量
```

</div>
</div>

## 执行更新

&emsp;&emsp;你可以使用各式二进制运算符执行更新赋值。

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- 如果执行更新的局部变量不存在，将新建一个局部变量
arg or= "默认值"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- 如果执行更新的局部变量不存在，将新建一个局部变量
arg or= "默认值"
```

</div>
</div>

## 链式赋值

&emsp;&emsp;你可以进行链式赋值，将多个项目赋予相同的值。

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</div>
</div>

## 显式声明局部变量

```yuescript
do
  local a = 1
  local *
  print "预先声明后续所有变量为局部变量"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "只预先声明后续大写的变量为局部变量"
  a = 1
  B = 2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  local a = 1
  local *
  print "预先声明后续所有变量为局部变量"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "只预先声明后续大写的变量为局部变量"
  a = 1
  B = 2
```

</div>
</div>

## 显式声明全局变量

```yuescript
do
  global a = 1
  global *
  print "预先声明所有变量为全局变量"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global x = 1
  global ^
  print "只预先声明大写的变量为全局变量"
  a = 1
  B = 2
  local Temp = "一个局部值"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  global a = 1
  global *
  print "预先声明所有变量为全局变量"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global x = 1
  global ^
  print "只预先声明大写的变量为全局变量"
  a = 1
  B = 2
  local Temp = "一个局部值"
```

</div>
</div>
