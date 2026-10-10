---
title: Atribuição em if
sidebar:
  order: 12
---

Os blocos `if` e `elseif` podem receber uma atribuição no lugar de uma expressão condicional. Ao avaliar o condicional, a atribuição será realizada e o valor que foi atribuído será usado como expressão condicional. A variável atribuída está no escopo apenas para o corpo do condicional, ou seja, nunca está disponível se o valor não for truthy. E você precisa usar o "operador walrus" `:=` em vez de `=` para fazer a atribuição.

```yuescript
if user := database.find_user "moon"
  print user.name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
if user := database.find_user "moon"
  print user.name
```

</div>
</div>

```yuescript
if hello := os.getenv "hello"
  print "Você tem hello", hello
elseif world := os.getenv "world"
  print "você tem world", world
else
  print "nada :("
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
if hello := os.getenv "hello"
  print "Você tem hello", hello
elseif world := os.getenv "world"
  print "você tem world", world
else
  print "nada :("
```

</div>
</div>

Atribuição em if com múltiplos valores de retorno. Apenas o primeiro valor é verificado, os outros valores estão no escopo.

```yuescript
if success, result := pcall -> "obter resultado sem problemas"
  print result -- variável result está no escopo
print "OK"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
if success, result := pcall -> "obter resultado sem problemas"
  print result -- variável result está no escopo
print "OK"
```

</div>
</div>

## Atribuição em while

Você também pode usar atribuição em if em um loop while para obter o valor como condição do loop.

```yuescript
while byte := stream\read_one!
  -- fazer algo com o byte
  print byte
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
while byte := stream\read_one!
  -- fazer algo com o byte
  print byte
```

</div>
</div>
