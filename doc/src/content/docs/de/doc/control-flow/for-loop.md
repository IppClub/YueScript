---
title: For-Schleife
sidebar:
  order: 19
---

Es gibt zwei Formen der `for`-Schleife, genau wie in Lua: eine numerische und eine generische.

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- ein optionaler Schritt
  print k

for key, value in pairs object
  print key, value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for i = 10, 20
  print i

for k = 1, 15, 2 -- ein optionaler Schritt
  print k

for key, value in pairs object
  print key, value
```

</div>
</div>

Die Slicing- und **\***-Operatoren können verwendet werden, genau wie bei Comprehensions:

```yuescript
for item in *items[2, 4]
  print item
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items[2, 4]
  print item
```

</div>
</div>

Eine kürzere Syntax ist für alle Varianten verfügbar, wenn der Rumpf nur eine Zeile hat:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items do print item

for j = 1, 10, 3 do print j
```

</div>
</div>

Eine `for`-Schleife kann auch als Ausdruck verwendet werden. Die letzte Anweisung im Schleifenrumpf wird in einen Ausdruck umgewandelt und an eine wachsende Array-Tabelle angehängt.

Alle geraden Zahlen verdoppeln:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

</div>
</div>

Zusätzlich unterstützen `for`-Schleifen `break` mit Rückgabewerten, sodass die Schleife selbst als Ausdruck verwendet werden kann, der früh mit einem sinnvollen Ergebnis endet. `for`-Ausdrücke unterstützen mehrere `break`-Werte.

Beispiel: die erste Zahl größer als 10 finden:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
first_large = for n in *numbers
  break n if n > 10
```

</div>
</div>

Diese `break`-mit-Wert-Syntax ermöglicht knappe und ausdrucksstarke Such- bzw. Early-Exit-Muster direkt in Schleifenausdrücken.

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

</div>
</div>

Du kannst Werte auch filtern, indem du den `for`-Ausdruck mit `continue` kombinierst.

`for`-Schleifen am Ende eines Funktionsrumpfs werden nicht in eine Tabelle für einen Rückgabewert gesammelt (stattdessen gibt die Funktion `nil` zurück). Du kannst entweder explizit `return` verwenden oder die Schleife in eine Listen-Comprehension umwandeln.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- gibt nil aus
print func_b! -- gibt Tabellenobjekt aus
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- gibt nil aus
print func_b! -- gibt Tabellenobjekt aus
```

</div>
</div>

Das verhindert die unnötige Erstellung von Tabellen in Funktionen, die die Ergebnisse der Schleife nicht zurückgeben müssen.
