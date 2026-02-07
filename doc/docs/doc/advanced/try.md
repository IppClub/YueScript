# Try

The syntax for Lua error handling in a common form.

```yuescript
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- working with if assignment pattern
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

<YueDisplay>

```yue
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- working with if assignment pattern
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

</YueDisplay>

## Try?

`try?` is a simplified use for error handling syntax that omit the boolean status from the `try` statement, and it will return the result from the try block when success, return nil instead of error object otherwise.

```yuescript
a, b, c = try? func!

-- with nil coalescing operator
a = (try? func!) ?? "default"

-- as function argument
f try? func!

-- with catch block
f try?
  print 123
  func!
catch e
  print e
  e
```

<YueDisplay>

```yue
a, b, c = try? func!

-- with nil coalescing operator
a = (try? func!) ?? "default"

-- as function argument
f try? func!

-- with catch block
f try?
  print 123
  func!
catch e
  print e
  e
```

</YueDisplay>
