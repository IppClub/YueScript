# Einführung

YueScript ist eine dynamische Sprache, die zu Lua kompiliert. Sie ist ein Dialekt von [MoonScript](https://github.com/leafo/moonscript). Code, der in YueScript geschrieben wird, ist ausdrucksstark und sehr kompakt. YueScript eignet sich zum Schreiben von veränderlicher Anwendungslogik mit besser wartbarem Code und läuft in eingebetteten Lua-Umgebungen wie Spielen oder Webservern.

Yue (月) ist das chinesische Wort für Mond und wird als [jyɛ] ausgesprochen.

## Ein Überblick über YueScript

```yuescript
-- Import-Syntax
import p, to_lua from "yue"

-- Objekt-Literale
inventory =
  equipment:
    - "Schwert"
    - "Schild"
  items:
    - name: "Trank"
      count: 10
    - name: "Brot"
      count: 3

-- Listen-Abstraktion
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- Pipe-Operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- Metatable-Manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- export-Syntax (ähnlich wie in JavaScript)
export 🌛 = "Skript des Mondes"
```

<YueDisplay>

```yue
-- Import-Syntax
import p, to_lua from "yue"

-- Objekt-Literale
inventory =
  equipment:
    - "Schwert"
    - "Schild"
  items:
    - name: "Trank"
      count: 10
    - name: "Brot"
      count: 3

-- Listen-Abstraktion
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- Pipe-Operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- Metatable-Manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- export-Syntax (ähnlich wie in JavaScript)
export 🌛 = "Skript des Mondes"
```

</YueDisplay>

## Über Dora SSR

YueScript wird zusammen mit der Open-Source-Spiel-Engine [Dora SSR](https://github.com/IppClub/Dora-SSR) entwickelt und gepflegt. Es wird zum Erstellen von Engine-Tools, Spiel-Demos und Prototypen eingesetzt und hat seine Leistungsfähigkeit in realen Szenarien unter Beweis gestellt, während es gleichzeitig die Dora-SSR-Entwicklungserfahrung verbessert.
