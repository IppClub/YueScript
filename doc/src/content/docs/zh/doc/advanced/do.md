---
title: do 语句
sidebar:
  order: 30
---

&emsp;&emsp;当用作语句时，do 语句的作用就像在 Lua 中差不多。

```yuescript
do
  var = "hello"
  print var
print var -- 这里是nil
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  var = "hello"
  print var
print var -- 这里是nil
```

</div>
</div>

&emsp;&emsp;月之脚本的 **do** 也可以用作表达式。允许你将多行代码的处理合并为一个表达式，并将 do 语句代码块的最后一个语句作为表达式返回的结果。

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</div>
</div>

```yuescript
tbl = {
  key: do
    print "分配键值!"
    1234
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  key: do
    print "分配键值!"
    1234
}
```

</div>
</div>

&emsp;&emsp;`do` 表达式支持通过 `break` 打断执行流并提前返回多个值。

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

</div>
</div>
