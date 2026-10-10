---
title: With-Statement
sidebar:
  order: 27
---

Ein häufiges Muster bei der Erstellung eines Objekts ist, unmittelbar danach eine Reihe von Funktionen aufzurufen und Eigenschaften zu setzen.

Das führt dazu, dass der Objektname mehrfach wiederholt wird und unnötiges Rauschen entsteht. Eine gängige Lösung ist, eine Tabelle als Argument zu übergeben, die eine Sammlung von Schlüsseln und Werten enthält, die überschrieben werden sollen. Der Nachteil ist, dass der Konstruktor dieses Objekts diese Form unterstützen muss.

Der `with`-Block hilft, das zu vermeiden. Innerhalb eines `with`-Blocks können wir spezielle Anweisungen verwenden, die mit `.` oder `\` beginnen und die Operationen auf das Objekt anwenden, mit dem wir gerade arbeiten.

Zum Beispiel arbeiten wir mit einem neu erstellten Objekt:

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</div>
</div>

Das `with`-Statement kann auch als Ausdruck verwendet werden und gibt den Wert zurück, auf den es Zugriff gewährt.

```yuescript
file = with File "Lieblingsessen.txt"
  \set_encoding "utf8"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
file = with File "Lieblingsessen.txt"
  \set_encoding "utf8"
```

</div>
</div>

`with`-Ausdrücke unterstützen `break` mit genau einem Wert:

```yuescript
result = with obj
  break .value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
result = with obj
  break .value
```

</div>
</div>

Sobald `break value` in `with` verwendet wird, gibt der `with`-Ausdruck nicht mehr sein Zielobjekt zurück, sondern den von `break` gelieferten Wert.

```yuescript
a = with obj
  .x = 1
-- a ist obj

b = with obj
  break .x
-- b ist .x, nicht obj
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = with obj
  .x = 1
-- a ist obj

b = with obj
  break .x
-- b ist .x, nicht obj
```

</div>
</div>

Im Unterschied zu `for` / `while` / `repeat` / `do` unterstützt `with` nur einen `break`-Wert.

Oder …

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</div>
</div>

In dieser Verwendung kann `with` als spezielle Form des K-Kombinators gesehen werden.

Der Ausdruck im `with`-Statement kann auch eine Zuweisung sein, wenn du dem Ausdruck einen Namen geben willst.

```yuescript
with str := "Hallo"
  print "Original:", str
  print "Großbuchstaben:", \upper!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with str := "Hallo"
  print "Original:", str
  print "Großbuchstaben:", \upper!
```

</div>
</div>

Du kannst in einem `with`-Statement über `[]` auf spezielle Schlüssel zugreifen.

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- an "tb" anhängen
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- an "tb" anhängen
```

</div>
</div>

`with?` ist eine erweiterte Version der `with`-Syntax, die einen Existenz-Check einführt, um Objekte, die `nil` sein könnten, sicher zuzugreifen, ohne explizite Nullprüfungen.

```yuescript
with? obj
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with? obj
  print .name
```

</div>
</div>
