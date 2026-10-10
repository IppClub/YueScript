---
title: Continue
sidebar:
  order: 21
---

A continue statement can be used to skip the current iteration in a loop.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

</div>
</div>

continue can also be used with loop expressions to prevent that iteration from accumulating into the result. This examples filters the array table into just even numbers:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

</div>
</div>
