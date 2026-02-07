# Penugasan

Variabel bersifat bertipe dinamis dan secara default dideklarasikan sebagai local. Namun Anda dapat mengubah cakupan deklarasi dengan pernyataan **local** dan **global**.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- menggunakan variabel yang sudah ada
```

<YueDisplay>

```yue
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- menggunakan variabel yang sudah ada
```

</YueDisplay>

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

<YueDisplay>

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

</YueDisplay>

## Assignment Berantai

Anda bisa melakukan assignment berantai untuk menetapkan beberapa item ke nilai yang sama.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

<YueDisplay>

```yue
a = b = c = d = e = 0
x = y = z = f!
```

</YueDisplay>

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

<YueDisplay>

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

</YueDisplay>

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

<YueDisplay>

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

</YueDisplay>
