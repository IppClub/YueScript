# Function Stubs

It is common to pass a function from an object around as a value, for example, passing an instance method into a function as a callback. If the function expects the object it is operating on as the first argument then you must somehow bundle that object with the function so it can be called properly.

The function stub syntax is a shorthand for creating a new closure function that bundles both the object and function. This new function calls the wrapped function in the correct context of the object.

Its syntax is the same as calling an instance method with the \ operator but with no argument list provided.

```yuescript
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
<YueDisplay>

```yue
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

</YueDisplay>
