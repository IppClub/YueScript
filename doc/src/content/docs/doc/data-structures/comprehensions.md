---
title: Comprehensions
sidebar:
  order: 25
---

Comprehensions provide a convenient syntax for constructing a new table by iterating over some existing object and applying an expression to its values. There are two kinds of comprehensions: list comprehensions and table comprehensions. They both produce Lua tables; list comprehensions accumulate values into an array-like table, and table comprehensions let you set both the key and the value on each iteration.

## List Comprehensions

The following creates a copy of the items table but with all the values doubled.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

</div>
</div>

The items included in the new table can be restricted with a when clause:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

</div>
</div>

Because it is common to iterate over the values of a numerically indexed table, an **\*** operator is introduced. The doubled example can be rewritten as:

```yuescript
doubled = [item * 2 for item in *items]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
doubled = [item * 2 for item in *items]
```

</div>
</div>

In list comprehensions, you can also use the spread operator `...` to flatten nested lists, achieving a flat map effect:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat is now [1, 2, 3, 4, 5, 6]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat is now [1, 2, 3, 4, 5, 6]
```

</div>
</div>

The for and when clauses can be chained as much as desired. The only requirement is that a comprehension has at least one for clause.

Using multiple for clauses is the same as using nested loops:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

</div>
</div>

Numeric for loops can also be used in comprehensions:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
evens = [i for i = 1, 100 when i % 2 == 0]
```

</div>
</div>

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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

</div>
</div>

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
no_color = {k, v for k, v in pairs thing when k != "color"}
```

</div>
</div>

The **\*** operator is also supported. Here we create a square root look up table for a few numbers.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

</div>
</div>

The key-value tuple in a table comprehension can also come from a single expression, in which case the expression should return two values. The first is used as the key and the second is used as the value:

In this example we convert an array of pairs to a table where the first item in the pair is the key and the second is the value.

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

</div>
</div>

## Slicing

A special syntax is provided to restrict the items that are iterated over when using the **\*** operator. This is equivalent to setting the iteration bounds and a step size in a for loop.

Here we can set the minimum and maximum bounds, taking all items with indexes between 1 and 5 inclusive:

```yuescript
slice = [item for item in *items[1, 5]]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
slice = [item for item in *items[1, 5]]
```

</div>
</div>

Any of the slice arguments can be left off to use a sensible default. In this example, if the max index is left off it defaults to the length of the table. This will take everything but the first element:

```yuescript
slice = [item for item in *items[2,]]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
slice = [item for item in *items[2,]]
```

</div>
</div>

If the minimum bound is left out, it defaults to 1. Here we only provide a step size and leave the other bounds blank. This takes all odd indexed items: (1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
slice = [item for item in *items[,,2]]
```

</div>
</div>

Both the minimum and maximum bounds can be negative, which means that the bounds are counted from the end of the table.

```yuescript
-- take the last 4 items
slice = [item for item in *items[-4,-1]]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- take the last 4 items
slice = [item for item in *items[-4,-1]]
```

</div>
</div>

The step size can also be negative, which means that the items are taken in reverse order.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
reverse_slice = [item for item in *items[-1,1,-1]]
```

</div>
</div>

### Slicing Expression

Slicing can also be used as an expression. This is useful for getting a sub-list of a table.

```yuescript
-- take the 2nd and 4th items as a new list
sub_list = items[2, 4]

-- take the last 4 items
last_four_items = items[-4, -1]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- take the 2nd and 4th items as a new list
sub_list = items[2, 4]

-- take the last 4 items
last_four_items = items[-4, -1]
```

</div>
</div>
