# Literais de tabela

Como no Lua, as tabelas são delimitadas por chaves.

```yuescript
some_values = [1, 2, 3, 4]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
```

</YueDisplay>

Diferente do Lua, atribuir um valor a uma chave em uma tabela é feito com **:** (em vez de **=**).

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

<YueDisplay>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

</YueDisplay>

As chaves podem ser omitidas se uma única tabela de pares chave-valor está sendo atribuída.

```yuescript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

<YueDisplay>

```yue
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

</YueDisplay>

Quebras de linha podem ser usadas para delimitar valores em vez de vírgula (ou ambos):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

<YueDisplay>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

</YueDisplay>

Ao criar um literal de tabela em uma única linha, as chaves também podem ser omitidas:

```yuescript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

<YueDisplay>

```yue
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

</YueDisplay>

As chaves de um literal de tabela podem ser palavras-chave da linguagem sem precisar escapar:

```yuescript
tbl = {
  do: "something"
  end: "hunger"
}
```

<YueDisplay>

```yue
tbl = {
  do: "something"
  end: "hunger"
}
```

</YueDisplay>

Se você está construindo uma tabela a partir de variáveis e deseja que as chaves sejam iguais aos nomes das variáveis, então o operador de prefixo **:** pode ser usado:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

<YueDisplay>

```yue
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</YueDisplay>

Se você quiser que a chave de um campo na tabela seja o resultado de uma expressão, então pode envolvê-la em **[ ]**, assim como no Lua. Você também pode usar um literal de string diretamente como chave, omitindo os colchetes. Isso é útil se sua chave tiver caracteres especiais.

```yuescript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

<YueDisplay>

```yue
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

</YueDisplay>

As tabelas Lua têm tanto uma parte array quanto uma parte hash, mas às vezes você quer fazer uma distinção semântica entre uso de array e hash ao escrever tabelas Lua. Então você pode escrever tabela Lua com **[ ]** em vez de **{ }** para representar uma tabela array, e escrever qualquer par chave-valor em uma tabela lista não será permitido.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

</YueDisplay>
