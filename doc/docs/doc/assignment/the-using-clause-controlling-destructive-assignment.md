# The Using Clause; Controlling Destructive Assignment

While lexical scoping can be a great help in reducing the complexity of the code we write, things can get unwieldy as the code size increases. Consider the following snippet:

```yuescript
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

<YueDisplay>

```yue
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

</YueDisplay>

In my_func, we've overwritten the value of i mistakenly. In this example it is quite obvious, but consider a large, or foreign code base where it isn't clear what names have already been declared.

It would be helpful to say which variables from the enclosing scope we intend on change, in order to prevent us from changing others by accident.

The using keyword lets us do that. using nil makes sure that no closed variables are overwritten in assignment. The using clause is placed after the argument list in a function, or in place of it if there are no arguments.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- a new local variable is created here

my_func!
print i -- prints 100, i is unaffected
```

<YueDisplay>

```yue
i = 100

my_func = (using nil) ->
  i = "hello" -- a new local variable is created here

my_func!
print i -- prints 100, i is unaffected
```

</YueDisplay>

Multiple names can be separated by commas. Closure values can still be accessed, they just cant be modified:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- a new local tmp is created
  i += tmp
  k += tmp

my_func(22)
print i, k -- these have been updated
```

<YueDisplay>

```yue
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- a new local tmp is created
  i += tmp
  k += tmp

my_func(22)
print i, k -- these have been updated
```

</YueDisplay>
