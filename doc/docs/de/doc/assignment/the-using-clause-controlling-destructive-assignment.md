# Die Using-Klausel: Destruktive Zuweisung kontrollieren

Lexikalisches Scoping kann die Komplexität des Codes stark reduzieren, aber mit wachsendem Codeumfang kann es unübersichtlich werden. Betrachte folgendes Beispiel:

```yuescript
i = 100

-- viele Zeilen Code...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- wird 0 ausgeben
```

<YueDisplay>

```yue
i = 100

-- viele Zeilen Code...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- wird 0 ausgeben
```

</YueDisplay>

In `my_func` haben wir den Wert von `i` versehentlich überschrieben. In diesem Beispiel ist es offensichtlich, aber in einer großen oder fremden Codebasis ist oft nicht klar, welche Namen bereits deklariert wurden.

Es wäre hilfreich, anzugeben, welche Variablen aus dem umschließenden Scope wir verändern wollen, um versehentliche Änderungen zu vermeiden.

Das Schlüsselwort `using` ermöglicht das. `using nil` stellt sicher, dass keine geschlossenen Variablen bei Zuweisungen überschrieben werden. Die `using`-Klausel steht nach der Argumentliste einer Funktion oder ersetzt sie, wenn es keine Argumente gibt.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- hier wird eine neue lokale Variable erstellt

my_func!
print i -- gibt 100 aus, i bleibt unverändert
```

<YueDisplay>

```yue
i = 100

my_func = (using nil) ->
  i = "hello" -- hier wird eine neue lokale Variable erstellt

my_func!
print i -- gibt 100 aus, i bleibt unverändert
```

</YueDisplay>

Mehrere Namen können durch Kommas getrennt werden. Closure-Werte können weiterhin gelesen, aber nicht verändert werden:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- ein neues lokales tmp wird erstellt
  i += tmp
  k += tmp

my_func(22)
print i, k -- diese wurden aktualisiert
```

<YueDisplay>

```yue
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- ein neues lokales tmp wird erstellt
  i += tmp
  k += tmp

my_func(22)
print i, k -- diese wurden aktualisiert
```

</YueDisplay>
