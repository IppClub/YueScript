# Literais

Todos os literais primitivos do Lua podem ser usados. Isso se aplica a números, strings, booleanos e **nil**.

Diferente do Lua, quebras de linha são permitidas dentro de strings com aspas simples e duplas sem sequência de escape:

```yuescript
some_string = "Aqui está uma string
  que tem uma quebra de linha."

-- Você pode misturar expressões em literais de string usando a sintaxe #{}.
-- Interpolação de string está disponível apenas em strings com aspas duplas.
print "Tenho #{math.random! * 100}% de certeza."
```

<YueDisplay>

```yue
some_string = "Aqui está uma string
  que tem uma quebra de linha."

-- Você pode misturar expressões em literais de string usando a sintaxe #{}.
-- Interpolação de string está disponível apenas em strings com aspas duplas.
print "Tenho #{math.random! * 100}% de certeza."
```

</YueDisplay>

## Literais numéricos

Você pode usar underscores em um literal numérico para aumentar a legibilidade.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

<YueDisplay>

```yue
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

</YueDisplay>

## String multilinha estilo YAML

O prefixo `|` introduz um literal de string multilinha no estilo YAML:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

<YueDisplay>

```yue
str = |
  key: value
  list:
    - item1
    - #{expr}
```

</YueDisplay>

Isso permite escrever texto estruturado multilinha convenientemente. Todas as quebras de linha e indentação são preservadas em relação à primeira linha não vazia, e expressões dentro de `#{...}` são interpoladas automaticamente como `tostring(expr)`.

A string multilinha YAML detecta automaticamente o prefixo comum de espaço em branco à esquerda (indentação mínima em todas as linhas não vazias) e remove-o de todas as linhas. Isso facilita a indentação visual do seu código sem afetar o conteúdo da string resultante.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

<YueDisplay>

```yue
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

</YueDisplay>

A indentação interna é preservada em relação ao prefixo comum removido, permitindo estruturas aninhadas limpas.

Todos os caracteres especiais como aspas (`"`) e barras invertidas (`\`) no bloco YAML Multiline são escapados automaticamente para que a string Lua gerada seja sintaticamente válida e se comporte como esperado.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'Ele disse: "#{Hello}!"'
```

<YueDisplay>

```yue
str = |
  path: "C:\Program Files\App"
  note: 'Ele disse: "#{Hello}!"'
```

</YueDisplay>
