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
