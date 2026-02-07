# Macro

## Uso comum

A função macro é usada para avaliar uma string em tempo de compilação e inserir os códigos gerados na compilação final.

```yuescript
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'hello world'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- as expressões passadas são tratadas como strings
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

<YueDisplay>

```yue
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'hello world'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- as expressões passadas são tratadas como strings
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

</YueDisplay>

## Inserir códigos brutos

Uma função macro pode retornar uma string YueScript ou uma tabela de configuração contendo códigos Lua.

```yuescript
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "fail to assign to the Yue macro defined variable"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "fail to assign to the Lua macro defined variable"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- os símbolos inicial e final da string bruta são aparados automaticamente
$lua[==[
-- inserção de códigos Lua brutos
if cond then
  print("output")
end
]==]
```

<YueDisplay>

```yue
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "fail to assign to the Yue macro defined variable"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "fail to assign to the Lua macro defined variable"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- os símbolos inicial e final da string bruta são aparados automaticamente
$lua[==[
-- inserção de códigos Lua brutos
if cond then
  print("output")
end
]==]
```

</YueDisplay>

## Exportar macro

Funções macro podem ser exportadas de um módulo e importadas em outro módulo. Você deve colocar funções export macro em um único arquivo para uso, e apenas definição de macro, importação de macro e expansão de macro inline podem ser colocadas no módulo exportador de macro.

```yuescript
-- arquivo: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- arquivo main.yue
import "utils" as {
  $, -- símbolo para importar todas as macros
  $foreach: $each -- renomear macro $foreach para $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```

<YueDisplay>

```yue
-- arquivo: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- arquivo main.yue
--[[
import "utils" as {
  $, -- símbolo para importar todas as macros
  $foreach: $each -- renomear macro $foreach para $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
]]
```

</YueDisplay>

## Macro embutida

Existem algumas macros embutidas, mas você pode sobrescrevê-las declarando macros com os mesmos nomes.

```yuescript
print $FILE -- obtém string do nome do módulo atual
print $LINE -- obtém número 2
```

<YueDisplay>

```yue
print $FILE -- obtém string do nome do módulo atual
print $LINE -- obtém número 2
```

</YueDisplay>

## Gerando macros com macros

No YueScript, as funções macro permitem que você gere código em tempo de compilação. Aninhando funções macro, você pode criar padrões de geração mais complexos. Este recurso permite que você defina uma função macro que gera outra função macro, permitindo geração de código mais dinâmica.

```yuescript
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "Valid enum type:", $BodyType Static
-- print "Compilation error with enum type:", $BodyType Unknown
```

<YueDisplay>

```yue
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "Valid enum type:", $BodyType Static
-- print "Compilation error with enum type:", $BodyType Unknown
```

</YueDisplay>

## Validação de argumentos

Você pode declarar os tipos de nós AST esperados na lista de argumentos e verificar se os argumentos da macro recebidos atendem às expectativas em tempo de compilação.

```yuescript
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

<YueDisplay>

```yue
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

</YueDisplay>

Se você precisar de verificação de argumentos mais flexível, pode usar a função macro embutida `$is_ast` para verificar manualmente no lugar apropriado.

```yuescript
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

<YueDisplay>

```yue
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

</YueDisplay>

Para mais detalhes sobre os nós AST disponíveis, consulte as definições em maiúsculas em [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp).
