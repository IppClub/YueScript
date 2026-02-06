# Assignment

The variable is dynamic typed and is defined as local by default. But you can change the scope of declaration by **local** and **global** statement.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- uses the existing variable
```
<YueDisplay>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- uses the existing variable
```

</YueDisplay>

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
<YueDisplay>

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

</YueDisplay>

## Chaining Assignment

You can do chaining assignment to assign multiple items to hold the same value.
```yuescript
a = b = c = d = e = 0
x = y = z = f!
```
<YueDisplay>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</YueDisplay>

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
<YueDisplay>

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

</YueDisplay>

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
<YueDisplay>

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

</YueDisplay>
