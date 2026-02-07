# Módulo

## Import

A instrução import é um açúcar sintático para requerer um módulo ou ajudar a extrair itens de um módulo importado. Os itens importados são const por padrão.

```yuescript
-- usado como desestruturação de tabela
do
  import insert, concat from table
  -- reporta erro ao atribuir a insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- atalho para require implícito
  import x, y, z from 'mymodule'
  -- import com estilo Python
  from 'module' import a, b, c

-- atalho para requerer um módulo
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requerer módulo com aliasing ou desestruturação de tabela
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

<YueDisplay>

```yue
-- usado como desestruturação de tabela
do
  import insert, concat from table
  -- reporta erro ao atribuir a insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- atalho para require implícito
  import x, y, z from 'mymodule'
  -- import com estilo Python
  from 'module' import a, b, c

-- atalho para requerer um módulo
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requerer módulo com aliasing ou desestruturação de tabela
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

</YueDisplay>

## Import Global

Você pode importar globais específicos para variáveis locais com `import`. Ao importar uma cadeia de acessos a variáveis globais, o último campo será atribuído à variável local.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

<YueDisplay>

```yue
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

</YueDisplay>

### Importação automática de variável global

Você pode colocar `import global` no topo de um bloco para importar automaticamente todos os nomes que não foram explicitamente declarados ou atribuídos no escopo atual como globais. Essas importações implícitas são tratadas como consts locais que referenciam os globais correspondentes na posição da instrução.

Nomes que foram explicitamente declarados como globais no mesmo escopo não serão importados, então você ainda pode atribuir a eles.

```yuescript
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- erro: globais importados são const

do
  -- variável global explícita não será importada
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

<YueDisplay>

```yue
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- erro: globais importados são const

do
  -- variável global explícita não será importada
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

</YueDisplay>

## Export

A instrução export oferece uma forma concisa de definir módulos.

### Export nomeado

Export nomeado definirá uma variável local e também adicionará um campo na tabela exportada.

```yuescript
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

<YueDisplay>

```yue
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

</YueDisplay>

Fazendo export nomeado com desestruturação.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

<YueDisplay>

```yue
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

</YueDisplay>

Exportar itens nomeados do módulo sem criar variáveis locais.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

<YueDisplay>

```yue
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

</YueDisplay>

### Export sem nome

Export sem nome adicionará o item alvo na parte array da tabela exportada.

```yuescript
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

<YueDisplay>

```yue
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

</YueDisplay>

### Export padrão

Usar a palavra-chave **default** na instrução export para substituir a tabela exportada por qualquer coisa.

```yuescript
export default ->
  print "hello"
  123
```

<YueDisplay>

```yue
export default ->
  print "hello"
  123
```

</YueDisplay>
