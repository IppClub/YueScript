# 反向回调

&emsp;&emsp;反向回调用于减少函数回调的嵌套。它们使用指向左侧的箭头，并且默认会被定义为传入后续函数调用的最后一个参数。它的语法大部分与常规箭头函数相同，只是它指向另一方向，并且后续的函数体不需要进行缩进。

```yuescript
x <- f
print "hello" .. x
```

<YueDisplay>

```yue
x <- f
print "hello" .. x
```

</YueDisplay>

&emsp;&emsp;月之脚本也提供了粗箭头反向回调函数。

```yuescript
<= f
print @value
```

<YueDisplay>

```yue
<= f
print @value
```

</YueDisplay>

&emsp;&emsp;你可以通过一个占位符指定回调函数的传参位置。

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

<YueDisplay>

```yue
(x) <- map _, [1, 2, 3]
x * 2
```

</YueDisplay>

&emsp;&emsp;如果你希望在反向回调处理后继续编写更多其它的代码，可以使用 do 语句将不属于反向回调的代码分隔开。对于非粗箭头函数的反向回调，回调返回值的括号也是可以省略的。

```yuescript
result, msg = do
  data <- readAsync "文件名.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

<YueDisplay>

```yue
result, msg = do
  data <- readAsync "文件名.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

</YueDisplay>
