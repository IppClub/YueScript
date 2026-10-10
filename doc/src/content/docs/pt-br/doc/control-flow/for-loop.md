---
title: Loop For
sidebar:
  order: 19
---

Existem duas formas de loop for, assim como no Lua. Uma numérica e uma genérica:

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- um passo opcional fornecido
  print k

for key, value in pairs object
  print key, value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for i = 10, 20
  print i

for k = 1, 15, 2 -- um passo opcional fornecido
  print k

for key, value in pairs object
  print key, value
```

</div>
</div>

Os operadores de slicing e **\*** podem ser usados, assim como com compreensões:

```yuescript
for item in *items[2, 4]
  print item
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items[2, 4]
  print item
```

</div>
</div>

Uma sintaxe mais curta também está disponível para todas as variações quando o corpo é apenas uma linha:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items do print item

for j = 1, 10, 3 do print j
```

</div>
</div>

Um loop for também pode ser usado como expressão. A última instrução no corpo do loop for é convertida em expressão e anexada a uma tabela array acumuladora.

Dobrando cada número par:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

</div>
</div>

Além disso, os loops for suportam break com valores de retorno, permitindo que o próprio loop seja usado como expressão que sai antecipadamente com um resultado significativo. Expressões `for` suportam `break` com múltiplos valores.

Por exemplo, para encontrar o primeiro número maior que 10:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
first_large = for n in *numbers
  break n if n > 10
```

</div>
</div>

Esta sintaxe de break-com-valor permite padrões concisos e expressivos de busca ou saída antecipada diretamente em expressões de loop.

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

</div>
</div>

Você também pode filtrar valores combinando a expressão do loop for com a instrução continue.

Loops for no final do corpo de uma função não são acumulados em uma tabela para valor de retorno (em vez disso, a função retornará nil). Uma instrução return explícita pode ser usada, ou o loop pode ser convertido em compreensão de lista.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- imprime nil
print func_b! -- imprime objeto table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- imprime nil
print func_b! -- imprime objeto table
```

</div>
</div>

Isso é feito para evitar a criação desnecessária de tabelas para funções que não precisam retornar os resultados do loop.
