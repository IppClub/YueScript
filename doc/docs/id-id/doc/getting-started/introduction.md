# Pendahuluan

YueScript adalah bahasa dinamis yang dikompilasi ke Lua, dan merupakan dialek [MoonScript](https://github.com/leafo/moonscript). Kode yang ditulis dengan YueScript ekspresif dan sangat ringkas. YueScript cocok untuk menulis logika aplikasi yang sering berubah dengan kode yang lebih mudah dipelihara, serta berjalan di lingkungan embed Lua seperti game atau server situs web.

Yue (月) adalah kata untuk bulan dalam bahasa Tionghoa dan diucapkan sebagai [jyɛ].

## Ikhtisar YueScript

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
export 🌛 = "Skrip Bulan"
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
export 🌛 = "Skrip Bulan"
```

</YueDisplay>

## Tentang Dora SSR

YueScript dikembangkan dan dipelihara bersama mesin game open-source [Dora SSR](https://github.com/IppClub/Dora-SSR). YueScript telah digunakan untuk membuat alat mesin, demo game, dan prototipe, membuktikan kemampuannya dalam skenario dunia nyata sekaligus meningkatkan pengalaman pengembangan Dora SSR.
