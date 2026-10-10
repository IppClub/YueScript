---
title: Goto
sidebar:
  order: 22
---

YueScript supports goto statement and label syntax for controlling program flow, following the same rules as Lua's goto statement. **Note:** The goto statement requires Lua 5.2 or higher. When compiling to Lua 5.1, using goto syntax will result in a compilation error.

A label is defined using double colons:

```yuescript
::start::
::done::
::my_label::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
::start::
::done::
::my_label::
```

</div>
</div>

The goto statement jumps to a specified label:

```yuescript
a = 0
::start::
a += 1
goto done if a == 5
goto start
::done::
print "a is now 5"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 0
::start::
a += 1
goto done if a == 5
goto start
::done::
print "a is now 5"
```

</div>
</div>

The goto statement is useful for breaking out of deeply nested loops:

```yuescript
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print 'found a Pythagorean triple:', x, y, z
      goto ok
::ok::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print 'found a Pythagorean triple:', x, y, z
      goto ok
::ok::
```

</div>
</div>

You can also use labels to jump to a specific loop level:

```yuescript
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print 'found a Pythagorean triple:', x, y, z
        print 'now trying next z...'
        goto zcontinue
  ::zcontinue::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print 'found a Pythagorean triple:', x, y, z
        print 'now trying next z...'
        goto zcontinue
  ::zcontinue::
```

</div>
</div>

## Notes

- Labels must be unique within their scope
- goto can jump to labels at the same or outer scope levels
- goto cannot jump into inner scopes (like inside blocks or loops)
- Use goto sparingly, as it can make code harder to read and maintain
