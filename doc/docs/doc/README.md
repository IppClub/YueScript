---
sidebar: auto
title: Reference
---

# E

<img src="/image/e.svg" width="300px" height="300px" alt="logo"/>

## Introduction

E is a dynamic language that compiles to Lua. And it's a [MoonScript](https://github.com/leafo/moonscript) dialect. The codes written in E are expressive and extremely concise. And it is suitable for writing some changing application logic with more maintainable codes and runs in a Lua embeded environment such as games or website servers.

E (月) is the name of moon in Chinese and it's pronounced as [jyɛ].

### An Overview of E
```moonscript
-- import syntax
import p, to_lua from "e"

-- object literals
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- list comprehension
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- pipe operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- metatable manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- js-like export syntax
export 🌛 = "月之脚本"
```
<EDisplay>
<pre>
-- import syntax
import p, to_lua from "e"

-- object literals
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- list comprehension
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- pipe operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- metatable manipulation
apple =
  size: 15
  &lt;index&gt;:
    color: 0x00ffff

with apple
  p .size, .color, .&lt;index&gt; if .&lt;&gt;?

-- js-like export syntax
export 🌛 = "月之脚本"
</pre>
</YueDisplay>

## Installation

* **Lua Module**

&emsp;Install [luarocks](https://luarocks.org), a package manager for Lua modules. Then install it as a Lua module and executable with:

```
> luarocks install e
```

&emsp;Or you can build `e.so` file with:

```
> make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

&emsp;Then get the binary file from path **bin/shared/e.so**.

* **Build Binary Tool**

&emsp;Clone this repo, then build and install executable with:
```
> make install
```

&emsp;Build E tool without macro feature:
```
> make install NO_MACRO=true
```

&emsp;Build E tool without built-in Lua binary:
```
> make install NO_LUA=true
```

* **Download Precompiled Binary**

&emsp;You can download precompiled binary files, including binary executable files compatible with different Lua versions and library files.

&emsp;Download precompiled binary files from [here](https://github.com/IppClub/E/releases).

## Usage

### Lua Module

&emsp;Use E module in Lua:

* **Case 1**
Require "your_e_entry.e" in Lua.
```Lua
require("e")("your_e_entry")
```
&emsp;And this code still works when you compile "your_e_entry.e"  to "your_e_entry.lua" in the same path. In the rest E files just use the normal **require** or **import**. The code line numbers in error messages will also be handled correctly.

* **Case 2**
Require E module and rewite message by hand.
```lua
local e = require("e")
e.insert_loader()
local success, result = xpcall(function()
  return require("e_module_name")
end, function(err)
  return e.traceback(err)
end)
```

* **Case 3**
Use the E compiler function in Lua.
```lua
local e = require("e")
local codes, err, globals = e.to_lua([[
f = ->
  print "hello world"
f!
]],{
  implicit_return_root = true,
  reserve_line_number = true,
  lint_global = true,
  space_over_tab = false,
  options = {
    target = "5.4",
    path = "/script"
  }
})
```

### E Tool

&emsp;Use E tool with:
```
> e -h
Usage: e [options|files|directories] ...

   -h       Print this message
   -e str   Execute a file or raw codes
   -m       Generate minified codes
   -r       Rewrite output to match original line numbers
   -t path  Specify where to place compiled files
   -o file  Write output to file
   -s       Use spaces in generated codes instead of tabs
   -p       Write output to standard out
   -b       Dump compile time (doesn't write output)
   -g       Dump global variables used in NAME LINE COLUMN
   -l       Write line numbers from source codes
   -j       Disable implicit return at end of file
   -c       Reserve comments before statement from source codes
   -w path  Watch changes and compile every file under directory
   -v       Print version
   --       Read from standard in, print to standard out
            (Must be first and only argument)

   --target=version  Specify the Lua version codes the compiler will generate
                     (version can only be 5.1, 5.2, 5.3 or 5.4)
   --path=path_str   Append an extra Lua search path string to package.path

   Execute without options to enter REPL, type symbol '$'
   in a single line to start/stop multi-line mode
```
&emsp;&emsp;Use cases:
&emsp;&emsp;Recursively compile every E file with extension **.e** under current path:  **e .**
&emsp;&emsp;Compile and save results to a target path:  **e -t /target/path/ .**
&emsp;&emsp;Compile and reserve debug info:  **e -l .**
&emsp;&emsp;Compile and generate minified codes:  **e -m .**
&emsp;&emsp;Execute raw codes:  **e -e 'print 123'**
&emsp;&emsp;Execute a E file:  **e -e main.e**

## Macro

### Common Usage

Macro function is used for evaluating a string in the compile time and insert the generated codes into final compilation.

```moonscript
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
<EDisplay>
<pre>
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
</pre>
</YueDisplay>

### Insert Raw Codes

A macro function can either return a E string or a config table containing Lua codes.
```moonscript
macro eFunc = (var) -> "local #{var} = ->"
$eFunc funcA
funcA = -> "fail to assign to the E macro defined variable"

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
<EDisplay>
<pre>
macro eFunc = (var) -> "local #{var} = ->"
$eFunc funcA
funcA = -> "fail to assign to the E macro defined variable"

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
</pre>
</YueDisplay>

### Export Macro

Macro functions can be exported from a module and get imported in another module. You have to put export macro functions in a single file to be used, and only macro definition, macro importing and macro expansion in place can be put into the macro exporting module.
```moonscript
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
<pre>
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
</pre>
</EDisplay>

### Builtin Macro

There are some builtin macros but you can override them by declaring macros with the same names.
```moonscript
print $FILE -- get string of current module name
print $LINE -- get number 2
```
<EDisplay>
<pre>
print $FILE -- get string of current module name
print $LINE -- get number 2
</pre>
</YueDisplay>

### Generating Macros with Macros

In E, macro functions allow you to generate code at compile time. By nesting macro functions, you can create more complex generation patterns. This feature enables you to define a macro function that generates another macro function, allowing for more dynamic code generation.

```moonscript
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
<pre>
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
</pre>
</YueDisplay>

## Operator

All of Lua's binary and unary operators are available. Additionally **!=** is as an alias for **~=**, and either **\\** or **::** can be used to write a chaining function call like `tb\func!` or `tb::func!`. And E offers some other special operators to write more expressive codes.

```moonscript
tb\func! if tb ~= nil
tb::func! if tb != nil
```
<EDisplay>
<pre>
tb\func! if tb ~= nil
tb::func! if tb != nil
</pre>
</EDisplay>

### Chaining Comparisons

Comparisons can be arbitrarily chained:

```moonscript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
```
<YueDisplay>
<pre>
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
</pre>
</YueDisplay>

Note the evaluation behavior of chained comparisons:

```moonscript
v = (x) ->
	print x
	x

print v(1) < v(2) <= v(3)
--[[
	output:
	2
	1
	3
	true
]]

print v(1) > v(2) <= v(3)
--[[
	output:
	2
	1
	false
]]
```
<EDisplay>
<pre>
v = (x) ->
	print x
	x

print v(1) < v(2) <= v(3)
--[[
	output:
	2
	1
	3
	true
]]

print v(1) > v(2) <= v(3)
--[[
	output:
	2
	1
	false
]]
</pre>
</EDisplay>

The middle expression is only evaluated once, rather than twice as it would be if the expression were written as `v(1) < v(2) and v(2) <= v(3)`. However, the order of evaluations in a chained comparison is undefined. It is strongly recommended not to use expressions with side effects (such as printing) in chained comparisons. If side effects are required, the short-circuit `and` operator should be used explicitly.

### Table Appending
The **[] =** operator is used to append values to tables.

```moonscript
tab = []
tab[] = "Value"
```
<EDisplay>
<pre>
tab = []
tab[] = "Value"
</pre>
</EDisplay>

### Table Spreading

You can concatenate array tables or hash tables using spread operator `...` before expressions in table literals.

```moonscript
parts =
	* "shoulders"
	* "knees"
lyrics =
	* "head"
	* ...parts
	* "and"
	* "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```
<EDisplay>
<pre>
parts =
	* "shoulders"
	* "knees"
lyrics =
	* "head"
	* ...parts
	* "and"
	* "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
</pre>
</YueDisplay>

### Metatable

The **<>** operator can be used as a shortcut for metatable manipulation.

* **Metatable Creation**
Create normal table with empty bracekets **<>** or metamethod key which is surrounded by **<>**.

```moonscript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- set field with variable of the same name
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "out of scope"
```
<EDisplay>
<pre>
mt = {}
add = (right) => &lt;&gt;: mt, value: @value + right.value
mt.__add = add

a = &lt;&gt;: mt, value: 1
 -- set field with variable of the same name
b = :&lt;add&gt;, value: 2
c = &lt;add&gt;: mt.__add, value: 3

d = a + b + c
print d.value

close _ = &lt;close&gt;: -> print "out of scope"
</pre>
</YueDisplay>

* **Metatable Accessing**
Accessing metatable with **<>** or metamethod name surrounded by **<>** or writing some expression in **<>**.

```moonscript
-- create with metatable containing field "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```
<EDisplay>

<pre>
-- create with metatable containing field "value"
tb = &lt;"value"&gt;: 123
tb.&lt;index&gt; = tb.&lt;&gt;
print tb.value
tb.&lt;&gt; = __index: {item: "hello"}
print tb.item
</pre>
</EDisplay>

* **Metatable Destructure**
Destruct metatable with metamethod key surrounded by **<>**.

```moonscript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```
<EDisplay>
<pre>
{item, :new, :&lt;close&gt;, &lt;index&gt;: getter} = tb
print item, new, close, getter
</pre>
</YueDisplay>

### Existence

The **?** operator can be used in a variety of contexts to check for existence.

```moonscript
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```
<EDisplay>
<pre>
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
</pre>
</YueDisplay>

### Piping

Instead of a series of nested function calls, you can pipe values with operator **|>**.

```moonscript
"hello" |> print
1 |> print 2 -- insert pipe item as the first argument
2 |> print 1, _, 3 -- pipe with a placeholder

-- pipe expression in multiline
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```
<EDisplay>
<pre>
"hello" |> print
1 |> print 2 -- insert pipe item as the first argument
2 |> print 1, _, 3 -- pipe with a placeholder
-- pipe expression in multiline
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
</pre>
</YueDisplay>

### Nil Coalescing

The nil-coalescing operator **??** returns the value of its left-hand operand if it isn't **nil**; otherwise, it evaluates the right-hand operand and returns its result. The **??** operator doesn't evaluate its right-hand operand if the left-hand operand evaluates to non-nil.
```moonscript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```
<EDisplay>
<pre>
local a, b, c, d
a = b ?? c ?? d
func a ?? {}
a ??= false
</pre>
</YueDisplay>

### Implicit Object

You can write a list of implicit structures that starts with the symbol **\*** or **-** inside a table block. If you are creating implicit object, the fields of the object must be with the same indent.

```moonscript
-- assignment with implicit object
list =
  * 1
  * 2
  * 3

-- function call with implicit object
func
  * 1
  * 2
  * 3

-- return with implicit object
f = ->
  return
    * 1
    * 2
    * 3

-- table with implicit object
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }

```
<EDisplay>
<pre>
-- assignment with implicit object
list =
  * 1
  * 2
  * 3

-- function call with implicit object
func
  * 1
  * 2
  * 3

-- return with implicit object
f = ->
  return
    * 1
    * 2
    * 3

-- table with implicit object
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }
</pre>
</EDisplay>

## Module

### Import

The import statement is a syntax sugar for requiring a module or help extracting items from an imported module. The imported items are const by default.

```moonscript
-- used as table destructuring
do
  import insert, concat from table
  -- report error when assigning to insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- shortcut for implicit requiring
  import x, y, z from 'mymodule'
  -- import with Python style
  from 'module' import a, b, c

-- shortcut for requring a module
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requring module with aliasing or table destructuring
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```
<EDisplay>
<pre>
-- used as table destructuring
do
  import insert, concat from table
  -- report error when assigning to insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- shortcut for implicit requiring
  import x, y, z from 'mymodule'
  -- import with Python style
  from 'module' import a, b, c

-- shortcut for requring a module
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requring module with aliasing or table destructuring
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
</pre>
</YueDisplay>

### Export

The export statement offers a concise way to define modules.

* **Named Export**
Named export will define a local variable as well as adding a field in the exported table.

```moonscript
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
<EDisplay>
<pre>
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
</pre>
</YueDisplay>

Doing named export with destructuring.

```moonscript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```
<EDisplay>
<pre>
export :loadstring, to_lua: tolua = e
export {itemA: {:fieldA = 'default'}} = tb
</pre>
</EDisplay>

Export named items from module without creating local variables.

```moonscript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```
<EDisplay>
<pre>
export.itemA = tb
export.&lt;index&gt; = items
export["a-b-c"] = 123
</pre>
</YueDisplay>

* **Unnamed Export**
Unnamed export will add the target item into the array part of the exported table.

```moonscript
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```
<EDisplay>
<pre>
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
</pre>
</YueDisplay>

* **Default Export**
Using the **default** keyword in export statement to replace the exported table with any thing.

```moonscript
export default ->
  print "hello"
  123
```
<EDisplay>
<pre>
export default ->
  print "hello"
  123
</pre>
</EDisplay>

## Assignment

The variable is dynamic typed and is defined as local by default. But you can change the scope of declaration by **local** and **global** statement.

```moonscript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- uses the existing variable
```
<EDisplay>
<pre>
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- uses the existing variable
</pre>
</YueDisplay>

### Perform Update

You can perform update assignment with many binary operators.
```moonscript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- will add a new local if local variable is not exist
arg or= "default value"
```
<EDisplay>
<pre>
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- will add a new local if local variable is not exist
arg or= "default value"
</pre>
</YueDisplay>

### Chaining Assignment

You can do chaining assignment to assign multiple items to hold the same value.
```moonscript
a = b = c = d = e = 0
x = y = z = f!
```
<EDisplay>
<pre>
a = b = c = d = e = 0
x = y = z = f!
</pre>
</YueDisplay>

### Explicit Locals
```moonscript
do
  local a = 1
  local *
  print "forward declare all variables as locals"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "only forward declare upper case variables"
  a = 1
  B = 2
```
<EDisplay>
<pre>
do
  local a = 1
  local *
  print "forward declare all variables as locals"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "only forward declare upper case variables"
  a = 1
  B = 2
</pre>
</YueDisplay>

### Explicit Globals
```moonscript
do
  global a = 1
  global *
  print "declare all variables as globals"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "only declare upper case variables as globals"
  a = 1
  B = 2
  local Temp = "a local value"
```
<EDisplay>
<pre>
do
  global a = 1
  global *
  print "declare all variables as globals"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "only declare upper case variables as globals"
  a = 1
  B = 2
  local Temp = "a local value"
</pre>
</EDisplay>

## Destructuring Assignment

Destructuring assignment is a way to quickly extract values from a table by their name or position in array based tables.

Typically when you see a table literal, {1,2,3}, it is on the right hand side of an assignment because it is a value. Destructuring assignment swaps the role of the table literal, and puts it on the left hand side of an assign statement.

This is best explained with examples. Here is how you would unpack the first two values from a table:

```moonscript
thing = [1, 2]

[a, b] = thing
print a, b
```
<EDisplay>

<pre>
thing = [1, 2]

[a, b] = thing
print a, b
</pre>
</YueDisplay>

In the destructuring table literal, the key represents the key to read from the right hand side, and the value represents the name the read value will be assigned to.

```moonscript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK to do simple destructuring without braces
```
<EDisplay>
<pre>
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK to do simple destructuring without braces
</pre>
</YueDisplay>

This also works with nested data structures as well:

```moonscript
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```
<EDisplay>
<pre>
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second]} = obj2
print first, second, color
</pre>
</YueDisplay>

If the destructuring statement is complicated, feel free to spread it out over a few lines. A slightly more complicated example:

```moonscript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```
<EDisplay>
<pre>
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
</pre>
</YueDisplay>

It's common to extract values from at table and assign them the local variables that have the same name as the key. In order to avoid repetition we can use the **:** prefix operator:

```moonscript
{:concat, :insert} = table
```
<EDisplay>
<pre>
{:concat, :insert} = table
</pre>
</EDisplay>

This is effectively the same as import, but we can rename fields we want to extract by mixing the syntax:

```moonscript
{:mix, :max, random: rand} = math
```
<EDisplay>
<pre>
{:mix, :max, random: rand} = math
</pre>
</EDisplay>

You can write default values while doing destructuring like:

```moonscript
{:name = "nameless", :job = "jobless"} = person
```
<EDisplay>
<pre>
{:name = "nameless", :job = "jobless"} = person
</pre>
</EDisplay>

You can use `_` as placeholder when doing a list destructuring:

```moonscript
[_, two, _, four] = items
```
<EDisplay>
<pre>
[_, two, _, four] = items
</pre>
</EDisplay>

### Destructuring In Other Places

Destructuring can also show up in places where an assignment implicitly takes place. An example of this is a for loop:

```moonscript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```
<EDisplay>
<pre>
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
</pre>
</YueDisplay>

We know each element in the array table is a two item tuple, so we can unpack it directly in the names clause of the for statement using a destructure.

## If Assignment

`if` and `elseif` blocks can take an assignment in place of a conditional expression. Upon evaluating the conditional, the assignment will take place and the value that was assigned to will be used as the conditional expression. The assigned variable is only in scope for the body of the conditional, meaning it is never available if the value is not truthy. And you have to use "the walrus operator" `:=` instead of `=` to do assignment.

```moonscript
if user := database.find_user "moon"
  print user.name
```
<EDisplay>
<pre>
if user := database.find_user "moon"
  print user.name
</pre>
</YueDisplay>

```moonscript
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```
<EDisplay>
<pre>
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
</pre>
</YueDisplay>

If assignment with multiple return values. Only the first value is getting checked, other values are scoped.
```moonscript
if success, result := pcall -> "get result without problems"
  print result -- variable result is scoped
print "OK"
```
<EDisplay>
<pre>
if success, result := pcall -> "get result without problems"
  print result -- variable result is scoped
print "OK"
</pre>
</YueDisplay>

### While Assignment

You can also use if assignment in a while loop to get the value as the loop condition.
```moonscript
while byte := stream\read_one!
  -- do something with the byte
  print byte
```
<EDisplay>
<pre>
while byte := stream\read_one!
  -- do something with the byte
  print byte
</pre>
</YueDisplay>

## Varargs Assignment

You can assign the results returned from a function  to a varargs symbol `...`. And then access its content using the Lua way.
```moonscript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```
<EDisplay>
<pre>
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
</pre>
</YueDisplay>

## Whitespace

E is a whitespace significant language. You have to write some code block in the same indent with space **' '** or tab **'\t'** like function body, value list and some control blocks. And expressions containing different whitespaces might mean different things. Tab is treated like 4 space, but it's better not mix the use of spaces and tabs.

### Multiline Chaining

You can write multi-line chaining function calls with a same indent.
```moonscript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```
<EDisplay>
<pre>
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
</pre>
</YueDisplay>

## Comment

```moonscript
-- I am a comment

str = --[[
This is a multi-line comment.
It's OK.
]] strA \ -- comment 1
  .. strB \ -- comment 2
  .. strC

func --[[port]] 3000, --[[ip]] "192.168.1.1"
```
<EDisplay>
<pre>
-- I am a comment

str = --[[
This is a multi-line comment.
It's OK.
]] strA \ -- comment 1
  .. strB \ -- comment 2
  .. strC

func --[[port]] 3000, --[[ip]] "192.168.1.1"
</pre>
</YueDisplay>

## Try

The syntax for Lua error handling in a common form.

```moonscript
try
  func 1, 2, 3
catch err
  print e.traceback err

success, result = try
  func 1, 2, 3
catch err
  e.traceback err

try func 1, 2, 3
catch err
  print e.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- working with if assignment pattern
if success, result := try func 1, 2, 3
catch err
    print e.traceback err
  print result
```
<EDisplay>
<pre>
try
  func 1, 2, 3
catch err
  print e.traceback err

success, result = try
  func 1, 2, 3
catch err
  e.traceback err

try func 1, 2, 3
catch err
  print e.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- working with if assignment pattern
if success, result := try func 1, 2, 3
catch err
    print e.traceback err
  print result
</pre>
</EDisplay>

### Try?

`try?` is a simplified use for error handling syntax that omit the boolean status from the `try` statement, and it will return the result from the try block when success, return nil instead of error object otherwise.

```moonscript
a, b, c = try? func!

-- with nil coalescing operator
a = (try? func!) ?? "default"

-- as function argument
f try? func!

-- with catch block
f try?
  print 123
  func!
catch e
  print e
  e
```
<EDisplay>
<pre>
a, b, c = try? func!

-- with nil coalescing operator
a = (try? func!) ?? "default"

-- as function argument
f try? func!

-- with catch block
f try?
  print 123
  func!
catch e
  print e
  e
</pre>
</YueDisplay>

## Attributes

Syntax support for Lua 5.4 attributes. And you can still use both the `const` and `close` declaration and get constant check and scoped callback working when targeting Lua versions below 5.4.

```moonscript
const a = 123
close _ = <close>: -> print "Out of scope."
```
<EDisplay>
<pre>
const a = 123
close _ = &lt;close&gt;: -> print "Out of scope."
</pre>
</EDisplay>

You can do desctructuring with variables attributed as constant.

```moonscript
const {:a, :b, c, d} = tb
-- a = 1
```
<EDisplay>
<pre>
const {:a, :b, c, d} = tb
-- a = 1
</pre>
</EDisplay>

You can also declare a global variable to be `const`.

```moonscript
global const Constant = 123
-- Constant = 1
```
<EDisplay>
<pre>
global const Constant = 123
-- Constant = 1
</pre>
</EDisplay>

## Literals

All of the primitive literals in Lua can be used. This applies to numbers, strings, booleans, and **nil**.

Unlike Lua, Line breaks are allowed inside of single and double quote strings without an escape sequence:

```moonscript
some_string = "Here is a string
  that has a line break in it."

-- You can mix expressions into string literals using #{} syntax.
-- String interpolation is only available in double quoted strings.
print "I am #{math.random! * 100}% sure."
```
<EDisplay>
<pre>
some_string = "Here is a string
  that has a line break in it."

-- You can mix expressions into string literals using #{} syntax.
-- String interpolation is only available in double quoted strings.
print "I am #{math.random! * 100}% sure."
</pre>
</EDisplay>

### Number Literals

You can use underscores in a number literal to increase readability.

```moonscript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```
<EDisplay>

<pre>
integer = 1_000_000
hex = 0xEF_BB_BF
</pre>
</EDisplay>

## Function Literals

All functions are created using a function expression. A simple function is denoted using the arrow: **->**.

```moonscript
my_function = ->
my_function() -- call the empty function
```
<EDisplay>
<pre>
my_function = ->
my_function() -- call the empty function
</pre>
</YueDisplay>

The body of the function can either be one statement placed directly after the arrow, or it can be a series of statements indented on the following lines:

```moonscript
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```
<EDisplay>
<pre>
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
</pre>
</YueDisplay>

If a function has no arguments, it can be called using the ! operator, instead of empty parentheses. The ! invocation is the preferred way to call functions with no arguments.

```moonscript
func_a!
func_b()
```
<EDisplay>
<pre>
func_a!
func_b()
</pre>
</YueDisplay>

Functions with arguments can be created by preceding the arrow with a list of argument names in parentheses:

```moonscript
sum = (x, y) -> print "sum", x + y
```
<EDisplay>
<pre>
sum = (x, y) -> print "sum", x + y
</pre>
</EDisplay>

Functions can be called by listing the arguments after the name of an expression that evaluates to a function. When chaining together function calls, the arguments are applied to the closest function to the left.

```moonscript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```
<EDisplay>
<pre>
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
</pre>
</EDisplay>

In order to avoid ambiguity in when calling functions, parentheses can also be used to surround the arguments. This is required here in order to make sure the right arguments get sent to the right functions.

```moonscript
print "x:", sum(10, 20), "y:", sum(30, 40)
```
<EDisplay>
<pre>
print "x:", sum(10, 20), "y:", sum(30, 40)
</pre>
</EDisplay>

There must not be any space between the opening parenthesis and the function.

Functions will coerce the last statement in their body into a return statement, this is called implicit return:

```moonscript
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```
<EDisplay>
<pre>
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
</pre>
</YueDisplay>

And if you need to explicitly return, you can use the return keyword:

```moonscript
sum = (x, y) -> return x + y
```
<EDisplay>
<pre>
sum = (x, y) -> return x + y
</pre>
</EDisplay>

Just like in Lua, functions can return multiple values. The last statement must be a list of values separated by commas:

```moonscript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```
<EDisplay>
<pre>
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
</pre>
</YueDisplay>

### Fat Arrows

Because it is an idiom in Lua to send an object as the first argument when calling a method, a special syntax is provided for creating functions which automatically includes a self argument.

```moonscript
func = (num) => @value + num
```
<EDisplay>
<pre>
func = (num) => @value + num
</pre>
</EDisplay>

### Argument Defaults

It is possible to provide default values for the arguments of a function. An argument is determined to be empty if its value is nil. Any nil arguments that have a default value will be replace before the body of the function is run.

```moonscript
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```
<EDisplay>
<pre>
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
</pre>
</YueDisplay>

An argument default value expression is evaluated in the body of the function in the order of the argument declarations. For this reason default values have access to previously declared arguments.

```moonscript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```
<EDisplay>
<pre>
some_args = (x = 100, y = x + 1000) ->
  print x + y
</pre>
</YueDisplay>

### Considerations

Because of the expressive parentheses-less way of calling functions, some restrictions must be put in place to avoid parsing ambiguity involving whitespace.

The minus sign plays two roles, a unary negation operator and a binary subtraction operator. Consider how the following examples compile:

```moonscript
a = x - 10
b = x-10
c = x -y
d = x- z
```
<EDisplay>
<pre>
a = x - 10
b = x-10
c = x -y
d = x- z
</pre>
</YueDisplay>

The precedence of the first argument of a function call can be controlled using whitespace if the argument is a literal string. In Lua, it is common to leave off parentheses when calling a function with a single string or table literal.

When there is no space between a variable and a string literal, the function call takes precedence over any following expressions. No other arguments can be passed to the function when it is called this way.

Where there is a space following a variable and a string literal, the function call acts as show above. The string literal belongs to any following expressions (if they exist), which serves as the argument list.

```moonscript
x = func"hello" + 100
y = func "hello" + 100
```
<EDisplay>
<pre>
x = func"hello" + 100
y = func "hello" + 100
</pre>
</YueDisplay>

### Multi-line arguments

When calling functions that take a large number of arguments, it is convenient to split the argument list over multiple lines. Because of the white-space sensitive nature of the language, care must be taken when splitting up the argument list.

If an argument list is to be continued onto the next line, the current line must end in a comma. And the following line must be indented more than the current indentation. Once indented, all other argument lines must be at the same level of indentation to be part of the argument list

```moonscript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```
<EDisplay>
<pre>
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
</pre>
</YueDisplay>

This type of invocation can be nested. The level of indentation is used to determine to which function the arguments belong to.

```moonscript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```
<YueDisplay>
<pre>
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
</pre>
</YueDisplay>

Because tables also use the comma as a delimiter, this indentation syntax is helpful for letting values be part of the argument list instead of being part of the table.

```moonscript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```
<EDisplay>
<pre>
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
</pre>
</YueDisplay>

Although uncommon, notice how we can give a deeper indentation for function arguments if we know we will be using a lower indentation further on.

```moonscript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```
<EDisplay>
<pre>
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
</pre>
</YueDisplay>

The same thing can be done with other block level statements like conditionals. We can use indentation level to determine what statement a value belongs to:

```moonscript
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
```
<EDisplay>
<pre>
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
</pre>
</EDisplay>

## Backcalls

Backcalls are used for unnesting callbacks. They are defined using arrows pointed to the left as the last parameter by default filling in a function call. All the syntax is mostly the same as regular arrow functions except that it is just pointing the other way and the function body does not require indent.

```moonscript
<- f
print "hello"
```
<EDisplay>
<pre>
<- f
print "hello"
</pre>
</YueDisplay>

Fat arrow functions are also available.

```moonscript
<= f
print @value
```
<EDisplay>
<pre>
<= f
print @value
</pre>
</YueDisplay>

You can specify a placeholder for where you want the backcall function to go as a parameter.

```moonscript
(x) <- map _, [1, 2, 3]
x * 2
```
<EDisplay>
<pre>
(x) <- map _, [1, 2, 3]
x * 2
</pre>
</YueDisplay>

If you wish to have further code after your backcalls, you can set them aside with a do statement. And the parentheses can be omitted with non-fat arrow functions.

```moonscript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```
<EDisplay>
<pre>
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
</pre>
</YueDisplay>

## Table Literals

Like in Lua, tables are delimited in curly braces.

```moonscript
some_values = [1, 2, 3, 4]
```
<EDisplay>
<pre>
some_values = [1, 2, 3, 4]
</pre>
</EDisplay>

Unlike Lua, assigning a value to a key in a table is done with **:** (instead of **=**).

```moonscript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```
<EDisplay>
<pre>
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
</pre>
</EDisplay>

The curly braces can be left off if a single table of key value pairs is being assigned.

```moonscript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```
<EDisplay>
<pre>
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
</pre>
</EDisplay>

Newlines can be used to delimit values instead of a comma (or both):

```moonscript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```
<EDisplay>
<pre>
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
</pre>
</EDisplay>

When creating a single line table literal, the curly braces can also be left off:

```moonscript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```
<EDisplay>
<pre>
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
</pre>
</EDisplay>

The keys of a table literal can be language keywords without being escaped:

```moonscript
tbl = {
  do: "something"
  end: "hunger"
}
```
<EDisplay>
<pre>
tbl = {
  do: "something"
  end: "hunger"
}
</pre>
</EDisplay>

If you are constructing a table out of variables and wish the keys to be the same as the variable names, then the **:** prefix operator can be used:

```moonscript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```
<EDisplay>
<pre>
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
</pre>
</EDisplay>

If you want the key of a field in the table to to be result of an expression, then you can wrap it in **[ ]**, just like in Lua. You can also use a string literal directly as a key, leaving out the square brackets. This is useful if your key has any special characters.

```moonscript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```
<EDisplay>
<pre>
t = {
  [1 + 2]: "hello"
  "hello world": true
}
</pre>
</EDisplay>

Lua tables have both an array part and a hash part, but sometimes you want to make a semantic distinction between array and hash usage when writing Lua tables. Then you can write Lua table with **[ ]** instead of **{ }** to represent an array table and writing any key value pair in a list table won't be allowed.

```moonscript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```
<EDisplay>
<pre>
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
</pre>
</EDisplay>

## Comprehensions

Comprehensions provide a convenient syntax for constructing a new table by iterating over some existing object and applying an expression to its values. There are two kinds of comprehensions: list comprehensions and table comprehensions. They both produce Lua tables; list comprehensions accumulate values into an array-like table, and table comprehensions let you set both the key and the value on each iteration.

### List Comprehensions

The following creates a copy of the items table but with all the values doubled.

```moonscript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```
<EDisplay>
<pre>
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
</pre>
</YueDisplay>

The items included in the new table can be restricted with a when clause:

```moonscript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```
<EDisplay>
<pre>
slice = [item for i, item in ipairs items when i > 1 and i < 3]
</pre>
</EDisplay>

Because it is common to iterate over the values of a numerically indexed table, an **\*** operator is introduced. The doubled example can be rewritten as:

```moonscript
doubled = [item * 2 for item in *items]
```
<EDisplay>
<pre>
doubled = [item * 2 for item in *items]
</pre>
</EDisplay>

The for and when clauses can be chained as much as desired. The only requirement is that a comprehension has at least one for clause.

Using multiple for clauses is the same as using nested loops:

```moonscript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```
<EDisplay>
<pre>
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
</pre>
</YueDisplay>

Numeric for loops can also be used in comprehensions:

```moonscript
evens = [i for i = 1, 100 when i % 2 == 0]
```
<EDisplay>
<pre>
evens = [i for i = 1, 100 when i % 2 == 0]
</pre>
</EDisplay>

### Table Comprehensions

The syntax for table comprehensions is very similar, only differing by using **{** and **}** and taking two values from each iteration.

This example makes a copy of the tablething:

```moonscript
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```
<EDisplay>
<pre>
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
</pre>
</YueDisplay>

```moonscript
no_color = {k, v for k, v in pairs thing when k != "color"}
```
<EDisplay>
<pre>
no_color = {k, v for k, v in pairs thing when k != "color"}
</pre>
</EDisplay>

The **\*** operator is also supported. Here we create a square root look up table for a few numbers.

```moonscript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```
<EDisplay>
<pre>
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
</pre>
</EDisplay>

The key-value tuple in a table comprehension can also come from a single expression, in which case the expression should return two values. The first is used as the key and the second is used as the value:

In this example we convert an array of pairs to a table where the first item in the pair is the key and the second is the value.

```moonscript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```
<EDisplay>
<pre>
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
</pre>
</YueDisplay>

### Slicing

A special syntax is provided to restrict the items that are iterated over when using the **\*** operator. This is equivalent to setting the iteration bounds and a step size in a for loop.

Here we can set the minimum and maximum bounds, taking all items with indexes between 1 and 5 inclusive:

```moonscript
slice = [item for item in *items[1, 5]]
```
<EDisplay>
<pre>
slice = [item for item in *items[1, 5]]
</pre>
</EDisplay>

Any of the slice arguments can be left off to use a sensible default. In this example, if the max index is left off it defaults to the length of the table. This will take everything but the first element:

```moonscript
slice = [item for item in *items[2,]]
```
<EDisplay>
<pre>
slice = [item for item in *items[2,]]
</pre>
</EDisplay>

If the minimum bound is left out, it defaults to 1. Here we only provide a step size and leave the other bounds blank. This takes all odd indexed items: (1, 3, 5, …)

```moonscript
slice = [item for item in *items[,,2]]
```
<EDisplay>
<pre>
slice = [item for item in *items[,,2]]
</pre>
</EDisplay>

## For Loop

There are two for loop forms, just like in Lua. A numeric one and a generic one:

```moonscript
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
```
<EDisplay>
<pre>
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
</pre>
</YueDisplay>

The slicing and **\*** operators can be used, just like with comprehensions:

```moonscript
for item in *items[2, 4]
  print item
```
<EDisplay>
<pre>
for item in *items[2, 4]
  print item
</pre>
</YueDisplay>

A shorter syntax is also available for all variations when the body is only a single line:

```moonscript
for item in *items do print item

for j = 1, 10, 3 do print j
```
<EDisplay>
<pre>
for item in *items do print item

for j = 1, 10, 3 do print j
</pre>
</YueDisplay>

A for loop can also be used as an expression. The last statement in the body of the for loop is coerced into an expression and appended to an accumulating array table.

Doubling every even number:

```moonscript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```
<EDisplay>
<pre>
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
</pre>
</YueDisplay>

In addition, for loops support break with a return value, allowing the loop itself to be used as an expression that exits early with a meaningful result.

For example, to find the first number greater than 10:

```moonscript
first_large = for n in *numbers
  break n if n > 10
```
<EDisplay>
<pre>
first_large = for n in *numbers
  break n if n > 10
</pre>
</YueDisplay>

This break-with-value syntax enables concise and expressive search or early-exit patterns directly within loop expressions.

You can also filter values by combining the for loop expression with the continue statement.

For loops at the end of a function body are not accumulated into a table for a return value (Instead the function will return nil). Either an explicit return statement can be used, or the loop can be converted into a list comprehension.

```moonscript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
```
<EDisplay>
<pre>
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
</pre>
</YueDisplay>

This is done to avoid the needless creation of tables for functions that don't need to return the results of the loop.

## Repeat Loop

The repeat loop comes from Lua:

```moonscript
i = 10
repeat
  print i
  i -= 1
until i == 0
```
<EDisplay>
<pre>
i = 10
repeat
  print i
  i -= 1
until i == 0
</pre>
</YueDisplay>

## While Loop

The while loop also comes in four variations:

```moonscript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```
<EDisplay>
<pre>
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
</pre>
</YueDisplay>

```moonscript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```
<EDisplay>
<pre>
i = 10
until i == 0
  print i
  i -= 1
until running == false do my_function!
</pre>
</YueDisplay>

Like for loops, the while loop can also be used an expression. Additionally, for a function to return the accumulated value of a while loop, the statement must be explicitly returned.

## Continue

A continue statement can be used to skip the current iteration in a loop.

```moonscript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```
<EDisplay>
<pre>
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
</pre>
</YueDisplay>

continue can also be used with loop expressions to prevent that iteration from accumulating into the result. This examples filters the array table into just even numbers:

```moonscript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```
<EDisplay>
<pre>
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
</pre>
</EDisplay>

## Conditionals

```moonscript
have_coins = false
if have_coins
  print "Got coins"
else
  print "No coins"
```
<EDisplay>
<pre>
have_coins = false
if have_coins
  print "Got coins"
else
  print "No coins"
</pre>
</YueDisplay>

A short syntax for single statements can also be used:

```moonscript
have_coins = false
if have_coins then print "Got coins" else print "No coins"
```
<EDisplay>
<pre>
have_coins = false
if have_coins then print "Got coins" else print "No coins"
</pre>
</YueDisplay>

Because if statements can be used as expressions, this can also be written as:

```moonscript
have_coins = false
print if have_coins then "Got coins" else "No coins"
```
<EDisplay>
<pre>
have_coins = false
print if have_coins then "Got coins" else "No coins"
</pre>
</YueDisplay>

Conditionals can also be used in return statements and assignments:

```moonscript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "I am very tall"
else
  "I am not so tall"

print message -- prints: I am very tall
```
<EDisplay>
<pre>
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "I am very tall"
else
  "I am not so tall"

print message -- prints: I am very tall
</pre>
</YueDisplay>

The opposite of if is unless:

```moonscript
unless os.date("%A") == "Monday"
  print "it is not Monday!"
```
<EDisplay>
<pre>
unless os.date("%A") == "Monday"
  print "it is not Monday!"
</pre>
</YueDisplay>

```moonscript
print "You're lucky!" unless math.random! > 0.1
```
<EDisplay>
<pre>
print "You're lucky!" unless math.random! > 0.1
</pre>
</EDisplay>

### In Expression

You can write range checking code with an `in-expression`.

```moonscript
a = 5

if a in [1, 3, 5, 7]
  print "checking equality with discrete values"

if a in list
  print "checking if `a` is in a list"
```
<EDisplay>
<pre>
a = 5

if a in [1, 3, 5, 7]
  print "checking equality with discrete values"

if a in list
  print "checking if `a` is in a list"
</pre>
</YueDisplay>

```moonscript
print "You're lucky!" unless math.random! > 0.1
```
<EDisplay>
<pre>
print "You're lucky!" unless math.random! > 0.1
</pre>
</EDisplay>

## Line Decorators

For convenience, the for loop and if statement can be applied to single statements at the end of the line:

```moonscript
print "hello world" if name == "Rob"
```
<EDisplay>
<pre>
print "hello world" if name == "Rob"
</pre>
</EDisplay>

And with basic loops:

```moonscript
print "item: ", item for item in *items
```
<EDisplay>
<pre>
print "item: ", item for item in *items
</pre>
</EDisplay>

And with while loops:

```moonscript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```
<EDisplay>
<pre>
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
</pre>
</EDisplay>

## Switch

The switch statement is shorthand for writing a series of if statements that check against the same value. Note that the value is only evaluated once. Like if statements, switches can have an else block to handle no matches. Comparison is done with the == operator. In switch statement, you can also use assignment expression to store temporary variable value.

```moonscript
switch name := "Dan"
  when "Robert"
    print "You are Robert"
  when "Dan", "Daniel"
    print "Your name, it's Dan"
  else
    print "I don't know about you with name #{name}"
```
<EDisplay>
<pre>
switch name := "Dan"
  when "Robert"
    print "You are Robert"
  when "Dan", "Daniel"
    print "Your name, it's Dan"
  else
    print "I don't know about you with name #{name}"
</pre>
</YueDisplay>

A switch when clause can match against multiple values by listing them out comma separated.

Switches can be used as expressions as well, here we can assign the result of the switch to a variable:

```moonscript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "can't count that high!"
```
<EDisplay>
<pre>
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "can't count that high!"
</pre>
</YueDisplay>

We can use the then keyword to write a switch's when block on a single line. No extra keyword is needed to write the else block on a single line.

```moonscript
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
```
<EDisplay>
<pre>
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
</pre>
</YueDisplay>

If you want to write code with one less indent when writing a switch statement, you can put the first when clause on the statement start line, and then all other clauses can be written with one less indent.

```moonscript
switch math.random(1, 5)
  when 1
    print "you are lucky" -- two indents
  else
    print "not so lucky"

switch math.random(1, 5) when 1
  print "you are lucky" -- one indent
else
  print "not so lucky"
```
<EDisplay>
<pre>
switch math.random(1, 5)
  when 1
    print "you are lucky" -- two indents
  else
    print "not so lucky"

switch math.random(1, 5) when 1
  print "you are lucky" -- one indent
else
  print "not so lucky"
</pre>
</YueDisplay>

It is worth noting the order of the case comparison expression. The case's expression is on the left hand side. This can be useful if the case's expression wants to overwrite how the comparison is done by defining an eq metamethod.

### Table Matching

You can do table matching in a switch when clause, if the table can be destructured by a specific structure and get non-nil values.

```moonscript
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "size #{width}, #{height}"
```
<YueDisplay>
<pre>
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "size #{width}, #{height}"
</pre>
</YueDisplay>

You can use default values to optionally destructure the table for some fields.

```moonscript
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
```
<YueDisplay>
<pre>
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
</pre>
</YueDisplay>

You can also match against array elements, table fields, and even nested structures with array or table literals.

Match against array elements.

```moonscript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b has a default value
    print "1, 2, #{b}"
```
<YueDisplay>
<pre>
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b has a default value
    print "1, 2, #{b}"
</pre>
</YueDisplay>

Match against table fields with destructuring.

```moonscript
switch tb
  when success: true, :result
    print "success", result
  when success: false
    print "failed", result
  else
    print "invalid"
```
<YueDisplay>
<pre>
switch tb
  when success: true, :result
    print "success", result
  when success: false
    print "failed", result
  else
    print "invalid"
</pre>
</YueDisplay>

Match against nested table structures.

```moonscript
switch tb
  when data: {type: "success", :content}
    print "success", content
  when data: {type: "error", :content}
    print "failed", content
  else
    print "invalid"
```
<YueDisplay>
<pre>
switch tb
  when data: {type: "success", :content}
    print "success", content
  when data: {type: "error", :content}
    print "failed", content
  else
    print "invalid"
</pre>
</YueDisplay>

Match against array of tables.

```moonscript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "matched", fourth
```
<YueDisplay>
<pre>
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "matched", fourth
</pre>
</YueDisplay>

## Object Oriented Programming

In these examples, the generated Lua code may appear overwhelming. It is best to focus on the meaning of the E code at first, then look into the Lua code if you wish to know the implementation details.

A simple class:

```moonscript
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```
<EDisplay>
<pre>
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
</pre>
</YueDisplay>

A class is declared with a class statement followed by a table-like declaration where all of the methods and properties are listed.

The new property is special in that it will become the constructor.

Notice how all the methods in the class use the fat arrow function syntax. When calling methods on a instance, the instance itself is sent in as the first argument. The fat arrow handles the creation of a self argument.

The @ prefix on a variable name is shorthand for self.. @items becomes self.items.

Creating an instance of the class is done by calling the name of the class as a function.

```moonscript
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```
<EDisplay>
<pre>
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
</pre>
</YueDisplay>

Because the instance of the class needs to be sent to the methods when they are called, the \ operator is used.

All properties of a class are shared among the instances. This is fine for functions, but for other types of objects, undesired results may occur.

Consider the example below, the clothes property is shared amongst all instances, so modifications to it in one instance will show up in another:

```moonscript
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "pants"
b\give_item "shirt"

-- will print both pants and shirt
print item for item in *a.clothes
```
<EDisplay>
<pre>
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "pants"
b\give_item "shirt"

-- will print both pants and shirt
print item for item in *a.clothes
</pre>
</YueDisplay>

The proper way to avoid this problem is to create the mutable state of the object in the constructor:

```moonscript
class Person
  new: =>
    @clothes = []
```
<EDisplay>
<pre>
class Person
  new: =>
    @clothes = []
</pre>
</YueDisplay>

### Inheritance

The extends keyword can be used in a class declaration to inherit the properties and methods from another class.

```moonscript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```
<EDisplay>
<pre>
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
</pre>
</YueDisplay>

Here we extend our Inventory class, and limit the amount of items it can carry.

In this example, we don't define a constructor on the subclass, so the parent class' constructor is called when we make a new instance. If we did define a constructor then we can use the super method to call the parent constructor.

Whenever a class inherits from another, it sends a message to the parent class by calling the method __inherited on the parent class if it exists. The function receives two arguments, the class that is being inherited and the child class.

```moonscript
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- will print: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```
<EDisplay>
<pre>
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- will print: Shelf was inherited by Cupboard
class Cupboard extends Shelf
</pre>
</YueDisplay>

### Super

**super** is a special keyword that can be used in two different ways: It can be treated as an object, or it can be called like a function. It only has special functionality when inside a class.

When called as a function, it will call the function of the same name in the parent class. The current self will automatically be passed as the first argument. (As seen in the inheritance example above)

When super is used as a normal value, it is a reference to the parent class object.

It can be accessed like any of object in order to retrieve values in the parent class that might have been shadowed by the child class.

When the \ calling operator is used with super, self is inserted as the first argument instead of the value of super itself. When using . to retrieve a function, the raw function is returned.

A few examples of using super in different ways:

```moonscript
class MyClass extends ParentClass
  a_method: =>
    -- the following have the same effect:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super as a value is equal to the parent class:
    assert super == ParentClass
```
<EDisplay>
<pre>
class MyClass extends ParentClass
  a_method: =>
    -- the following have the same effect:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super as a value is equal to the parent class:
    assert super == ParentClass
</pre>
</YueDisplay>

**super** can also be used on left side of a Function Stub. The only major difference is that instead of the resulting function being bound to the value of super, it is bound to self.

### Types

Every instance of a class carries its type with it. This is stored in the special __class property. This property holds the class object. The class object is what we call to build a new instance. We can also index the class object to retrieve class methods and properties.

```moonscript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- prints 10
```
<EDisplay>
<pre>
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- prints 10
</pre>
</YueDisplay>

### Class Objects

The class object is what we create when we use a class statement. The class object is stored in a variable of the same name of the class.

The class object can be called like a function in order to create new instances. That's how we created instances of classes in the examples above.

A class is made up of two tables. The class table itself, and the base table. The base is used as the metatable for all the instances. All properties listed in the class declaration are placed in the base.

The class object's metatable reads properties from the base if they don't exist in the class object. This means we can access functions and properties directly from the class.

It is important to note that assigning to the class object does not assign into the base, so it's not a valid way to add new methods to instances. Instead the base must explicitly be changed. See the __base field below.

The class object has a couple special properties:

The name of the class as when it was declared is stored as a string in the __name field of the class object.

```moonscript
print BackPack.__name -- prints Backpack
```
<EDisplay>
<pre>
print BackPack.__name -- prints Backpack
</pre>
</EDisplay>

The base object is stored in __base. We can modify this table to add functionality to instances that have already been created and ones that are yet to be created.

If the class extends from anything, the parent class object is stored in __parent.

### Class Variables

We can create variables directly in the class object instead of in the base by using @ in the front of the property name in a class declaration.

```moonscript
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- class variables not visible in instances
assert Things().some_func == nil
```
<EDisplay>
<pre>
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- class variables not visible in instances
assert Things().some_func == nil
</pre>
</YueDisplay>

In expressions, we can use @@ to access a value that is stored in the __class of self. Thus, @@hello is shorthand for self.__class.hello.

```moonscript
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- prints 2
```
<EDisplay>
<pre>
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- prints 2
</pre>
</YueDisplay>

The calling semantics of @@ are similar to @. Calling a @@ name will pass the class in as the first argument using Lua's colon syntax.

```moonscript
@@hello 1,2,3,4
```
<EDisplay>
<pre>
@@hello 1,2,3,4
</pre>
</EDisplay>

### Class Declaration Statements

In the body of a class declaration, we can have normal expressions in addition to key/value pairs. In this context, self is equal to the class object.

Here is an alternative way to create a class variable compared to what's described above:

```moonscript
class Things
  @class_var = "hello world"
```
<EDisplay>
<pre>
class Things
  @class_var = "hello world"
</pre>
</YueDisplay>

These expressions are executed after all the properties have been added to the base.

All variables declared in the body of the class are local to the classes properties. This is convenient for placing private values or helper functions that only the class methods can access:

```moonscript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```
<EDisplay>
<pre>
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
</pre>
</YueDisplay>

### @ and @@ Values

When @ and @@ are prefixed in front of a name they represent, respectively, that name accessed in self and self.__class.

If they are used all by themselves, they are aliases for self and self.__class.

```moonscript
assert @ == self
assert @@ == self.__class
```
<EDisplay>
<pre>
assert @ == self
assert @@ == self.__class
</pre>
</YueDisplay>

For example, a quick way to create a new instance of the same class from an instance method using @@:

```moonscript
some_instance_method = (...) => @@ ...
```
<EDisplay>
<pre>
some_instance_method = (...) => @@ ...
</pre>
</EDisplay>

### Constructor Property Promotion

To reduce the boilerplate code for definition of simple value objects. You can write a simple class like:

```moonscript
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- Which is short for

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```
<EDisplay>
<pre>
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- Which is short for

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
</pre>
</YueDisplay>

You can also use this syntax for a common function to initialize a object's fields.

```moonscript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```
<EDisplay>
<pre>
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
</pre>
</YueDisplay>

### Class Expressions

The class syntax can also be used as an expression which can be assigned to a variable or explicitly returned.

```moonscript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```
<EDisplay>
<pre>
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
</pre>
</YueDisplay>

### Anonymous classes

The name can be left out when declaring a class. The __name attribute will be nil, unless the class expression is in an assignment. The name on the left hand side of the assignment is used instead of nil.

```moonscript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```
<EDisplay>
<pre>
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
</pre>
</YueDisplay>

You can even leave off the body, meaning you can write a blank anonymous class like this:

```moonscript
x = class
```
<EDisplay>
<pre>
x = class
</pre>
</EDisplay>

### Class Mixing

You can do mixing with keyword `using` to copy functions from either a plain table or a predefined class object into your new class. When doing mixing with a plain table, you can override the class indexing function (metamethod `__index`) to your customized implementation. When doing mixing with an existing class object, the class object's metamethods won't be copied.

```moonscript
MyIndex = __index: var: 1

class X using MyIndex
  func: =>
    print 123

x = X!
print x.var

class Y using X

y = Y!
y\func!

assert y.__class.__parent ~= X -- X is not parent of Y
```
<EDisplay>
<pre>
MyIndex = __index: var: 1

class X using MyIndex
  func: =>
    print 123

x = X!
print x.var

class Y using X

y = Y!
y\func!

assert y.__class.__parent ~= X -- X is not parent of Y
</pre>
</YueDisplay>

## With Statement

A common pattern involving the creation of an object is calling a series of functions and setting a series of properties immediately after creating it.

This results in repeating the name of the object multiple times in code, adding unnecessary noise. A common solution to this is to pass a table in as an argument which contains a collection of keys and values to overwrite. The downside to this is that the constructor of this object must support this form.

The with block helps to alleviate this. Within a with block we can use a special statements that begin with either . or \ which represent those operations applied to the object we are using with on.

For example, we work with a newly created object:

```moonscript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```
<EDisplay>
<pre>
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
</pre>
</YueDisplay>

The with statement can also be used as an expression which returns the value it has been giving access to.

```moonscript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```
<EDisplay>
<pre>
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
</pre>
</YueDisplay>

Or…

```moonscript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```
<EDisplay>
<pre>
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
</pre>
</YueDisplay>

In this usage, with can be seen as a special form of the K combinator.

The expression in the with statement can also be an assignment, if you want to give a name to the expression.

```moonscript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```
<EDisplay>
<pre>
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
</pre>
</YueDisplay>

You can access special keys with `[]` in a `with` statement.

```moonscript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- appending to "tb"
```
<EDisplay>
<pre>
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- appending to "tb"
</pre>
</YueDisplay>

`with?` is an enhanced version of `with` syntax, which introduces an existential check to safely access objects that may be nil without explicit null checks.

```moonscript
with? obj
  print obj.name
```
<EDisplay>
<pre>
with? obj
  print obj.name
</pre>
</YueDisplay>

## Do

When used as a statement, do works just like it does in Lua.

```moonscript
do
  var = "hello"
  print var
print var -- nil here
```
<EDisplay>
<pre>
do
  var = "hello"
  print var
print var -- nil here
</pre>
</YueDisplay>

E's **do** can also be used an expression . Allowing you to combine multiple lines into one. The result of the do expression is the last statement in its body.

```moonscript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```
<EDisplay>
<pre>
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
</pre>
</YueDisplay>

```moonscript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```
<EDisplay>
<pre>
tbl = {
  key: do
    print "assigning key!"
    1234
}
</pre>
</YueDisplay>

## Function Stubs

It is common to pass a function from an object around as a value, for example, passing an instance method into a function as a callback. If the function expects the object it is operating on as the first argument then you must somehow bundle that object with the function so it can be called properly.

The function stub syntax is a shorthand for creating a new closure function that bundles both the object and function. This new function calls the wrapped function in the correct context of the object.

Its syntax is the same as calling an instance method with the \ operator but with no argument list provided.

```moonscript
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- this will not work:
-- the function has to no reference to my_object
run_callback my_object.write

-- function stub syntax
-- lets us bundle the object into a new function
run_callback my_object\write
```
<EDisplay>
<pre>
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- this will not work:
-- the function has to no reference to my_object
run_callback my_object.write

-- function stub syntax
-- lets us bundle the object into a new function
run_callback my_object\write
</pre>
</YueDisplay>

## The Using Clause; Controlling Destructive Assignment

While lexical scoping can be a great help in reducing the complexity of the code we write, things can get unwieldy as the code size increases. Consider the following snippet:

```moonscript
i = 100

-- many lines of code...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- will print 0
```
<EDisplay>
<pre>
i = 100

-- many lines of code...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- will print 0
</pre>
</YueDisplay>

In my_func, we've overwritten the value of i mistakenly. In this example it is quite obvious, but consider a large, or foreign code base where it isn't clear what names have already been declared.

It would be helpful to say which variables from the enclosing scope we intend on change, in order to prevent us from changing others by accident.

The using keyword lets us do that. using nil makes sure that no closed variables are overwritten in assignment. The using clause is placed after the argument list in a function, or in place of it if there are no arguments.

```moonscript
i = 100

my_func = (using nil) ->
  i = "hello" -- a new local variable is created here

my_func!
print i -- prints 100, i is unaffected
```
<EDisplay>
<pre>
i = 100

my_func = (using nil) ->
  i = "hello" -- a new local variable is created here

my_func!
print i -- prints 100, i is unaffected
</pre>
</YueDisplay>

Multiple names can be separated by commas. Closure values can still be accessed, they just cant be modified:

```moonscript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- a new local tmp is created
  i += tmp
  k += tmp

my_func(22)
print i, k -- these have been updated
```
<EDisplay>
<pre>
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- a new local tmp is created
  i += tmp
  k += tmp

my_func(22)
print i, k -- these have been updated
</pre>
</YueDisplay>

## The E Library

Access it by `require("e")`.

### e

**Description:**

The E language library.

#### version

**Type:** Field.

**Description:**

The E version.

**Signature:**
```lua
version: string
```

#### dirsep

**Type:** Field.

**Description:**

The file separator for the current platform.

**Signature:**
```lua
dirsep: string
```

#### e_compiled

**Type:** Field.

**Description:**

The compiled module code cache.

**Signature:**
```lua
e_compiled: {string: string}
```

#### to_lua

**Type:** Function.

**Description:**

The E compiling function. It compiles the E code to Lua code.

**Signature:**
```lua
to_lua: function(code: string, config?: Config):
		--[[codes]] string | nil,
		--[[error]] string | nil,
		--[[globals]] {{string, integer, integer}} | nil
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| code | string | The E code. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| string \| nil | The compiled Lua code, or nil if the compilation failed. |
| string \| nil | The error message, or nil if the compilation succeeded. |
| \{\{string, integer, integer}} \| nil | The global variables appearing in the code (with name, row and column), or nil if the compiler option `lint_global` is false. |

#### file_exist

**Type:** Function.

**Description:**

The source file existence checking function. Can be overridden to customize the behavior.

**Signature:**
```lua
file_exist: function(filename: string): boolean
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| filename | string | The file name. |

**Returns:**

| Return Type | Description |
| --- | --- |
| boolean | Whether the file exists. |

#### read_file

**Type:** Function.

**Description:**

The source file reading function. Can be overridden to customize the behavior.

**Signature:**
```lua
read_file: function(filename: string): string
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| filename | string | The file name. |

**Returns:**

| Return Type | Description |
| --- | --- |
| string | The file content. |

#### insert_loader

**Type:** Function.

**Description:**

Insert the E loader to the package loaders (searchers).

**Signature:**
```lua
insert_loader: function(pos?: integer): boolean
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| pos | integer | [Optional] The position to insert the loader. Default is 3. |

**Returns:**

| Return Type | Description |
| --- | --- |
| boolean | Whether the loader is inserted successfully. It will fail if the loader is already inserted. |

#### remove_loader

**Type:** Function.

**Description:**

Remove the E loader from the package loaders (searchers).

**Signature:**
```lua
remove_loader: function(): boolean
```

**Returns:**

| Return Type | Description |
| --- | --- |
| boolean | Whether the loader is removed successfully. It will fail if the loader is not inserted. |

#### loadstring

**Type:** Function.

**Description:**

Loads E code from a string into a function.

**Signature:**
```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
		--[[loaded function]] nil | function(...: any): (any...),
		--[[error]] string | nil
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| input | string | The E code. |
| chunkname | string | The name of the code chunk. |
| env | table | The environment table. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| function \| nil | The loaded function, or nil if the loading failed. |
| string \| nil | The error message, or nil if the loading succeeded. |

#### loadstring

**Type:** Function.

**Description:**

Loads E code from a string into a function.

**Signature:**
```lua
loadstring: function(input: string, chunkname: string, config?: Config):
		--[[loaded function]] nil | function(...: any): (any...),
		--[[error]] string | nil
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| input | string | The E code. |
| chunkname | string | The name of the code chunk. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| function \| nil | The loaded function, or nil if the loading failed. |
| string \| nil | The error message, or nil if the loading succeeded. |

#### loadstring

**Type:** Function.

**Description:**

Loads E code from a string into a function.

**Signature:**
```lua
loadstring: function(input: string, config?: Config):
		--[[loaded function]] nil | function(...: any): (any...),
		--[[error]] string | nil
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| input | string | The E code. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| function \| nil | The loaded function, or nil if the loading failed. |
| string \| nil | The error message, or nil if the loading succeeded. |

#### loadfile

**Type:** Function.

**Description:**

Loads E code from a file into a function.
Loads E code from a file into a function.

**Signature:**
```lua
loadfile: function(filename: string, env: table, config?: Config):
		nil | function(...: any): (any...),
		string | nil
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| filename | string | The file name. |
| env | table | The environment table. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| function \| nil | The loaded function, or nil if the loading failed. |
| string \| nil | The error message, or nil if the loading succeeded. |

#### loadfile

**Type:** Function.

**Description:**

Loads YueScript code from a file into a function.

**Signature:**
```lua
loadfile: function(filename: string, config?: Config):
		nil | function(...: any): (any...),
		string | nil
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| filename | string | The file name. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| function \| nil | The loaded function, or nil if the loading failed. |
| string \| nil | The error message, or nil if the loading succeeded. |

#### dofile

**Type:** Function.

**Description:**

Loads E code from a file into a function and executes it.
Loads E code from a file into a function and executes it.

**Signature:**
```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| filename | string | The file name. |
| env | table | The environment table. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| any... | The return values of the loaded function. |

#### dofile

**Type:** Function.

**Description:**

Loads YueScript code from a file into a function and executes it.

**Signature:**
```lua
dofile: function(filename: string, config?: Config): any...
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| filename | string | The file name. |
| config | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description |
| --- | --- |
| any... | The return values of the loaded function. |

#### find_modulepath

**Type:** Function.

**Description:**

Resolves the E module name to the file path.

**Signature:**
```lua
find_modulepath: function(name: string): string
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| name | string | The module name. |

**Returns:**

| Return Type | Description |
| --- | --- |
| string | The file path. |

#### pcall

**Type:** Function.

**Description:**

Calls a function in protected mode.
Catches any errors and returns a status code and results or error object.
Rewrites the error line number to the original line number in the E code when errors occur.

**Signature:**
```lua
pcall: function(f: function, ...: any): boolean, any...
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| f | function | The function to call. |
| ... | any | Arguments to pass to the function. |

**Returns:**

| Return Type | Description |
| --- | --- |
| boolean, ... | Status code and function results or error object. |

#### require

**Type:** Function.

**Description:**

Loads a given module. Can be either a Lua module or a E module.
Rewrites the error line number to the original line number in the E code if the module is a E module and loading fails.

**Signature:**
```lua
require: function(name: string): any...
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| modname | string | The name of the module to load. |

**Returns:**

| Return Type | Description |
| --- | --- |
| any | The value stored at package.loaded[modname] if the module is already loaded.Otherwise, tries to find a loader and returns the final value of package.loaded[modname] and a loader data as a second result. |

#### p

**Type:** Function.

**Description:**

Inspects the structures of the passed values and prints string representations.

**Signature:**
```lua
p: function(...: any)
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| ... | any | The values to inspect. |

#### options

**Type:** Field.

**Description:**

The current compiler options.

**Signature:**
```lua
options: Config.Options
```

#### traceback

**Type:** Function.

**Description:**

The traceback function that rewrites the stack trace line numbers to the original line numbers in the E code.

**Signature:**
```lua
traceback: function(message: string): string
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| message | string | The traceback message. |

**Returns:**

| Return Type | Description |
| --- | --- |
| string | The rewritten traceback message. |

#### is_ast

**Type:** Function.

**Description:**

Checks whether the code matches the specified AST.

**Signature:**
```lua
is_ast: function(astName: string, code: string): boolean
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| astName | string | The AST name. |
| code | string | The code. |

**Returns:**

| Return Type | Description |
| --- | --- |
| boolean | Whether the code matches the AST. |

#### AST

**Type:** Field.

**Description:**

The AST type definition with name, row, column and sub nodes.

**Signature:**
```lua
type AST = {string, integer, integer, any}
```

#### to_ast

**Type:** Function.

**Description:**

Converts the code to the AST.

**Signature:**
```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string):
		--[[AST]] AST | nil,
		--[[error]] nil | string
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| code | string | The code. |
| flattenLevel | integer | [Optional] The flatten level. Higher level means more flattening. Default is 0. Maximum is 2. |
| astName | string | [Optional] The AST name. Default is "File". |

**Returns:**

| Return Type | Description |
| --- | --- |
| AST \| nil | The AST, or nil if the conversion failed. |
| string \| nil | The error message, or nil if the conversion succeeded. |

#### __call

**Type:** Metamethod.

**Description:**

Requires the E module.
Rewrites the error line number to the original line number in the E code when loading fails.

**Signature:**
```lua
metamethod __call: function(self: e, module: string): any...
```

**Parameters:**

| Parameter | Type | Description |
| --- | --- | --- |
| module | string | The module name. |

**Returns:**

| Return Type | Description |
| --- | --- |
| any | The module value. |

### Config

**Description:**

The compiler compile options.

#### lint_global

**Type:** Field.

**Description:**

Whether the compiler should collect the global variables appearing in the code.

**Signature:**
```lua
lint_global: boolean
```

#### implicit_return_root

**Type:** Field.

**Description:**

Whether the compiler should do an implicit return for the root code block.

**Signature:**
```lua
implicit_return_root: boolean
```

#### reserve_line_number

**Type:** Field.

**Description:**

Whether the compiler should reserve the original line number in the compiled code.

**Signature:**
```lua
reserve_line_number: boolean
```

#### space_over_tab

**Type:** Field.

**Description:**

Whether the compiler should use the space character instead of the tab character in the compiled code.

**Signature:**
```lua
space_over_tab: boolean
```

#### same_module

**Type:** Field.

**Description:**

Whether the compiler should treat the code to be compiled as the same currently being compiled module. For internal use only.

**Signature:**
```lua
same_module: boolean
```

#### line_offset

**Type:** Field.

**Description:**

Whether the compiler error message should include the line number offset. For internal use only.

**Signature:**
```lua
line_offset: integer
```

#### e.Config.LuaTarget

**Type:** Enumeration.

**Description:**

The target Lua version enumeration.

**Signature:**
```lua
enum LuaTarget
	"5.1"
	"5.2"
	"5.3"
	"5.4"
	"5.5"
end
```

#### options

**Type:** Field.

**Description:**

The extra options to be passed to the compilation function.

**Signature:**
```lua
options: Options
```

### Options

**Description:**

The extra compiler options definition.

#### target

**Type:** Field.

**Description:**

The target Lua version for the compilation.

**Signature:**
```lua
target: LuaTarget
```

#### path

**Type:** Field.

**Description:**

The extra module search path.

**Signature:**
```lua
path: string
```

#### dump_locals

**Type:** Field.

**Description:**

Whether to dump the local variables in the traceback error message. Default is false.

**Signature:**
```lua
dump_locals: boolean
```

#### simplified

**Type:** Field.

**Description:**

Whether to simplify the error message. Default is true.

**Signature:**
```lua
simplified: boolean
```

## Licence: MIT

Copyright (c) 2017-2025 Li Jin \<dragon-fly@qq.com\>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

<CompilerModal />
