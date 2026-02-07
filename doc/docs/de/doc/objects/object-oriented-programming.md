# Objektorientierte Programmierung

In diesen Beispielen kann der generierte Lua-Code überwältigend wirken. Am besten konzentrierst du dich zunächst auf die Bedeutung des YueScript-Codes und schaust dir den Lua-Code nur an, wenn du die Implementierungsdetails wissen möchtest.

Eine einfache Klasse:

```yuescript
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```

<YueDisplay>

```yue
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```

</YueDisplay>

Eine Klasse wird mit einem `class`-Statement deklariert, gefolgt von einer tabellenähnlichen Deklaration mit allen Methoden und Eigenschaften.

Die Eigenschaft `new` ist besonders, da sie zum Konstruktor wird.

Beachte, dass alle Methoden in der Klasse die Fat-Arrow-Syntax verwenden. Beim Aufruf von Methoden auf einer Instanz wird die Instanz selbst als erstes Argument übergeben. Der Fat-Arrow übernimmt die Erstellung des `self`-Arguments.

Das `@`-Präfix ist Kurzform für `self.`. `@items` wird zu `self.items`.

Eine Instanz der Klasse wird erstellt, indem man den Klassennamen wie eine Funktion aufruft.

```yuescript
inv = Inventory!
inv\add_item "T-Shirt"
inv\add_item "Hose"
```

<YueDisplay>

```yue
inv = Inventory!
inv\add_item "T-Shirt"
inv\add_item "Hose"
```

</YueDisplay>

Da die Instanz bei Methodenaufrufen an die Methoden übergeben werden muss, wird der `\`-Operator verwendet.

Alle Eigenschaften einer Klasse werden von allen Instanzen gemeinsam genutzt. Für Funktionen ist das ok, aber bei anderen Objekten kann das zu unerwünschten Ergebnissen führen.

Im folgenden Beispiel wird die Eigenschaft `clothes` von allen Instanzen geteilt, sodass Änderungen in einer Instanz in einer anderen sichtbar werden:

```yuescript
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "Hose"
b\give_item "Hemd"

-- gibt sowohl Hose als auch Hemd aus
print item for item in *a.clothes
```

<YueDisplay>

```yue
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "Hose"
b\give_item "Hemd"

-- gibt sowohl Hose als auch Hemd aus
print item for item in *a.clothes
```

</YueDisplay>

Der richtige Weg, das zu vermeiden, ist, den veränderlichen Zustand im Konstruktor zu erstellen:

```yuescript
class Person
  new: =>
    @clothes = []
```

<YueDisplay>

```yue
class Person
  new: =>
    @clothes = []
```

</YueDisplay>

## Vererbung

Das Schlüsselwort `extends` kann in einer Klassendeklaration verwendet werden, um Eigenschaften und Methoden von einer anderen Klasse zu erben.

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "Rucksack ist voll"
    super name
```

<YueDisplay>

```yue
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "Rucksack ist voll"
    super name
```

</YueDisplay>

Hier erweitern wir unsere `Inventory`-Klasse und begrenzen die Anzahl der Elemente.

In diesem Beispiel definieren wir keinen Konstruktor in der Subklasse, daher wird der Konstruktor der Elternklasse beim Erstellen einer neuen Instanz aufgerufen. Definieren wir einen Konstruktor, können wir mit `super` den Elternkonstruktor aufrufen.

Wenn eine Klasse von einer anderen erbt, sendet sie eine Nachricht an die Elternklasse, indem die Methode `__inherited` der Elternklasse aufgerufen wird, falls vorhanden. Die Funktion erhält zwei Argumente: die Klasse, die vererbt wird, und die Kindklasse.

```yuescript
class Shelf
  @__inherited: (child) =>
    print @__name, "wurde vererbt von", child.__name

-- gibt aus: Shelf wurde von Cupboard geerbt
class Cupboard extends Shelf
```

<YueDisplay>

```yue
class Shelf
  @__inherited: (child) =>
    print @__name, "wurde vererbt von", child.__name

-- gibt aus: Shelf wurde von Cupboard geerbt
class Cupboard extends Shelf
```

</YueDisplay>

## Super

**super** ist ein spezielles Schlüsselwort, das auf zwei Arten verwendet werden kann: als Objekt oder als Funktionsaufruf. Es hat besondere Funktionalität nur innerhalb einer Klasse.

Wenn es als Funktion aufgerufen wird, ruft es die gleichnamige Funktion in der Elternklasse auf. `self` wird automatisch als erstes Argument übergeben (wie im Vererbungsbeispiel oben).

Wenn `super` als normaler Wert verwendet wird, ist es eine Referenz auf das Objekt der Elternklasse.

Du kannst es wie jedes andere Objekt verwenden, um Werte der Elternklasse zu lesen, die von der Kindklasse überschattet wurden.

Wenn der `\`-Aufrufoperator mit `super` verwendet wird, wird `self` als erstes Argument eingefügt statt des Wertes von `super`. Wenn man `.` zum Abrufen einer Funktion verwendet, wird die rohe Funktion zurückgegeben.

Ein paar Beispiele für `super` in unterschiedlichen Formen:

```yuescript
class MyClass extends ParentClass
  a_method: =>
    -- Folgendes hat dieselbe Wirkung:
    super "hallo", "Welt"
    super\a_method "hallo", "Welt"
    super.a_method self, "hallo", "Welt"

    -- super als Wert entspricht der Elternklasse:
    assert super == ParentClass
```

<YueDisplay>

```yue
class MyClass extends ParentClass
  a_method: =>
    -- Folgendes hat dieselbe Wirkung:
    super "hallo", "Welt"
    super\a_method "hallo", "Welt"
    super.a_method self, "hallo", "Welt"

    -- super als Wert entspricht der Elternklasse:
    assert super == ParentClass
```

</YueDisplay>

**super** kann auch links einer Funktions-Stub verwendet werden. Der einzige große Unterschied ist, dass die resultierende Funktion statt an `super` an `self` gebunden wird.

## Typen

Jede Instanz einer Klasse trägt ihren Typ in sich. Dieser wird in der speziellen Eigenschaft `__class` gespeichert. Diese Eigenschaft enthält das Klassenobjekt. Das Klassenobjekt wird aufgerufen, um eine neue Instanz zu erstellen. Wir können das Klassenobjekt auch indizieren, um Klassenmethoden und Eigenschaften abzurufen.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- gibt 10 aus
```

<YueDisplay>

```yue
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- gibt 10 aus
```

</YueDisplay>

## Klassenobjekte

Das Klassenobjekt entsteht, wenn wir ein `class`-Statement verwenden. Es wird in einer Variablen mit dem Klassennamen gespeichert.

Das Klassenobjekt kann wie eine Funktion aufgerufen werden, um neue Instanzen zu erstellen. So haben wir die Instanzen in den Beispielen oben erstellt.

Eine Klasse besteht aus zwei Tabellen: der Klassentabelle selbst und der Basistabelle. Die Basis wird als Metatable für alle Instanzen verwendet. Alle in der Klassendeklaration aufgeführten Eigenschaften werden in der Basis platziert.

Das Metatable des Klassenobjekts liest Eigenschaften aus der Basis, wenn sie im Klassenobjekt nicht existieren. Das bedeutet, dass wir Funktionen und Eigenschaften direkt von der Klasse aus aufrufen können.

Wichtig: Zuweisungen an das Klassenobjekt schreiben nicht in die Basis. Das ist keine gültige Methode, um neue Methoden zu Instanzen hinzuzufügen. Stattdessen muss die Basis explizit geändert werden. Siehe das Feld `__base` unten.

Das Klassenobjekt hat einige spezielle Eigenschaften:

Der Name der Klasse, wie sie deklariert wurde, wird im Feld `__name` gespeichert.

```yuescript
print BackPack.__name -- gibt Backpack aus
```

<YueDisplay>

```yue
print BackPack.__name -- gibt Backpack aus
```

</YueDisplay>

Die Basistabelle ist in `__base` gespeichert. Du kannst diese Tabelle ändern, um Instanzen Funktionalität hinzuzufügen, die bereits existieren oder noch erstellt werden.

Wenn die Klasse von etwas erbt, ist das Elternklassenobjekt in `__parent` gespeichert.

## Klassenvariablen

Du kannst Variablen direkt im Klassenobjekt statt in der Basis erstellen, indem du in der Klassendeklaration `@` vor den Eigenschaftsnamen setzt.

```yuescript
class Things
  @some_func: => print "Hallo von", @__name

Things\some_func!

-- Klassenvariablen in Instanzen nicht sichtbar
assert Things().some_func == nil
```

<YueDisplay>

```yue
class Things
  @some_func: => print "Hallo von", @__name

Things\some_func!

-- Klassenvariablen in Instanzen nicht sichtbar
assert Things().some_func == nil
```

</YueDisplay>

In Ausdrücken können wir `@@` verwenden, um auf einen Wert zuzugreifen, der in `self.__class` gespeichert ist. `@@hello` ist also eine Kurzform für `self.__class.hello`.

```yuescript
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- gibt 2 aus
```

<YueDisplay>

```yue
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- gibt 2 aus
```

</YueDisplay>

Die Aufrufsemantik von `@@` ist ähnlich wie bei `@`. Wenn du einen `@@`-Namen aufrufst, wird die Klasse als erstes Argument übergeben (Lua-`:`-Syntax).

```yuescript
@@hello 1,2,3,4
```

<YueDisplay>

```yue
@@hello 1,2,3,4
```

</YueDisplay>

## Klassendeklarations-Statements

Im Rumpf einer Klassendeklaration können wir normale Ausdrücke zusätzlich zu Schlüssel/Wert-Paaren haben. In diesem Kontext ist `self` gleich dem Klassenobjekt.

Hier ist eine alternative Möglichkeit, eine Klassenvariable zu erstellen:

```yuescript
class Things
  @class_var = "Hallo Welt"
```

<YueDisplay>

```yue
class Things
  @class_var = "Hallo Welt"
```

</YueDisplay>

Diese Ausdrücke werden ausgeführt, nachdem alle Eigenschaften zur Basis hinzugefügt wurden.

Alle Variablen, die im Klassenkörper deklariert werden, sind lokal zu den Klasseneigenschaften. Das ist praktisch, um private Werte oder Hilfsfunktionen zu platzieren, auf die nur die Klassenmethoden zugreifen können:

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "Hallo Welt: " .. secret
```

<YueDisplay>

```yue
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "Hallo Welt: " .. secret
```

</YueDisplay>

## @- und @@-Werte

Wenn `@` und `@@` vor einem Namen stehen, repräsentieren sie den Namen in `self` bzw. `self.__class`.

Wenn sie alleine verwendet werden, sind sie Aliase für `self` und `self.__class`.

```yuescript
assert @ == self
assert @@ == self.__class
```

<YueDisplay>

```yue
assert @ == self
assert @@ == self.__class
```

</YueDisplay>

Zum Beispiel kannst du mit `@@` in einer Instanzmethode schnell eine neue Instanz derselben Klasse erzeugen:

```yuescript
some_instance_method = (...) => @@ ...
```

<YueDisplay>

```yue
some_instance_method = (...) => @@ ...
```

</YueDisplay>

## Konstruktor-Property-Promotion

Um Boilerplate beim Definieren einfacher Value-Objekte zu reduzieren, kannst du eine Klasse so schreiben:

```yuescript
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- Kurzform für

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```

<YueDisplay>

```yue
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- Kurzform für

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```

</YueDisplay>

Du kannst diese Syntax auch für eine gemeinsame Funktion verwenden, um Objektfelder zu initialisieren.

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

<YueDisplay>

```yue
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

</YueDisplay>

## Klassenausdrücke

Die `class`-Syntax kann auch als Ausdruck verwendet werden, der einer Variable zugewiesen oder explizit zurückgegeben wird.

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

<YueDisplay>

```yue
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

</YueDisplay>

## Anonyme Klassen

Der Name kann beim Deklarieren einer Klasse weggelassen werden. Das `__name`-Attribut ist dann `nil`, es sei denn, der Klassenausdruck steht in einer Zuweisung. In diesem Fall wird der Name auf der linken Seite statt `nil` verwendet.

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

<YueDisplay>

```yue
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

</YueDisplay>

Du kannst sogar den Körper weglassen und eine leere anonyme Klasse schreiben:

```yuescript
x = class
```

<YueDisplay>

```yue
x = class
```

</YueDisplay>

## Class Mixing

Du kannst mit dem Schlüsselwort `using` mischen, um Funktionen aus einer einfachen Tabelle oder einem vordefinierten Klassenobjekt in deine neue Klasse zu kopieren. Beim Mischen mit einer einfachen Tabelle kannst du die Klassen-Indexing-Funktion (Metamethod `__index`) überschreiben. Beim Mischen mit einem bestehenden Klassenobjekt werden dessen Metamethoden nicht kopiert.

```yuescript
MyIndex = __index: var: 1

class X using MyIndex
  func: =>
    print 123

x = X!
print x.var

class Y using X

y = Y!
y\func!

assert y.__class.__parent ~= X -- X ist nicht die Elternklasse von Y
```

<YueDisplay>

```yue
MyIndex = __index: var: 1

class X using MyIndex
  func: =>
    print 123

x = X!
print x.var

class Y using X

y = Y!
y\func!

assert y.__class.__parent ~= X -- X ist nicht die Elternklasse von Y
```

</YueDisplay>
