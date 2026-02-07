# Verwendung

## Lua-Modul

YueScript-Modul in Lua verwenden:

- **Fall 1**

  "your_yuescript_entry.yue" in Lua require'n.

  ```Lua
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
