# Condicionais

```yuescript
have_coins = false
if have_coins
  print "Tem moedas"
else
  print "Sem moedas"
```

<YueDisplay>

```yue
have_coins = false
if have_coins
  print "Tem moedas"
else
  print "Sem moedas"
```

</YueDisplay>

Uma sintaxe curta para instruções únicas também pode ser usada:

```yuescript
have_coins = false
if have_coins then print "Tem moedas" else print "Sem moedas"
```

<YueDisplay>

```yue
have_coins = false
if have_coins then print "Tem moedas" else print "Sem moedas"
```

</YueDisplay>

Como instruções if podem ser usadas como expressões, isso também pode ser escrito como:

```yuescript
have_coins = false
print if have_coins then "Tem moedas" else "Sem moedas"
```

<YueDisplay>

```yue
have_coins = false
print if have_coins then "Tem moedas" else "Sem moedas"
```

</YueDisplay>

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

<YueDisplay>

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

</YueDisplay>

O oposto de if é unless:

```yuescript
unless os.date("%A") == "Monday"
  print "não é segunda-feira!"
```

<YueDisplay>

```yue
unless os.date("%A") == "Monday"
  print "não é segunda-feira!"
```

</YueDisplay>

```yuescript
print "Você tem sorte!" unless math.random! > 0.1
```

<YueDisplay>

```yue
print "Você tem sorte!" unless math.random! > 0.1
```

</YueDisplay>

## Em expressão

Você pode escrever código de verificação de intervalo com uma `in-expression`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "verificando igualdade com valores discretos"

if a in list
  print "verificando se `a` está na lista"
```

<YueDisplay>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "verificando igualdade com valores discretos"

if a in list
  print "verificando se `a` está na lista"
```

</YueDisplay>
