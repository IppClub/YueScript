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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>
