---
title: Destructuring-Zuweisung
sidebar:
  order: 11
---

Destructuring-Zuweisung ist eine Möglichkeit, schnell Werte aus einer Tabelle nach Name oder Position in array-basierten Tabellen zu extrahieren.

Normalerweise steht ein Tabellenliteral wie `{1,2,3}` auf der rechten Seite einer Zuweisung, weil es ein Wert ist. Destructuring-Zuweisung tauscht die Rolle des Tabellenliterals und setzt es auf die linke Seite der Zuweisung.

Am besten lässt sich das mit Beispielen erklären. So entpackst du die ersten zwei Werte einer Tabelle:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
thing = [1, 2]

[a, b] = thing
print a, b
```

</div>
</div>

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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

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

</div>
</div>

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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

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

</div>
</div>

Wenn die Destructuring-Anweisung kompliziert ist, kannst du sie gerne auf mehrere Zeilen verteilen. Ein etwas komplexeres Beispiel:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

</div>
</div>

Es ist üblich, Werte aus einer Tabelle zu extrahieren und ihnen lokale Variablen mit demselben Namen wie der Schlüssel zuzuweisen. Um Wiederholungen zu vermeiden, kannst du den Präfix-Operator **:** verwenden:

```yuescript
{:concat, :insert} = table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:concat, :insert} = table
```

</div>
</div>

Das ist effektiv dasselbe wie `import`, aber du kannst Felder umbenennen, indem du die Syntax mischst:

```yuescript
{:mix, :max, random: rand} = math
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:mix, :max, random: rand} = math
```

</div>
</div>

Du kannst Standardwerte beim Destructuring angeben, z. B.:

```yuescript
{:name = "namenlos", :job = "arbeitlos"} = person
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:name = "namenlos", :job = "arbeitlos"} = person
```

</div>
</div>

Du kannst `_` als Platzhalter verwenden, wenn du eine Listen-Destructuring-Zuweisung machst:

```yuescript
[_, two, _, four] = items
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
[_, two, _, four] = items
```

</div>
</div>

## Bereichs-Destructuring

Du kannst den Spread-Operator `...` in Listen-Destructuring verwenden, um einen Wertebereich zu erfassen. Das ist nützlich, wenn du bestimmte Elemente am Anfang und Ende einer Liste extrahieren und den Rest dazwischen sammeln willst.

```yuescript
orders = ["erster", "zweiter", "dritter", "vierter", "letzter"]
[first, ...bulk, last] = orders
print first  -- gibt aus: erster
print bulk   -- gibt aus: {"zweiter", "dritter", "vierter"}
print last   -- gibt aus: letzter
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
orders = ["erster", "zweiter", "dritter", "vierter", "letzter"]
[first, ...bulk, last] = orders
print first  -- gibt aus: erster
print bulk   -- gibt aus: {"zweiter", "dritter", "vierter"}
print last   -- gibt aus: letzter
```

</div>
</div>

Der Spread-Operator kann an unterschiedlichen Positionen verwendet werden, um unterschiedliche Bereiche zu erfassen, und du kannst `_` als Platzhalter für Werte verwenden, die du nicht erfassen willst:

```yuescript
-- Alles nach dem ersten Element erfassen
[first, ...rest] = orders

-- Alles vor dem letzten Element erfassen
[...start, last] = orders

-- Alles außer den mittleren Elementen erfassen
[first, ..._, last] = orders
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- Alles nach dem ersten Element erfassen
[first, ...rest] = orders

-- Alles vor dem letzten Element erfassen
[...start, last] = orders

-- Alles außer den mittleren Elementen erfassen
[first, ..._, last] = orders
```

</div>
</div>

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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tuples = [
  ["hallo", "Welt"]
  ["Ei", "Kopf"]
]

for [left, right] in *tuples
  print left, right
```

</div>
</div>

Wir wissen, dass jedes Element der Array-Tabelle ein 2er-Tupel ist, daher können wir es direkt in der Namensliste der `for`-Anweisung mittels Destructuring entpacken.
