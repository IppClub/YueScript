---
title: Do
sidebar:
  order: 30
---

Quando usado como instrução, do funciona exatamente como no Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil aqui
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  var = "hello"
  print var
print var -- nil aqui
```

</div>
</div>

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
    print "assigning key!"
    1234
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

</div>
</div>

Expressões `do` suportam usar `break` para interromper o fluxo de execução e retornar múltiplos valores antecipadamente.

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
