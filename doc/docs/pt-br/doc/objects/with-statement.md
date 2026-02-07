# Instrução With

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

<YueDisplay>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</YueDisplay>

A instrução with também pode ser usada como expressão que retorna o valor ao qual foi dado acesso.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

<YueDisplay>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</YueDisplay>

Ou…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

<YueDisplay>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</YueDisplay>

Neste uso, with pode ser visto como uma forma especial do combinador K.

A expressão na instrução with também pode ser uma atribuição, se você quiser dar um nome à expressão.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

<YueDisplay>

```yue
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

</YueDisplay>

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

<YueDisplay>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- anexando a "tb"
```

</YueDisplay>

`with?` é uma versão aprimorada da sintaxe `with`, que introduz uma verificação existencial para acessar com segurança objetos que podem ser nil sem verificações explícitas de null.

```yuescript
with? obj
  print obj.name
```

<YueDisplay>

```yue
with? obj
  print obj.name
```

</YueDisplay>
