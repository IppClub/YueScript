# Operador

Todos os operadores binários e unários do Lua estão disponíveis. Além disso, **!=** é um alias para **~=**, e **\\** ou **::** podem ser usados para escrever uma chamada de função encadeada como `tb\func!` ou `tb::func!`. E o YueScript oferece alguns outros operadores especiais para escrever códigos mais expressivos.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

<YueDisplay>

```yue
tb\func! if tb ~= nil
tb::func! if tb != nil
```

</YueDisplay>

## Comparações encadeadas

Comparações podem ser encadeadas arbitrariamente:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- saída: true

a = 5
print 1 <= a <= 10
-- saída: true
```

<YueDisplay>

```yue
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- saída: true

a = 5
print 1 <= a <= 10
-- saída: true
```

</YueDisplay>

Observe o comportamento de avaliação das comparações encadeadas:

```yuescript
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  saída:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  saída:
  2
  1
  false
]]
```

<YueDisplay>

```yue
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  saída:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  saída:
  2
  1
  false
]]
```

</YueDisplay>

A expressão do meio é avaliada apenas uma vez, em vez de duas vezes como seria se a expressão fosse escrita como `v(1) < v(2) and v(2) <= v(3)`. No entanto, a ordem das avaliações em uma comparação encadeada é indefinida. É fortemente recomendado não usar expressões com efeitos colaterais (como impressão) em comparações encadeadas. Se efeitos colaterais forem necessários, o operador de curto-circuito `and` deve ser usado explicitamente.

## Anexar à tabela

O operador **[] =** é usado para anexar valores a tabelas.

```yuescript
tab = []
tab[] = "Value"
```

<YueDisplay>

```yue
tab = []
tab[] = "Value"
```

</YueDisplay>

Você também pode usar o operador spread `...` para anexar todos os elementos de uma lista a outra:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA agora é [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA agora é [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

## Spread de tabela

Você pode concatenar tabelas de array ou tabelas hash usando o operador spread `...` antes de expressões em literais de tabela.

```yuescript
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

<YueDisplay>

```yue
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

</YueDisplay>

## Indexação reversa de tabela

Você pode usar o operador **#** para obter os últimos elementos de uma tabela.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

<YueDisplay>

```yue
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

</YueDisplay>

## Metatable

O operador **<>** pode ser usado como atalho para manipulação de metatable.

### Criação de metatable

Crie tabela normal com chaves vazias **<>** ou chave de metamétodo cercada por **<>**.

```yuescript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- definir campo com variável de mesmo nome
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "fora do escopo"
```

<YueDisplay>

```yue
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- definir campo com variável de mesmo nome
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "fora do escopo"
```

</YueDisplay>

### Acesso à metatable

Acesse a metatable com **<>** ou nome do metamétodo cercado por **<>** ou escrevendo alguma expressão em **<>**.

```yuescript
-- criar com metatable contendo campo "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```

<YueDisplay>

```yue
-- criar com metatable contendo campo "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value
tb.<> = __index: {item: "hello"}
print tb.item
```

</YueDisplay>

### Desestruturação de metatable

Desestruture a metatable com chave de metamétodo cercada por **<>**.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

<YueDisplay>

```yue
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

</YueDisplay>

## Existência

O operador **?** pode ser usado em diversos contextos para verificar existência.

```yuescript
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

<YueDisplay>

```yue
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

</YueDisplay>

## Pipe

Em vez de uma série de chamadas de função aninhadas, você pode encaminhar valores com o operador **|>**.

```yuescript
"hello" |> print
1 |> print 2 -- insere o item do pipe como primeiro argumento
2 |> print 1, _, 3 -- pipe com um placeholder

-- expressão pipe em multilinha
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

<YueDisplay>

```yue
"hello" |> print
1 |> print 2 -- insere o item do pipe como primeiro argumento
2 |> print 1, _, 3 -- pipe com um placeholder
-- expressão pipe em multilinha
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

</YueDisplay>

## Coalescência de nil

O operador de coalescência de nil **??** retorna o valor do operando esquerdo se não for **nil**; caso contrário, avalia o operando direito e retorna seu resultado. O operador **??** não avalia seu operando direito se o operando esquerdo avaliar para não-nil.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

<YueDisplay>

```yue
local a, b, c, d
a = b ?? c ?? d
func a ?? {}
a ??= false
```

</YueDisplay>

## Objeto implícito

Você pode escrever uma lista de estruturas implícitas que começa com o símbolo **\*** ou **-** dentro de um bloco de tabela. Se você está criando objeto implícito, os campos do objeto devem estar com a mesma indentação.

```yuescript
-- atribuição com objeto implícito
list =
  * 1
  * 2
  * 3

-- chamada de função com objeto implícito
func
  * 1
  * 2
  * 3

-- retorno com objeto implícito
f = ->
  return
    * 1
    * 2
    * 3

-- tabela com objeto implícito
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }

```

<YueDisplay>

```yue
-- atribuição com objeto implícito
list =
  * 1
  * 2
  * 3

-- chamada de função com objeto implícito
func
  * 1
  * 2
  * 3

-- retorno com objeto implícito
f = ->
  return
    * 1
    * 2
    * 3

-- tabela com objeto implícito
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }
```

</YueDisplay>
