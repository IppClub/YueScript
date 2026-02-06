# Table Literals

Like in Lua, tables are delimited in curly braces.

```yuescript
some_values = [1, 2, 3, 4]
```
<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
```

</YueDisplay>

Unlike Lua, assigning a value to a key in a table is done with **:** (instead of **=**).

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```
<YueDisplay>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

</YueDisplay>

The curly braces can be left off if a single table of key value pairs is being assigned.

```yuescript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```
<YueDisplay>

```yue
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

</YueDisplay>

Newlines can be used to delimit values instead of a comma (or both):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```
<YueDisplay>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

</YueDisplay>

When creating a single line table literal, the curly braces can also be left off:

```yuescript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```
<YueDisplay>

```yue
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

</YueDisplay>

The keys of a table literal can be language keywords without being escaped:

```yuescript
tbl = {
  do: "something"
  end: "hunger"
}
```
<YueDisplay>

```yue
tbl = {
  do: "something"
  end: "hunger"
}
```

</YueDisplay>

If you are constructing a table out of variables and wish the keys to be the same as the variable names, then the **:** prefix operator can be used:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```
<YueDisplay>

```yue
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</YueDisplay>

If you want the key of a field in the table to to be result of an expression, then you can wrap it in **[ ]**, just like in Lua. You can also use a string literal directly as a key, leaving out the square brackets. This is useful if your key has any special characters.

```yuescript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```
<YueDisplay>

```yue
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

</YueDisplay>

Lua tables have both an array part and a hash part, but sometimes you want to make a semantic distinction between array and hash usage when writing Lua tables. Then you can write Lua table with **[ ]** instead of **{ }** to represent an array table and writing any key value pair in a list table won't be allowed.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```
<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

</YueDisplay>
