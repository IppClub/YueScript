# Function Literals

All functions are created using a function expression. A simple function is denoted using the arrow: **->**.

```yuescript
my_function = ->
my_function() -- call the empty function
```
<YueDisplay>

```yue
my_function = ->
my_function() -- call the empty function
```

</YueDisplay>

The body of the function can either be one statement placed directly after the arrow, or it can be a series of statements indented on the following lines:

```yuescript
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```
<YueDisplay>

```yue
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

</YueDisplay>

If a function has no arguments, it can be called using the ! operator, instead of empty parentheses. The ! invocation is the preferred way to call functions with no arguments.

```yuescript
func_a!
func_b()
```
<YueDisplay>

```yue
func_a!
func_b()
```

</YueDisplay>

Functions with arguments can be created by preceding the arrow with a list of argument names in parentheses:

```yuescript
sum = (x, y) -> print "sum", x + y
```
<YueDisplay>

```yue
sum = (x, y) -> print "sum", x + y
```

</YueDisplay>

Functions can be called by listing the arguments after the name of an expression that evaluates to a function. When chaining together function calls, the arguments are applied to the closest function to the left.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```
<YueDisplay>

```yue
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

</YueDisplay>

In order to avoid ambiguity in when calling functions, parentheses can also be used to surround the arguments. This is required here in order to make sure the right arguments get sent to the right functions.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```
<YueDisplay>

```yue
print "x:", sum(10, 20), "y:", sum(30, 40)
```

</YueDisplay>

There must not be any space between the opening parenthesis and the function.

Functions will coerce the last statement in their body into a return statement, this is called implicit return:

```yuescript
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```
<YueDisplay>

```yue
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

</YueDisplay>

And if you need to explicitly return, you can use the return keyword:

```yuescript
sum = (x, y) -> return x + y
```
<YueDisplay>

```yue
sum = (x, y) -> return x + y
```

</YueDisplay>

Just like in Lua, functions can return multiple values. The last statement must be a list of values separated by commas:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```
<YueDisplay>

```yue
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

</YueDisplay>

## Fat Arrows

Because it is an idiom in Lua to send an object as the first argument when calling a method, a special syntax is provided for creating functions which automatically includes a self argument.

```yuescript
func = (num) => @value + num
```
<YueDisplay>

```yue
func = (num) => @value + num
```

</YueDisplay>

## Argument Defaults

It is possible to provide default values for the arguments of a function. An argument is determined to be empty if its value is nil. Any nil arguments that have a default value will be replace before the body of the function is run.

```yuescript
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```
<YueDisplay>

```yue
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

</YueDisplay>

An argument default value expression is evaluated in the body of the function in the order of the argument declarations. For this reason default values have access to previously declared arguments.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```
<YueDisplay>

```yue
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

</YueDisplay>

## Considerations

Because of the expressive parentheses-less way of calling functions, some restrictions must be put in place to avoid parsing ambiguity involving whitespace.

The minus sign plays two roles, a unary negation operator and a binary subtraction operator. Consider how the following examples compile:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```
<YueDisplay>

```yue
a = x - 10
b = x-10
c = x -y
d = x- z
```

</YueDisplay>

The precedence of the first argument of a function call can be controlled using whitespace if the argument is a literal string. In Lua, it is common to leave off parentheses when calling a function with a single string or table literal.

When there is no space between a variable and a string literal, the function call takes precedence over any following expressions. No other arguments can be passed to the function when it is called this way.

Where there is a space following a variable and a string literal, the function call acts as show above. The string literal belongs to any following expressions (if they exist), which serves as the argument list.

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```
<YueDisplay>

```yue
x = func"hello" + 100
y = func "hello" + 100
```

</YueDisplay>

## Multi-line arguments

When calling functions that take a large number of arguments, it is convenient to split the argument list over multiple lines. Because of the white-space sensitive nature of the language, care must be taken when splitting up the argument list.

If an argument list is to be continued onto the next line, the current line must end in a comma. And the following line must be indented more than the current indentation. Once indented, all other argument lines must be at the same level of indentation to be part of the argument list

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```
<YueDisplay>

```yue
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

</YueDisplay>

This type of invocation can be nested. The level of indentation is used to determine to which function the arguments belong to.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```
<YueDisplay>

```yue
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

</YueDisplay>

Because tables also use the comma as a delimiter, this indentation syntax is helpful for letting values be part of the argument list instead of being part of the table.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```
<YueDisplay>

```yue
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

</YueDisplay>

Although uncommon, notice how we can give a deeper indentation for function arguments if we know we will be using a lower indentation further on.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```
<YueDisplay>

```yue
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

</YueDisplay>

The same thing can be done with other block level statements like conditionals. We can use indentation level to determine what statement a value belongs to:

```yuescript
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
<YueDisplay>

```yue
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

</YueDisplay>

## Parameter Destructuring

YueScript now supports destructuring function parameters when the argument is an object. Two forms of destructuring table literals are available:

* **Curly-brace wrapped literals/object parameters**, allowing optional default values when fields are missing (e.g., `{:a, :b}`, `{a: a1 = 123}`).

* **Unwrapped simple table syntax**, starting with a sequence of key-value or shorthand bindings and continuing until another expression terminates it (e.g., `:a, b: b1, :c`). This form extracts multiple fields from the same object.

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```
<YueDisplay>

```yue
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

</YueDisplay>

## Prefixed Return Expression

When working with deeply nested function bodies, it can be tedious to maintain readability and consistency of the return value. To address this, YueScript introduces the **Prefixed Return Expression** syntax. Its form is as follows:

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```
<YueDisplay>

```yue
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

</YueDisplay>

This is equivalent to:

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```
<YueDisplay>

```yue
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

</YueDisplay>

The only difference is that you can move the final return expression before the `->` or `=>` token to indicate the function’s implicit return value as the last statement. This way, even in functions with multiple nested loops or conditional branches, you no longer need to write a trailing return expression at the end of the function body, making the logic structure more straightforward and easier to follow.

## Named Varargs

You can use the `(...t) ->` syntax to automatically store varargs into a named table. This table will contain all passed arguments (including `nil` values), and the `n` field of the table will store the actual number of arguments passed (including `nil` values).

```yuescript
f = (...t) ->
  print "argument count:", t.n
  print "table length:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Handling cases with nil values
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```
<YueDisplay>

```yue
f = (...t) ->
  print "argument count:", t.n
  print "table length:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Handling cases with nil values
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

</YueDisplay>
