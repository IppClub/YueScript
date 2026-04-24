# Macro

## Common Usage

Macro function is used for evaluating a string in the compile time and insert the generated codes into final compilation.

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

-- the passed expressions are treated as strings
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

-- the passed expressions are treated as strings
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

</YueDisplay>

## Insert Raw Codes

A macro function can either return a YueScript string or a config table containing generated code.

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

-- the raw string leading and ending symbols are auto trimed
$lua[==[
-- raw Lua codes insertion
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

-- the raw string leading and ending symbols are auto trimed
$lua[==[
-- raw Lua codes insertion
if cond then
  print("output")
end
]==]
```

</YueDisplay>

The returned table can be used to control how the generated code gets inserted.

- `code` is the generated text.
- `type` chooses how the text is handled. It can be `"yue"` (the default), `"lua"`, or `"text"`.
- `locals` declares local names introduced by inserted text.
- `before` puts the generated result before the annotated statement instead of after it.

In most cases you only need to choose a `type`. Use `"yue"` for generated YueScript, `"lua"` for raw Lua, and `"text"` for text that should be copied straight into the final output.

## Export Macro

Macro functions can be exported from a module and get imported in another module. You have to put export macro functions in a single file to be used, and only macro definition, macro importing and macro expansion in place can be put into the macro exporting module.

```yuescript
-- file: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- file main.yue
import "utils" as {
  $, -- symbol to import all macros
  $foreach: $each -- rename macro $foreach to $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```

<YueDisplay>

```yue
-- file: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- file main.yue
-- import function is not available in browser, try it in a real environment
--[[
import "utils" as {
  $, -- symbol to import all macros
  $foreach: $each -- rename macro $foreach to $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
]]
```

</YueDisplay>

## Builtin Macro

There are some builtin macros but you can override them by declaring macros with the same names.

```yuescript
print $FILE -- get string of current module name
print $LINE -- get number 2
```

<YueDisplay>

```yue
print $FILE -- get string of current module name
print $LINE -- get number 2
```

</YueDisplay>

## Generating Macros with Macros

In YueScript, macro functions allow you to generate code at compile time. By nesting macro functions, you can create more complex generation patterns. This feature enables you to define a macro function that generates another macro function, allowing for more dynamic code generation.

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

## Generating Multi-line Code

When a macro returns multi-line Yue code, using a quoted multi-line string is not recommended. Prefer `-> |` instead.

A quoted string keeps the literal text as-is, while a YAML multiline string removes the common leading indentation. This usually makes generated Yue blocks more stable, especially when the generated code contains comments or nested blocks.

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

## Argument Validation

You can declare the expected AST node types in the argument list, and check whether the incoming macro arguments meet the expectations at compile time.

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

If you need more flexible argument checking, you can use the built-in `$is_ast` macro function to manually check at the appropriate place.

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

For more details about available AST nodes, please refer to the uppercased definitions in [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp).

## Annotation Statements

Annotation statements apply a macro to the statement immediately following them.

This is equivalent to calling the macro with the following statement's source text appended as the last argument.

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

When the annotation macro returns a config table, the optional `before` field controls whether the generated result is emitted before or after the annotated statement.

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

Because the followed statement is passed in as an extra macro argument, annotations can also be used to generate registration code from class declarations. Because the followed statement is passed in as an extra macro argument, you can use the same AST argument checks as normal macros:

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

Annotations can also inject wrapper code around functions:

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

An annotation must always be followed by a statement, and it can not be applied to a `return` statement. If the annotated statement appears at the end of a block, add an explicit trailing `return` when you need the raw statement AST shape instead of an implicitly returned expression.
