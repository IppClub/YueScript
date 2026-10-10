---
title: Penugasan
sidebar:
  order: 10
---

Variabel bersifat bertipe dinamis dan secara default dideklarasikan sebagai local. Namun Anda dapat mengubah cakupan deklarasi dengan pernyataan **local** dan **global**.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- menggunakan variabel yang sudah ada
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- menggunakan variabel yang sudah ada
```

</div>
</div>

## Pembaruan Nilai

Anda dapat melakukan assignment pembaruan dengan banyak operator biner.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- akan menambah local baru jika variabel local belum ada
arg or= "default value"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- akan menambah local baru jika variabel local belum ada
arg or= "default value"
```

</div>
</div>

## Assignment Berantai

Anda bisa melakukan assignment berantai untuk menetapkan beberapa item ke nilai yang sama.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</div>
</div>

## Local Eksplisit

```yuescript
do
  local a = 1
  local *
  print "deklarasikan semua variabel sebagai local di awal"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "hanya deklarasikan variabel huruf besar sebagai local di awal"
  a = 1
  B = 2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  local a = 1
  local *
  print "deklarasikan semua variabel sebagai local di awal"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "hanya deklarasikan variabel huruf besar sebagai local di awal"
  a = 1
  B = 2
```

</div>
</div>

## Global Eksplisit

```yuescript
do
  global a = 1
  global *
  print "deklarasikan semua variabel sebagai global"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "hanya deklarasikan variabel huruf besar sebagai global"
  a = 1
  B = 2
  local Temp = "a local value"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  global a = 1
  global *
  print "deklarasikan semua variabel sebagai global"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "hanya deklarasikan variabel huruf besar sebagai global"
  a = 1
  B = 2
  local Temp = "a local value"
```

</div>
</div>
