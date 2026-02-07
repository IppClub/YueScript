# 属性

&emsp;&emsp;月之脚本现在提供了 Lua 5.4 新增的叫做属性的语法支持。在月之脚本编译到的 Lua 目标版本低于 5.4 时，你仍然可以同时使用`const` 和 `close` 的属性声明语法，并获得常量检查和作用域回调的功能。

```yuescript
const a = 123
close _ = <close>: -> print "超出范围。"
```

<YueDisplay>

```yue
const a = 123
close _ = <close>: -> print "超出范围。"
```

</YueDisplay>

&emsp;&emsp;你可以对进行解构得到的变量标记为常量。

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<YueDisplay>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</YueDisplay>

&emsp;&emsp;你也可以声明全局变量为常量。

```yuescript
global const Constant = 123
-- Constant = 1
```

<YueDisplay>

```yue
global const Constant = 123
-- Constant = 1
```

</YueDisplay>
