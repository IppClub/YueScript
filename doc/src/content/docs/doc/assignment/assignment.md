---
title: Assignment
sidebar:
  order: 10
---

The variable is dynamic typed and is defined as local by default. But you can change the scope of declaration by **local** and **global** statement.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- uses the existing variable
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- uses the existing variable
```

</div>
</div>

## Perform Update

You can perform update assignment with many binary operators.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- will add a new local if local variable is not exist
arg or= "default value"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- will add a new local if local variable is not exist
arg or= "default value"
```

</div>
</div>

## Chaining Assignment

You can do chaining assignment to assign multiple items to hold the same value.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</div>
</div>

## Explicit Locals

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

## Explicit Globals

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>
