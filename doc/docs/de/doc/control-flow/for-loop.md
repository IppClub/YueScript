# For-Schleife

Es gibt zwei Formen der `for`-Schleife, genau wie in Lua: eine numerische und eine generische.

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- ein optionaler Schritt
  print k

for key, value in pairs object
  print key, value
```

<YueDisplay>

```yue
for i = 10, 20
  print i

for k = 1, 15, 2 -- ein optionaler Schritt
  print k

for key, value in pairs object
  print key, value
```

</YueDisplay>

Die Slicing- und **\***-Operatoren können verwendet werden, genau wie bei Comprehensions:

```yuescript
for item in *items[2, 4]
  print item
```

<YueDisplay>

```yue
for item in *items[2, 4]
  print item
```

</YueDisplay>

Eine kürzere Syntax ist für alle Varianten verfügbar, wenn der Rumpf nur eine Zeile hat:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

<YueDisplay>

```yue
for item in *items do print item

for j = 1, 10, 3 do print j
```

</YueDisplay>

Eine `for`-Schleife kann auch als Ausdruck verwendet werden. Die letzte Anweisung im Schleifenrumpf wird in einen Ausdruck umgewandelt und an eine wachsende Array-Tabelle angehängt.

Alle geraden Zahlen verdoppeln:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

<YueDisplay>

```yue
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

</YueDisplay>

Zusätzlich unterstützen `for`-Schleifen `break` mit Rückgabewert, sodass die Schleife selbst als Ausdruck verwendet werden kann, der früh mit einem sinnvollen Ergebnis endet.

Beispiel: die erste Zahl größer als 10 finden:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

<YueDisplay>

```yue
first_large = for n in *numbers
  break n if n > 10
```

</YueDisplay>

Diese `break`-mit-Wert-Syntax ermöglicht knappe und ausdrucksstarke Such- bzw. Early-Exit-Muster direkt in Schleifenausdrücken.

Du kannst Werte auch filtern, indem du den `for`-Ausdruck mit `continue` kombinierst.

`for`-Schleifen am Ende eines Funktionsrumpfs werden nicht in eine Tabelle für einen Rückgabewert gesammelt (stattdessen gibt die Funktion `nil` zurück). Du kannst entweder explizit `return` verwenden oder die Schleife in eine Listen-Comprehension umwandeln.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- gibt nil aus
print func_b! -- gibt Tabellenobjekt aus
```

<YueDisplay>

```yue
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- gibt nil aus
print func_b! -- gibt Tabellenobjekt aus
```

</YueDisplay>

Das verhindert die unnötige Erstellung von Tabellen in Funktionen, die die Ergebnisse der Schleife nicht zurückgeben müssen.
