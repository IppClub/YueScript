# 推导式

&emsp;&emsp;推导式为我们提供了一种便捷的语法，通过遍历现有对象并对其值应用表达式来构造出新的表格。月之脚本有两种推导式：列表推导式和表格推导式。它们最终都是产生 Lua 表格；列表推导式将值累积到类似数组的表格中，而表格推导式允许你在每次遍历时设置新表格的键和值。

## 列表推导式

&emsp;&emsp;以下操作创建了一个 items 表的副本，但所有包含的值都翻倍了。

```yuescript
items = [1, 2, 3, 4]
doubled = [item * 2 for i, item in ipairs items]
```
<YueDisplay>

```yue
items = [1, 2, 3, 4]
doubled = [item * 2 for i, item in ipairs items]
```

</YueDisplay>

&emsp;&emsp;可以使用 `when` 子句筛选新表中包含的项目：

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```
<YueDisplay>

```yue
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

</YueDisplay>

&emsp;&emsp;因为我们常常需要迭代数值索引表的值，所以引入了 **\*** 操作符来做语法简化。doubled 示例可以重写为：

```yuescript
doubled = [item * 2 for item in *items]
```
<YueDisplay>

```yue
doubled = [item * 2 for item in *items]
```

</YueDisplay>

&emsp;&emsp;在列表推导式中，你还可以使用展开操作符 `...` 来实现对列表嵌套层级进行扁平化的处理：

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat 现在为 [1, 2, 3, 4, 5, 6]
```
<YueDisplay>

```yue
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat 现在为 [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

&emsp;&emsp;for 和 when 子句可以根据需要进行链式操作。唯一的要求是推导式中至少要有一个 for 子句。

&emsp;&emsp;使用多个 for 子句与使用多重循环的效果相同：

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```
<YueDisplay>

```yue
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

</YueDisplay>

&emsp;&emsp;在推导式中也可以使用简单的数值 for 循环：

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```
<YueDisplay>

```yue
evens = [i for i = 1, 100 when i % 2 == 0]
```

</YueDisplay>

## 表格推导式

&emsp;&emsp;表格推导式和列表推导式的语法非常相似，只是要使用 **{** 和 **}** 并从每次迭代中取两个值。

&emsp;&emsp;以下示例生成了表格 thing 的副本：

```yuescript
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```
<YueDisplay>

```yue
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

</YueDisplay>

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```
<YueDisplay>

```yue
no_color = {k, v for k, v in pairs thing when k != "color"}
```

</YueDisplay>

&emsp;&emsp;**\*** 操作符在表格推导式中能使用。在下面的例子里，我们为几个数字创建了一个平方根查找表。

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```
<YueDisplay>

```yue
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

</YueDisplay>

&emsp;&emsp;表格推导式中的键值元组也可以来自单个表达式，在这种情况下，表达式在计算后应返回两个值。第一个用作键，第二个用作值：

&emsp;&emsp;在下面的示例中，我们将一些数组转换为一个表，其中每个数组里的第一项是键，第二项是值。

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```
<YueDisplay>

```yue
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

</YueDisplay>

## 切片

&emsp;&emsp;当使用 **\*** 操作符时，月之脚本还提供了一种特殊的语法来限制要遍历的列表范围。这个语法也相当于在 for 循环中设置迭代边界和步长。

&emsp;&emsp;下面的案例中，我们在切片中设置最小和最大边界，取索引在 1 到 5 之间（包括 1 和 5）的所有项目：

```yuescript
slice = [item for item in *items[1, 5]]
```
<YueDisplay>

```yue
slice = [item for item in *items[1, 5]]
```

</YueDisplay>

&emsp;&emsp;切片的任意参数都可以省略，并会使用默认值。在如下示例中，如果省略了最大索引边界，它默认为表的长度。使下面的代码取除第一个元素之外的所有元素：

```yuescript
slice = [item for item in *items[2,]]
```
<YueDisplay>

```yue
slice = [item for item in *items[2,]]
```

</YueDisplay>

&emsp;&emsp;如果省略了最小边界，便默认会设置为 1。这里我们只提供一个步长，并留下其他边界为空。这样会使得代码取出所有奇数索引的项目：(1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```
<YueDisplay>


```yue
slice = [item for item in *items[,,2]]
```

</YueDisplay>

&emsp;&emsp;最小和最大边界都可以是负数，使用负数意味着边界是从表的末尾开始计算的。

```yuescript
-- 取最后4个元素
slice = [item for item in *items[-4,-1]]
```
<YueDisplay>

```yue
-- 取最后4个元素
slice = [item for item in *items[-4,-1]]
```

</YueDisplay>

&emsp;&emsp;切片的步长也可以是负数，这意味着元素会以相反的顺序被取出。

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```
<YueDisplay>

```yue
reverse_slice = [item for item in *items[-1,1,-1]]
```

</YueDisplay>

### 切片表达式

&emsp;&emsp;切片也可以作为表达式来使用。可以用于获取一个表包含的子列表。

```yuescript
-- 取第2和第4个元素作为新的列表
sub_list = items[2, 4]

-- 取最后4个元素作为新的列表
last_four_items = items[-4, -1]
```
<YueDisplay>

```yue
-- 取第2和第4个元素作为新的列表
sub_list = items[2, 4]

-- 取最后4个元素作为新的列表
last_four_items = items[-4, -1]
```

</YueDisplay>
