# Continue

Uma instrução continue pode ser usada para pular a iteração atual em um loop.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

<YueDisplay>

```yue
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

</YueDisplay>

continue também pode ser usado com expressões de loop para impedir que essa iteração seja acumulada no resultado. Este exemplo filtra a tabela array para apenas números pares:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

<YueDisplay>

```yue
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

</YueDisplay>
