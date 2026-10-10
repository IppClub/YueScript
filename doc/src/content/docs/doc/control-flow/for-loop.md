---
title: For Loop
sidebar:
  order: 19
---

There are two for loop forms, just like in Lua. A numeric one and a generic one:

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
```

</div>
</div>

The slicing and **\*** operators can be used, just like with comprehensions:

```yuescript
for item in *items[2, 4]
  print item
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items[2, 4]
  print item
```

</div>
</div>

A shorter syntax is also available for all variations when the body is only a single line:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items do print item

for j = 1, 10, 3 do print j
```

</div>
</div>

A for loop can also be used as an expression. The last statement in the body of the for loop is coerced into an expression and appended to an accumulating array table.

Doubling every even number:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

</div>
</div>

In addition, for loops support break with return values, allowing the loop itself to be used as an expression that exits early with meaningful results.

For example, to find the first number greater than 10:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
first_large = for n in *numbers
  break n if n > 10
```

</div>
</div>

This break-with-value syntax enables concise and expressive search or early-exit patterns directly within loop expressions.

For loop expressions can break with multiple values:

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

</div>
</div>

You can also filter values by combining the for loop expression with the continue statement.

For loops at the end of a function body are not accumulated into a table for a return value (Instead the function will return nil). Either an explicit return statement can be used, or the loop can be converted into a list comprehension.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
```

</div>
</div>

This is done to avoid the needless creation of tables for functions that don't need to return the results of the loop.
