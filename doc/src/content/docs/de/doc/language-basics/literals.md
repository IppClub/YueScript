---
title: Literale
sidebar:
  order: 6
---

Alle primitiven Literale in Lua können verwendet werden. Das gilt für Zahlen, Strings, Booleans und **nil**.

Anders als in Lua sind Zeilenumbrüche innerhalb einfacher und doppelter Anführungszeichen ohne Escape-Sequenz erlaubt:

```yuescript
some_string = "Hier ist ein String
  mit einem Zeilenumbruch."

-- Mit der #{}-Syntax kannst du Ausdrücke in String-Literale einbinden.
-- String-Interpolation gibt es nur in doppelt angeführten Strings.
print "Ich bin mir zu #{math.random! * 100}% sicher."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_string = "Hier ist ein String
  mit einem Zeilenumbruch."

-- Mit der #{}-Syntax kannst du Ausdrücke in String-Literale einbinden.
-- String-Interpolation gibt es nur in doppelt angeführten Strings.
print "Ich bin mir zu #{math.random! * 100}% sicher."
```

</div>
</div>

## Zahlenliterale

Du kannst Unterstriche in Zahlenliteralen verwenden, um die Lesbarkeit zu erhöhen.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

</div>
</div>

## YAML-Mehrzeilen-String

Das Präfix `|` führt ein mehrzeiliges String-Literal im YAML-Stil ein:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
str = |
  key: value
  list:
    - item1
    - #{expr}
```

</div>
</div>

Damit lässt sich strukturierter, mehrzeiliger Text bequem schreiben. Alle Zeilenumbrüche und Einrückungen bleiben relativ zur ersten nicht-leeren Zeile erhalten, und Ausdrücke innerhalb von `#{...}` werden automatisch als `tostring(expr)` interpoliert.

Der YAML-Mehrzeilen-String erkennt automatisch das gemeinsame führende Leerraumpräfix (minimale Einrückung über alle nicht-leeren Zeilen) und entfernt es aus allen Zeilen. So kannst du deinen Code optisch einrücken, ohne den resultierenden String zu verändern.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

</div>
</div>

Die interne Einrückung bleibt relativ zum entfernten gemeinsamen Präfix erhalten, wodurch saubere, verschachtelte Strukturen möglich sind.

Alle Sonderzeichen wie Anführungszeichen (`"`) und Backslashes (`\`) im YAML-Mehrzeilen-Block werden automatisch escaped, sodass der erzeugte Lua-String syntaktisch korrekt ist und wie erwartet funktioniert.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

</div>
</div>
