# continue 语句

&emsp;&emsp;继续语句可以用来跳出当前的循环迭代。

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```
<YueDisplay>

```yue
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

</YueDisplay>

&emsp;&emsp;继续语句也可以与各种循环表达式一起使用，以防止当前的循环迭代结果累积到结果列表中。以下示例将数组表过滤为仅包含偶数的数组：

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```
<YueDisplay>

```yue
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

</YueDisplay>
