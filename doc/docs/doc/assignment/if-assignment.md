# If Assignment

`if` and `elseif` blocks can take an assignment in place of a conditional expression. Upon evaluating the conditional, the assignment will take place and the value that was assigned to will be used as the conditional expression. The assigned variable is only in scope for the body of the conditional, meaning it is never available if the value is not truthy. And you have to use "the walrus operator" `:=` instead of `=` to do assignment.

```yuescript
if user := database.find_user "moon"
  print user.name
```
<YueDisplay>

```yue
if user := database.find_user "moon"
  print user.name
```

</YueDisplay>

```yuescript
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```
<YueDisplay>

```yue
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```

</YueDisplay>

If assignment with multiple return values. Only the first value is getting checked, other values are scoped.
```yuescript
if success, result := pcall -> "get result without problems"
  print result -- variable result is scoped
print "OK"
```
<YueDisplay>

```yue
if success, result := pcall -> "get result without problems"
  print result -- variable result is scoped
print "OK"
```

</YueDisplay>

## While Assignment

You can also use if assignment in a while loop to get the value as the loop condition.

```yuescript
while byte := stream\read_one!
  -- do something with the byte
  print byte
```
<YueDisplay>

```yue
while byte := stream\read_one!
  -- do something with the byte
  print byte
```

</YueDisplay>
