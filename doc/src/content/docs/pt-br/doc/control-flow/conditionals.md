---
title: Condicionais
sidebar:
  order: 18
---

```yuescript
have_coins = false
if have_coins
  print "Tem moedas"
else
  print "Sem moedas"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins
  print "Tem moedas"
else
  print "Sem moedas"
```

</div>
</div>

Uma sintaxe curta para instruções únicas também pode ser usada:

```yuescript
have_coins = false
if have_coins then print "Tem moedas" else print "Sem moedas"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins then print "Tem moedas" else print "Sem moedas"
```

</div>
</div>

Como instruções if podem ser usadas como expressões, isso também pode ser escrito como:

```yuescript
have_coins = false
print if have_coins then "Tem moedas" else "Sem moedas"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
print if have_coins then "Tem moedas" else "Sem moedas"
```

</div>
</div>

Condicionais também podem ser usados em instruções de retorno e atribuições:

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Sou muito alto"
else
  "Não sou tão alto"

print message -- imprime: Sou muito alto
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Sou muito alto"
else
  "Não sou tão alto"

print message -- imprime: Sou muito alto
```

</div>
</div>

O oposto de if é unless:

```yuescript
unless os.date("%A") == "Monday"
  print "não é segunda-feira!"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
unless os.date("%A") == "Monday"
  print "não é segunda-feira!"
```

</div>
</div>

```yuescript
print "Você tem sorte!" unless math.random! > 0.1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "Você tem sorte!" unless math.random! > 0.1
```

</div>
</div>

## Em expressão

Você pode escrever código de verificação de intervalo com uma `in-expression`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "verificando igualdade com valores discretos"

if a in list
  print "verificando se `a` está na lista"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "verificando igualdade com valores discretos"

if a in list
  print "verificando se `a` está na lista"
```

</div>
</div>

O operador `in` também pode ser usado com tabelas e suporta a variante `not in` para negação:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a está na tabela"

not_exist = item not in list

check = -> value not in table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a está na tabela"

not_exist = item not in list

check = -> value not in table
```

</div>
</div>

Uma lista ou tabela de único elemento verifica igualdade com esse elemento:

```yuescript
-- [1,] verifica se valor == 1
c = a in [1,]

-- {1} também verifica se valor == 1
c = a in {1}

-- Sem vírgula, [1] é acesso por índice (tb[1])
with tb
  c = a in [1]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- [1,] verifica se valor == 1
c = a in [1,]

-- {1} também verifica se valor == 1
c = a in {1}

-- Sem vírgula, [1] é acesso por índice (tb[1])
with tb
  c = a in [1]
```

</div>
</div>
