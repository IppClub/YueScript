# Switch

The switch statement is shorthand for writing a series of if statements that check against the same value. Note that the value is only evaluated once. Like if statements, switches can have an else block to handle no matches. Comparison is done with the == operator. In switch statement, you can also use assignment expression to store temporary variable value.

```yuescript
switch name := "Dan"
  when "Robert"
    print "You are Robert"
  when "Dan", "Daniel"
    print "Your name, it's Dan"
  else
    print "I don't know about you with name #{name}"
```
<YueDisplay>

```yue
switch name := "Dan"
  when "Robert"
    print "You are Robert"
  when "Dan", "Daniel"
    print "Your name, it's Dan"
  else
    print "I don't know about you with name #{name}"
```

</YueDisplay>

A switch when clause can match against multiple values by listing them out comma separated.

Switches can be used as expressions as well, here we can assign the result of the switch to a variable:

```yuescript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "can't count that high!"
```
<YueDisplay>

```yue
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "can't count that high!"
```

</YueDisplay>

We can use the then keyword to write a switch's when block on a single line. No extra keyword is needed to write the else block on a single line.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
```
<YueDisplay>

```yue
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
```

</YueDisplay>

If you want to write code with one less indent when writing a switch statement, you can put the first when clause on the statement start line, and then all other clauses can be written with one less indent.

```yuescript
switch math.random(1, 5)
  when 1
    print "you are lucky" -- two indents
  else
    print "not so lucky"

switch math.random(1, 5) when 1
  print "you are lucky" -- one indent
else
  print "not so lucky"
```
<YueDisplay>

```yue
switch math.random(1, 5)
  when 1
    print "you are lucky" -- two indents
  else
    print "not so lucky"

switch math.random(1, 5) when 1
  print "you are lucky" -- one indent
else
  print "not so lucky"
```

</YueDisplay>

It is worth noting the order of the case comparison expression. The case's expression is on the left hand side. This can be useful if the case's expression wants to overwrite how the comparison is done by defining an eq metamethod.

## Table Matching

You can do table matching in a switch when clause, if the table can be destructured by a specific structure and get non-nil values.

```yuescript
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "size #{width}, #{height}"
```
<YueDisplay>

```yue
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "size #{width}, #{height}"
```

</YueDisplay>

You can use default values to optionally destructure the table for some fields.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
```
<YueDisplay>

```yue
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
```

</YueDisplay>

You can also match against array elements, table fields, and even nested structures with array or table literals.

Match against array elements.

```yuescript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b has a default value
    print "1, 2, #{b}"
```
<YueDisplay>

```yue
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b has a default value
    print "1, 2, #{b}"
```

</YueDisplay>

Match against table fields with destructuring.

```yuescript
switch tb
  when success: true, :result
    print "success", result
  when success: false
    print "failed", result
  else
    print "invalid"
```
<YueDisplay>

```yue
switch tb
  when success: true, :result
    print "success", result
  when success: false
    print "failed", result
  else
    print "invalid"
```

</YueDisplay>

Match against nested table structures.

```yuescript
switch tb
  when data: {type: "success", :content}
    print "success", content
  when data: {type: "error", :content}
    print "failed", content
  else
    print "invalid"
```
<YueDisplay>

```yue
switch tb
  when data: {type: "success", :content}
    print "success", content
  when data: {type: "error", :content}
    print "failed", content
  else
    print "invalid"
```

</YueDisplay>

Match against array of tables.

```yuescript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "matched", fourth
```
<YueDisplay>

```yue
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "matched", fourth
```

</YueDisplay>

Match against a list and capture a range of elements.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- prints: {"admin", "users"}
    print "Resource:", resource -- prints: "logs"
    print "Action:", action -- prints: "view"
```
<YueDisplay>

```yue
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- prints: {"admin", "users"}
    print "Resource:", resource -- prints: "logs"
    print "Action:", action -- prints: "view"
```

</YueDisplay>
