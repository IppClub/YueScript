# Backcalls

Backcalls werden verwendet, um Callbacks zu entkoppeln (unnesting). Sie werden mit Pfeilen nach links definiert und füllen standardmäßig als letzter Parameter einen Funktionsaufruf. Die Syntax ist weitgehend wie bei normalen Pfeilfunktionen, nur dass der Pfeil in die andere Richtung zeigt und der Funktionskörper keine Einrückung benötigt.

```yuescript
x <- f
print "hallo" .. x
```

<YueDisplay>

```yue
x <- f
print "hallo" .. x
```

</YueDisplay>

Fat-Arrow-Funktionen sind ebenfalls verfügbar.

```yuescript
<= f
print @value
```

<YueDisplay>

```yue
<= f
print @value
```

</YueDisplay>

Du kannst einen Platzhalter angeben, an welcher Stelle die Backcall-Funktion als Parameter eingesetzt werden soll.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

<YueDisplay>

```yue
(x) <- map _, [1, 2, 3]
x * 2
```

</YueDisplay>

Wenn du nach deinen Backcalls weiteren Code haben willst, kannst du sie mit einem `do`-Statement absetzen. Bei Nicht-Fat-Arrow-Funktionen können die Klammern weggelassen werden.

```yuescript
result, msg = do
  data <- readAsync "dateiname.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

<YueDisplay>

```yue
result, msg = do
  data <- readAsync "dateiname.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

</YueDisplay>
