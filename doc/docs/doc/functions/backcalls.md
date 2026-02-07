# Backcalls

Backcalls are used for unnesting callbacks. They are defined using arrows pointed to the left as the last parameter by default filling in a function call. All the syntax is mostly the same as regular arrow functions except that it is just pointing the other way and the function body does not require indent.

```yuescript
x <- f
print "hello" .. x
```

<YueDisplay>

```yue
x <- f
print "hello" .. x
```

</YueDisplay>

Fat arrow functions are also available.

```yuescript
<= f
print @value
```

<YueDisplay>

```yue
<= f
print @value
```

</YueDisplay>

You can specify a placeholder for where you want the backcall function to go as a parameter.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

<YueDisplay>

```yue
(x) <- map _, [1, 2, 3]
x * 2
```

</YueDisplay>

If you wish to have further code after your backcalls, you can set them aside with a do statement. And the parentheses can be omitted with non-fat arrow functions.

```yuescript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

<YueDisplay>

```yue
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

</YueDisplay>
