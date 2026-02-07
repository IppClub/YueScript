# Destructuring-Zuweisung

Destructuring-Zuweisung ist eine Möglichkeit, schnell Werte aus einer Tabelle nach Name oder Position in array-basierten Tabellen zu extrahieren.

Normalerweise steht ein Tabellenliteral wie `{1,2,3}` auf der rechten Seite einer Zuweisung, weil es ein Wert ist. Destructuring-Zuweisung tauscht die Rolle des Tabellenliterals und setzt es auf die linke Seite der Zuweisung.

Am besten lässt sich das mit Beispielen erklären. So entpackst du die ersten zwei Werte einer Tabelle:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

<YueDisplay>

```yue
thing = [1, 2]

[a, b] = thing
print a, b
```

</YueDisplay>

Im Destructuring-Tabellenliteral repräsentiert der Schlüssel den zu lesenden Schlüssel der rechten Seite, und der Wert ist der Name, dem der gelesene Wert zugewiesen wird.

```yuescript
obj = {
  hello: "Welt"
  day: "Dienstag"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- einfache Destructuring-Zuweisung ohne Klammern ist ok
```

<YueDisplay>

```yue
obj = {
  hello: "Welt"
  day: "Dienstag"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- einfache Destructuring-Zuweisung ohne Klammern ist ok
```

</YueDisplay>

Das funktioniert auch mit verschachtelten Datenstrukturen:

```yuescript
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "grün"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

<YueDisplay>

```yue
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "grün"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

</YueDisplay>

Wenn die Destructuring-Anweisung kompliziert ist, kannst du sie gerne auf mehrere Zeilen verteilen. Ein etwas komplexeres Beispiel:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

<YueDisplay>

```yue
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

</YueDisplay>

Es ist üblich, Werte aus einer Tabelle zu extrahieren und ihnen lokale Variablen mit demselben Namen wie der Schlüssel zuzuweisen. Um Wiederholungen zu vermeiden, kannst du den Präfix-Operator **:** verwenden:

```yuescript
{:concat, :insert} = table
```

<YueDisplay>

```yue
{:concat, :insert} = table
```

</YueDisplay>

Das ist effektiv dasselbe wie `import`, aber du kannst Felder umbenennen, indem du die Syntax mischst:

```yuescript
{:mix, :max, random: rand} = math
```

<YueDisplay>

```yue
{:mix, :max, random: rand} = math
```

</YueDisplay>

Du kannst Standardwerte beim Destructuring angeben, z. B.:

```yuescript
{:name = "namenlos", :job = "arbeitlos"} = person
```

<YueDisplay>

```yue
{:name = "namenlos", :job = "arbeitlos"} = person
```

</YueDisplay>

Du kannst `_` als Platzhalter verwenden, wenn du eine Listen-Destructuring-Zuweisung machst:

```yuescript
[_, two, _, four] = items
```

<YueDisplay>

```yue
[_, two, _, four] = items
```

</YueDisplay>

## Bereichs-Destructuring

Du kannst den Spread-Operator `...` in Listen-Destructuring verwenden, um einen Wertebereich zu erfassen. Das ist nützlich, wenn du bestimmte Elemente am Anfang und Ende einer Liste extrahieren und den Rest dazwischen sammeln willst.

```yuescript
orders = ["erster", "zweiter", "dritter", "vierter", "letzter"]
[first, ...bulk, last] = orders
print first  -- gibt aus: erster
print bulk   -- gibt aus: {"zweiter", "dritter", "vierter"}
print last   -- gibt aus: letzter
```

<YueDisplay>

```yue
orders = ["erster", "zweiter", "dritter", "vierter", "letzter"]
[first, ...bulk, last] = orders
print first  -- gibt aus: erster
print bulk   -- gibt aus: {"zweiter", "dritter", "vierter"}
print last   -- gibt aus: letzter
```

</YueDisplay>

Der Spread-Operator kann an unterschiedlichen Positionen verwendet werden, um unterschiedliche Bereiche zu erfassen, und du kannst `_` als Platzhalter für Werte verwenden, die du nicht erfassen willst:

```yuescript
-- Alles nach dem ersten Element erfassen
[first, ...rest] = orders

-- Alles vor dem letzten Element erfassen
[...start, last] = orders

-- Alles außer den mittleren Elementen erfassen
[first, ..._, last] = orders
```

<YueDisplay>

```yue
-- Alles nach dem ersten Element erfassen
[first, ...rest] = orders

-- Alles vor dem letzten Element erfassen
[...start, last] = orders

-- Alles außer den mittleren Elementen erfassen
[first, ..._, last] = orders
```

</YueDisplay>

## Destructuring an anderen Stellen

Destructuring kann auch an Stellen vorkommen, an denen eine Zuweisung implizit erfolgt. Ein Beispiel ist eine `for`-Schleife:

```yuescript
tuples = [
  ["hallo", "Welt"]
  ["Ei", "Kopf"]
]

for [left, right] in *tuples
  print left, right
```

<YueDisplay>

```yue
tuples = [
  ["hallo", "Welt"]
  ["Ei", "Kopf"]
]

for [left, right] in *tuples
  print left, right
```

</YueDisplay>

Wir wissen, dass jedes Element der Array-Tabelle ein 2er-Tupel ist, daher können wir es direkt in der Namensliste der `for`-Anweisung mittels Destructuring entpacken.
