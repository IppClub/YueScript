---
title: Operator
sidebar:
  order: 7
---

All of Lua's binary and unary operators are available. Additionally **!=** is as an alias for **~=**, and either **\\** or **::** can be used to write a chaining function call like `tb\func!` or `tb::func!`. And Yuescipt offers some other special operators to write more expressive codes.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tb\func! if tb ~= nil
tb::func! if tb != nil
```

</div>
</div>

## Chaining Comparisons

Comparisons can be arbitrarily chained:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
```

</div>
</div>

Note the evaluation behavior of chained comparisons:

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

The middle expression is only evaluated once, rather than twice as it would be if the expression were written as `v(1) < v(2) and v(2) <= v(3)`. However, the order of evaluations in a chained comparison is undefined. It is strongly recommended not to use expressions with side effects (such as printing) in chained comparisons. If side effects are required, the short-circuit `and` operator should be used explicitly.

## Table Appending

The **[] =** operator is used to append values to tables.

```yuescript
tab = []
tab[] = "Value"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tab = []
tab[] = "Value"
```

</div>
</div>

You can also use the spread operator `...` to append all elements from one list to another:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA is now [1, 2, 3, 4, 5, 6]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA is now [1, 2, 3, 4, 5, 6]
```

</div>
</div>

## Table Spreading

You can concatenate array tables or hash tables using spread operator `...` before expressions in table literals.

When spreading into a brace table literal (for example, `{...other}`), both the array part and hash part of the Lua table are copied.

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

### List Table Spreading

When spreading into a bracket table literal (for example, `[...other,]`), only the array part is copied.

```yuescript
source = {1, 2, 3, name: "Yue"}
fullCopy = {...source}
listCopy = [...source,]
-- fullCopy => {1, 2, 3, name: "Yue"}
-- listCopy => [1, 2, 3]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
source = {1, 2, 3, name: "Yue"}
fullCopy = {...source}
listCopy = [...source,]
-- fullCopy => {1, 2, 3, name: "Yue"}
-- listCopy => [1, 2, 3]
```

</div>
</div>

## Table Reversed Indexing

You can use the **#** operator to get the last elements of a table.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

</div>
</div>

## Metatable

The **<>** operator can be used as a shortcut for metatable manipulation.

### Metatable Creation

Create normal table with empty bracekets **<>** or metamethod key which is surrounded by **<>**.

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

### Metatable Accessing

Accessing metatable with **<>** or metamethod name surrounded by **<>** or writing some expression in **<>**.

```yuescript
-- create with metatable containing field "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- create with metatable containing field "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value
tb.<> = __index: {item: "hello"}
print tb.item
```

</div>
</div>

### Metatable Destructure

Destruct metatable with metamethod key surrounded by **<>**.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

</div>
</div>

## Existence

The **?** operator can be used in a variety of contexts to check for existence.

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

## Piping

Instead of a series of nested function calls, you can pipe values with operator **|>**.

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

## Nil Coalescing

The nil-coalescing operator **??** returns the value of its left-hand operand if it isn't **nil**; otherwise, it evaluates the right-hand operand and returns its result. The **??** operator doesn't evaluate its right-hand operand if the left-hand operand evaluates to non-nil.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
local a, b, c, d
a = b ?? c ?? d
func a ?? {}
a ??= false
```

</div>
</div>

## Implicit Object

You can write a list of implicit structures that starts with the symbol **\*** or **-** inside a table block. If you are creating implicit object, the fields of the object must be with the same indent.

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>
