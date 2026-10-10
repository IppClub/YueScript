---
title: Atribuição por desestruturação
sidebar:
  order: 11
---

A atribuição por desestruturação é uma forma de extrair rapidamente valores de uma tabela por seu nome ou posição em tabelas baseadas em array.

Tipicamente, quando você vê um literal de tabela, {1,2,3}, ele está no lado direito de uma atribuição porque é um valor. A atribuição por desestruturação troca o papel do literal de tabela e o coloca no lado esquerdo de uma instrução de atribuição.

Isso é melhor explicado com exemplos. Assim você extrairia os dois primeiros valores de uma tabela:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
thing = [1, 2]

[a, b] = thing
print a, b
```

</div>
</div>

No literal de tabela de desestruturação, a chave representa a chave para ler do lado direito, e o valor representa o nome ao qual o valor lido será atribuído.

```yuescript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK fazer desestruturação simples sem chaves
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK fazer desestruturação simples sem chaves
```

</div>
</div>

Isso também funciona com estruturas de dados aninhadas:

```yuescript
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

</div>
</div>

Se a instrução de desestruturação for complicada, sinta-se à vontade para espalhá-la em várias linhas. Um exemplo um pouco mais complicado:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

</div>
</div>

É comum extrair valores de uma tabela e atribuí-los a variáveis locais que têm o mesmo nome da chave. Para evitar repetição, podemos usar o operador de prefixo **:**:

```yuescript
{:concat, :insert} = table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:concat, :insert} = table
```

</div>
</div>

Isso é efetivamente o mesmo que import, mas podemos renomear campos que queremos extrair misturando a sintaxe:

```yuescript
{:mix, :max, random: rand} = math
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:mix, :max, random: rand} = math
```

</div>
</div>

Você pode escrever valores padrão ao fazer desestruturação:

```yuescript
{:name = "sem nome", :job = "sem emprego"} = person
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:name = "sem nome", :job = "sem emprego"} = person
```

</div>
</div>

Você pode usar `_` como placeholder ao fazer desestruturação de lista:

```yuescript
[_, two, _, four] = items
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
[_, two, _, four] = items
```

</div>
</div>

## Desestruturação por intervalo

Você pode usar o operador spread `...` na desestruturação de lista para capturar um intervalo de valores. Isso é útil quando você quer extrair elementos específicos do início e do fim de uma lista enquanto coleta o restante entre eles.

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- imprime: first
print bulk   -- imprime: {"second", "third", "fourth"}
print last   -- imprime: last
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- imprime: first
print bulk   -- imprime: {"second", "third", "fourth"}
print last   -- imprime: last
```

</div>
</div>

O operador spread pode ser usado em diferentes posições para capturar diferentes intervalos, e você pode usar `_` como placeholder para os valores que não quer capturar:

```yuescript
-- Capturar tudo após o primeiro elemento
[first, ...rest] = orders

-- Capturar tudo antes do último elemento
[...start, last] = orders

-- Capturar tudo exceto os elementos do meio
[first, ..._, last] = orders
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- Capturar tudo após o primeiro elemento
[first, ...rest] = orders

-- Capturar tudo antes do último elemento
[...start, last] = orders

-- Capturar tudo exceto os elementos do meio
[first, ..._, last] = orders
```

</div>
</div>

## Desestruturação em outros lugares

A desestruturação também pode aparecer em lugares onde uma atribuição ocorre implicitamente. Um exemplo disso é um loop for:

```yuescript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

</div>
</div>

Sabemos que cada elemento na tabela array é uma tupla de dois itens, então podemos desempacotá-lo diretamente na cláusula de nomes da instrução for usando desestruturação.
