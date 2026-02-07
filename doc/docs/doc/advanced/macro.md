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

A macro function can either return a YueScript string or a config table containing Lua codes.

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
