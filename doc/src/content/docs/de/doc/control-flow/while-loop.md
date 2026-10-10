---
title: While-Schleife
sidebar:
  order: 20
---

Die `while`-Schleife gibt es ebenfalls in vier Variationen:

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

</div>
</div>

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
until i == 0
  print i
  i -= 1
until running == false do my_function!
```

</div>
</div>

Wie bei `for`-Schleifen kann die `while`-Schleife auch als Ausdruck verwendet werden. `while`- und `until`-Ausdrücke unterstützen `break` mit mehreren Rückgabewerten.

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

</div>
</div>

Damit eine Funktion den akkumulierten Wert einer `while`-Schleife zurückgibt, muss die Anweisung explizit mit `return` zurückgegeben werden.

## Repeat-Schleife

Die `repeat`-Schleife stammt aus Lua:

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
repeat
  print i
  i -= 1
until i == 0
```

</div>
</div>

`repeat`-Ausdrücke unterstützen ebenfalls `break` mit mehreren Rückgabewerten:

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

</div>
</div>
