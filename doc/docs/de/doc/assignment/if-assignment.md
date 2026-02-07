# If-Zuweisung

`if`- und `elseif`-Blöcke können eine Zuweisung anstelle eines Bedingungsausdrucks enthalten. Beim Auswerten der Bedingung findet die Zuweisung statt, und der zugewiesene Wert wird als Bedingung verwendet. Die zugewiesene Variable ist nur im Geltungsbereich des Bedingungsblocks verfügbar, d. h. sie ist nicht verfügbar, wenn der Wert nicht truthy ist. Für die Zuweisung musst du den "Walrus-Operator" `:=` statt `=` verwenden.

```yuescript
if user := database.find_user "moon"
  print user.name
```

<YueDisplay>

```yue
if user := database.find_user "moon"
  print user.name
```

</YueDisplay>

```yuescript
if hello := os.getenv "hello"
  print "Du hast hello", hello
elseif world := os.getenv "world"
  print "Du hast world", world
else
  print "nichts :("
```

<YueDisplay>

```yue
if hello := os.getenv "hello"
  print "Du hast hello", hello
elseif world := os.getenv "world"
  print "Du hast world", world
else
  print "nichts :("
```

</YueDisplay>

If-Zuweisung mit mehreren Rückgabewerten. Nur der erste Wert wird geprüft, andere Werte bleiben im Scope.

```yuescript
if success, result := pcall -> "Ergebnis ohne Probleme erhalten"
  print result -- Variable result ist im Scope
print "OK"
```

<YueDisplay>

```yue
if success, result := pcall -> "Ergebnis ohne Probleme erhalten"
  print result -- Variable result ist im Scope
print "OK"
```

</YueDisplay>

## While-Zuweisung

Du kannst if-Zuweisung auch in einer while-Schleife verwenden, um den Wert als Schleifenbedingung zu nutzen.

```yuescript
while byte := stream\read_one!
  -- mit dem Byte etwas anfangen
  print byte
```

<YueDisplay>

```yue
while byte := stream\read_one!
  -- mit dem Byte etwas anfangen
  print byte
```

</YueDisplay>
