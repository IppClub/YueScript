---
title: Atribuição
sidebar:
  order: 10
---

A variável é tipada dinamicamente e é definida como local por padrão. Mas você pode alterar o escopo da declaração pelas instruções **local** e **global**.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- usa a variável existente
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- usa a variável existente
```

</div>
</div>

## Atualização

Você pode realizar atribuição de atualização com muitos operadores binários.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- adiciona um novo local se a variável local não existir
arg or= "valor padrão"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- adiciona um novo local se a variável local não existir
arg or= "valor padrão"
```

</div>
</div>

## Atribuição encadeada

Você pode fazer atribuição encadeada para atribuir múltiplos itens ao mesmo valor.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</div>
</div>

## Locais explícitos

```yuescript
do
  local a = 1
  local *
  print "declarar antecipadamente todas as variáveis como locais"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "declarar antecipadamente apenas variáveis em maiúsculas"
  a = 1
  B = 2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  local a = 1
  local *
  print "declarar antecipadamente todas as variáveis como locais"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "declarar antecipadamente apenas variáveis em maiúsculas"
  a = 1
  B = 2
```

</div>
</div>

## Globais explícitos

```yuescript
do
  global a = 1
  global *
  print "declarar todas as variáveis como globais"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "declarar apenas variáveis em maiúsculas como globais"
  a = 1
  B = 2
  local Temp = "um valor local"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  global a = 1
  global *
  print "declarar todas as variáveis como globais"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "declarar apenas variáveis em maiúsculas como globais"
  a = 1
  B = 2
  local Temp = "um valor local"
```

</div>
</div>
