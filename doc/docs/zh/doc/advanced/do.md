# do 语句

&emsp;&emsp;当用作语句时，do 语句的作用就像在 Lua 中差不多。

```yuescript
do
  var = "hello"
  print var
print var -- 这里是nil
```
<YueDisplay>

```yue
do
  var = "hello"
  print var
print var -- 这里是nil
```

</YueDisplay>

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
<YueDisplay>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</YueDisplay>

```yuescript
tbl = {
  key: do
    print "分配键值!"
    1234
}
```
<YueDisplay>

```yue
tbl = {
  key: do
    print "分配键值!"
    1234
}
```

</YueDisplay>
