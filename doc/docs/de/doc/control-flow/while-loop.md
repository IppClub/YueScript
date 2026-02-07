# While-Schleife

Die `while`-Schleife gibt es ebenfalls in vier Variationen:

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

<YueDisplay>

```yue
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

</YueDisplay>

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

<YueDisplay>

```yue
i = 10
until i == 0
  print i
  i -= 1
until running == false do my_function!
```

</YueDisplay>

Wie bei `for`-Schleifen kann die `while`-Schleife auch als Ausdruck verwendet werden. Damit eine Funktion den akkumulierten Wert einer `while`-Schleife zurückgibt, muss die Anweisung explizit mit `return` zurückgegeben werden.

## Repeat-Schleife

Die `repeat`-Schleife stammt aus Lua:

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

<YueDisplay>

```yue
i = 10
repeat
  print i
  i -= 1
until i == 0
```

</YueDisplay>
