---
title: Destructuring Assignment
sidebar:
  order: 11
---

Destructuring assignment is a way to quickly extract values from a table by their name or position in array based tables.

Typically when you see a table literal, {1,2,3}, it is on the right hand side of an assignment because it is a value. Destructuring assignment swaps the role of the table literal, and puts it on the left hand side of an assign statement.

This is best explained with examples. Here is how you would unpack the first two values from a table:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
thing = [1, 2]

[a, b] = thing
print a, b
```

</div>
</div>

In the destructuring table literal, the key represents the key to read from the right hand side, and the value represents the name the read value will be assigned to.

```yuescript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK to do simple destructuring without braces
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK to do simple destructuring without braces
```

</div>
</div>

This also works with nested data structures as well:

```yuescript
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

</div>
</div>

If the destructuring statement is complicated, feel free to spread it out over a few lines. A slightly more complicated example:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

</div>
</div>

It's common to extract values from at table and assign them the local variables that have the same name as the key. In order to avoid repetition we can use the **:** prefix operator:

```yuescript
{:concat, :insert} = table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:concat, :insert} = table
```

</div>
</div>

This is effectively the same as import, but we can rename fields we want to extract by mixing the syntax:

```yuescript
{:mix, :max, random: rand} = math
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:mix, :max, random: rand} = math
```

</div>
</div>

You can write default values while doing destructuring like:

```yuescript
{:name = "nameless", :job = "jobless"} = person
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
{:name = "nameless", :job = "jobless"} = person
```

</div>
</div>

You can use `_` as placeholder when doing a list destructuring:

```yuescript
[_, two, _, four] = items
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
[_, two, _, four] = items
```

</div>
</div>

## Range Destructuring

You can use the spread operator `...` in list destructuring to capture a range of values. This is useful when you want to extract specific elements from the beginning and end of a list while collecting the rest in between.

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- prints: first
print bulk   -- prints: {"second", "third", "fourth"}
print last   -- prints: last
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- prints: first
print bulk   -- prints: {"second", "third", "fourth"}
print last   -- prints: last
```

</div>
</div>

The spread operator can be used in different positions to capture different ranges, and you can use `_` as a placeholder for the values you don't want to capture:

```yuescript
-- Capture everything after first element
[first, ...rest] = orders

-- Capture everything before last element
[...start, last] = orders

-- Capture things except the middle elements
[first, ..._, last] = orders
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- Capture everything after first element
[first, ...rest] = orders

-- Capture everything before last element
[...start, last] = orders

-- Capture things except the middle elements
[first, ..._, last] = orders
```

</div>
</div>

## Destructuring In Other Places

Destructuring can also show up in places where an assignment implicitly takes place. An example of this is a for loop:

```yuescript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

</div>
</div>

We know each element in the array table is a two item tuple, so we can unpack it directly in the names clause of the for statement using a destructure.
