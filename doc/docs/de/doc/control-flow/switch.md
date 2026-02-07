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

<YueDisplay>

```yue
switch name := "Dan"
  when "Robert"
    print "Du bist Robert"
  when "Dan", "Daniel"
    print "Dein Name ist Dan"
  else
    print "Ich kenne dich nicht mit dem Namen #{name}"
```

</YueDisplay>

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

<YueDisplay>

```yue
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "so hoch kann ich nicht zählen!"
```

</YueDisplay>

Du kannst das Schlüsselwort `then` verwenden, um einen `when`-Block in einer Zeile zu schreiben. Für den `else`-Block braucht es kein zusätzliches Schlüsselwort.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "Du hast Glück"
  when 2 then "Du hast fast Glück"
  else "nicht so viel Glück"
```

<YueDisplay>

```yue
msg = switch math.random(1, 5)
  when 1 then "Du hast Glück"
  when 2 then "Du hast fast Glück"
  else "nicht so viel Glück"
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Du kannst Standardwerte verwenden, um bestimmte Felder optional zu destrukturieren.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- Fehler: Versuch, einen nil-Wert zu indexieren (Feld 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- Tabellen-Destrukturierung greift trotzdem
```

<YueDisplay>

```yue
item = {}

{pos: {:x = 50, :y = 200}} = item -- Fehler: Versuch, einen nil-Wert zu indexieren (Feld 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- Tabellen-Destrukturierung greift trotzdem
```

</YueDisplay>

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

<YueDisplay>

```yue
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b hat einen Standardwert
    print "1, 2, #{b}"
```

</YueDisplay>

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

<YueDisplay>

```yue
switch tb
  when success: true, :result
    print "Erfolg", result
  when success: false
    print "fehlgeschlagen", result
  else
    print "ungültig"
```

</YueDisplay>

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

<YueDisplay>

```yue
switch tb
  when data: {type: "success", :content}
    print "Erfolg", content
  when data: {type: "error", :content}
    print "fehlgeschlagen", content
  else
    print "ungültig"
```

</YueDisplay>

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

<YueDisplay>

```yue
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "getroffen", fourth
```

</YueDisplay>

Matchen gegen eine Liste und einen Bereich von Elementen erfassen.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Gruppe:", groups -- gibt aus: {"admin", "users"}
    print "Ressource:", resource -- gibt aus: "logs"
    print "Aktion:", action -- gibt aus: "view"
```

<YueDisplay>

```yue
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Gruppe:", groups -- gibt aus: {"admin", "users"}
    print "Ressource:", resource -- gibt aus: "logs"
    print "Aktion:", action -- gibt aus: "view"
```

</YueDisplay>
