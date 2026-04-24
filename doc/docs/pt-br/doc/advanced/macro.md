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

## Gerando código em múltiplas linhas

Quando uma macro retorna código Yue em múltiplas linhas, não é recomendado usar uma string multilinha entre aspas. Prefira `-> |`.

Uma string entre aspas preserva o texto literal, enquanto uma string multilinha estilo YAML remove a indentação inicial comum. Isso normalmente deixa os blocos Yue gerados mais estáveis, especialmente quando o código gerado contém comentários ou blocos aninhados.

```yuescript
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

<YueDisplay>

```yue
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

</YueDisplay>

```yuescript
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

<YueDisplay>

```yue
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
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

## Instruções de anotação

As instruções de anotação aplicam uma macro à instrução logo em seguida.

Isso equivale a chamar a macro com o código-fonte da instrução seguinte anexado como último argumento.

```yuescript
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

<YueDisplay>

```yue
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

</YueDisplay>

Quando a macro de anotação retorna uma tabela de configuração, o campo opcional `before` controla se o resultado gerado será emitido antes ou depois da instrução anotada.

```yuescript
macro Tag = (tag, code) ->
  tableName = code\match "^[%w_]+"
  return
    type: "text"
    before: tag == "before"
    code: "-- #{tag}:#{tableName}"

$[Tag before]
tableA = {}

$[Tag after]
tableB = {}

return
```

<YueDisplay>

```yue
macro Tag = (tag, code) ->
  tableName = code\match "^[%w_]+"
  return
    type: "text"
    before: tag == "before"
    code: "-- #{tag}:#{tableName}"

$[Tag before]
tableA = {}

$[Tag after]
tableB = {}

return
```

</YueDisplay>

Como a instrução seguinte é passada como um argumento extra para a macro, anotações também podem ser usadas para gerar código de registro a partir de declarações de classe. Você também pode usar as mesmas checagens de AST nos argumentos que macros normais oferecem.

```yuescript
macro Register = (registry, code`ClassDecl) ->
  className = code\match "^class%s+(%w+)"
  return |
    #{registry}["#{className}"] = #{className}

registry = {}

$[Register(registry)]
class Worker
  run: => "ok"

return
```

<YueDisplay>

```yue
macro Register = (registry, code`ClassDecl) ->
  className = code\match "^class%s+(%w+)"
  return |
    #{registry}["#{className}"] = #{className}

registry = {}

$[Register(registry)]
class Worker
  run: => "ok"

return
```

</YueDisplay>

Anotações também podem injetar código de empacotamento em volta de funções:

```yuescript
macro ValidateNumberArgs = (code) ->
  funcName = code\match "^(%w+)%s*="
  return |
    local __orig_#{funcName} = #{funcName}
    #{funcName} = (...) ->
      for i = 1, select "#", ...
        assert type(select i, ...) == "number", "expected number for arg \#{i}"
      __orig_#{funcName} ...

$[ValidateNumberArgs]
add = (a, b) -> a + b
```

<YueDisplay>

```yue
macro ValidateNumberArgs = (code) ->
  funcName = code\match "^(%w+)%s*="
  return |
    local __orig_#{funcName} = #{funcName}
    #{funcName} = (...) ->
      for i = 1, select "#", ...
        assert type(select i, ...) == "number", "expected number for arg \#{i}"
      __orig_#{funcName} ...

$[ValidateNumberArgs]
add = (a, b) -> a + b
```

</YueDisplay>

Uma anotação sempre precisa ser seguida por uma instrução, e ela não pode ser aplicada a uma instrução `return`. Se a instrução anotada aparecer no fim de um bloco e você precisar da forma AST bruta dessa instrução, adicione um `return` explícito em seguida para evitar que ela seja envolvida por uma expressão com retorno implícito.
