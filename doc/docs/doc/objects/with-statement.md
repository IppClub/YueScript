# With Statement


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
<YueDisplay>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</YueDisplay>

The with statement can also be used as an expression which returns the value it has been giving access to.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```
<YueDisplay>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</YueDisplay>

Or…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```
<YueDisplay>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</YueDisplay>

In this usage, with can be seen as a special form of the K combinator.

The expression in the with statement can also be an assignment, if you want to give a name to the expression.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```
<YueDisplay>

```yue
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

</YueDisplay>

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
<YueDisplay>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- appending to "tb"
```

</YueDisplay>

`with?` is an enhanced version of `with` syntax, which introduces an existential check to safely access objects that may be nil without explicit null checks.

```yuescript
with? obj
  print obj.name
```
<YueDisplay>

```yue
with? obj
  print obj.name
```

</YueDisplay>
