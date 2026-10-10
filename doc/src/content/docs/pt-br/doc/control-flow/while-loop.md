---
title: Loop While
sidebar:
  order: 20
---

O loop while também vem em quatro variações:

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

</div>
</div>

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
until i == 0
  print i
  i -= 1
until running == false do my_function!
```

</div>
</div>

Como os loops for, o loop while também pode ser usado como expressão. Expressões `while` e `until` suportam `break` com múltiplos valores.

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

</div>
</div>

Além disso, para uma função retornar o valor acumulado de um loop while, a instrução deve ser explicitamente retornada.

## Loop Repeat

O loop repeat vem do Lua:

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 10
repeat
  print i
  i -= 1
until i == 0
```

</div>
</div>

Expressões `repeat` também suportam `break` com múltiplos valores:

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

</div>
</div>
