# 解构赋值

&emsp;&emsp;解构赋值是一种快速从 Lua 表中按名称或基于数组中的位置提取值的方法。

&emsp;&emsp;通常当你看到一个字面量的 Lua 表，比如 `{1,2,3}`，它位于赋值的右侧，因为它是一个值。解构赋值语句的写法就是交换了字面量 Lua 表的角色，并将其放在赋值语句的左侧。

&emsp;&emsp;最好是通过示例来解释。以下是如何从表格中解包前两个值的方法：

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```
<YueDisplay>


```yue
thing = [1, 2]

[a, b] = thing
print a, b
```

</YueDisplay>

&emsp;&emsp;在解构表格字面量中，键代表从右侧读取的键，值代表读取的值将被赋予的名称。

```yuescript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- 可以不带大括号进行简单的解构
```
<YueDisplay>

```yue
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- 可以不带大括号进行简单的解构
```

</YueDisplay>

&emsp;&emsp;这也适用于嵌套的数据结构：

```yuescript
obj2 = {
  numbers: [1,2,3,4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```
<YueDisplay>

```yue
obj2 = {
  numbers: [1,2,3,4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

</YueDisplay>

&emsp;&emsp;如果解构语句很复杂，也可以任意将其分散在几行中。稍微复杂一些的示例：

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```
<YueDisplay>

```yue
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

</YueDisplay>

&emsp;&emsp;有时候我们会需要从 Lua 表中提取值并将它们赋给与键同名的局部变量。为了避免编写重复代码，我们可以使用 **:** 前缀操作符：

```yuescript
{:concat, :insert} = table
```
<YueDisplay>

```yue
{:concat, :insert} = table
```

</YueDisplay>

&emsp;&emsp;这样的用法与导入语法有些相似。但我们可以通过混合语法重命名我们想要提取的字段：

```yuescript
{:mix, :max, random: rand} = math
```
<YueDisplay>

```yue
{:mix, :max, random: rand} = math
```

</YueDisplay>

&emsp;&emsp;在进行解构时，你可以指定默认值，如：

```yuescript
{:name = "nameless", :job = "jobless"} = person
```
<YueDisplay>

```yue
{:name = "nameless", :job = "jobless"} = person
```

</YueDisplay>

&emsp;&emsp;在进行列表解构时，你可以使用`_`作为占位符：

```yuescript
[_, two, _, four] = items
```
<YueDisplay>

```yue
[_, two, _, four] = items
```

</YueDisplay>

## 范围解构

&emsp;&emsp;你可以使用展开运算符 `...` 在列表解构中来捕获一个范围的值到子列表中。这在当你想要从列表的开头和结尾提取特定元素，同时收集中间的元素时非常有用。

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- 打印: first
print bulk   -- 打印: {"second", "third", "fourth"}
print last   -- 打印: last
```
<YueDisplay>

```yue
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- 打印: first
print bulk   -- 打印: {"second", "third", "fourth"}
print last   -- 打印: last
```

</YueDisplay>

&emsp;&emsp;展开运算符可以用在不同的位置来捕获不同的范围，并且你可以使用 `_` 作为占位符来表示你想跳过对应范围的捕获：

```yuescript
-- 捕获第一个元素之后的所有元素
[first, ...rest] = orders

-- 捕获最后一个元素之前的所有元素
[...start, last] = orders

-- 跳过中间的元素，只捕获第一个和最后一个元素
[first, ..._, last] = orders
```
<YueDisplay>

```yue
-- 捕获第一个元素之后的所有元素
[first, ...rest] = orders

-- 捕获最后一个元素之前的所有元素
[...start, last] = orders

-- 跳过中间的元素，只捕获第一个和最后一个元素
[first, ..._, last] = orders
```

</YueDisplay>

## 在其它地方的解构赋值

&emsp;&emsp;解构赋值也可以出现在其它隐式进行赋值的地方。一个例子是用在 for 循环中：

```yuescript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```
<YueDisplay>

```yue
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

</YueDisplay>

&emsp;&emsp;我们知道数组表中的每个元素都是一个两项的元组，所以我们可以直接在 for 语句的名称子句中使用解构来解包它。
