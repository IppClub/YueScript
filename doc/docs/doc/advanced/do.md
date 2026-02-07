# Do

When used as a statement, do works just like it does in Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil here
```

<YueDisplay>

```yue
do
  var = "hello"
  print var
print var -- nil here
```

</YueDisplay>

YueScript's **do** can also be used an expression . Allowing you to combine multiple lines into one. The result of the do expression is the last statement in its body.

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

<YueDisplay>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</YueDisplay>

```yuescript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

<YueDisplay>

```yue
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

</YueDisplay>
