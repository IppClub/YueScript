# 表格字面量

&emsp;&emsp;和 Lua 一样，表格可以通过花括号进行定义。

```yuescript
some_values = [1, 2, 3, 4]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
```

</YueDisplay>

&emsp;&emsp;但与Lua不同的是，给表格中的键赋值是用 **:**（而不是 **=**）。

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

<YueDisplay>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

</YueDisplay>

&emsp;&emsp;如果只分配一个键值对的表格，可以省略花括号。

```yuescript
profile =
  height: "4英尺",
  shoe_size: 13,
  favorite_foods: ["冰淇淋", "甜甜圈"]
```

<YueDisplay>

```yue
profile =
  height: "4英尺",
  shoe_size: 13,
  favorite_foods: ["冰淇淋", "甜甜圈"]
```

</YueDisplay>

&emsp;&emsp;可以使用换行符而不使用逗号（或两者都用）来分隔表格中的值：

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "超人"
  occupation: "打击犯罪"
}
```

<YueDisplay>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "超人"
  occupation: "打击犯罪"
}
```

</YueDisplay>

&emsp;&emsp;创建单行表格字面量时，也可以省略花括号：

```yuescript
my_function dance: "探戈", partner: "无"

y = type: "狗", legs: 4, tails: 1
```

<YueDisplay>

```yue
my_function dance: "探戈", partner: "无"

y = type: "狗", legs: 4, tails: 1
```

</YueDisplay>

&emsp;&emsp;表格字面量的键可以使用 Lua 语言的关键字，而无需转义：

```yuescript
tbl = {
  do: "某事"
  end: "饥饿"
}
```

<YueDisplay>

```yue
tbl = {
  do: "某事"
  end: "饥饿"
}
```

</YueDisplay>

&emsp;&emsp;如果你要构造一个由变量组成的表，并希望键与变量名相同，那么可以使用 **:** 前缀操作符：

```yuescript
hair = "金色"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

<YueDisplay>

```yue
hair = "金色"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</YueDisplay>

&emsp;&emsp;如果你希望表中字段的键是某个表达式的结果，那么可以用 **[ ]** 包裹它，就像在 Lua 中一样。如果键中有任何特殊字符，也可以直接使用字符串字面量作为键，省略方括号。

```yuescript
t = {
  [1 + 2]: "你好"
  "你好 世界": true
}
```

<YueDisplay>

```yue
t = {
  [1 + 2]: "你好"
  "你好 世界": true
}
```

</YueDisplay>

&emsp;&emsp;Lua 的表同时具有数组部分和哈希部分，但有时候你会希望在书写 Lua 表时，对 Lua 表做数组和哈希不同用法的语义区分。然后你可以用 **[ ]** 而不是 **{ }** 来编写表示数组的 Lua 表，并且不允许在数组 Lua 表中写入任何键值对。

```yuescript
some_values = [ 1, 2, 3, 4 ]
list_with_one_element = [ 1, ]
```

<YueDisplay>

```yue
some_values = [ 1, 2, 3, 4 ]
list_with_one_element = [ 1, ]
```

</YueDisplay>
