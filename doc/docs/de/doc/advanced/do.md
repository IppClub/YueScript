# Do

Als Statement verhält sich `do` wie in Lua.

```yuescript
do
  var = "hallo"
  print var
print var -- nil hier
```

<YueDisplay>

```yue
do
  var = "hallo"
  print var
print var -- nil hier
```

</YueDisplay>

YueScripts **do** kann auch als Ausdruck verwendet werden. So kannst du mehrere Zeilen in einem Ausdruck kombinieren. Das Ergebnis des `do`-Ausdrucks ist die letzte Anweisung im Block.

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

<YueDisplay>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</YueDisplay>

```yuescript
tbl = {
  key: do
    print "Schlüssel wird zugewiesen!"
    1234
}
```

<YueDisplay>

```yue
tbl = {
  key: do
    print "Schlüssel wird zugewiesen!"
    1234
}
```

</YueDisplay>
