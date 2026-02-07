# Conditionals

```yuescript
have_coins = false
if have_coins
  print "Got coins"
else
  print "No coins"
```

<YueDisplay>

```yue
have_coins = false
if have_coins
  print "Got coins"
else
  print "No coins"
```

</YueDisplay>

A short syntax for single statements can also be used:

```yuescript
have_coins = false
if have_coins then print "Got coins" else print "No coins"
```

<YueDisplay>

```yue
have_coins = false
if have_coins then print "Got coins" else print "No coins"
```

</YueDisplay>

Because if statements can be used as expressions, this can also be written as:

```yuescript
have_coins = false
print if have_coins then "Got coins" else "No coins"
```

<YueDisplay>

```yue
have_coins = false
print if have_coins then "Got coins" else "No coins"
```

</YueDisplay>

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

<YueDisplay>

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

</YueDisplay>

The opposite of if is unless:

```yuescript
unless os.date("%A") == "Monday"
  print "it is not Monday!"
```

<YueDisplay>

```yue
unless os.date("%A") == "Monday"
  print "it is not Monday!"
```

</YueDisplay>

```yuescript
print "You're lucky!" unless math.random! > 0.1
```

<YueDisplay>

```yue
print "You're lucky!" unless math.random! > 0.1
```

</YueDisplay>

## In Expression

You can write range checking code with an `in-expression`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "checking equality with discrete values"

if a in list
  print "checking if `a` is in a list"
```

<YueDisplay>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "checking equality with discrete values"

if a in list
  print "checking if `a` is in a list"
```

</YueDisplay>
