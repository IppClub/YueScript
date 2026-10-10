---
title: Continue
sidebar:
  order: 21
---

Eine `continue`-Anweisung überspringt die aktuelle Iteration einer Schleife.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

</div>
</div>

`continue` kann auch mit Schleifenausdrücken verwendet werden, um zu verhindern, dass diese Iteration in das Ergebnis akkumuliert wird. Dieses Beispiel filtert die Array-Tabelle auf gerade Zahlen:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

</div>
</div>
