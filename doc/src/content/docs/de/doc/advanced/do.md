---
title: Do
sidebar:
  order: 30
---

Als Statement verhält sich `do` wie in Lua.

```yuescript
do
  var = "hallo"
  print var
print var -- nil hier
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  var = "hallo"
  print var
print var -- nil hier
```

</div>
</div>

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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</div>
</div>

```yuescript
tbl = {
  key: do
    print "Schlüssel wird zugewiesen!"
    1234
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  key: do
    print "Schlüssel wird zugewiesen!"
    1234
}
```

</div>
</div>

`do`-Ausdrücke unterstützen die Verwendung von `break`, um den Kontrollfluss zu unterbrechen und mehrere Rückgabewerte vorzeitig zurückzugeben.

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

</div>
</div>
