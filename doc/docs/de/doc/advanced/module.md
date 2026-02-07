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

<YueDisplay>

```yue
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

</YueDisplay>

## Import von Globals

Du kannst mit `import` bestimmte Globals in lokale Variablen importieren. Wenn du eine Kette von Globalzugriffen importierst, wird das letzte Feld der lokalen Variable zugewiesen.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

<YueDisplay>

```yue
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Benannter Export mit Destructuring.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

<YueDisplay>

```yue
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

</YueDisplay>

Benannte Elemente aus dem Modul exportieren, ohne lokale Variablen zu erstellen.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

<YueDisplay>

```yue
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

</YueDisplay>

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

<YueDisplay>

```yue
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

</YueDisplay>

### Default-Export

Mit dem Schlüsselwort **default** in einer `export`-Anweisung wird die exportierte Tabelle durch ein beliebiges Objekt ersetzt.

```yuescript
export default ->
  print "hallo"
  123
```

<YueDisplay>

```yue
export default ->
  print "hallo"
  123
```

</YueDisplay>
