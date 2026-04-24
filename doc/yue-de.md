# YueScript-Dokumentation

Willkommen in der offiziellen <b>YueScript</b>-Dokumentation!<br/>
Hier findest du Sprachfeatures, Nutzung, Referenzbeispiele und Ressourcen.<br/>
Bitte wähle ein Kapitel in der Seitenleiste, um mit YueScript zu beginnen.

# Do

Als Statement verhält sich `do` wie in Lua.

```yuescript
do
  var = "hallo"
  print var
print var -- nil hier
```

YueScripts **do** kann auch als Ausdruck verwendet werden. So kannst du mehrere Zeilen in einem Ausdruck kombinieren. Das Ergebnis des `do`-Ausdrucks ist die letzte Anweisung im Block.

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

```yuescript
tbl = {
  key: do
    print "Schlüssel wird zugewiesen!"
    1234
}
```

`do`-Ausdrücke unterstützen die Verwendung von `break`, um den Kontrollfluss zu unterbrechen und mehrere Rückgabewerte vorzeitig zurückzugeben.

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

# Line-Decorators

Zur Vereinfachung können `for`-Schleifen und `if`-Anweisungen auf einzelne Anweisungen am Zeilenende angewendet werden:

```yuescript
print "Hallo Welt" if name == "Rob"
```

Und mit einfachen Schleifen:

```yuescript
print "Element: ", item for item in *items
```

Und mit `while`-Schleifen:

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

# Makros

## Häufige Verwendung

Makrofunktionen werden verwendet, um zur Compile-Zeit einen String auszuwerten und den generierten Code in die finale Kompilierung einzufügen.

```yuescript
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'Hallo Welt'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- übergebene Ausdrücke werden als Strings behandelt
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

## Rohcode einfügen

Eine Makrofunktion kann entweder einen YueScript-String oder eine Konfigurationstabelle mit Lua-Code zurückgeben.

```yuescript
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "Zuweisung an die vom Yue-Makro definierte Variable schlägt fehl"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "Zuweisung an die vom Lua-Makro definierte Variable schlägt fehl"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- führende und abschließende Symbole des Raw-Strings werden automatisch getrimmt
$lua[==[
-- Einfügen von rohem Lua-Code
if cond then
  print("Ausgabe")
end
]==]
```

## Makros exportieren

Makrofunktionen können aus einem Modul exportiert und in ein anderes Modul importiert werden. Exportierte Makros müssen in einer einzelnen Datei liegen, und im Export-Modul dürfen nur Makrodefinitionen, Makro-Imports und Makro-Expansionen stehen.

```yuescript
-- Datei: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- Datei main.yue
import "utils" as {
  $, -- Symbol zum Importieren aller Makros
  $foreach: $each -- Makro $foreach in $each umbenennen
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```

## Eingebaute Makros

Es gibt einige eingebaute Makros, aber du kannst sie überschreiben, indem du Makros mit denselben Namen deklarierst.

```yuescript
print $FILE -- String des aktuellen Modulnamens
print $LINE -- gibt 2 aus
```

## Makros mit Makros erzeugen

In YueScript erlauben Makrofunktionen Codegenerierung zur Compile-Zeit. Durch das Verschachteln von Makrofunktionen kannst du komplexere Generierungsmuster erzeugen. Damit kannst du eine Makrofunktion definieren, die eine andere Makrofunktion erzeugt.

```yuescript
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "erhalten: \"#{item}\", erwartet eines von #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "Gültiger Enum-Typ:", $BodyType Static
-- print "Kompilierungsfehler bei Enum-Typ:", $BodyType Unknown
```

## Mehrzeiligen Code erzeugen

Wenn ein Makro mehrzeiligen Yue-Code zurückgibt, ist eine mehrzeilige Zeichenkette in Anführungszeichen nicht zu empfehlen. Verwende stattdessen bevorzugt `-> |`.

Eine Zeichenkette in Anführungszeichen behält den Text wörtlich bei, während ein YAML-Mehrzeilen-String die gemeinsame führende Einrückung entfernt. Dadurch bleiben erzeugte Yue-Blöcke in der Regel stabiler, besonders wenn der erzeugte Code Kommentare oder verschachtelte Blöcke enthält.

```yuescript
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

```yuescript
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

## Argument-Validierung

Du kannst erwartete AST-Knotentypen in der Argumentliste deklarieren und zur Compile-Zeit prüfen, ob die übergebenen Makroargumente den Erwartungen entsprechen.

```yuescript
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hallo"
```

Wenn du flexiblere Argumentprüfungen brauchst, kannst du das eingebaute Makro `$is_ast` verwenden, um manuell an der passenden Stelle zu prüfen.

```yuescript
macro printNumAndStr = (num, str) ->
  error "als erstes Argument Num erwartet" unless $is_ast Num, num
  error "als zweites Argument String erwartet" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hallo"
```

Weitere Details zu verfügbaren AST-Knoten findest du in den großgeschriebenen Definitionen in `yue_parser.cpp`.

## Annotation-Anweisungen

Annotation-Anweisungen wenden ein Makro auf die direkt folgende Anweisung an.

Das entspricht einem Makroaufruf, bei dem der Quelltext der folgenden Anweisung als letztes Argument zusätzlich übergeben wird.

```yuescript
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

Wenn das Annotationsmakro eine Konfigurationstabelle zurückgibt, steuert das optionale Feld `before`, ob das Ergebnis vor oder nach der annotierten Anweisung eingefügt wird.

```yuescript
macro Tag = (tag, code) ->
  tableName = code\match "^[%w_]+"
  return
    type: "text"
    before: tag == "before"
    code: "-- #{tag}:#{tableName}"

$[Tag before]
tableA = {}

$[Tag after]
tableB = {}

return
```

Da die folgende Anweisung als zusätzliches Makroargument übergeben wird, lassen sich mit Annotationen auch direkt Registrierungszeilen aus Klassendeklarationen erzeugen. Du kannst dabei dieselben AST-Argumentprüfungen wie bei normalen Makros verwenden.

```yuescript
macro Register = (registry, code`ClassDecl) ->
  className = code\match "^class%s+(%w+)"
  return |
    #{registry}["#{className}"] = #{className}

registry = {}

$[Register(registry)]
class Worker
  run: => "ok"

return
```

Annotationen können auch Wrapper-Code um Funktionen herum einfügen:

```yuescript
macro ValidateNumberArgs = (code) ->
  funcName = code\match "^(%w+)%s*="
  return |
    local __orig_#{funcName} = #{funcName}
    #{funcName} = (...) ->
      for i = 1, select "#", ...
        assert type(select i, ...) == "number", "expected number for arg \#{i}"
      __orig_#{funcName} ...

$[ValidateNumberArgs]
add = (a, b) -> a + b
```

Auf eine Annotation muss immer eine Anweisung folgen, und sie kann nicht auf eine `return`-Anweisung angewendet werden. Wenn die annotierte Anweisung am Ende eines Blocks steht und du die rohe AST-Form der Anweisung brauchst, füge ein explizites `return` danach ein, damit sie nicht in einen implizit zurückgegebenen Ausdruck eingebettet wird.

# Try

Die Syntax für Fehlerbehandlung in Lua in einer gängigen Form.

```yuescript
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "Versuche"
  func 1, 2, 3

-- Verwendung mit if-Zuweisungsmuster
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

## Try?

`try?` ist eine vereinfachte Fehlerbehandlungs-Syntax, die den booleschen Status aus dem `try`-Statement weglässt. Bei Erfolg gibt sie das Ergebnis des `try`-Blocks zurück, ansonsten `nil` statt eines Fehlerobjekts.

```yuescript
a, b, c = try? func!

-- mit Nil-Verschmelzungs-Operator
a = (try? func!) ?? "Standardwert"

-- als Funktionsargument
f try? func!

-- mit catch-Block
f try?
  print 123
  func!
catch e
  print e
  e
```

# Tabellenliterale

Wie in Lua werden Tabellen mit geschweiften Klammern definiert.

```yuescript
some_values = {1, 2, 3, 4}
```

Anders als in Lua weist man einem Schlüssel in einer Tabelle mit **:** (statt **=**) einen Wert zu.

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["Lieblingsessen"]: "Reis"
}
```

Die geschweiften Klammern können weggelassen werden, wenn eine einzelne Tabelle aus Schlüssel-Wert-Paaren zugewiesen wird.

```yuescript
profile =
  height: "4 Fuß",
  shoe_size: 13,
  favorite_foods: ["Eis", "Donuts"]
```

Zeilenumbrüche können Werte statt eines Kommas trennen (oder zusätzlich):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "Superman"
  occupation: "Verbrechensbekämpfung"
}
```

Beim Erstellen eines einzeiligen Tabellenliterals können die geschweiften Klammern ebenfalls weggelassen werden:

```yuescript
my_function dance: "Tango", partner: "keiner"

y = type: "Hund", legs: 4, tails: 1
```

Die Schlüssel eines Tabellenliterals können Sprach-Schlüsselwörter sein, ohne sie zu escapen:

```yuescript
tbl = {
  do: "etwas"
  end: "Hunger"
}
```

Wenn du eine Tabelle aus Variablen konstruierst und die Schlüssel den Variablennamen entsprechen sollen, kannst du den Präfix-Operator **:** verwenden:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

Wenn der Schlüssel eines Feldes das Ergebnis eines Ausdrucks sein soll, kannst du ihn wie in Lua in **[ ]** setzen. Du kannst auch ein String-Literal direkt als Schlüssel verwenden und die eckigen Klammern weglassen. Das ist nützlich, wenn dein Schlüssel Sonderzeichen enthält.

```yuescript
t = {
  [1 + 2]: "hallo"
  "Hallo Welt": true
}
```

Lua-Tabellen haben sowohl einen Array-Teil als auch einen Hash-Teil, aber manchmal ist es nützlich, hier eine semantische Unterscheidung zu treffen. Du kannst **[ ]** anstelle von **{ }** verwenden, um eine Tabelle explizit als Array zu deklarieren; dadurch wird verhindert, dass Schlüssel-Wert-Paare hineingeschrieben werden.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

# Comprehensions

Comprehensions bieten eine bequeme Syntax, um eine neue Tabelle zu erzeugen, indem man über ein bestehendes Objekt iteriert und einen Ausdruck auf seine Werte anwendet. Es gibt zwei Arten: Listen-Comprehensions und Tabellen-Comprehensions. Beide erzeugen Lua-Tabellen; Listen-Comprehensions sammeln Werte in einer array-ähnlichen Tabelle, und Tabellen-Comprehensions erlauben es, Schlüssel und Wert pro Iteration zu setzen.

## Listen-Comprehensions

Das folgende Beispiel erstellt eine Kopie der `items`-Tabelle, aber mit verdoppelten Werten.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

Die Elemente in der neuen Tabelle können mit einer `when`-Klausel eingeschränkt werden:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

Da es üblich ist, über die Werte einer numerisch indizierten Tabelle zu iterieren, gibt es den **\***-Operator. Das Verdopplungsbeispiel kann so umgeschrieben werden:

```yuescript
doubled = [item * 2 for item in *items]
```

In Listen-Comprehensions kannst du außerdem den Spread-Operator `...` verwenden, um verschachtelte Listen zu flatten und einen Flat-Map-Effekt zu erzielen:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat ist jetzt [1, 2, 3, 4, 5, 6]
```

Die `for`- und `when`-Klauseln können beliebig oft verkettet werden. Die einzige Anforderung ist, dass eine Comprehension mindestens eine `for`-Klausel enthält.

Mehrere `for`-Klauseln entsprechen verschachtelten Schleifen:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

Numerische `for`-Schleifen können ebenfalls in Comprehensions verwendet werden:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

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

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

Der **\***-Operator wird ebenfalls unterstützt. Hier erstellen wir eine Nachschlagetabelle für Quadratwurzeln einiger Zahlen.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

Das Schlüssel-Wert-Tupel in einer Tabellen-Comprehension kann auch aus einem einzelnen Ausdruck stammen; der Ausdruck muss dann zwei Werte zurückgeben. Der erste wird als Schlüssel und der zweite als Wert verwendet:

In diesem Beispiel konvertieren wir ein Array von Paaren in eine Tabelle, wobei das erste Element des Paars der Schlüssel und das zweite der Wert ist.

```yuescript
tuples = [ ["hallo", "Welt"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

## Slicing

Eine spezielle Syntax erlaubt es, die iterierten Elemente bei Verwendung des **\***-Operators einzuschränken. Das ist äquivalent zum Setzen von Iterationsgrenzen und Schrittweite in einer `for`-Schleife.

Hier setzen wir die minimalen und maximalen Grenzen und nehmen alle Elemente mit Indizes zwischen 1 und 5 (inklusive):

```yuescript
slice = [item for item in *items[1, 5]]
```

Jedes der Slice-Argumente kann weggelassen werden, um einen sinnvollen Standard zu verwenden. Wenn der maximale Index weggelassen wird, entspricht er der Länge der Tabelle. Dieses Beispiel nimmt alles außer dem ersten Element:

```yuescript
slice = [item for item in *items[2,]]
```

Wenn die Mindestgrenze weggelassen wird, ist sie standardmäßig 1. Hier geben wir nur die Schrittweite an und lassen die anderen Grenzen leer. Das nimmt alle ungerad indizierten Elemente (1, 3, 5, …):

```yuescript
slice = [item for item in *items[,,2]]
```

Sowohl die Mindest- als auch die Maximalgrenze können negativ sein; dann werden die Grenzen vom Ende der Tabelle gezählt.

```yuescript
-- die letzten 4 Elemente nehmen
slice = [item for item in *items[-4,-1]]
```

Die Schrittweite kann ebenfalls negativ sein, wodurch die Elemente in umgekehrter Reihenfolge genommen werden.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

### Slicing-Ausdruck

Slicing kann auch als Ausdruck verwendet werden. Das ist nützlich, um eine Teilliste einer Tabelle zu erhalten.

```yuescript
-- das 2. und 4. Element als neue Liste nehmen
sub_list = items[2, 4]

-- die letzten 4 Elemente nehmen
last_four_items = items[-4, -1]
```

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

Eine Klasse wird mit einem `class`-Statement deklariert, gefolgt von einer tabellenähnlichen Deklaration mit allen Methoden und Eigenschaften.

Die Eigenschaft `new` ist besonders, da sie zum Konstruktor wird.

Beachte, dass alle Methoden in der Klasse die Fat-Arrow-Syntax verwenden. Beim Aufruf von Methoden auf einer Instanz wird die Instanz selbst als erstes Argument übergeben. Der Fat-Arrow übernimmt die Erstellung des `self`-Arguments.

Das `@`-Präfix ist Kurzform für `self.`. `@items` wird zu `self.items`.

Der Klassenblock unterstützt auch Metatable-Felder, indem Metamethod-Schlüssel in spitzen Klammern geschrieben werden, zum Beispiel `<tostring>`.

```yuescript
class User
  new: (@name) =>
  <tostring>: => "User(#{@name})"

print tostring User "Yue"
```

Eine Instanz der Klasse wird erstellt, indem man den Klassennamen wie eine Funktion aufruft.

```yuescript
inv = Inventory!
inv\add_item "T-Shirt"
inv\add_item "Hose"
```

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

Der richtige Weg, das zu vermeiden, ist, den veränderlichen Zustand im Konstruktor zu erstellen:

```yuescript
class Person
  new: =>
    @clothes = []
```

## Vererbung

Das Schlüsselwort `extends` kann in einer Klassendeklaration verwendet werden, um Eigenschaften und Methoden von einer anderen Klasse zu erben.

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "Rucksack ist voll"
    super name
```

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

**super** kann auch links einer Funktions-Stub verwendet werden. Der einzige große Unterschied ist, dass die resultierende Funktion statt an `super` an `self` gebunden wird.

## Typen

Jede Instanz einer Klasse trägt ihren Typ in sich. Dieser wird in der speziellen Eigenschaft `__class` gespeichert. Diese Eigenschaft enthält das Klassenobjekt. Das Klassenobjekt wird aufgerufen, um eine neue Instanz zu erstellen. Wir können das Klassenobjekt auch indizieren, um Klassenmethoden und Eigenschaften abzurufen.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- gibt 10 aus
```

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

Die Aufrufsemantik von `@@` ist ähnlich wie bei `@`. Wenn du einen `@@`-Namen aufrufst, wird die Klasse als erstes Argument übergeben (Lua-`:`-Syntax).

```yuescript
@@hello 1,2,3,4
```

## Klassendeklarations-Statements

Im Rumpf einer Klassendeklaration können wir normale Ausdrücke zusätzlich zu Schlüssel/Wert-Paaren haben. In diesem Kontext ist `self` gleich dem Klassenobjekt.

Hier ist eine alternative Möglichkeit, eine Klassenvariable zu erstellen:

```yuescript
class Things
  @class_var = "Hallo Welt"
```

Diese Ausdrücke werden ausgeführt, nachdem alle Eigenschaften zur Basis hinzugefügt wurden.

Alle Variablen, die im Klassenkörper deklariert werden, sind lokal zu den Klasseneigenschaften. Das ist praktisch, um private Werte oder Hilfsfunktionen zu platzieren, auf die nur die Klassenmethoden zugreifen können:

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "Hallo Welt: " .. secret
```

## @- und @@-Werte

Wenn `@` und `@@` vor einem Namen stehen, repräsentieren sie den Namen in `self` bzw. `self.__class`.

Wenn sie alleine verwendet werden, sind sie Aliase für `self` und `self.__class`.

```yuescript
assert @ == self
assert @@ == self.__class
```

Zum Beispiel kannst du mit `@@` in einer Instanzmethode schnell eine neue Instanz derselben Klasse erzeugen:

```yuescript
some_instance_method = (...) => @@ ...
```

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

Du kannst diese Syntax auch für eine gemeinsame Funktion verwenden, um Objektfelder zu initialisieren.

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

## Klassenausdrücke

Die `class`-Syntax kann auch als Ausdruck verwendet werden, der einer Variable zugewiesen oder explizit zurückgegeben wird.

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

## Anonyme Klassen

Der Name kann beim Deklarieren einer Klasse weggelassen werden. Das `__name`-Attribut ist dann `nil`, es sei denn, der Klassenausdruck steht in einer Zuweisung. In diesem Fall wird der Name auf der linken Seite statt `nil` verwendet.

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

Du kannst sogar den Körper weglassen und eine leere anonyme Klasse schreiben:

```yuescript
x = class
```

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

# With-Statement

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

Das `with`-Statement kann auch als Ausdruck verwendet werden und gibt den Wert zurück, auf den es Zugriff gewährt.

```yuescript
file = with File "Lieblingsessen.txt"
  \set_encoding "utf8"
```

`with`-Ausdrücke unterstützen `break` mit genau einem Wert:

```yuescript
result = with obj
  break .value
```

Sobald `break value` in `with` verwendet wird, gibt der `with`-Ausdruck nicht mehr sein Zielobjekt zurück, sondern den von `break` gelieferten Wert.

```yuescript
a = with obj
  .x = 1
-- a ist obj

b = with obj
  break .x
-- b ist .x, nicht obj
```

Im Unterschied zu `for` / `while` / `repeat` / `do` unterstützt `with` nur einen `break`-Wert.

Oder …

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

In dieser Verwendung kann `with` als spezielle Form des K-Kombinators gesehen werden.

Der Ausdruck im `with`-Statement kann auch eine Zuweisung sein, wenn du dem Ausdruck einen Namen geben willst.

```yuescript
with str := "Hallo"
  print "Original:", str
  print "Großbuchstaben:", \upper!
```

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

`with?` ist eine erweiterte Version der `with`-Syntax, die einen Existenz-Check einführt, um Objekte, die `nil` sein könnten, sicher zuzugreifen, ohne explizite Nullprüfungen.

```yuescript
with? obj
  print .name
```

# Zuweisung

Variablen sind dynamisch typisiert und standardmäßig `local`. Du kannst den Geltungsbereich mit den Statements **local** und **global** ändern.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- nutzt die bestehende Variable
```

## Update-Zuweisung

Du kannst Update-Zuweisungen mit vielen binären Operatoren durchführen.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- legt eine neue lokale Variable an, wenn sie nicht existiert
arg or= "default value"
```

## Verkettete Zuweisung

Mit verketteten Zuweisungen kannst du mehrere Variablen auf denselben Wert setzen.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

## Explizite Locals

```yuescript
do
  local a = 1
  local *
  print "forward declare all variables as locals"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "only forward declare upper case variables"
  a = 1
  B = 2
```

## Explizite Globals

```yuescript
do
  global a = 1
  global *
  print "declare all variables as globals"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "only declare upper case variables as globals"
  a = 1
  B = 2
  local Temp = "a local value"
```

# Varargs-Zuweisung

Du kannst Rückgabewerte einer Funktion dem Varargs-Symbol `...` zuweisen und dann den Inhalt auf die Lua-Weise auslesen.

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

# If-Zuweisung

`if`- und `elseif`-Blöcke können eine Zuweisung anstelle eines Bedingungsausdrucks enthalten. Beim Auswerten der Bedingung findet die Zuweisung statt, und der zugewiesene Wert wird als Bedingung verwendet. Die zugewiesene Variable ist nur im Geltungsbereich des Bedingungsblocks verfügbar, d. h. sie ist nicht verfügbar, wenn der Wert nicht truthy ist. Für die Zuweisung musst du den "Walrus-Operator" `:=` statt `=` verwenden.

```yuescript
if user := database.find_user "moon"
  print user.name
```

```yuescript
if hello := os.getenv "hello"
  print "Du hast hello", hello
elseif world := os.getenv "world"
  print "Du hast world", world
else
  print "nichts :("
```

If-Zuweisung mit mehreren Rückgabewerten. Nur der erste Wert wird geprüft, andere Werte bleiben im Scope.

```yuescript
if success, result := pcall -> "Ergebnis ohne Probleme erhalten"
  print result -- Variable result ist im Scope
print "OK"
```

## While-Zuweisung

Du kannst if-Zuweisung auch in einer while-Schleife verwenden, um den Wert als Schleifenbedingung zu nutzen.

```yuescript
while byte := stream\read_one!
  -- mit dem Byte etwas anfangen
  print byte
```

# Destructuring-Zuweisung

Destructuring-Zuweisung ist eine Möglichkeit, schnell Werte aus einer Tabelle nach Name oder Position in array-basierten Tabellen zu extrahieren.

Normalerweise steht ein Tabellenliteral wie `{1,2,3}` auf der rechten Seite einer Zuweisung, weil es ein Wert ist. Destructuring-Zuweisung tauscht die Rolle des Tabellenliterals und setzt es auf die linke Seite der Zuweisung.

Am besten lässt sich das mit Beispielen erklären. So entpackst du die ersten zwei Werte einer Tabelle:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

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

Wenn die Destructuring-Anweisung kompliziert ist, kannst du sie gerne auf mehrere Zeilen verteilen. Ein etwas komplexeres Beispiel:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

Es ist üblich, Werte aus einer Tabelle zu extrahieren und ihnen lokale Variablen mit demselben Namen wie der Schlüssel zuzuweisen. Um Wiederholungen zu vermeiden, kannst du den Präfix-Operator **:** verwenden:

```yuescript
{:concat, :insert} = table
```

Das ist effektiv dasselbe wie `import`, aber du kannst Felder umbenennen, indem du die Syntax mischst:

```yuescript
{:mix, :max, random: rand} = math
```

Du kannst Standardwerte beim Destructuring angeben, z. B.:

```yuescript
{:name = "namenlos", :job = "arbeitlos"} = person
```

Du kannst `_` als Platzhalter verwenden, wenn du eine Listen-Destructuring-Zuweisung machst:

```yuescript
[_, two, _, four] = items
```

## Bereichs-Destructuring

Du kannst den Spread-Operator `...` in Listen-Destructuring verwenden, um einen Wertebereich zu erfassen. Das ist nützlich, wenn du bestimmte Elemente am Anfang und Ende einer Liste extrahieren und den Rest dazwischen sammeln willst.

```yuescript
orders = ["erster", "zweiter", "dritter", "vierter", "letzter"]
[first, ...bulk, last] = orders
print first  -- gibt aus: erster
print bulk   -- gibt aus: {"zweiter", "dritter", "vierter"}
print last   -- gibt aus: letzter
```

Der Spread-Operator kann an unterschiedlichen Positionen verwendet werden, um unterschiedliche Bereiche zu erfassen, und du kannst `_` als Platzhalter für Werte verwenden, die du nicht erfassen willst:

```yuescript
-- Alles nach dem ersten Element erfassen
[first, ...rest] = orders

-- Alles vor dem letzten Element erfassen
[...start, last] = orders

-- Alles außer den mittleren Elementen erfassen
[first, ..._, last] = orders
```

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

Wir wissen, dass jedes Element der Array-Tabelle ein 2er-Tupel ist, daher können wir es direkt in der Namensliste der `for`-Anweisung mittels Destructuring entpacken.

# Die Using-Klausel: Destruktive Zuweisung kontrollieren

Lexikalisches Scoping kann die Komplexität des Codes stark reduzieren, aber mit wachsendem Codeumfang kann es unübersichtlich werden. Betrachte folgendes Beispiel:

```yuescript
i = 100

-- viele Zeilen Code...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- wird 0 ausgeben
```

In `my_func` haben wir den Wert von `i` versehentlich überschrieben. In diesem Beispiel ist es offensichtlich, aber in einer großen oder fremden Codebasis ist oft nicht klar, welche Namen bereits deklariert wurden.

Es wäre hilfreich, anzugeben, welche Variablen aus dem umschließenden Scope wir verändern wollen, um versehentliche Änderungen zu vermeiden.

Das Schlüsselwort `using` ermöglicht das. `using nil` stellt sicher, dass keine geschlossenen Variablen bei Zuweisungen überschrieben werden. Die `using`-Klausel steht nach der Argumentliste einer Funktion oder ersetzt sie, wenn es keine Argumente gibt.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- hier wird eine neue lokale Variable erstellt

my_func!
print i -- gibt 100 aus, i bleibt unverändert
```

Mehrere Namen können durch Kommas getrennt werden. Closure-Werte können weiterhin gelesen, aber nicht verändert werden:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- ein neues lokales tmp wird erstellt
  i += tmp
  k += tmp

my_func(22)
print i, k -- diese wurden aktualisiert
```

# Verwendung

## Lua-Modul

YueScript-Modul in Lua verwenden:

- **Fall 1**

  "your_yuescript_entry.yue" in Lua require'n.

  ```lua
  require("yue")("your_yuescript_entry")
  ```

  Dieser Code funktioniert weiterhin, wenn du "your_yuescript_entry.yue" im gleichen Pfad zu "your_yuescript_entry.lua" kompilierst. In den restlichen YueScript-Dateien verwendest du einfach normales **require** oder **import**. Die Zeilennummern in Fehlermeldungen werden korrekt behandelt.

- **Fall 2**

  YueScript-Modul require'n und das Fehlermapping manuell umschreiben.

  ```lua
  local yue = require("yue")
  yue.insert_loader()
  local success, result = xpcall(function()
    return require("yuescript_module_name")
  end, function(err)
    return yue.traceback(err)
  end)
  ```

- **Fall 3**

  Die YueScript-Compilerfunktion in Lua verwenden.

  ```lua
  local yue = require("yue")
  local codes, err, globals = yue.to_lua([[
    f = ->
      print "Hallo Welt"
    f!
  ]],{
    implicit_return_root = true,
    reserve_line_number = true,
    lint_global = true,
    space_over_tab = false,
    options = {
      target = "5.4",
      path = "/script"
    }
  })
  ```

## YueScript-Tool

YueScript-Tool verwenden mit:

```shell
> yue -h
Verwendung: yue
          [Optionen] [<Datei/Verzeichnis>] ...
          yue -e <code_oder_datei> [argumente...]
          yue -w [<verzeichnis>] [optionen]
          yue -

Hinweise:
   - '-' / '--' muss das erste und einzige Argument sein.
   - '-o/--output' kann nicht mit mehreren Eingabedateien verwendet werden.
   - '-w/--watch' kann nicht mit Dateieingabe verwendet werden (nur Verzeichnisse).
   - Mit '-e/--execute' werden verbleibende Tokens als Skriptargumente behandelt.

Optionen:
   -h, --help                 Zeigt diese Hilfemeldung an und beendet das Programm.
   -e <str>, --execute <str>  Datei oder Quellcode ausführen
   -m, --minify               Minimierten Code erzeugen
   -r, --rewrite              Ausgabe so umschreiben, dass die Zeilennummern dem Original entsprechen
   -t <ziel>, --output-to <ziel>
                              Ziel für kompilierte Dateien angeben
   -o <datei>, --output <datei>
                              Schreibe die Ausgabe in eine Datei
   -p, --print                Schreibe die Ausgabe auf die Standardausgabe
   -b, --benchmark            Gibt die Kompilierungszeit aus (keine Ausgabe schreiben)
   -g, --globals              Gibt verwendete globale Variablen im Format NAME ZEILE SPALTE aus
   -s, --spaces               Verwende Leerzeichen anstelle von Tabs im generierten Code
   -l, --line-numbers         Schreibe Zeilennummern aus dem Quellcode
   -j, --no-implicit-return   Deaktiviert implizites Rückgabe am Datei-Ende
   -c, --reserve-comments     Kommentare aus dem Quellcode vor Anweisungen beibehalten
   -w [<verz>], --watch [<verz>]
                              Änderungen beobachten und alle Dateien im Verzeichnis kompilieren
   -v, --version              Version ausgeben
   -                          Lese von Standardinput, schreibe auf Standardausgabe
                              (muss das erste und einzige Argument sein)
   --                         Wie '-', bleibt zur Abwärtskompatibilität bestehen

   --target <version>         Gib an, welche Lua-Version erzeugt werden soll
                              (Version nur von 5.1 bis 5.5 möglich)
   --path <pfad_str>          Füge einen zusätzlichen Lua-Suchpfad zu package.path hinzu
   --<schlüssel>=<wert>       Übertrage Compileroption im Schlüssel=Wert-Format (bestehendes Verhalten)

   Ohne Optionen wird die REPL gestartet, gebe das Symbol '$'
   in eine einzelne Zeile ein, um den Multi-Line-Modus zu starten/beenden
```

Anwendungsfälle:

Rekursiv jede YueScript-Datei mit der Endung **.yue** unter dem aktuellen Pfad kompilieren: **yue .**

Kompilieren und Ergebnisse in einen Zielpfad schreiben: **yue -t /target/path/ .**

Kompilieren und Debug-Infos beibehalten: **yue -l .**

Kompilieren und minifizierten Code erzeugen: **yue -m .**

Rohcode ausführen: **yue -e 'print 123'**

Eine YueScript-Datei ausführen: **yue -e main.yue**

# Einführung

YueScript ist eine dynamische Sprache, die zu Lua kompiliert. Sie ist ein Dialekt von [MoonScript](https://github.com/leafo/moonscript). Code, der in YueScript geschrieben wird, ist ausdrucksstark und sehr kompakt. YueScript eignet sich zum Schreiben von veränderlicher Anwendungslogik mit besser wartbarem Code und läuft in eingebetteten Lua-Umgebungen wie Spielen oder Webservern.

Yue (月) ist das chinesische Wort für Mond und wird als [jyɛ] ausgesprochen.

## Ein Überblick über YueScript

```yuescript
-- Import-Syntax
import p, to_lua from "yue"

-- Objekt-Literale
inventory =
  equipment:
    - "Schwert"
    - "Schild"
  items:
    - name: "Trank"
      count: 10
    - name: "Brot"
      count: 3

-- Listen-Abstraktion
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- Pipe-Operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- Metatable-Manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- export-Syntax (ähnlich wie in JavaScript)
export 🌛 = "Skript des Mondes"
```

## Über Dora SSR

YueScript wird zusammen mit der Open-Source-Spiel-Engine [Dora SSR](https://github.com/Dora-SSR/Dora-SSR) entwickelt und gepflegt. Es wird zum Erstellen von Engine-Tools, Spiel-Demos und Prototypen eingesetzt und hat seine Leistungsfähigkeit in realen Szenarien unter Beweis gestellt, während es gleichzeitig die Dora-SSR-Entwicklungserfahrung verbessert.

# Installation

## Lua-Modul

Installiere [luarocks](https://luarocks.org), einen Paketmanager für Lua-Module. Installiere YueScript dann als Lua-Modul und ausführbare Datei mit:

```shell
luarocks install yuescript
```

Oder du kannst die Datei `yue.so` bauen mit:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Anschließend findest du die Binärdatei unter **bin/shared/yue.so**.

## Binär-Tool bauen

Klone dieses Repo und baue/installiere die ausführbare Datei mit:

```shell
make install
```

YueScript-Tool ohne Makro-Feature bauen:

```shell
make install NO_MACRO=true
```

YueScript-Tool ohne eingebautes Lua-Binary bauen:

```shell
make install NO_LUA=true
```

## Vorgefertigtes Binary herunterladen

Du kannst vorkompilierte Binärdateien herunterladen, inklusive ausführbarer Dateien für unterschiedliche Lua-Versionen und Bibliotheksdateien.

Lade vorkompilierte Binärdateien von [hier](https://github.com/IppClub/YueScript/releases) herunter.

# Bedingungen

```yuescript
have_coins = false
if have_coins
  print "Münzen erhalten"
else
  print "Keine Münzen"
```

Eine Kurzsyntax für einzelne Anweisungen kann ebenfalls verwendet werden:

```yuescript
have_coins = false
if have_coins then print "Münzen erhalten" else print "Keine Münzen"
```

Da `if`-Anweisungen als Ausdrücke verwendet werden können, kann man das auch so schreiben:

```yuescript
have_coins = false
print if have_coins then "Münzen erhalten" else "Keine Münzen"
```

Bedingungen können auch in `return`-Anweisungen und Zuweisungen verwendet werden:

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Ich bin sehr groß"
else
  "Ich bin nicht so groß"

print message -- gibt aus: Ich bin sehr groß
```

Das Gegenteil von `if` ist `unless`:

```yuescript
unless os.date("%A") == "Monday"
  print "Es ist nicht Montag!"
```

```yuescript
print "You're lucky!" unless math.random! > 0.1
```

## In-Ausdruck

Mit einem `in`-Ausdruck kannst du Bereichsprüfungen schreiben.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "Gleichheitsprüfung mit diskreten Werten"

if a in list
  print "Prüfen, ob `a` in einer Liste ist"
```

Der `in`-Operator kann auch mit Tabellen verwendet werden und unterstützt die Variante `not in` für Verneinungen:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a ist in der Tabelle"

not_exist = item not in list

check = -> value not in table
```

Eine Ein-Element-Liste oder Tabelle prüft auf Gleichheit mit diesem Element:

```yuescript
-- [1,] prüft, ob wert == 1
c = a in [1,]

-- {1} prüft auch, ob wert == 1
c = a in {1}

-- Ohne Komma ist [1] ein Indexzugriff (tb[1])
with tb
  c = a in [1]
```

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

Die Slicing- und **\***-Operatoren können verwendet werden, genau wie bei Comprehensions:

```yuescript
for item in *items[2, 4]
  print item
```

Eine kürzere Syntax ist für alle Varianten verfügbar, wenn der Rumpf nur eine Zeile hat:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

Eine `for`-Schleife kann auch als Ausdruck verwendet werden. Die letzte Anweisung im Schleifenrumpf wird in einen Ausdruck umgewandelt und an eine wachsende Array-Tabelle angehängt.

Alle geraden Zahlen verdoppeln:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

Zusätzlich unterstützen `for`-Schleifen `break` mit Rückgabewerten, sodass die Schleife selbst als Ausdruck verwendet werden kann, der früh mit einem sinnvollen Ergebnis endet. `for`-Ausdrücke unterstützen mehrere `break`-Werte.

Beispiel: die erste Zahl größer als 10 finden:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

Diese `break`-mit-Wert-Syntax ermöglicht knappe und ausdrucksstarke Such- bzw. Early-Exit-Muster direkt in Schleifenausdrücken.

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

Du kannst Werte auch filtern, indem du den `for`-Ausdruck mit `continue` kombinierst.

`for`-Schleifen am Ende eines Funktionsrumpfs werden nicht in eine Tabelle für einen Rückgabewert gesammelt (stattdessen gibt die Funktion `nil` zurück). Du kannst entweder explizit `return` verwenden oder die Schleife in eine Listen-Comprehension umwandeln.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- gibt nil aus
print func_b! -- gibt Tabellenobjekt aus
```

Das verhindert die unnötige Erstellung von Tabellen in Funktionen, die die Ergebnisse der Schleife nicht zurückgeben müssen.

# Continue

Eine `continue`-Anweisung überspringt die aktuelle Iteration einer Schleife.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

`continue` kann auch mit Schleifenausdrücken verwendet werden, um zu verhindern, dass diese Iteration in das Ergebnis akkumuliert wird. Dieses Beispiel filtert die Array-Tabelle auf gerade Zahlen:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

# Switch

Die `switch`-Anweisung ist eine Kurzform für eine Reihe von `if`-Anweisungen, die gegen denselben Wert prüfen. Der Wert wird nur einmal ausgewertet. Wie bei `if` kann `switch` einen `else`-Block haben, wenn keine Übereinstimmung gefunden wird. Verglichen wird mit dem Operator `==`. In einer `switch`-Anweisung kannst du auch eine Zuweisung verwenden, um den temporären Wert zu speichern.

```yuescript
switch name := "Dan"
  when "Robert"
    print "Du bist Robert"
  when "Dan", "Daniel"
    print "Dein Name ist Dan"
  else
    print "Ich kenne dich nicht mit dem Namen #{name}"
```

Eine `when`-Klausel kann mehrere Werte prüfen, indem sie kommasepariert aufgelistet werden.

`switch` kann auch als Ausdruck verwendet werden. Hier wird das Ergebnis der `switch`-Anweisung einer Variable zugewiesen:

```yuescript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "so hoch kann ich nicht zählen!"
```

Du kannst das Schlüsselwort `then` verwenden, um einen `when`-Block in einer Zeile zu schreiben. Für den `else`-Block braucht es kein zusätzliches Schlüsselwort.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "Du hast Glück"
  when 2 then "Du hast fast Glück"
  else "nicht so viel Glück"
```

Wenn du eine Einrückung weniger möchtest, kannst du die erste `when`-Klausel in die Startzeile der Anweisung setzen und alle weiteren Klauseln mit einer Einrückung weniger schreiben.

```yuescript
switch math.random(1, 5)
  when 1
    print "Du hast Glück" -- zwei Einrückungen
  else
    print "nicht so viel Glück"

switch math.random(1, 5) when 1
  print "Du hast Glück" -- eine Einrückung
else
  print "nicht so viel Glück"
```

Beachte die Reihenfolge des Case-Vergleichsausdrucks. Der Case-Ausdruck steht auf der linken Seite. Das kann nützlich sein, wenn der Case-Ausdruck die Vergleichslogik über eine `__eq`-Metamethod selbst definiert.

## Tabellen-Matching

Du kannst in einer `switch`-`when`-Klausel Tabellen-Matching verwenden, wenn die Tabelle durch eine bestimmte Struktur destrukturiert werden kann und dabei nicht-`nil`-Werte liefert.

```yuescript
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "Größe #{width}, #{height}"
```

Du kannst Standardwerte verwenden, um bestimmte Felder optional zu destrukturieren.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- Fehler: Versuch, einen nil-Wert zu indexieren (Feld 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- Tabellen-Destrukturierung greift trotzdem
```

Du kannst auch gegen Array-Elemente, Tabellenfelder und sogar verschachtelte Strukturen mit Array- oder Tabellenliteralen matchen.

Matchen gegen Array-Elemente.

```yuescript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b hat einen Standardwert
    print "1, 2, #{b}"
```

Matchen gegen Tabellenfelder mit Destructuring.

```yuescript
switch tb
  when success: true, :result
    print "Erfolg", result
  when success: false
    print "fehlgeschlagen", result
  else
    print "ungültig"
```

Matchen gegen verschachtelte Tabellenstrukturen.

```yuescript
switch tb
  when data: {type: "success", :content}
    print "Erfolg", content
  when data: {type: "error", :content}
    print "fehlgeschlagen", content
  else
    print "ungültig"
```

Matchen gegen Array von Tabellen.

```yuescript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "getroffen", fourth
```

Matchen gegen eine Liste und einen Bereich von Elementen erfassen.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Gruppe:", groups -- gibt aus: {"admin", "users"}
    print "Ressource:", resource -- gibt aus: "logs"
    print "Aktion:", action -- gibt aus: "view"
```

# While-Schleife

Die `while`-Schleife gibt es ebenfalls in vier Variationen:

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

Wie bei `for`-Schleifen kann die `while`-Schleife auch als Ausdruck verwendet werden. `while`- und `until`-Ausdrücke unterstützen `break` mit mehreren Rückgabewerten.

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

Damit eine Funktion den akkumulierten Wert einer `while`-Schleife zurückgibt, muss die Anweisung explizit mit `return` zurückgegeben werden.

## Repeat-Schleife

Die `repeat`-Schleife stammt aus Lua:

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

`repeat`-Ausdrücke unterstützen ebenfalls `break` mit mehreren Rückgabewerten:

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

# Funktions-Stubs

Es ist üblich, eine Funktion eines Objekts als Wert weiterzureichen, z. B. eine Instanzmethode als Callback. Wenn die Funktion das Objekt, auf dem sie arbeitet, als erstes Argument erwartet, musst du dieses Objekt irgendwie mit der Funktion bündeln, damit sie korrekt aufgerufen werden kann.

Die Funktions-Stub-Syntax ist eine Kurzform, um eine neue Closure-Funktion zu erstellen, die sowohl Objekt als auch Funktion bündelt. Diese neue Funktion ruft die umschlossene Funktion im richtigen Kontext des Objekts auf.

Die Syntax entspricht dem Aufruf einer Instanzmethode mit dem `\`-Operator, jedoch ohne Argumentliste.

```yuescript
my_object = {
  value: 1000
  write: => print "der Wert:", @value
}

run_callback = (func) ->
  print "Callback wird ausgeführt..."
  func!

-- das funktioniert nicht:
-- die Funktion darf keine Referenz auf my_object haben
run_callback my_object.write

-- Funktions-Stub-Syntax
-- bindet das Objekt in eine neue Funktion ein
run_callback my_object\write
```

# Backcalls

Backcalls werden verwendet, um Callbacks zu entkoppeln (unnesting). Sie werden mit Pfeilen nach links definiert und füllen standardmäßig als letzter Parameter einen Funktionsaufruf. Die Syntax ist weitgehend wie bei normalen Pfeilfunktionen, nur dass der Pfeil in die andere Richtung zeigt und der Funktionskörper keine Einrückung benötigt.

```yuescript
x <- f
print "hallo" .. x
```

Fat-Arrow-Funktionen sind ebenfalls verfügbar.

```yuescript
<= f
print @value
```

Du kannst einen Platzhalter angeben, an welcher Stelle die Backcall-Funktion als Parameter eingesetzt werden soll.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

Wenn du nach deinen Backcalls weiteren Code haben willst, kannst du sie mit einem `do`-Statement absetzen. Bei Nicht-Fat-Arrow-Funktionen können die Klammern weggelassen werden.

```yuescript
result, msg = do
  data <- readAsync "dateiname.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

# Funktionsliterale

Alle Funktionen werden mit einem Funktionsausdruck erstellt. Eine einfache Funktion wird mit dem Pfeil **->** notiert.

```yuescript
my_function = ->
my_function() -- leere Funktion aufrufen
```

Der Funktionskörper kann entweder eine einzelne Anweisung direkt nach dem Pfeil sein oder aus mehreren Anweisungen bestehen, die in den folgenden Zeilen eingerückt werden:

```yuescript
func_a = -> print "Hallo Welt"

func_b = ->
  value = 100
  print "Der Wert:", value
```

Wenn eine Funktion keine Argumente hat, kann sie mit dem `!`-Operator statt leerer Klammern aufgerufen werden. Der `!`-Aufruf ist die bevorzugte Art, Funktionen ohne Argumente aufzurufen.

```yuescript
func_a!
func_b()
```

Funktionen mit Argumenten werden erstellt, indem der Pfeil von einer Argumentliste in Klammern eingeleitet wird:

```yuescript
sum = (x, y) -> print "Summe", x + y
```

Funktionen können aufgerufen werden, indem die Argumente hinter dem Namen eines Ausdrucks stehen, der zu einer Funktion evaluiert. Beim Verketten mehrerer Funktionsaufrufe werden die Argumente der nächstliegenden Funktion links zugeordnet.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

Um Mehrdeutigkeiten beim Aufruf zu vermeiden, können die Argumente auch in Klammern gesetzt werden. Das ist hier nötig, damit die richtigen Argumente an die richtigen Funktionen gehen.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

Zwischen öffnender Klammer und Funktionsname darf kein Leerzeichen stehen.

Funktionen wandeln die letzte Anweisung im Funktionskörper in ein `return` um. Das nennt sich implizites Return:

```yuescript
sum = (x, y) -> x + y
print "Die Summe ist ", sum 10, 20
```

Wenn du explizit zurückgeben willst, verwende `return`:

```yuescript
sum = (x, y) -> return x + y
```

Wie in Lua können Funktionen mehrere Werte zurückgeben. Die letzte Anweisung muss eine Liste von Werten sein, getrennt durch Kommas:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

## Fat Arrows

Da es in Lua üblich ist, beim Methodenaufruf ein Objekt als erstes Argument zu übergeben, gibt es eine spezielle Syntax zum Erstellen von Funktionen, die automatisch ein `self`-Argument enthalten.

```yuescript
func = (num) => @value + num
```

## Standardwerte für Argumente

Es ist möglich, Standardwerte für Funktionsargumente anzugeben. Ein Argument gilt als leer, wenn sein Wert `nil` ist. Alle `nil`-Argumente mit Standardwert werden vor Ausführung des Funktionskörpers ersetzt.

```yuescript
my_function = (name = "etwas", height = 100) ->
  print "Hallo, ich bin", name
  print "Meine Größe ist", height
```

Der Ausdruck für den Standardwert wird im Funktionskörper in der Reihenfolge der Argumentdeklarationen ausgewertet. Daher können Standardwerte auf zuvor deklarierte Argumente zugreifen.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

## Hinweise

Aufgrund der ausdrucksstarken, klammerlosen Funktionsaufrufe müssen einige Einschränkungen gelten, um Parsing-Mehrdeutigkeiten mit Leerraum zu vermeiden.

Das Minuszeichen hat zwei Rollen: unäre Negation und binäre Subtraktion. Sieh dir an, wie die folgenden Beispiele kompiliert werden:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

Die Präzedenz des ersten Arguments eines Funktionsaufrufs kann mit Leerraum gesteuert werden, wenn das Argument ein String-Literal ist. In Lua lässt man bei Aufrufen mit einem einzelnen String- oder Tabellenliteral häufig die Klammern weg.

Wenn kein Leerzeichen zwischen Variable und String-Literal steht, hat der Funktionsaufruf Vorrang vor nachfolgenden Ausdrücken. In dieser Form können keine weiteren Argumente übergeben werden.

Steht ein Leerzeichen zwischen Variable und String-Literal, verhält sich der Aufruf wie oben gezeigt. Das String-Literal gehört dann zu nachfolgenden Ausdrücken (falls vorhanden) und dient als Argumentliste.

```yuescript
x = func"hallo" + 100
y = func "hallo" + 100
```

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

Diese Art des Aufrufs kann verschachtelt werden. Die Einrückungsebene bestimmt, zu welcher Funktion die Argumente gehören.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

Da Tabellen ebenfalls das Komma als Trennzeichen verwenden, hilft diese Einrückungssyntax dabei, Werte zur Argumentliste gehören zu lassen, statt zur Tabelle.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

Obwohl es selten ist: Du kannst Funktionsargumente tiefer einrücken, wenn du weißt, dass du später eine geringere Einrückungsebene verwenden wirst.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

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

# Leerraum

YueScript ist eine whitespace-sensible Sprache. Du musst bestimmte Code-Blöcke mit derselben Einrückung (Leerzeichen **' '** oder Tab **'\t'**) schreiben, z. B. Funktionskörper, Wertelisten und Kontrollblöcke. Ausdrücke mit unterschiedlichem Leerraum können unterschiedliche Bedeutungen haben. Ein Tab wird wie 4 Leerzeichen behandelt, aber es ist besser, Leerzeichen und Tabs nicht zu mischen.

## Anweisungs-Trenner

Eine Anweisung endet normalerweise an einem Zeilenumbruch. Du kannst auch ein Semikolon `;` verwenden, um eine Anweisung explizit zu beenden, wodurch mehrere Anweisungen in einer Zeile möglich sind:

```yuescript
a = 1; b = 2; print a + b
```

## Mehrzeiliges Chaining

Du kannst mehrzeilige, verkettete Funktionsaufrufe mit derselben Einrückung schreiben.

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

# Kommentare

```yuescript
-- Ich bin ein Kommentar

str = --[[
Dies ist ein mehrzeiliger Kommentar.
Alles okay.
]] strA \ -- Kommentar 1
  .. strB \ -- Kommentar 2
  .. strC

func --[[Port]] 3000, --[[IP]] "192.168.1.1"
```

# Attribute

Syntax-Unterstützung für Lua-5.4-Attribute. Du kannst weiterhin die Deklarationen `const` und `close` verwenden und erhältst Konstantenprüfung sowie Scoped-Callbacks, wenn du auf Lua-Versionen unter 5.4 zielst.

```yuescript
const a = 123
close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs."
```

Du kannst Destructuring mit als konstant markierten Variablen verwenden.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

Du kannst auch eine globale Variable als `const` deklarieren.

```yuescript
global const Constant = 123
-- Constant = 1
```

# Operatoren

Alle binären und unären Operatoren von Lua sind verfügbar. Zusätzlich ist **!=** ein Alias für **~=**, und entweder **\*\* oder **::\*\* kann für verkettete Funktionsaufrufe wie `tb\func!` oder `tb::func!` verwendet werden. Außerdem bietet YueScript einige spezielle Operatoren für ausdrucksstärkeren Code.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

## Verkettete Vergleiche

Vergleiche können beliebig verkettet werden:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- Ausgabe: true

a = 5
print 1 <= a <= 10
-- Ausgabe: true
```

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

Der mittlere Ausdruck wird nur einmal ausgewertet, nicht zweimal wie bei `v(1) < v(2) and v(2) <= v(3)`. Die Auswertungsreihenfolge in verketteten Vergleichen ist jedoch undefiniert. Es wird dringend empfohlen, in verketteten Vergleichen keine Ausdrücke mit Seiteneffekten (z. B. `print`) zu verwenden. Wenn Seiteneffekte nötig sind, sollte der Short-Circuit-Operator `and` explizit verwendet werden.

## Tabellenerweiterung

Der Operator **[] =** wird verwendet, um Werte an Tabellen anzuhängen.

```yuescript
tab = []
tab[] = "Wert"
```

Du kannst auch den Spread-Operator `...` verwenden, um alle Elemente einer Liste an eine andere anzuhängen:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA ist jetzt [1, 2, 3, 4, 5, 6]
```

## Tabellen-Spread

Du kannst Array-Tabellen oder Hash-Tabellen mit dem Spread-Operator `...` vor Ausdrücken in Tabellenliteralen zusammenführen.

Wenn in ein Tabellenliteral mit geschweiften Klammern gespreadet wird (zum Beispiel `{...other}`), werden sowohl der Array-Teil als auch der Hash-Teil der Lua-Tabelle kopiert.

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

### List-Tabellen-Spread

Wenn in ein Tabellenliteral mit eckigen Klammern gespreadet wird (zum Beispiel `[...other,]`), wird nur der Array-Teil kopiert.

```yuescript
source = {1, 2, 3, name: "Yue"}
fullCopy = {...source}
listCopy = [...source,]
-- fullCopy => {1, 2, 3, name: "Yue"}
-- listCopy => [1, 2, 3]
```

## Umgekehrter Tabellenindex

Mit dem Operator **#** kannst du auf die letzten Elemente einer Tabelle zugreifen.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

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

### Metatable-Destrukturierung

Destrukturiere Metatable mit Metamethoden-Schlüssel, der von **<>** umschlossen ist.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

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

## Nil-Coalescing

Der Nil-Coalescing-Operator **??** gibt den Wert des linken Operanden zurück, wenn er nicht **nil** ist; andernfalls wird der rechte Operand ausgewertet und sein Ergebnis zurückgegeben. Der **??**-Operator wertet seinen rechten Operanden nicht aus, wenn der linke Operand nicht nil ergibt.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

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

# Literale

Alle primitiven Literale in Lua können verwendet werden. Das gilt für Zahlen, Strings, Booleans und **nil**.

Anders als in Lua sind Zeilenumbrüche innerhalb einfacher und doppelter Anführungszeichen ohne Escape-Sequenz erlaubt:

```yuescript
some_string = "Hier ist ein String
  mit einem Zeilenumbruch."

-- Mit der #{}-Syntax kannst du Ausdrücke in String-Literale einbinden.
-- String-Interpolation gibt es nur in doppelt angeführten Strings.
print "Ich bin mir zu #{math.random! * 100}% sicher."
```

## Zahlenliterale

Du kannst Unterstriche in Zahlenliteralen verwenden, um die Lesbarkeit zu erhöhen.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

## YAML-Mehrzeilen-String

Das Präfix `|` führt ein mehrzeiliges String-Literal im YAML-Stil ein:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

Damit lässt sich strukturierter, mehrzeiliger Text bequem schreiben. Alle Zeilenumbrüche und Einrückungen bleiben relativ zur ersten nicht-leeren Zeile erhalten, und Ausdrücke innerhalb von `#{...}` werden automatisch als `tostring(expr)` interpoliert.

Der YAML-Mehrzeilen-String erkennt automatisch das gemeinsame führende Leerraumpräfix (minimale Einrückung über alle nicht-leeren Zeilen) und entfernt es aus allen Zeilen. So kannst du deinen Code optisch einrücken, ohne den resultierenden String zu verändern.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

Die interne Einrückung bleibt relativ zum entfernten gemeinsamen Präfix erhalten, wodurch saubere, verschachtelte Strukturen möglich sind.

Alle Sonderzeichen wie Anführungszeichen (`"`) und Backslashes (`\`) im YAML-Mehrzeilen-Block werden automatisch escaped, sodass der erzeugte Lua-String syntaktisch korrekt ist und wie erwartet funktioniert.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

# Module

## Import

Die `import`-Anweisung ist syntaktischer Zucker für `require` und hilft beim Extrahieren von Einträgen aus importierten Modulen. Importierte Elemente sind standardmäßig `const`.

```yuescript
-- als Tabellen-Destrukturierung
do
  import insert, concat from table
  -- Fehler beim Zuweisen zu insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- Kurzform für implizites Require
  import x, y, z from 'mymodule'
  -- Import im Python-Stil
  from 'module' import a, b, c

-- Kurzform zum Laden eines Moduls
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- Modul mit Alias oder Tabellen-Destrukturierung laden
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

## Import von Globals

Du kannst mit `import` bestimmte Globals in lokale Variablen importieren. Wenn du eine Kette von Globalzugriffen importierst, wird das letzte Feld der lokalen Variable zugewiesen.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

### Automatischer Global-Import

Du kannst `import global` am Anfang eines Blocks platzieren, um automatisch alle Namen zu importieren, die im aktuellen Scope nicht explizit deklariert oder zugewiesen sind. Diese impliziten Importe werden als lokale `const` behandelt, die an die entsprechenden Globals zum Zeitpunkt der Anweisung gebunden sind.

Namen, die im selben Scope explizit als `global` deklariert werden, werden nicht importiert, sodass du sie weiterhin zuweisen kannst.

```yuescript
do
  import global
  print "hallo"
  math.random 3
  -- print = nil -- Fehler: importierte Globals sind const

do
  -- explizite globale Variable wird nicht importiert
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

## Export

Die `export`-Anweisung bietet eine knappe Möglichkeit, Module zu definieren.

### Benannter Export

Benannter Export definiert eine lokale Variable und fügt ein Feld in die exportierte Tabelle ein.

```yuescript
export a, b, c = 1, 2, 3
export cool = "Katze"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

Benannter Export mit Destructuring.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

Benannte Elemente aus dem Modul exportieren, ohne lokale Variablen zu erstellen.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

### Unbenannter Export

Unbenannter Export fügt das Ziel-Element in den Array-Teil der exportierten Tabelle ein.

```yuescript
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

### Default-Export

Mit dem Schlüsselwort **default** in einer `export`-Anweisung wird die exportierte Tabelle durch ein beliebiges Objekt ersetzt.

```yuescript
export default ->
  print "hallo"
  123
```

# Lizenz: MIT

Hinweis: Die MIT-Lizenz ist unten im englischen Originaltext wiedergegeben.

Urheberrecht (c) 2017-2026 Li Jin <dragon-fly@qq.com>

Hiermit wird unentgeltlich jeder Person, die eine Kopie dieser Software und der zugehörigen Dokumentationsdateien (die "Software") erhält, die Erlaubnis erteilt, uneingeschränkt mit der Software zu verfahren, einschließlich und ohne Beschränkung der Rechte, die Software zu benutzen, zu kopieren, zu verändern, zusammenzuführen, zu veröffentlichen, zu verbreiten, zu unterlizenzieren und/oder zu verkaufen, sowie Personen, denen die Software zur Verfügung gestellt wird, dies ebenfalls zu gestatten, unter den folgenden Bedingungen:

Der obige Urheberrechtshinweis und dieser Genehmigungshinweis müssen in allen Kopien oder wesentlichen Teilen der Software enthalten sein.

DIE SOFTWARE WIRD OHNE JEGLICHE AUSDRÜCKLICHE ODER STILLSCHWEIGENDE GARANTIE ZUR VERFÜGUNG GESTELLT, EINSCHLIESSLICH DER GARANTIEN DER MARKTGÄNGIGKEIT, DER EIGNUNG FÜR EINEN BESTIMMTEN ZWECK UND DER NICHTVERLETZUNG. IN KEINEM FALL SIND DIE AUTOREN ODER URHEBERRECHTSINHABER FÜR ANSPRÜCHE, SCHÄDEN ODER SONSTIGE HAFTUNGEN VERANTWORTLICH, SEI ES AUS EINEM VERTRAG, EINER UNERLAUBTEN HANDLUNG ODER ANDERWEITIG, DIE SICH AUS DER SOFTWARE ODER DER BENUTZUNG DER SOFTWARE ODER ANDEREN GESCHÄFTEN MIT DER SOFTWARE ERGEBEN ODER DAMIT IN ZUSAMMENHANG STEHEN.

# Die YueScript-Bibliothek

Zugriff in Lua über `local yue = require("yue")`.

## yue

**Beschreibung:**

Die YueScript-Sprachbibliothek.

### version

**Typ:** Feld.

**Beschreibung:**

Die YueScript-Version.

**Signatur:**

```lua
version: string
```

### dirsep

**Typ:** Feld.

**Beschreibung:**

Der Dateitrennzeichen-String der aktuellen Plattform.

**Signatur:**

```lua
dirsep: string
```

### yue_compiled

**Typ:** Feld.

**Beschreibung:**

Der Cache für kompilierten Modulcode.

**Signatur:**

```lua
yue_compiled: {string: string}
```

### to_lua

**Typ:** Funktion.

**Beschreibung:**

Die YueScript-Compilerfunktion. Sie kompiliert YueScript-Code zu Lua-Code.

**Signatur:**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| code      | string | Der YueScript-Code.               |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp                         | Beschreibung                                                                                                              |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| string \| nil                       | Der kompilierte Lua-Code oder `nil`, falls die Kompilierung fehlgeschlagen ist.                                           |
| string \| nil                       | Die Fehlermeldung oder `nil`, falls die Kompilierung erfolgreich war.                                                     |
| {{string, integer, integer}} \| nil | Die globalen Variablen im Code (mit Name, Zeile und Spalte) oder `nil`, wenn die Compiler-Option `lint_global` false ist. |

### file_exist

**Typ:** Funktion.

**Beschreibung:**

Prüft, ob eine Quelldatei existiert. Kann überschrieben werden, um das Verhalten anzupassen.

**Signatur:**

```lua
file_exist: function(filename: string): boolean
```

**Parameter:**

| Parameter | Typ    | Beschreibung   |
| --------- | ------ | -------------- |
| filename  | string | Der Dateiname. |

**Rückgabe:**

| Rückgabetyp | Beschreibung            |
| ----------- | ----------------------- |
| boolean     | Ob die Datei existiert. |

### read_file

**Typ:** Funktion.

**Beschreibung:**

Liest eine Quelldatei. Kann überschrieben werden, um das Verhalten anzupassen.

**Signatur:**

```lua
read_file: function(filename: string): string
```

**Parameter:**

| Parameter | Typ    | Beschreibung   |
| --------- | ------ | -------------- |
| filename  | string | Der Dateiname. |

**Rückgabe:**

| Rückgabetyp | Beschreibung     |
| ----------- | ---------------- |
| string      | Der Dateiinhalt. |

### insert_loader

**Typ:** Funktion.

**Beschreibung:**

Fügt den YueScript-Loader in die Package-Loader (Searcher) ein.

**Signatur:**

```lua
insert_loader: function(pos?: integer): boolean
```

**Parameter:**

| Parameter | Typ     | Beschreibung                                                           |
| --------- | ------- | ---------------------------------------------------------------------- |
| pos       | integer | [Optional] Position, an der der Loader eingefügt wird. Standard ist 3. |

**Rückgabe:**

| Rückgabetyp | Beschreibung                                                                         |
| ----------- | ------------------------------------------------------------------------------------ |
| boolean     | Ob der Loader erfolgreich eingefügt wurde. Scheitert, wenn er bereits eingefügt ist. |

### remove_loader

**Typ:** Funktion.

**Beschreibung:**

Entfernt den YueScript-Loader aus den Package-Loadern (Searchern).

**Signatur:**

```lua
remove_loader: function(): boolean
```

**Rückgabe:**

| Rückgabetyp | Beschreibung                                                                      |
| ----------- | --------------------------------------------------------------------------------- |
| boolean     | Ob der Loader erfolgreich entfernt wurde. Scheitert, wenn er nicht eingefügt ist. |

### loadstring

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einem String in eine Funktion.

**Signatur:**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| input     | string | Der YueScript-Code.               |
| chunkname | string | Der Name des Code-Chunks.         |
| env       | table  | Die Environment-Tabelle.          |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp     | Beschreibung                                                          |
| --------------- | --------------------------------------------------------------------- |
| function \| nil | Die geladene Funktion oder `nil`, falls das Laden fehlgeschlagen ist. |
| string \| nil   | Die Fehlermeldung oder `nil`, falls das Laden erfolgreich war.        |

### loadstring

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einem String in eine Funktion.

**Signatur:**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| input     | string | Der YueScript-Code.               |
| chunkname | string | Der Name des Code-Chunks.         |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp     | Beschreibung                                                          |
| --------------- | --------------------------------------------------------------------- |
| function \| nil | Die geladene Funktion oder `nil`, falls das Laden fehlgeschlagen ist. |
| string \| nil   | Die Fehlermeldung oder `nil`, falls das Laden erfolgreich war.        |

### loadstring

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einem String in eine Funktion.

**Signatur:**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| input     | string | Der YueScript-Code.               |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp     | Beschreibung                                                          |
| --------------- | --------------------------------------------------------------------- |
| function \| nil | Die geladene Funktion oder `nil`, falls das Laden fehlgeschlagen ist. |
| string \| nil   | Die Fehlermeldung oder `nil`, falls das Laden erfolgreich war.        |

### loadfile

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einer Datei in eine Funktion.

**Signatur:**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| filename  | string | Der Dateiname.                    |
| env       | table  | Die Environment-Tabelle.          |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp     | Beschreibung                                                          |
| --------------- | --------------------------------------------------------------------- |
| function \| nil | Die geladene Funktion oder `nil`, falls das Laden fehlgeschlagen ist. |
| string \| nil   | Die Fehlermeldung oder `nil`, falls das Laden erfolgreich war.        |

### loadfile

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einer Datei in eine Funktion.

**Signatur:**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| filename  | string | Der Dateiname.                    |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp     | Beschreibung                                                          |
| --------------- | --------------------------------------------------------------------- |
| function \| nil | Die geladene Funktion oder `nil`, falls das Laden fehlgeschlagen ist. |
| string \| nil   | Die Fehlermeldung oder `nil`, falls das Laden erfolgreich war.        |

### dofile

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einer Datei in eine Funktion und führt sie aus.

**Signatur:**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| filename  | string | Der Dateiname.                    |
| env       | table  | Die Environment-Tabelle.          |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp | Beschreibung                              |
| ----------- | ----------------------------------------- |
| any...      | Die Rückgabewerte der geladenen Funktion. |

### dofile

**Typ:** Funktion.

**Beschreibung:**

Lädt YueScript-Code aus einer Datei in eine Funktion und führt sie aus.

**Signatur:**

```lua
dofile: function(filename: string, config?: Config): any...
```

**Parameter:**

| Parameter | Typ    | Beschreibung                      |
| --------- | ------ | --------------------------------- |
| filename  | string | Der Dateiname.                    |
| config    | Config | [Optional] Die Compiler-Optionen. |

**Rückgabe:**

| Rückgabetyp | Beschreibung                              |
| ----------- | ----------------------------------------- |
| any...      | Die Rückgabewerte der geladenen Funktion. |

### find_modulepath

**Typ:** Funktion.

**Beschreibung:**

Löst den YueScript-Modulnamen in einen Dateipfad auf.

**Signatur:**

```lua
find_modulepath: function(name: string): string
```

**Parameter:**

| Parameter | Typ    | Beschreibung   |
| --------- | ------ | -------------- |
| name      | string | Der Modulname. |

**Rückgabe:**

| Rückgabetyp | Beschreibung   |
| ----------- | -------------- |
| string      | Der Dateipfad. |

### pcall

**Typ:** Funktion.

**Beschreibung:**

Ruft eine Funktion im geschützten Modus auf.
Fängt Fehler ab und gibt einen Statuscode sowie Ergebnisse oder ein Fehlerobjekt zurück.
Schreibt die Fehlerzeilennummer bei Fehlern auf die ursprüngliche Zeilennummer im YueScript-Code um.

**Signatur:**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**Parameter:**

| Parameter | Typ      | Beschreibung                |
| --------- | -------- | --------------------------- |
| f         | function | Die aufzurufende Funktion.  |
| ...       | any      | Argumente für die Funktion. |

**Rückgabe:**

| Rückgabetyp  | Beschreibung                                         |
| ------------ | ---------------------------------------------------- |
| boolean, ... | Statuscode und Funktionsresultate oder Fehlerobjekt. |

### require

**Typ:** Funktion.

**Beschreibung:**

Lädt ein Modul (Lua oder YueScript).
Schreibt die Fehlerzeilennummer auf die ursprüngliche Zeilennummer im YueScript-Code um, wenn das Modul ein YueScript-Modul ist und das Laden fehlschlägt.

**Signatur:**

```lua
require: function(name: string): any...
```

**Parameter:**

| Parameter | Typ    | Beschreibung                     |
| --------- | ------ | -------------------------------- |
| modname   | string | Der Name des zu ladenden Moduls. |

**Rückgabe:**

| Rückgabetyp | Beschreibung                                                                                                                                                                                                             |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| any         | Der Wert in `package.loaded[modname]`, falls das Modul bereits geladen ist. Andernfalls wird ein Loader gesucht und der finale Wert von `package.loaded[modname]` sowie Loader-Daten als zweites Ergebnis zurückgegeben. |

### p

**Typ:** Funktion.

**Beschreibung:**

Inspiziert die Struktur der übergebenen Werte und gibt String-Repräsentationen aus.

**Signatur:**

```lua
p: function(...: any)
```

**Parameter:**

| Parameter | Typ | Beschreibung                 |
| --------- | --- | ---------------------------- |
| ...       | any | Die zu inspizierenden Werte. |

### options

**Typ:** Feld.

**Beschreibung:**

Die aktuellen Compiler-Optionen.

**Signatur:**

```lua
options: Config.Options
```

### traceback

**Typ:** Funktion.

**Beschreibung:**

Die Traceback-Funktion, die Stacktrace-Zeilennummern auf die ursprünglichen Zeilennummern im YueScript-Code umschreibt.

**Signatur:**

```lua
traceback: function(message: string): string
```

**Parameter:**

| Parameter | Typ    | Beschreibung             |
| --------- | ------ | ------------------------ |
| message   | string | Die Traceback-Nachricht. |

**Rückgabe:**

| Rückgabetyp | Beschreibung                            |
| ----------- | --------------------------------------- |
| string      | Die umgeschriebene Traceback-Nachricht. |

### is_ast

**Typ:** Funktion.

**Beschreibung:**

Prüft, ob der Code dem angegebenen AST entspricht.

**Signatur:**

```lua
is_ast: function(astName: string, code: string): boolean
```

**Parameter:**

| Parameter | Typ    | Beschreibung  |
| --------- | ------ | ------------- |
| astName   | string | Der AST-Name. |
| code      | string | Der Code.     |

**Rückgabe:**

| Rückgabetyp | Beschreibung                    |
| ----------- | ------------------------------- |
| boolean     | Ob der Code dem AST entspricht. |

### AST

**Typ:** Feld.

**Beschreibung:**

Die AST-Typdefinition mit Name, Zeile, Spalte und Unterknoten.

**Signatur:**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**Typ:** Funktion.

**Beschreibung:**

Konvertiert Code in AST.

**Signatur:**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**Parameter:**

| Parameter      | Typ     | Beschreibung                                                                                 |
| -------------- | ------- | -------------------------------------------------------------------------------------------- |
| code           | string  | Der Code.                                                                                    |
| flattenLevel   | integer | [Optional] Der Flatten-Level. Höher bedeutet mehr Flattening. Standard ist 0. Maximum ist 2. |
| astName        | string  | [Optional] Der AST-Name. Standard ist "File".                                                |
| reserveComment | boolean | [Optional] Ob die ursprünglichen Kommentare beibehalten werden. Standard ist false.          |

**Rückgabe:**

| Rückgabetyp   | Beschreibung                                                           |
| ------------- | ---------------------------------------------------------------------- |
| AST \| nil    | Der AST oder `nil`, falls die Konvertierung fehlgeschlagen ist.        |
| string \| nil | Die Fehlermeldung oder `nil`, falls die Konvertierung erfolgreich war. |

### format

**Typ:** Funktion.

**Beschreibung:**

Formatiert den YueScript-Code.

**Signatur:**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**Parameter:**

| Parameter      | Typ     | Beschreibung                                                                       |
| -------------- | ------- | ---------------------------------------------------------------------------------- |
| code           | string  | Der Code.                                                                          |
| tabSize        | integer | [Optional] Die Tab-Größe. Standard ist 4.                                          |
| reserveComment | boolean | [Optional] Ob die ursprünglichen Kommentare beibehalten werden. Standard ist true. |

**Rückgabe:**

| Rückgabetyp | Beschreibung          |
| ----------- | --------------------- |
| string      | Der formatierte Code. |

### \_\_call

**Typ:** Metamethod.

**Beschreibung:**

Required das YueScript-Modul.
Schreibt die Fehlerzeilennummer bei Ladefehlern auf die ursprüngliche Zeilennummer im YueScript-Code um.

**Signatur:**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**Parameter:**

| Parameter | Typ    | Beschreibung   |
| --------- | ------ | -------------- |
| module    | string | Der Modulname. |

**Rückgabe:**

| Rückgabetyp | Beschreibung   |
| ----------- | -------------- |
| any         | Der Modulwert. |

## Config

**Beschreibung:**

Die Compiler-Optionen.

### lint_global

**Typ:** Feld.

**Beschreibung:**

Ob der Compiler die globalen Variablen im Code sammeln soll.

**Signatur:**

```lua
lint_global: boolean
```

### implicit_return_root

**Typ:** Feld.

**Beschreibung:**

Ob der Compiler für den Root-Codeblock ein implizites Return verwenden soll.

**Signatur:**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**Typ:** Feld.

**Beschreibung:**

Ob der Compiler die ursprüngliche Zeilennummer im kompilierten Code beibehalten soll.

**Signatur:**

```lua
reserve_line_number: boolean
```

### reserve_comment

**Typ:** Feld.

**Beschreibung:**

Ob der Compiler die ursprünglichen Kommentare im kompilierten Code beibehalten soll.

**Signatur:**

```lua
reserve_comment: boolean
```

### space_over_tab

**Typ:** Feld.

**Beschreibung:**

Ob der Compiler statt Tabzeichen Leerzeichen verwenden soll.

**Signatur:**

```lua
space_over_tab: boolean
```

### same_module

**Typ:** Feld.

**Beschreibung:**

Ob der Compiler den zu kompilierenden Code als dasselbe aktuell kompilierte Modul behandeln soll. Nur für internen Gebrauch.

**Signatur:**

```lua
same_module: boolean
```

### line_offset

**Typ:** Feld.

**Beschreibung:**

Ob die Compiler-Fehlermeldung einen Zeilennummern-Offset enthalten soll. Nur für internen Gebrauch.

**Signatur:**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**Typ:** Enumeration.

**Beschreibung:**

Die Ziel-Lua-Version.

**Signatur:**

```lua
enum LuaTarget
  "5.1"
  "5.2"
  "5.3"
  "5.4"
  "5.5"
end
```

### options

**Typ:** Feld.

**Beschreibung:**

Zusätzliche Optionen für die Kompilierung.

**Signatur:**

```lua
options: Options
```

## Options

**Beschreibung:**

Zusätzliche Compiler-Optionen.

### target

**Typ:** Feld.

**Beschreibung:**

Die Ziel-Lua-Version für die Kompilierung.

**Signatur:**

```lua
target: LuaTarget
```

### path

**Typ:** Feld.

**Beschreibung:**

Zusätzlicher Modul-Suchpfad.

**Signatur:**

```lua
path: string
```

### dump_locals

**Typ:** Feld.

**Beschreibung:**

Ob lokale Variablen in Traceback-Fehlermeldungen ausgegeben werden sollen. Standard ist false.

**Signatur:**

```lua
dump_locals: boolean
```

### simplified

**Typ:** Feld.

**Beschreibung:**

Ob Fehlermeldungen vereinfacht werden sollen. Standard ist true.

**Signatur:**

```lua
simplified: boolean
```
