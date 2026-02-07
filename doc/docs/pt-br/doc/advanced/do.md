# Do

Quando usado como instrução, do funciona exatamente como no Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil aqui
```

<YueDisplay>

```yue
do
  var = "hello"
  print var
print var -- nil aqui
```

</YueDisplay>

O **do** do YueScript também pode ser usado como expressão. Permitindo combinar múltiplas linhas em uma. O resultado da expressão do é a última instrução em seu corpo.

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
    print "assigning key!"
    1234
}
```

<YueDisplay>

```yue
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

</YueDisplay>
