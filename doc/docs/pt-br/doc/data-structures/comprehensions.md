# Compreensões

As compreensões fornecem uma sintaxe conveniente para construir uma nova tabela iterando sobre algum objeto existente e aplicando uma expressão a seus valores. Existem dois tipos de compreensões: compreensões de lista e compreensões de tabela. Ambas produzem tabelas Lua; as compreensões de lista acumulam valores em uma tabela semelhante a array, e as compreensões de tabela permitem definir tanto a chave quanto o valor em cada iteração.

## Compreensões de lista

O seguinte cria uma cópia da tabela items mas com todos os valores dobrados.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

<YueDisplay>

```yue
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

</YueDisplay>

Os itens incluídos na nova tabela podem ser restringidos com uma cláusula when:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

<YueDisplay>

```yue
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

</YueDisplay>

Como é comum iterar sobre os valores de uma tabela indexada numericamente, um operador **\*** é introduzido. O exemplo doubled pode ser reescrito como:

```yuescript
doubled = [item * 2 for item in *items]
```

<YueDisplay>

```yue
doubled = [item * 2 for item in *items]
```

</YueDisplay>

Nas compreensões de lista, você também pode usar o operador spread `...` para achatar listas aninhadas, alcançando um efeito de flat map:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat agora é [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat agora é [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

As cláusulas for e when podem ser encadeadas tanto quanto desejado. O único requisito é que uma compreensão tenha pelo menos uma cláusula for.

Usar múltiplas cláusulas for é o mesmo que usar loops aninhados:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

<YueDisplay>

```yue
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

</YueDisplay>

Loops for numéricos também podem ser usados em compreensões:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

<YueDisplay>

```yue
evens = [i for i = 1, 100 when i % 2 == 0]
```

</YueDisplay>

## Compreensões de tabela

A sintaxe para compreensões de tabela é muito semelhante, diferindo apenas por usar **{** e **}** e receber dois valores de cada iteração.

Este exemplo faz uma cópia da tabela thing:

```yuescript
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

<YueDisplay>

```yue
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

</YueDisplay>

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

<YueDisplay>

```yue
no_color = {k, v for k, v in pairs thing when k != "color"}
```

</YueDisplay>

O operador **\*** também é suportado. Aqui criamos uma tabela de consulta de raiz quadrada para alguns números.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

<YueDisplay>

```yue
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

</YueDisplay>

A tupla chave-valor em uma compreensão de tabela também pode vir de uma única expressão, caso em que a expressão deve retornar dois valores. O primeiro é usado como chave e o segundo é usado como valor:

Neste exemplo convertemos um array de pares em uma tabela onde o primeiro item do par é a chave e o segundo é o valor.

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

<YueDisplay>

```yue
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

</YueDisplay>

## Slicing

Uma sintaxe especial é fornecida para restringir os itens sobre os quais se itera ao usar o operador **\***. Isso é equivalente a definir os limites de iteração e um tamanho de passo em um loop for.

Aqui podemos definir os limites mínimo e máximo, pegando todos os itens com índices entre 1 e 5 inclusive:

```yuescript
slice = [item for item in *items[1, 5]]
```

<YueDisplay>

```yue
slice = [item for item in *items[1, 5]]
```

</YueDisplay>

Qualquer um dos argumentos do slice pode ser omitido para usar um padrão sensato. Neste exemplo, se o índice máximo for omitido, ele usa como padrão o comprimento da tabela. Isso pegará tudo exceto o primeiro elemento:

```yuescript
slice = [item for item in *items[2,]]
```

<YueDisplay>

```yue
slice = [item for item in *items[2,]]
```

</YueDisplay>

Se o limite mínimo for omitido, ele usa como padrão 1. Aqui fornecemos apenas um tamanho de passo e deixamos os outros limites em branco. Isso pega todos os itens com índice ímpar: (1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

<YueDisplay>

```yue
slice = [item for item in *items[,,2]]
```

</YueDisplay>

Tanto o limite mínimo quanto o máximo podem ser negativos, o que significa que os limites são contados a partir do fim da tabela.

```yuescript
-- pegar os últimos 4 itens
slice = [item for item in *items[-4,-1]]
```

<YueDisplay>

```yue
-- pegar os últimos 4 itens
slice = [item for item in *items[-4,-1]]
```

</YueDisplay>

O tamanho do passo também pode ser negativo, o que significa que os itens são tomados em ordem reversa.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

<YueDisplay>

```yue
reverse_slice = [item for item in *items[-1,1,-1]]
```

</YueDisplay>

### Expressão de slicing

O slicing também pode ser usado como expressão. Isso é útil para obter uma sublista de uma tabela.

```yuescript
-- pegar o 2º e 4º itens como nova lista
sub_list = items[2, 4]

-- pegar os últimos 4 itens
last_four_items = items[-4, -1]
```

<YueDisplay>

```yue
-- pegar o 2º e 4º itens como nova lista
sub_list = items[2, 4]

-- pegar os últimos 4 itens
last_four_items = items[-4, -1]
```

</YueDisplay>
