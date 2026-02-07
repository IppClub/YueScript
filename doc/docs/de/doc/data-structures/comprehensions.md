# Comprehensions

Comprehensions bieten eine bequeme Syntax, um eine neue Tabelle zu erzeugen, indem man über ein bestehendes Objekt iteriert und einen Ausdruck auf seine Werte anwendet. Es gibt zwei Arten: Listen-Comprehensions und Tabellen-Comprehensions. Beide erzeugen Lua-Tabellen; Listen-Comprehensions sammeln Werte in einer array-ähnlichen Tabelle, und Tabellen-Comprehensions erlauben es, Schlüssel und Wert pro Iteration zu setzen.

## Listen-Comprehensions

Das folgende Beispiel erstellt eine Kopie der `items`-Tabelle, aber mit verdoppelten Werten.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

<YueDisplay>

```yue
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

</YueDisplay>

Die Elemente in der neuen Tabelle können mit einer `when`-Klausel eingeschränkt werden:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

<YueDisplay>

```yue
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

</YueDisplay>

Da es üblich ist, über die Werte einer numerisch indizierten Tabelle zu iterieren, gibt es den **\***-Operator. Das Verdopplungsbeispiel kann so umgeschrieben werden:

```yuescript
doubled = [item * 2 for item in *items]
```

<YueDisplay>

```yue
doubled = [item * 2 for item in *items]
```

</YueDisplay>

In Listen-Comprehensions kannst du außerdem den Spread-Operator `...` verwenden, um verschachtelte Listen zu flatten und einen Flat-Map-Effekt zu erzielen:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat ist jetzt [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat ist jetzt [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

Die `for`- und `when`-Klauseln können beliebig oft verkettet werden. Die einzige Anforderung ist, dass eine Comprehension mindestens eine `for`-Klausel enthält.

Mehrere `for`-Klauseln entsprechen verschachtelten Schleifen:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

<YueDisplay>

```yue
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

</YueDisplay>

Numerische `for`-Schleifen können ebenfalls in Comprehensions verwendet werden:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

<YueDisplay>

```yue
evens = [i for i = 1, 100 when i % 2 == 0]
```

</YueDisplay>

## Tabellen-Comprehensions

Die Syntax für Tabellen-Comprehensions ist sehr ähnlich, unterscheidet sich jedoch dadurch, dass **{** und **}** verwendet werden und pro Iteration zwei Werte erzeugt werden.

Dieses Beispiel erstellt eine Kopie von `thing`:

```yuescript
thing = {
  color: "rot"
  name: "schnell"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

<YueDisplay>

```yue
thing = {
  color: "rot"
  name: "schnell"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

</YueDisplay>

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

<YueDisplay>

```yue
no_color = {k, v for k, v in pairs thing when k != "color"}
```

</YueDisplay>

Der **\***-Operator wird ebenfalls unterstützt. Hier erstellen wir eine Nachschlagetabelle für Quadratwurzeln einiger Zahlen.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

<YueDisplay>

```yue
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

</YueDisplay>

Das Schlüssel-Wert-Tupel in einer Tabellen-Comprehension kann auch aus einem einzelnen Ausdruck stammen; der Ausdruck muss dann zwei Werte zurückgeben. Der erste wird als Schlüssel und der zweite als Wert verwendet:

In diesem Beispiel konvertieren wir ein Array von Paaren in eine Tabelle, wobei das erste Element des Paars der Schlüssel und das zweite der Wert ist.

```yuescript
tuples = [ ["hallo", "Welt"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

<YueDisplay>

```yue
tuples = [ ["hallo", "Welt"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

</YueDisplay>

## Slicing

Eine spezielle Syntax erlaubt es, die iterierten Elemente bei Verwendung des **\***-Operators einzuschränken. Das ist äquivalent zum Setzen von Iterationsgrenzen und Schrittweite in einer `for`-Schleife.

Hier setzen wir die minimalen und maximalen Grenzen und nehmen alle Elemente mit Indizes zwischen 1 und 5 (inklusive):

```yuescript
slice = [item for item in *items[1, 5]]
```

<YueDisplay>

```yue
slice = [item for item in *items[1, 5]]
```

</YueDisplay>

Jedes der Slice-Argumente kann weggelassen werden, um einen sinnvollen Standard zu verwenden. Wenn der maximale Index weggelassen wird, entspricht er der Länge der Tabelle. Dieses Beispiel nimmt alles außer dem ersten Element:

```yuescript
slice = [item for item in *items[2,]]
```

<YueDisplay>

```yue
slice = [item for item in *items[2,]]
```

</YueDisplay>

Wenn die Mindestgrenze weggelassen wird, ist sie standardmäßig 1. Hier geben wir nur die Schrittweite an und lassen die anderen Grenzen leer. Das nimmt alle ungerad indizierten Elemente (1, 3, 5, …):

```yuescript
slice = [item for item in *items[,,2]]
```

<YueDisplay>

```yue
slice = [item for item in *items[,,2]]
```

</YueDisplay>

Sowohl die Mindest- als auch die Maximalgrenze können negativ sein; dann werden die Grenzen vom Ende der Tabelle gezählt.

```yuescript
-- die letzten 4 Elemente nehmen
slice = [item for item in *items[-4,-1]]
```

<YueDisplay>

```yue
-- die letzten 4 Elemente nehmen
slice = [item for item in *items[-4,-1]]
```

</YueDisplay>

Die Schrittweite kann ebenfalls negativ sein, wodurch die Elemente in umgekehrter Reihenfolge genommen werden.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

<YueDisplay>

```yue
reverse_slice = [item for item in *items[-1,1,-1]]
```

</YueDisplay>

### Slicing-Ausdruck

Slicing kann auch als Ausdruck verwendet werden. Das ist nützlich, um eine Teilliste einer Tabelle zu erhalten.

```yuescript
-- das 2. und 4. Element als neue Liste nehmen
sub_list = items[2, 4]

-- die letzten 4 Elemente nehmen
last_four_items = items[-4, -1]
```

<YueDisplay>

```yue
-- das 2. und 4. Element als neue Liste nehmen
sub_list = items[2, 4]

-- die letzten 4 Elemente nehmen
last_four_items = items[-4, -1]
```

</YueDisplay>
