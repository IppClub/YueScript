# Comprehensions

Comprehensions provide a convenient syntax for constructing a new table by iterating over some existing object and applying an expression to its values. There are two kinds of comprehensions: list comprehensions and table comprehensions. They both produce Lua tables; list comprehensions accumulate values into an array-like table, and table comprehensions let you set both the key and the value on each iteration.

## List Comprehensions

The following creates a copy of the items table but with all the values doubled.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

<YueDisplay>

```yue
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

</YueDisplay>

The items included in the new table can be restricted with a when clause:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

<YueDisplay>

```yue
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

</YueDisplay>

Because it is common to iterate over the values of a numerically indexed table, an **\*** operator is introduced. The doubled example can be rewritten as:

```yuescript
doubled = [item * 2 for item in *items]
```

<YueDisplay>

```yue
doubled = [item * 2 for item in *items]
```

</YueDisplay>

In list comprehensions, you can also use the spread operator `...` to flatten nested lists, achieving a flat map effect:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat is now [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat is now [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

The for and when clauses can be chained as much as desired. The only requirement is that a comprehension has at least one for clause.

Using multiple for clauses is the same as using nested loops:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

<YueDisplay>

```yue
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

</YueDisplay>

Numeric for loops can also be used in comprehensions:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

<YueDisplay>

```yue
evens = [i for i = 1, 100 when i % 2 == 0]
```

</YueDisplay>

## Table Comprehensions

The syntax for table comprehensions is very similar, only differing by using **{** and **}** and taking two values from each iteration.

This example makes a copy of the tablething:

```yuescript
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

<YueDisplay>

```yue
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

</YueDisplay>

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

<YueDisplay>

```yue
no_color = {k, v for k, v in pairs thing when k != "color"}
```

</YueDisplay>

The **\*** operator is also supported. Here we create a square root look up table for a few numbers.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

<YueDisplay>

```yue
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

</YueDisplay>

The key-value tuple in a table comprehension can also come from a single expression, in which case the expression should return two values. The first is used as the key and the second is used as the value:

In this example we convert an array of pairs to a table where the first item in the pair is the key and the second is the value.

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

<YueDisplay>

```yue
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

</YueDisplay>

## Slicing

A special syntax is provided to restrict the items that are iterated over when using the **\*** operator. This is equivalent to setting the iteration bounds and a step size in a for loop.

Here we can set the minimum and maximum bounds, taking all items with indexes between 1 and 5 inclusive:

```yuescript
slice = [item for item in *items[1, 5]]
```

<YueDisplay>

```yue
slice = [item for item in *items[1, 5]]
```

</YueDisplay>

Any of the slice arguments can be left off to use a sensible default. In this example, if the max index is left off it defaults to the length of the table. This will take everything but the first element:

```yuescript
slice = [item for item in *items[2,]]
```

<YueDisplay>

```yue
slice = [item for item in *items[2,]]
```

</YueDisplay>

If the minimum bound is left out, it defaults to 1. Here we only provide a step size and leave the other bounds blank. This takes all odd indexed items: (1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

<YueDisplay>

```yue
slice = [item for item in *items[,,2]]
```

</YueDisplay>

Both the minimum and maximum bounds can be negative, which means that the bounds are counted from the end of the table.

```yuescript
-- take the last 4 items
slice = [item for item in *items[-4,-1]]
```

<YueDisplay>

```yue
-- take the last 4 items
slice = [item for item in *items[-4,-1]]
```

</YueDisplay>

The step size can also be negative, which means that the items are taken in reverse order.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

<YueDisplay>

```yue
reverse_slice = [item for item in *items[-1,1,-1]]
```

</YueDisplay>

### Slicing Expression

Slicing can also be used as an expression. This is useful for getting a sub-list of a table.

```yuescript
-- take the 2nd and 4th items as a new list
sub_list = items[2, 4]

-- take the last 4 items
last_four_items = items[-4, -1]
```

<YueDisplay>

```yue
-- take the 2nd and 4th items as a new list
sub_list = items[2, 4]

-- take the last 4 items
last_four_items = items[-4, -1]
```

</YueDisplay>
