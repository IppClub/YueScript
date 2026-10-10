---
title: Do
sidebar:
  order: 30
---

When used as a statement, do works just like it does in Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil here
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  var = "hello"
  print var
print var -- nil here
```

</div>
</div>

YueScript's **do** can also be used an expression. Allowing you to combine multiple lines into one. The result of the do expression is the last statement in its body.

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</div>
</div>

```yuescript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

</div>
</div>

`do` expressions also support using `break` to interrupt control flow and return multiple values early:

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

</div>
</div>
