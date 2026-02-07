# 代码行修饰

&emsp;&emsp;为了方便编写代码，循环语句和 if 语句可以应用于单行代码语句的末尾：

```yuescript
print "你好，世界" if name == "Rob"
```

<YueDisplay>

```yue
print "你好，世界" if name == "Rob"
```

</YueDisplay>

&emsp;&emsp;修饰 for 循环的示例：

```yuescript
print "项目: ", item for item in *items
```

<YueDisplay>

```yue
print "项目: ", item for item in *items
```

</YueDisplay>

&emsp;&emsp;修饰 while 循环的示例：

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

<YueDisplay>

```yue
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

</YueDisplay>
