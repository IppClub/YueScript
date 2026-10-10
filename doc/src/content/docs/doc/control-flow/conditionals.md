---
title: Conditionals
sidebar:
  order: 18
---

```yuescript
have_coins = false
if have_coins
  print "Got coins"
else
  print "No coins"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins
  print "Got coins"
else
  print "No coins"
```

</div>
</div>

A short syntax for single statements can also be used:

```yuescript
have_coins = false
if have_coins then print "Got coins" else print "No coins"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins then print "Got coins" else print "No coins"
```

</div>
</div>

Because if statements can be used as expressions, this can also be written as:

```yuescript
have_coins = false
print if have_coins then "Got coins" else "No coins"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
print if have_coins then "Got coins" else "No coins"
```

</div>
</div>

Conditionals can also be used in return statements and assignments:

```yuescript
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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
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

</div>
</div>

The opposite of if is unless:

```yuescript
unless os.date("%A") == "Monday"
  print "it is not Monday!"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
unless os.date("%A") == "Monday"
  print "it is not Monday!"
```

</div>
</div>

```yuescript
print "You're lucky!" unless math.random! > 0.1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "You're lucky!" unless math.random! > 0.1
```

</div>
</div>

## In Expression

You can write range checking code with an `in-expression`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "checking equality with discrete values"

if a in list
  print "checking if `a` is in a list"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "checking equality with discrete values"

if a in list
  print "checking if `a` is in a list"
```

</div>
</div>

The `in` operator can also be used with tables and supports the `not in` variant for negation:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a is in the table"

not_exist = item not in list

check = -> value not in table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a is in the table"

not_exist = item not in list

check = -> value not in table
```

</div>
</div>

A single-element list or table checks for equality with that element:

```yuescript
-- [1,] checks if value == 1
c = a in [1,]

-- {1} also checks if value == 1
c = a in {1}

-- Without comma, [1] is indexing (tb[1])
with tb
  c = a in [1]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- [1,] checks if value == 1
c = a in [1,]

-- {1} also checks if value == 1
c = a in {1}

-- Without comma, [1] is indexing (tb[1])
with tb
  c = a in [1]
```

</div>
</div>
