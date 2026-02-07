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

<YueDisplay>

```yue
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

</YueDisplay>
