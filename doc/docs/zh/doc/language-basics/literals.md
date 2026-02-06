# 字面量

&emsp;&emsp;Lua 中的所有基本字面量都可以在月之脚本中使用。包括数字、字符串、布尔值和 **nil**。

&emsp;&emsp;但与 Lua 不同的是，单引号和双引号字符串内部允许有换行：

```yuescript
some_string = "这是一个字符串
  并包括一个换行。"

-- 使用#{}语法可以将表达式插入到字符串字面量中。
-- 字符串插值只在双引号字符串中可用。
print "我有#{math.random! * 100}%的把握。"
```
<YueDisplay>

```yue
some_string = "这是一个字符串
  并包括一个换行。"

-- 使用#{}语法可以将表达式插入到字符串字面量中。
-- 字符串插值只在双引号字符串中可用。
print "我有#{math.random! * 100}%的把握。"
```

</YueDisplay>

## 数字字面量

&emsp;&emsp;你可以在数字字面量中使用下划线来增加可读性。

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```
<YueDisplay>


```yue
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

</YueDisplay>

## YAML 风格字符串

&emsp;&emsp;使用 `|` 前缀标记一个多行 YAML 风格字符串：

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```
<YueDisplay>

```yue
str = |
  key: value
  list:
    - item1
    - #{expr}
```

</YueDisplay>

&emsp;&emsp;其效果类似于原生 Lua 的多行拼接，所有文本（含换行）将被保留下来，并支持 `#{...}` 语法，通过 `tostring(expr)` 插入表达式结果。

&emsp;&emsp;YAML 风格的多行字符串会自动检测首行后最小的公共缩进，并从所有行中删除该前缀空白字符。这让你可以在代码中对齐文本，但输出字符串不会带多余缩进。

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```
<YueDisplay>

```yue
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

</YueDisplay>

&emsp;&emsp;输出字符串中的 foo: 对齐到行首，不会带有函数缩进空格。保留内部缩进的相对结构，适合书写结构化嵌套样式的内容。

&emsp;&emsp;支持自动处理字符中的引号、反斜杠等特殊符号，无需手动转义：

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```
<YueDisplay>

```yue
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

</YueDisplay>
