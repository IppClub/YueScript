---
title: Goto
sidebar:
  order: 22
---

YueScript mendukung pernyataan goto dan sintaks label untuk mengontrol alur program, mengikuti aturan yang sama dengan pernyataan goto Lua. **Catatan:** Pernyataan goto memerlukan Lua 5.2 atau lebih tinggi. Saat mengompilasi ke Lua 5.1, penggunaan sintaks goto akan menyebabkan galat kompilasi.

Label didefinisikan menggunakan dua titik dua:

```yuescript
::mulai::
::selesai::
::label_saya::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
::mulai::
::selesai::
::label_saya::
```

</div>
</div>

Pernyataan goto melompat ke label yang ditentukan:

```yuescript
a = 0
::mulai::
a += 1
goto selesai if a == 5
goto mulai
::selesai::
print "a sekarang 5"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 0
::mulai::
a += 1
goto selesai if a == 5
goto mulai
::selesai::
print "a sekarang 5"
```

</div>
</div>

Pernyataan goto berguna untuk keluar dari loop yang bersarang dalam:

```yuescript
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print 'tripel Pythagorean ditemukan:', x, y, z
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
      print 'tripel Pythagorean ditemukan:', x, y, z
      goto ok
::ok::
```

</div>
</div>

Anda juga dapat menggunakan label untuk melompat ke tingkat loop tertentu:

```yuescript
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print 'tripel Pythagorean ditemukan:', x, y, z
        print 'mencoba z berikutnya...'
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
        print 'tripel Pythagorean ditemukan:', x, y, z
        print 'mencoba z berikutnya...'
        goto zcontinue
  ::zcontinue::
```

</div>
</div>

## Catatan

- Label harus unik dalam cakupannya
- goto dapat melompat ke label pada tingkat cakupan yang sama atau luar
- goto tidak dapat melompat ke cakupan dalam (seperti di dalam blok atau loop)
- Gunakan goto dengan hemat, karena dapat membuat kode lebih sulit dibaca dan dipelihara
