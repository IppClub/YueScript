# Introduction

YueScript is a dynamic language that compiles to Lua. And it's a [MoonScript](https://github.com/leafo/moonscript) dialect. The codes written in YueScript are expressive and extremely concise. And it is suitable for writing some changing application logic with more maintainable codes and runs in a Lua embeded environment such as games or website servers.

Yue (月) is the name of moon in Chinese and it's pronounced as [jyɛ].

## An Overview of YueScript

```yuescript
-- import syntax
import p, to_lua from "yue"

-- object literals
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- list comprehension
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- pipe operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- metatable manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- js-like export syntax
export 🌛 = "Script of Moon"
```

<YueDisplay>

```yue
-- import syntax
import p, to_lua from "yue"

-- object literals
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- list comprehension
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- pipe operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- metatable manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- js-like export syntax
export 🌛 = "Script of Moon"
```

</YueDisplay>

## About Dora SSR

YueScript is being developed and maintained alongside the open-source game engine [Dora SSR](https://github.com/Dora-SSR/Dora-SSR). It has been used to create engine tools, game demos and prototypes, validating its capabilities in real-world scenarios while enhancing the Dora SSR development experience.
