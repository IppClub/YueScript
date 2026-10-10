---
title: Pernyataan Continue
sidebar:
  order: 21
---

Pernyataan continue dapat digunakan untuk melewati iterasi saat ini di dalam loop.

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

continue juga bisa digunakan bersama ekspresi loop untuk mencegah iterasi tersebut diakumulasikan ke hasil. Contoh ini memfilter tabel array menjadi hanya angka genap:

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
