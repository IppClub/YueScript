---
title: Goto
sidebar:
  order: 22
---

YueScript 支持 goto 语句和标签语法来控制程序流程，该语法遵循与 Lua 的 goto 语句相同的规则。**注意：** goto 语句需要 Lua 5.2 或更高版本。当编译目标是 Lua 5.1 时，使用 goto 语法将导致编译错误。

标签使用双冒号定义：

```yuescript
::开始::
::结束::
::我的标签::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
::开始::
::结束::
::我的标签::
```

</div>
</div>

goto 语句可以跳转到指定的标签：

```yuescript
a = 0
::开始::
a += 1
goto 结束 if a == 5
goto 开始
::结束::
print "a 现在是 5"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 0
::开始::
a += 1
goto 结束 if a == 5
goto 开始
::结束::
print "a 现在是 5"
```

</div>
</div>

goto 语句对于跳出深层嵌套循环非常有用：

```yuescript
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print '找到勾股数:', x, y, z
      goto 完成
::完成::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print '找到勾股数:', x, y, z
      goto 完成
::完成::
```

</div>
</div>

你也可以使用标签跳转到特定的循环层级：

```yuescript
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print '找到勾股数:', x, y, z
        print '尝试下一个 z...'
        goto 继续z
  ::继续z::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print '找到勾股数:', x, y, z
        print '尝试下一个 z...'
        goto 继续z
  ::继续z::
```

</div>
</div>

## 注意事项

- 标签在其作用域内必须唯一
- goto 可以跳转到相同或外层作用域级别的标签
- goto 不能跳转到内层作用域（如代码块或循环内部）
- 谨慎使用 goto，因为它会使代码更难阅读和维护
