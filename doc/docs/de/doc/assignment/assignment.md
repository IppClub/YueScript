# Zuweisung

Variablen sind dynamisch typisiert und standardmäßig `local`. Du kannst den Geltungsbereich mit den Statements **local** und **global** ändern.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- nutzt die bestehende Variable
```

<YueDisplay>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- nutzt die bestehende Variable
```

</YueDisplay>

## Update-Zuweisung

Du kannst Update-Zuweisungen mit vielen binären Operatoren durchführen.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- legt eine neue lokale Variable an, wenn sie nicht existiert
arg or= "default value"
```

<YueDisplay>

```yue
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- legt eine neue lokale Variable an, wenn sie nicht existiert
arg or= "default value"
```

</YueDisplay>

## Verkettete Zuweisung

Mit verketteten Zuweisungen kannst du mehrere Variablen auf denselben Wert setzen.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

<YueDisplay>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</YueDisplay>

## Explizite Locals

```yuescript
do
  local a = 1
  local *
  print "forward declare all variables as locals"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "only forward declare upper case variables"
  a = 1
  B = 2
```

<YueDisplay>

```yue
do
  local a = 1
  local *
  print "forward declare all variables as locals"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "only forward declare upper case variables"
  a = 1
  B = 2
```

</YueDisplay>

## Explizite Globals

```yuescript
do
  global a = 1
  global *
  print "declare all variables as globals"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "only declare upper case variables as globals"
  a = 1
  B = 2
  local Temp = "a local value"
```

<YueDisplay>

```yue
do
  global a = 1
  global *
  print "declare all variables as globals"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "only declare upper case variables as globals"
  a = 1
  B = 2
  local Temp = "a local value"
```

</YueDisplay>
