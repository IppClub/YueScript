---
title: Kondisional
sidebar:
  order: 18
---

```yuescript
have_coins = false
if have_coins
  print "Dapat koin"
else
  print "Tidak ada koin"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins
  print "Dapat koin"
else
  print "Tidak ada koin"
```

</div>
</div>

Sintaks pendek untuk pernyataan tunggal juga bisa digunakan:

```yuescript
have_coins = false
if have_coins then print "Dapat koin" else print "Tidak ada koin"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins then print "Dapat koin" else print "Tidak ada koin"
```

</div>
</div>

Karena pernyataan if dapat digunakan sebagai ekspresi, ini juga bisa ditulis sebagai:

```yuescript
have_coins = false
print if have_coins then "Dapat koin" else "Tidak ada koin"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
print if have_coins then "Dapat koin" else "Tidak ada koin"
```

</div>
</div>

Kondisional juga bisa digunakan di pernyataan return dan assignment:

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Saya sangat tinggi"
else
  "Saya tidak terlalu tinggi"

print message -- prints: Saya sangat tinggi
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Saya sangat tinggi"
else
  "Saya tidak terlalu tinggi"

print message -- prints: Saya sangat tinggi
```

</div>
</div>

Kebalikan dari if adalah unless:

```yuescript
unless os.date("%A") == "Monday"
  print "hari ini bukan Senin!"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
unless os.date("%A") == "Monday"
  print "hari ini bukan Senin!"
```

</div>
</div>

```yuescript
print "Kamu beruntung!" unless math.random! > 0.1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "Kamu beruntung!" unless math.random! > 0.1
```

</div>
</div>

## Ekspresi In

Anda dapat menulis kode pengecekan rentang dengan `ekspresi in`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "memeriksa kesamaan dengan nilai-nilai diskrit"

if a in list
  print "memeriksa apakah `a` ada di dalam daftar"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "memeriksa kesamaan dengan nilai-nilai diskrit"

if a in list
  print "memeriksa apakah `a` ada di dalam daftar"
```

</div>
</div>

Operator `in` juga dapat digunakan dengan tabel dan mendukung varian `not in` untuk negasi:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a ada di dalam tabel"

not_exist = item not in list

check = -> value not in table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a ada di dalam tabel"

not_exist = item not in list

check = -> value not in table
```

</div>
</div>

Daftar atau tabel dengan satu elemen memeriksa kesamaan dengan elemen tersebut:

```yuescript
-- [1,] memeriksa apakah nilai == 1
c = a in [1,]

-- {1} juga memeriksa apakah nilai == 1
c = a in {1}

-- Tanpa koma, [1] adalah akses indeks (tb[1])
with tb
  c = a in [1]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- [1,] memeriksa apakah nilai == 1
c = a in [1,]

-- {1} juga memeriksa apakah nilai == 1
c = a in {1}

-- Tanpa koma, [1] adalah akses indeks (tb[1])
with tb
  c = a in [1]
```

</div>
</div>
