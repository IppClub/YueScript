# Funktionsliterale

Alle Funktionen werden mit einem Funktionsausdruck erstellt. Eine einfache Funktion wird mit dem Pfeil **->** notiert.

```yuescript
my_function = ->
my_function() -- leere Funktion aufrufen
```

<YueDisplay>

```yue
my_function = ->
my_function() -- leere Funktion aufrufen
```

</YueDisplay>

Der Funktionskörper kann entweder eine einzelne Anweisung direkt nach dem Pfeil sein oder aus mehreren Anweisungen bestehen, die in den folgenden Zeilen eingerückt werden:

```yuescript
func_a = -> print "Hallo Welt"

func_b = ->
  value = 100
  print "Der Wert:", value
```

<YueDisplay>

```yue
func_a = -> print "Hallo Welt"

func_b = ->
  value = 100
  print "Der Wert:", value
```

</YueDisplay>

Wenn eine Funktion keine Argumente hat, kann sie mit dem `!`-Operator statt leerer Klammern aufgerufen werden. Der `!`-Aufruf ist die bevorzugte Art, Funktionen ohne Argumente aufzurufen.

```yuescript
func_a!
func_b()
```

<YueDisplay>

```yue
func_a!
func_b()
```

</YueDisplay>

Funktionen mit Argumenten werden erstellt, indem der Pfeil von einer Argumentliste in Klammern eingeleitet wird:

```yuescript
sum = (x, y) -> print "Summe", x + y
```

<YueDisplay>

```yue
sum = (x, y) -> print "Summe", x + y
```

</YueDisplay>

Funktionen können aufgerufen werden, indem die Argumente hinter dem Namen eines Ausdrucks stehen, der zu einer Funktion evaluiert. Beim Verketten mehrerer Funktionsaufrufe werden die Argumente der nächstliegenden Funktion links zugeordnet.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

<YueDisplay>

```yue
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

</YueDisplay>

Um Mehrdeutigkeiten beim Aufruf zu vermeiden, können die Argumente auch in Klammern gesetzt werden. Das ist hier nötig, damit die richtigen Argumente an die richtigen Funktionen gehen.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

<YueDisplay>

```yue
print "x:", sum(10, 20), "y:", sum(30, 40)
```

</YueDisplay>

Zwischen öffnender Klammer und Funktionsname darf kein Leerzeichen stehen.

Funktionen wandeln die letzte Anweisung im Funktionskörper in ein `return` um. Das nennt sich implizites Return:

```yuescript
sum = (x, y) -> x + y
print "Die Summe ist ", sum 10, 20
```

<YueDisplay>

```yue
sum = (x, y) -> x + y
print "Die Summe ist ", sum 10, 20
```

</YueDisplay>

Wenn du explizit zurückgeben willst, verwende `return`:

```yuescript
sum = (x, y) -> return x + y
```

<YueDisplay>

```yue
sum = (x, y) -> return x + y
```

</YueDisplay>

Wie in Lua können Funktionen mehrere Werte zurückgeben. Die letzte Anweisung muss eine Liste von Werten sein, getrennt durch Kommas:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

<YueDisplay>

```yue
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

</YueDisplay>

## Fat Arrows

Da es in Lua üblich ist, beim Methodenaufruf ein Objekt als erstes Argument zu übergeben, gibt es eine spezielle Syntax zum Erstellen von Funktionen, die automatisch ein `self`-Argument enthalten.

```yuescript
func = (num) => @value + num
```

<YueDisplay>

```yue
func = (num) => @value + num
```

</YueDisplay>

## Standardwerte für Argumente

Es ist möglich, Standardwerte für Funktionsargumente anzugeben. Ein Argument gilt als leer, wenn sein Wert `nil` ist. Alle `nil`-Argumente mit Standardwert werden vor Ausführung des Funktionskörpers ersetzt.

```yuescript
my_function = (name = "etwas", height = 100) ->
  print "Hallo, ich bin", name
  print "Meine Größe ist", height
```

<YueDisplay>

```yue
my_function = (name = "etwas", height = 100) ->
  print "Hallo, ich bin", name
  print "Meine Größe ist", height
```

</YueDisplay>

Der Ausdruck für den Standardwert wird im Funktionskörper in der Reihenfolge der Argumentdeklarationen ausgewertet. Daher können Standardwerte auf zuvor deklarierte Argumente zugreifen.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

<YueDisplay>

```yue
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

</YueDisplay>

## Hinweise

Aufgrund der ausdrucksstarken, klammerlosen Funktionsaufrufe müssen einige Einschränkungen gelten, um Parsing-Mehrdeutigkeiten mit Leerraum zu vermeiden.

Das Minuszeichen hat zwei Rollen: unäre Negation und binäre Subtraktion. Sieh dir an, wie die folgenden Beispiele kompiliert werden:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

<YueDisplay>

```yue
a = x - 10
b = x-10
c = x -y
d = x- z
```

</YueDisplay>

Die Präzedenz des ersten Arguments eines Funktionsaufrufs kann mit Leerraum gesteuert werden, wenn das Argument ein String-Literal ist. In Lua lässt man bei Aufrufen mit einem einzelnen String- oder Tabellenliteral häufig die Klammern weg.

Wenn kein Leerzeichen zwischen Variable und String-Literal steht, hat der Funktionsaufruf Vorrang vor nachfolgenden Ausdrücken. In dieser Form können keine weiteren Argumente übergeben werden.

Steht ein Leerzeichen zwischen Variable und String-Literal, verhält sich der Aufruf wie oben gezeigt. Das String-Literal gehört dann zu nachfolgenden Ausdrücken (falls vorhanden) und dient als Argumentliste.

```yuescript
x = func"hallo" + 100
y = func "hallo" + 100
```

<YueDisplay>

```yue
x = func"hallo" + 100
y = func "hallo" + 100
```

</YueDisplay>

## Mehrzeilige Argumente

Wenn Funktionsaufrufe viele Argumente haben, ist es praktisch, die Argumentliste auf mehrere Zeilen zu verteilen. Wegen der whitespace-sensitiven Natur der Sprache muss man dabei sorgfältig sein.

Wenn eine Argumentliste in der nächsten Zeile fortgesetzt wird, muss die aktuelle Zeile mit einem Komma enden. Die folgende Zeile muss stärker eingerückt sein als die aktuelle. Sobald eingerückt, müssen alle weiteren Argumentzeilen auf derselben Einrückungsebene liegen, um Teil der Argumentliste zu sein.

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

<YueDisplay>

```yue
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

</YueDisplay>

Diese Art des Aufrufs kann verschachtelt werden. Die Einrückungsebene bestimmt, zu welcher Funktion die Argumente gehören.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

<YueDisplay>

```yue
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

</YueDisplay>

Da Tabellen ebenfalls das Komma als Trennzeichen verwenden, hilft diese Einrückungssyntax dabei, Werte zur Argumentliste gehören zu lassen, statt zur Tabelle.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

<YueDisplay>

```yue
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

</YueDisplay>

Obwohl es selten ist: Du kannst Funktionsargumente tiefer einrücken, wenn du weißt, dass du später eine geringere Einrückungsebene verwenden wirst.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

<YueDisplay>

```yue
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

</YueDisplay>

Dasselbe lässt sich mit anderen Block-Statements wie Bedingungen machen. Wir können die Einrückungsebene verwenden, um zu bestimmen, zu welcher Anweisung ein Wert gehört:

```yuescript
if func 1, 2, 3,
  "hallo",
  "Welt"
    print "hallo"
    print "Ich bin innerhalb der if-Bedingung"

if func 1, 2, 3,
    "hallo",
    "Welt"
  print "hallo"
  print "Ich bin innerhalb der if-Bedingung"
```

<YueDisplay>

```yue
if func 1, 2, 3,
  "hallo",
  "Welt"
    print "hallo"
    print "Ich bin innerhalb der if-Bedingung"

if func 1, 2, 3,
    "hallo",
    "Welt"
  print "hallo"
  print "Ich bin innerhalb der if-Bedingung"
```

</YueDisplay>

## Parameter-Destructuring

YueScript unterstützt jetzt Destructuring von Funktionsparametern, wenn das Argument ein Objekt ist. Es gibt zwei Formen von Destructuring-Tabellenliteralen:

- **Geschweifte Klammern/Objektparameter**, die optionale Standardwerte erlauben, wenn Felder fehlen (z. B. `{:a, :b}`, `{a: a1 = 123}`).
- **Unverpackte einfache Tabellensyntax**, die mit einer Sequenz aus Key-Value- oder Shorthand-Bindings beginnt und so lange läuft, bis ein anderer Ausdruck sie beendet (z. B. `:a, b: b1, :c`). Diese Form extrahiert mehrere Felder aus demselben Objekt.

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

<YueDisplay>

```yue
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

</YueDisplay>

## Präfixiertes Return-Expression

Wenn du mit tief verschachtelten Funktionskörpern arbeitest, kann es mühsam sein, die Lesbarkeit und Konsistenz des Rückgabewerts zu erhalten. Dafür führt YueScript die Syntax der **präfixierten Return-Expression** ein. Sie hat folgende Form:

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

<YueDisplay>

```yue
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

</YueDisplay>

Das ist äquivalent zu:

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

<YueDisplay>

```yue
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

</YueDisplay>

Der einzige Unterschied ist, dass du den finalen Rückgabeausdruck vor das `->`- oder `=>`-Token ziehen kannst, um den impliziten Rückgabewert der Funktion als letzte Anweisung zu kennzeichnen. So musst du selbst bei Funktionen mit mehreren verschachtelten Schleifen oder bedingten Zweigen kein abschließendes `return` am Ende des Funktionskörpers mehr schreiben, was die Logikstruktur klarer und leichter nachvollziehbar macht.

## Benannte Varargs

Mit der Syntax `(...t) ->` kannst du Varargs automatisch in einer benannten Tabelle speichern. Diese Tabelle enthält alle übergebenen Argumente (einschließlich `nil`-Werten), und das Feld `n` der Tabelle speichert die tatsächliche Anzahl übergebener Argumente (einschließlich `nil`-Werten).

```yuescript
f = (...t) ->
  print "Anzahl der Argumente:", t.n
  print "Tabellenlänge:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Fälle mit nil-Werten behandeln
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

<YueDisplay>

```yue
f = (...t) ->
  print "Anzahl der Argumente:", t.n
  print "Tabellenlänge:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Fälle mit nil-Werten behandeln
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

</YueDisplay>
