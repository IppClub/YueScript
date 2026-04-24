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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
-- Datei: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- Datei main.yue
-- Import-Funktion im Browser nicht verfügbar, in echter Umgebung testen
--[[
import "utils" as {
  $, -- Symbol zum Importieren aller Makros
  $foreach: $each -- Makro $foreach in $each umbenennen
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
]]
```

</YueDisplay>

## Eingebaute Makros

Es gibt einige eingebaute Makros, aber du kannst sie überschreiben, indem du Makros mit denselben Namen deklarierst.

```yuescript
print $FILE -- String des aktuellen Modulnamens
print $LINE -- gibt 2 aus
```

<YueDisplay>

```yue
print $FILE -- String des aktuellen Modulnamens
print $LINE -- gibt 2 aus
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

</YueDisplay>

```yuescript
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

<YueDisplay>

```yue
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

</YueDisplay>

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

<YueDisplay>

```yue
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hallo"
```

</YueDisplay>

Wenn du flexiblere Argumentprüfungen brauchst, kannst du das eingebaute Makro `$is_ast` verwenden, um manuell an der passenden Stelle zu prüfen.

```yuescript
macro printNumAndStr = (num, str) ->
  error "als erstes Argument Num erwartet" unless $is_ast Num, num
  error "als zweites Argument String erwartet" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hallo"
```

<YueDisplay>

```yue
macro printNumAndStr = (num, str) ->
  error "als erstes Argument Num erwartet" unless $is_ast Num, num
  error "als zweites Argument String erwartet" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hallo"
```

</YueDisplay>

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

<YueDisplay>

```yue
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Auf eine Annotation muss immer eine Anweisung folgen, und sie kann nicht auf eine `return`-Anweisung angewendet werden. Wenn die annotierte Anweisung am Ende eines Blocks steht und du die rohe AST-Form der Anweisung brauchst, füge ein explizites `return` danach ein, damit sie nicht in einen implizit zurückgegebenen Ausdruck eingebettet wird.
