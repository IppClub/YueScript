# 可变参数赋值

&emsp;&emsp;你可以将函数返回的结果赋值给一个可变参数符号 `...`。然后使用 Lua 的方式访问其内容。

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

<YueDisplay>

```yue
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

</YueDisplay>
