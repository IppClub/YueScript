---
title: Atributos
sidebar:
  order: 8
---

Suporte de sintaxe para atributos do Lua 5.4. E você ainda pode usar tanto a declaração `const` quanto `close` e obter verificação de constante e callback com escopo funcionando ao direcionar para versões do Lua abaixo da 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Fora do escopo."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const a = 123
close _ = <close>: -> print "Fora do escopo."
```

</div>
</div>

Você pode fazer desestruturação com variáveis atribuídas como constante.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</div>
</div>

Você também pode declarar uma variável global como `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
global const Constant = 123
-- Constant = 1
```

</div>
</div>
