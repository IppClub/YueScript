---
title: Instrução With
sidebar:
  order: 27
---

Um padrão comum envolvendo a criação de um objeto é chamar uma série de funções e definir uma série de propriedades imediatamente após criá-lo.

Isso resulta em repetir o nome do objeto várias vezes no código, adicionando ruído desnecessário. Uma solução comum para isso é passar uma tabela como argumento que contém uma coleção de chaves e valores para sobrescrever. O inconveniente é que o construtor desse objeto deve suportar essa forma.

O bloco with ajuda a aliviar isso. Dentro de um bloco with podemos usar instruções especiais que começam com . ou \ que representam essas operações aplicadas ao objeto com o qual estamos usando with.

Por exemplo, trabalhamos com um objeto recém-criado:

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</div>
</div>

A instrução with também pode ser usada como expressão que retorna o valor ao qual foi dado acesso.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</div>
</div>

Expressões `with` suportam `break` com um valor:

```yuescript
result = with obj
  break .value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
result = with obj
  break .value
```

</div>
</div>

Depois que `break value` é usado dentro de `with`, a expressão `with` deixa de retornar seu objeto-alvo e passa a retornar o valor de `break`.

```yuescript
a = with obj
  .x = 1
-- a é obj

b = with obj
  break .x
-- b é .x, não obj
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = with obj
  .x = 1
-- a é obj

b = with obj
  break .x
-- b é .x, não obj
```

</div>
</div>

Diferente de `for` / `while` / `repeat` / `do`, `with` suporta apenas um valor de `break`.

Ou…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</div>
</div>

Neste uso, with pode ser visto como uma forma especial do combinador K.

A expressão na instrução with também pode ser uma atribuição, se você quiser dar um nome à expressão.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

</div>
</div>

Você pode acessar chaves especiais com `[]` em uma instrução `with`.

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- anexando a "tb"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- anexando a "tb"
```

</div>
</div>

`with?` é uma versão aprimorada da sintaxe `with`, que introduz uma verificação existencial para acessar com segurança objetos que podem ser nil sem verificações explícitas de null.

```yuescript
with? obj
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with? obj
  print .name
```

</div>
</div>
