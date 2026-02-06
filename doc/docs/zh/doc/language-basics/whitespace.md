# 空白

&emsp;&emsp;月之脚本是一个对空白敏感的语言。你必须在相同的缩进中使用空格 **' '** 或制表符 **'\t'** 来编写一些代码块，如函数体、值列表和一些控制块。包含不同空白的表达式可能意味着不同的事情。制表符被视为4个空格，但最好不要混合使用空格和制表符。

## 语句分隔符

&emsp;&emsp;一条语句通常以换行结束。你也可以使用分号 `;` 显式结束一条语句，从而在同一行中编写多条语句：

```yuescript
a = 1; b = 2; print a + b
```
<YueDisplay>

```yue
a = 1; b = 2; print a + b
```

</YueDisplay>

## 多行链式调用

&emsp;&emsp;你可以使用相同的缩进来编写多行链式函数调用。

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```
<YueDisplay>

```yue
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

</YueDisplay>
