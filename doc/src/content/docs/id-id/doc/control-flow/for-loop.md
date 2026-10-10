---
title: Perulangan For
sidebar:
  order: 19
---

Ada dua bentuk perulangan for, seperti di Lua. Satu numerik dan satu generik:

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
```

</div>
</div>

Operator slicing dan **\*** dapat digunakan, seperti pada comprehension:

```yuescript
for item in *items[2, 4]
  print item
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items[2, 4]
  print item
```

</div>
</div>

Sintaks yang lebih singkat juga tersedia untuk semua variasi ketika badan hanya satu baris:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for item in *items do print item

for j = 1, 10, 3 do print j
```

</div>
</div>

Perulangan for juga bisa digunakan sebagai ekspresi. Pernyataan terakhir di badan for dipaksa menjadi ekspresi dan ditambahkan ke tabel array yang terakumulasi.

Menggandakan setiap bilangan genap:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

</div>
</div>

Selain itu, loop for mendukung break dengan nilai kembalian, sehingga loop itu sendiri bisa dipakai sebagai ekspresi yang keluar lebih awal dengan hasil bermakna. Ekspresi `for` mendukung `break` dengan banyak nilai.

Contohnya, untuk menemukan angka pertama yang lebih besar dari 10:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
first_large = for n in *numbers
  break n if n > 10
```

</div>
</div>

Sintaks break-dengan-nilai ini memungkinkan pola pencarian atau keluar-lebih-awal yang ringkas langsung di dalam ekspresi loop.

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

</div>
</div>

Anda juga bisa memfilter nilai dengan menggabungkan ekspresi for dengan pernyataan continue.

Loop for di akhir badan fungsi tidak diakumulasikan menjadi tabel untuk nilai kembalian (sebaliknya fungsi akan mengembalikan nil). Gunakan pernyataan return eksplisit, atau ubah loop menjadi list comprehension.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
```

</div>
</div>
