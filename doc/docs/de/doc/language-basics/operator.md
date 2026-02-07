# Operatoren

Alle binären und unären Operatoren von Lua sind verfügbar. Zusätzlich ist **!=** ein Alias für **~=**, und entweder **\*\* oder **::\*\* kann für verkettete Funktionsaufrufe wie `tb\func!` oder `tb::func!` verwendet werden. Außerdem bietet YueScript einige spezielle Operatoren für ausdrucksstärkeren Code.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

<YueDisplay>

```yue
tb\func! if tb ~= nil
tb::func! if tb != nil
```

</YueDisplay>

## Verkettete Vergleiche

Vergleiche können beliebig verkettet werden:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- Ausgabe: true

a = 5
print 1 <= a <= 10
-- Ausgabe: true
```

<YueDisplay>

```yue
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- Ausgabe: true

a = 5
print 1 <= a <= 10
-- Ausgabe: true
```

</YueDisplay>

Beachte das Auswertungsverhalten verketteter Vergleiche:

```yuescript
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  Ausgabe:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  Ausgabe:
  2
  1
  false
]]
```

<YueDisplay>

```yue
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  Ausgabe:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  Ausgabe:
  2
  1
  false
]]
```

</YueDisplay>

Der mittlere Ausdruck wird nur einmal ausgewertet, nicht zweimal wie bei `v(1) < v(2) and v(2) <= v(3)`. Die Auswertungsreihenfolge in verketteten Vergleichen ist jedoch undefiniert. Es wird dringend empfohlen, in verketteten Vergleichen keine Ausdrücke mit Seiteneffekten (z. B. `print`) zu verwenden. Wenn Seiteneffekte nötig sind, sollte der Short-Circuit-Operator `and` explizit verwendet werden.

## Tabellenerweiterung

Der Operator **[] =** wird verwendet, um Werte an Tabellen anzuhängen.

```yuescript
tab = []
tab[] = "Wert"
```

<YueDisplay>

```yue
tab = []
tab[] = "Wert"
```

</YueDisplay>

Du kannst auch den Spread-Operator `...` verwenden, um alle Elemente einer Liste an eine andere anzuhängen:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA ist jetzt [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA ist jetzt [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

## Tabellen-Spread

Du kannst Array-Tabellen oder Hash-Tabellen mit dem Spread-Operator `...` vor Ausdrücken in Tabellenliteralen zusammenführen.

```yuescript
parts =
  * "Schultern"
  * "Knie"
lyrics =
  * "Kopf"
  * ...parts
  * "und"
  * "Zehen"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

<YueDisplay>

```yue
parts =
  * "Schultern"
  * "Knie"
lyrics =
  * "Kopf"
  * ...parts
  * "und"
  * "Zehen"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

</YueDisplay>

## Umgekehrter Tabellenindex

Mit dem Operator **#** kannst du auf die letzten Elemente einer Tabelle zugreifen.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

<YueDisplay>

```yue
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

</YueDisplay>

## Metatable

Der Operator **<>** kann als Abkürzung für Metatable-Manipulation verwendet werden.

### Metatable erstellen

Erzeuge eine normale Tabelle mit leeren Klammern **<>** oder einem Metamethod-Schlüssel, der von **<>** umschlossen ist.

```yuescript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- Feld mit gleichnamiger Variable setzen
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs"
```

<YueDisplay>

```yue
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- Feld mit gleichnamiger Variable setzen
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs"
```

</YueDisplay>

### Metatable-Zugriff

Metatable mit **<>** oder einem von **<>** umschlossenen Metamethod-Namen aufrufen oder einen Ausdruck in **<>** schreiben.

```yuescript
-- erstellen mit Metatable, das das Feld "value" enthält
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hallo"}
print tb.item
```

<YueDisplay>

```yue
-- erstellen mit Metatable, das das Feld "value" enthält
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value
tb.<> = __index: {item: "hallo"}
print tb.item
```

</YueDisplay>

### Metatable-Destrukturierung

Destrukturiere Metatable mit Metamethoden-Schlüssel, der von **<>** umschlossen ist.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

<YueDisplay>

```yue
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

</YueDisplay>

## Existenz

Der Operator **?** kann in verschiedenen Kontexten verwendet werden, um die Existenz zu prüfen.

```yuescript
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

<YueDisplay>

```yue
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

</YueDisplay>

## Piping

Anstelle einer Reihe verschachtelter Funktionsaufrufe kannst du Werte mit dem Operator **|>** weiterleiten.

```yuescript
"hello" |> print
1 |> print 2 -- Pipe-Element als erstes Argument einfügen
2 |> print 1, _, 3 -- Pipe mit Platzhalter

-- Pipe-Ausdruck über mehrere Zeilen
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

<YueDisplay>

```yue
"hello" |> print
1 |> print 2 -- Pipe-Element als erstes Argument einfügen
2 |> print 1, _, 3 -- Pipe mit Platzhalter
-- Pipe-Ausdruck über mehrere Zeilen
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

</YueDisplay>

## Nil-Coalescing

Der Nil-Coalescing-Operator **??** gibt den Wert des linken Operanden zurück, wenn er nicht **nil** ist; andernfalls wird der rechte Operand ausgewertet und sein Ergebnis zurückgegeben. Der **??**-Operator wertet seinen rechten Operanden nicht aus, wenn der linke Operand nicht nil ergibt.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

<YueDisplay>

```yue
local a, b, c, d
a = b ?? c ?? d
func a ?? {}
a ??= false
```

</YueDisplay>

## Implizites Objekt

Du kannst innerhalb eines Tabellenblocks eine Liste impliziter Strukturen schreiben, die mit dem Symbol **\*** oder **-** beginnt. Beim Erstellen eines impliziten Objekts müssen die Felder des Objekts dieselbe Einrückung haben.

```yuescript
-- Zuweisung mit implizitem Objekt
list =
  * 1
  * 2
  * 3

-- Funktionsaufruf mit implizitem Objekt
func
  * 1
  * 2
  * 3

-- Rückgabe mit implizitem Objekt
f = ->
  return
    * 1
    * 2
    * 3

-- Tabelle mit implizitem Objekt
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }

```

<YueDisplay>

```yue
-- Zuweisung mit implizitem Objekt
list =
  * 1
  * 2
  * 3

-- Funktionsaufruf mit implizitem Objekt
func
  * 1
  * 2
  * 3

-- Rückgabe mit implizitem Objekt
f = ->
  return
    * 1
    * 2
    * 3

-- Tabelle mit implizitem Objekt
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }
```

</YueDisplay>
