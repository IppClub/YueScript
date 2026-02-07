# Atributos

Suporte de sintaxe para atributos do Lua 5.4. E você ainda pode usar tanto a declaração `const` quanto `close` e obter verificação de constante e callback com escopo funcionando ao direcionar para versões do Lua abaixo da 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Fora do escopo."
```

<YueDisplay>

```yue
const a = 123
close _ = <close>: -> print "Fora do escopo."
```

</YueDisplay>

Você pode fazer desestruturação com variáveis atribuídas como constante.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<YueDisplay>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</YueDisplay>

Você também pode declarar uma variável global como `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

<YueDisplay>

```yue
global const Constant = 123
-- Constant = 1
```

</YueDisplay>
