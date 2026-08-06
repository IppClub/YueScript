# Introdução

YueScript é uma linguagem dinâmica que compila para Lua. É um dialeto do [MoonScript](https://github.com/leafo/moonscript). O código escrito em YueScript é expressivo e extremamente conciso. É adequado para escrever lógica de aplicação variável com código mais manutenível e roda em ambientes Lua embutidos, como jogos ou servidores web.

Yue (月) é o nome da lua em chinês e é pronunciado como [jyɛ].

## Uma visão geral do YueScript

```yuescript
-- sintaxe de importação
import p, to_lua from "yue"

-- literais de objeto
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- compreensão de lista
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- operador pipe
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- manipulação de metatable
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- sintaxe de exportação estilo js
export 🌛 = "Script da Lua"
```

<YueDisplay>

```yue
-- sintaxe de importação
import p, to_lua from "yue"

-- literais de objeto
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- compreensão de lista
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- operador pipe
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- manipulação de metatable
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- sintaxe de exportação estilo js
export 🌛 = "Script da Lua"
```

</YueDisplay>

## Sobre o Dora SSR

O YueScript está sendo desenvolvido e mantido em conjunto com o motor de jogo open-source [Dora SSR](https://github.com/IppClub/Dora-SSR). Tem sido usado para criar ferramentas do motor, demonstrações de jogos e protótipos, validando suas capacidades em cenários do mundo real e aprimorando a experiência de desenvolvimento do Dora SSR.
