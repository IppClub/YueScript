# 介绍

月之脚本（YueScript）是一种动态语言，可以编译为 Lua。它是 [MoonScript](https://github.com/leafo/moonscript) 的方言。用月之脚本编写的代码既有表现力又非常简洁。它适合编写一些更易于维护的代码，并在嵌入 Lua 的环境中运行，如游戏或网站服务器。

Yue（月）是中文中“月亮”的名称。

## 月之脚本概览

```yuescript
-- 导入语法
import p, to_lua from "yue"

-- 隐式对象
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- 列表推导
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- 管道操作符
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- 元表操作
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- 类似js的导出语法
export 🌛 = "月之脚本"
```

<YueDisplay>

```yue
-- 导入语法
import p, to_lua from "yue"

-- 隐式对象
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- 列表推导
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- 管道操作符
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- 元表操作
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- 类似js的导出语法
export 🌛 = "月之脚本"
```

</YueDisplay>

## 关于 Dora SSR

月之脚本是与开源游戏引擎 [Dora SSR](https://github.com/Dora-SSR/Dora-SSR) 一起开发和维护的。它已被用于创建引擎工具、游戏原型和演示，在实际的游戏项目中验证其能力，同时它也帮助增强了 Dora SSR 游戏引擎的开发体验。
