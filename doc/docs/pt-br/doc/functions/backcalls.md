# Backcalls

Backcalls são usados para desaninhar callbacks. Eles são definidos usando setas apontando para a esquerda como o último parâmetro, preenchendo por padrão uma chamada de função. Toda a sintaxe é basicamente a mesma das funções seta regulares, exceto que apenas aponta para o outro lado e o corpo da função não requer indentação.

```yuescript
x <- f
print "hello" .. x
```

<YueDisplay>

```yue
x <- f
print "hello" .. x
```

</YueDisplay>

Funções seta "fat" também estão disponíveis.

```yuescript
<= f
print @value
```

<YueDisplay>

```yue
<= f
print @value
```

</YueDisplay>

Você pode especificar um placeholder para onde deseja que a função backcall vá como parâmetro.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

<YueDisplay>

```yue
(x) <- map _, [1, 2, 3]
x * 2
```

</YueDisplay>

Se você desejar ter mais código após seus backcalls, pode colocá-los em uma instrução do. E os parênteses podem ser omitidos com funções seta não-fat.

```yuescript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

<YueDisplay>

```yue
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

</YueDisplay>
