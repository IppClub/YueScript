# with 语句


在编写 Lua 代码时，我们在创建对象后的常见操作是立即调用这个对象一系列操作函数并设置一系列属性。

这导致在代码中多次重复引用对象的名称，增加了不必要的文本噪音。一个常见的解决方案是在创建对象时，在构造函数传入一个表，该表包含要覆盖设置的键和值的集合。这样做的缺点是该对象的构造函数必须支持这种初始化形式。

with 块有助于简化编写这样的代码。在 with 块内，我们可以使用以 . 或 \ 开头的特殊语句，这些语句代表我们正在使用的对象的操作。

例如，我们可以这样处理一个新创建的对象：

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```
<YueDisplay>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</YueDisplay>

with 语句也可以用作一个表达式，并返回它的代码块正在处理的对象。

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```
<YueDisplay>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</YueDisplay>

或者…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```
<YueDisplay>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</YueDisplay>

在此用法中，with 可以被视为K组合子（k-combinator）的一种特殊形式。

如果你想给表达式另外起一个名称的话，with 语句中的表达式也可以是一个赋值语句。

```yuescript
with str := "你好"
  print "原始:", str
  print "大写:", \upper!
```
<YueDisplay>

```yue
with str := "你好"
  print "原始:", str
  print "大写:", \upper!
```

</YueDisplay>

你可以在 `with` 语句中使用 `[]` 访问特殊键。

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- 追加到 "tb"
```
<YueDisplay>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- 追加到 "tb"
```

</YueDisplay>

`with?` 是 `with` 语法的一个增强版本，引入了存在性检查，用于在不显式判空的情况下安全访问可能为 nil 的对象。

```yuescript
with? obj
  print obj.name
```
<YueDisplay>

```yue
with? obj
  print obj.name
```

</YueDisplay>
