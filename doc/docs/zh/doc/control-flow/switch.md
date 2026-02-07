# switch 语句

&emsp;&emsp;switch 语句是为了简化检查一系列相同值的if语句而提供的简写语法。要注意用于比较检查的目标值只会计算一次。和 if 语句一样，switch 语句在最后可以接一个 else 代码块来处理没有匹配的情况。在生成的 Lua 代码中，进行比较是使用 == 操作符完成的。switch 语句中也可以使用赋值表达式来储存临时变量值。

```yuescript
switch name := "Dan"
  when "Robert"
    print "你是Robert"
  when "Dan", "Daniel"
    print "你的名字是Dan"
  else
    print "我不认识你，你的名字是#{name}"
```

<YueDisplay>

```yue
switch name := "Dan"
  when "Robert"
    print "你是Robert"
  when "Dan", "Daniel"
    print "你的名字是Dan"
  else
    print "我不认识你，你的名字是#{name}"
```

</YueDisplay>

&emsp;&emsp;switch 语句的 when 子句中可以通过使用逗号分隔的列表来匹配多个值。

&emsp;&emsp;switch 语句也可以作为表达式使用，下面我们可以将 switch 语句返回的结果分配给一个变量：

```yuescript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "数字数得太大了！"
```

<YueDisplay>

```yue
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "数字数得太大了！"
```

</YueDisplay>

&emsp;&emsp;我们可以使用 then 关键字在 when 子句的同一行上编写处理代码。else 代码块的后续代码中要写在同一行上不需要额外的关键字。

```yuescript
msg = switch math.random(1, 5)
  when 1 then "你很幸运"
  when 2 then "你差点很幸运"
  else "不太幸运"
```

<YueDisplay>

```yue
msg = switch math.random(1, 5)
  when 1 then "你很幸运"
  when 2 then "你差点很幸运"
  else "不太幸运"
```

</YueDisplay>

&emsp;&emsp;如果在编写 switch 语句时希望少写一个缩进，那么你可以把第一个 when 子句放在 switch 开始语句的第一行，然后后续的子语句就都可以都少写一个缩进。

```yuescript
switch math.random(1, 5)
  when 1
    print "你很幸运" -- 两个缩进级别
  else
    print "不太幸运"

switch math.random(1, 5) when 1
  print "你很幸运" -- 一个缩进级别
else
  print "不太幸运"
```

<YueDisplay>

```yue
switch math.random(1, 5)
  when 1
    print "你很幸运" -- 两个缩进级别
  else
    print "不太幸运"

switch math.random(1, 5) when 1
  print "你很幸运" -- 一个缩进级别
else
  print "不太幸运"
```

</YueDisplay>

&emsp;&emsp;值得注意的是，在生成 Lua 代码时，我们要做检查的目标变量会放在 == 表达式的右侧。当你希望给 when 子句的比较对象定义一个 \_\_eq 元方法来重载判断逻辑时，可能会有用。

## 表格匹配

&emsp;&emsp;在 switch 的 when 子句中，如果期待检查目标是一个表格，且可以通过特定的结构进行解构并获得非 nil 值，那么你可以尝试使用表格匹配的语法。

```yuescript
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "尺寸 #{width}, #{height}"
```

<YueDisplay>

```yue
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "尺寸 #{width}, #{height}"
```

</YueDisplay>

&emsp;&emsp;你可以使用默认值来选择性地解构表格的某些字段。

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- 获取错误：尝试索引nil值（字段'pos'）

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- 表格解构仍然会通过
```

<YueDisplay>

```yue
item = {}

{pos: {:x = 50, :y = 200}} = item -- 获取错误：尝试索引nil值（字段'pos'）

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- 表格解构仍然会通过
```

</YueDisplay>

&emsp;&emsp;你也可以匹配数组元素、表格字段，甚至使用数组或表格字面量来匹配嵌套的结构。

&emsp;&emsp;匹配数组元素。

```yuescript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- 变量b有默认值
    print "1, 2, #{b}"
```

<YueDisplay>

```yue
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- 变量b有默认值
    print "1, 2, #{b}"
```

</YueDisplay>

&emsp;&emsp;匹配表格字段。

```yuescript
switch tb
  when success: true, :result
    print "成功", result
  when success: false
    print "失败", result
  else
    print "无效值"
```

<YueDisplay>

```yue
switch tb
  when success: true, :result
    print "成功", result
  when success: false
    print "失败", result
  else
    print "无效值"
```

</YueDisplay>

&emsp;&emsp;匹配嵌套的表格结构。

```yuescript
switch tb
  when data: {type: "success", :content}
    print "成功", content
  when data: {type: "error", :content}
    print "失败", content
  else
    print "无效值"
```

<YueDisplay>

```yue
switch tb
  when data: {type: "success", :content}
    print "成功", content
  when data: {type: "error", :content}
    print "失败", content
  else
    print "无效值"
```

</YueDisplay>

&emsp;&emsp;匹配表格数组。

```yuescript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "匹配成功", fourth
```

<YueDisplay>

```yue
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "匹配成功", fourth
```

</YueDisplay>

&emsp;&emsp;匹配一个列表并捕获特定范围内的元素。

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- 打印: {"admin", "users"}
    print "Resource:", resource -- 打印: "logs"
    print "Action:", action -- 打印: "view"
```

<YueDisplay>

```yue
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- 打印: {"admin", "users"}
    print "Resource:", resource -- 打印: "logs"
    print "Action:", action -- 打印: "view"
```

</YueDisplay>
