# Literais de função

Todas as funções são criadas usando uma expressão de função. Uma função simples é denotada usando a seta: **->**.

```yuescript
my_function = ->
my_function() -- chama a função vazia
```

<YueDisplay>

```yue
my_function = ->
my_function() -- chama a função vazia
```

</YueDisplay>

O corpo da função pode ser uma instrução colocada diretamente após a seta, ou pode ser uma série de instruções indentadas nas linhas seguintes:

```yuescript
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

<YueDisplay>

```yue
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

</YueDisplay>

Se uma função não tem argumentos, ela pode ser chamada usando o operador !, em vez de parênteses vazios. A invocação ! é a forma preferida de chamar funções sem argumentos.

```yuescript
func_a!
func_b()
```

<YueDisplay>

```yue
func_a!
func_b()
```

</YueDisplay>

Funções com argumentos podem ser criadas precedendo a seta com uma lista de nomes de argumentos entre parênteses:

```yuescript
sum = (x, y) -> print "sum", x + y
```

<YueDisplay>

```yue
sum = (x, y) -> print "sum", x + y
```

</YueDisplay>

Funções podem ser chamadas listando os argumentos após o nome de uma expressão que avalia para uma função. Ao encadear chamadas de função, os argumentos são aplicados à função mais próxima à esquerda.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

<YueDisplay>

```yue
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

</YueDisplay>

Para evitar ambiguidade ao chamar funções, parênteses também podem ser usados para envolver os argumentos. Isso é necessário aqui para garantir que os argumentos certos sejam enviados às funções certas.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

<YueDisplay>

```yue
print "x:", sum(10, 20), "y:", sum(30, 40)
```

</YueDisplay>

Não deve haver espaço entre o parêntese de abertura e a função.

As funções convertem a última instrução em seu corpo em uma instrução de retorno, isso é chamado de retorno implícito:

```yuescript
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

<YueDisplay>

```yue
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

</YueDisplay>

E se você precisar retornar explicitamente, pode usar a palavra-chave return:

```yuescript
sum = (x, y) -> return x + y
```

<YueDisplay>

```yue
sum = (x, y) -> return x + y
```

</YueDisplay>

Assim como no Lua, as funções podem retornar múltiplos valores. A última instrução deve ser uma lista de valores separados por vírgulas:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

<YueDisplay>

```yue
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

</YueDisplay>

## Setas fat

Como é um idioma em Lua enviar um objeto como primeiro argumento ao chamar um método, uma sintaxe especial é fornecida para criar funções que incluem automaticamente um argumento self.

```yuescript
func = (num) => @value + num
```

<YueDisplay>

```yue
func = (num) => @value + num
```

</YueDisplay>

## Valores padrão de argumentos

É possível fornecer valores padrão para os argumentos de uma função. Um argumento é determinado como vazio se seu valor for nil. Qualquer argumento nil que tenha valor padrão será substituído antes da execução do corpo da função.

```yuescript
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

<YueDisplay>

```yue
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

</YueDisplay>

Uma expressão de valor padrão de argumento é avaliada no corpo da função na ordem das declarações de argumentos. Por esse motivo, os valores padrão têm acesso aos argumentos declarados anteriormente.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

<YueDisplay>

```yue
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

</YueDisplay>

## Considerações

Devido à forma expressiva de chamar funções sem parênteses, algumas restrições devem ser colocadas para evitar ambiguidade de análise envolvendo espaço em branco.

O sinal de menos desempenha dois papéis: um operador de negação unário e um operador de subtração binário. Considere como os seguintes exemplos compilam:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

<YueDisplay>

```yue
a = x - 10
b = x-10
c = x -y
d = x- z
```

</YueDisplay>

A precedência do primeiro argumento de uma chamada de função pode ser controlada usando espaço em branco se o argumento for um literal de string. Em Lua, é comum omitir parênteses ao chamar uma função com uma única string ou literal de tabela.

Quando não há espaço entre uma variável e um literal de string, a chamada de função tem precedência sobre quaisquer expressões seguintes. Nenhum outro argumento pode ser passado para a função quando ela é chamada dessa forma.

Quando há um espaço após uma variável e um literal de string, a chamada de função age como mostrado acima. O literal de string pertence a quaisquer expressões seguintes (se existirem), que servem como lista de argumentos.

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```

<YueDisplay>

```yue
x = func"hello" + 100
y = func "hello" + 100
```

</YueDisplay>

## Argumentos multilinha

Ao chamar funções que recebem um grande número de argumentos, é conveniente dividir a lista de argumentos em várias linhas. Devido à natureza sensível a espaço em branco da linguagem, deve-se ter cuidado ao dividir a lista de argumentos.

Se uma lista de argumentos for continuada na próxima linha, a linha atual deve terminar em vírgula. E a linha seguinte deve estar mais indentada que a indentação atual. Uma vez indentada, todas as outras linhas de argumentos devem estar no mesmo nível de indentação para fazer parte da lista de argumentos.

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

<YueDisplay>

```yue
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

</YueDisplay>

Este tipo de invocação pode ser aninhado. O nível de indentação é usado para determinar a qual função os argumentos pertencem.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

<YueDisplay>

```yue
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

</YueDisplay>

Como as tabelas também usam vírgula como delimitador, esta sintaxe de indentação ajuda a deixar os valores fazerem parte da lista de argumentos em vez de fazerem parte da tabela.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

<YueDisplay>

```yue
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

</YueDisplay>

Embora incomum, observe como podemos dar uma indentação mais profunda para argumentos de função se soubermos que usaremos uma indentação menor mais adiante.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

<YueDisplay>

```yue
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

</YueDisplay>

A mesma coisa pode ser feita com outras instruções em nível de bloco como condicionais. Podemos usar o nível de indentação para determinar a qual instrução um valor pertence:

```yuescript
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
```

<YueDisplay>

```yue
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
```

</YueDisplay>

## Desestruturação de parâmetros

YueScript agora suporta desestruturação de parâmetros de função quando o argumento é um objeto. Duas formas de literais de tabela de desestruturação estão disponíveis:

- **Literais/parâmetros de objeto envolvidos em chaves**, permitindo valores padrão opcionais quando os campos estão ausentes (ex.: `{:a, :b}`, `{a: a1 = 123}`).

- **Sintaxe de tabela simples não envolvida**, começando com uma sequência de ligações chave-valor ou abreviadas e continuando até outra expressão terminá-la (ex.: `:a, b: b1, :c`). Esta forma extrai múltiplos campos do mesmo objeto.

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

<YueDisplay>

```yue
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

</YueDisplay>

## Expressão de retorno prefixada

Ao trabalhar com corpos de função profundamente aninhados, pode ser tedioso manter a legibilidade e consistência do valor de retorno. Para resolver isso, YueScript introduz a sintaxe **Expressão de Retorno Prefixada**. Sua forma é a seguinte:

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

<YueDisplay>

```yue
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

</YueDisplay>

Isso é equivalente a:

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

<YueDisplay>

```yue
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

</YueDisplay>

A única diferença é que você pode mover a expressão de retorno final antes do token `->` ou `=>` para indicar o valor de retorno implícito da função como última instrução. Dessa forma, mesmo em funções com múltiplos loops aninhados ou ramificações condicionais, você não precisa mais escrever uma expressão de retorno no final do corpo da função, tornando a estrutura lógica mais direta e fácil de seguir.

## Varargs nomeados

Você pode usar a sintaxe `(...t) ->` para armazenar automaticamente varargs em uma tabela nomeada. Esta tabela conterá todos os argumentos passados (incluindo valores `nil`), e o campo `n` da tabela armazenará o número real de argumentos passados (incluindo valores `nil`).

```yuescript
f = (...t) ->
  print "contagem de argumentos:", t.n
  print "comprimento da tabela:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Tratando casos com valores nil
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

<YueDisplay>

```yue
f = (...t) ->
  print "contagem de argumentos:", t.n
  print "comprimento da tabela:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Tratando casos com valores nil
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

</YueDisplay>
