# Varargs-Zuweisung

Du kannst Rückgabewerte einer Funktion dem Varargs-Symbol `...` zuweisen und dann den Inhalt auf die Lua-Weise auslesen.

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

<YueDisplay>

```yue
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

</YueDisplay>
