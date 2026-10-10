---
title: With Statement
sidebar:
  order: 27
---

A common pattern involving the creation of an object is calling a series of functions and setting a series of properties immediately after creating it.

This results in repeating the name of the object multiple times in code, adding unnecessary noise. A common solution to this is to pass a table in as an argument which contains a collection of keys and values to overwrite. The downside to this is that the constructor of this object must support this form.

The with block helps to alleviate this. Within a with block we can use a special statements that begin with either . or \ which represent those operations applied to the object we are using with on.

For example, we work with a newly created object:

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</div>
</div>

The with statement can also be used as an expression which returns the value it has been giving access to.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</div>
</div>

`with` expressions support `break` with one value:

```yuescript
result = with obj
  break .value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
result = with obj
  break .value
```

</div>
</div>

After `break value` is used inside `with`, the `with` expression no longer returns its target object. Instead, it returns the value from `break`.

```yuescript
a = with obj
  .x = 1
-- a is obj

b = with obj
  break .x
-- b is .x, not obj
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = with obj
  .x = 1
-- a is obj

b = with obj
  break .x
-- b is .x, not obj
```

</div>
</div>

Unlike `for` / `while` / `repeat` / `do`, `with` only supports one break value.

Or…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</div>
</div>

In this usage, with can be seen as a special form of the K combinator.

The expression in the with statement can also be an assignment, if you want to give a name to the expression.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

</div>
</div>

You can access special keys with `[]` in a `with` statement.

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- appending to "tb"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- appending to "tb"
```

</div>
</div>

`with?` is an enhanced version of `with` syntax, which introduces an existential check to safely access objects that may be nil without explicit null checks.

```yuescript
with? obj
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with? obj
  print .name
```

</div>
</div>
