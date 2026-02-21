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
