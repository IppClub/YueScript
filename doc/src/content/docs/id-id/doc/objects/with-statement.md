---
title: Pernyataan With
sidebar:
  order: 27
---

Pola umum saat membuat objek adalah memanggil serangkaian fungsi dan mengatur serangkaian properti segera setelah objek dibuat.

Hal ini menyebabkan nama objek diulang berkali-kali di kode, menambah noise yang tidak perlu. Solusi umum untuk ini adalah meneruskan tabel sebagai argumen yang berisi kumpulan kunci dan nilai untuk ditimpa. Kekurangannya adalah konstruktor objek harus mendukung bentuk ini.

Blok `with` membantu mengatasi hal ini. Di dalam blok `with`, kita bisa menggunakan pernyataan khusus yang diawali dengan `.` atau `\` yang merepresentasikan operasi tersebut diterapkan pada objek yang sedang dipakai.

Sebagai contoh, kita bekerja dengan objek yang baru dibuat:

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</div>
</div>

Pernyataan `with` juga bisa digunakan sebagai ekspresi yang mengembalikan nilai yang diberi akses.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</div>
</div>

Ekspresi `with` mendukung `break` dengan satu nilai:

```yuescript
result = with obj
  break .value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
result = with obj
  break .value
```

</div>
</div>

Setelah `break value` digunakan di dalam `with`, ekspresi `with` tidak lagi mengembalikan objek targetnya, melainkan mengembalikan nilai dari `break`.

```yuescript
a = with obj
  .x = 1
-- a adalah obj

b = with obj
  break .x
-- b adalah .x, bukan obj
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = with obj
  .x = 1
-- a adalah obj

b = with obj
  break .x
-- b adalah .x, bukan obj
```

</div>
</div>

Berbeda dari `for` / `while` / `repeat` / `do`, `with` hanya mendukung satu nilai `break`.

Atau…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</div>
</div>

Dalam penggunaan ini, `with` dapat dilihat sebagai bentuk khusus dari kombinator K.

Ekspresi pada pernyataan `with` juga bisa berupa assignment jika Anda ingin memberi nama pada ekspresi tersebut.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

</div>
</div>

Anda bisa mengakses kunci khusus dengan `[]` di dalam pernyataan `with`.

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- menambahkan ke "tb"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- menambahkan ke "tb"
```

</div>
</div>

`with?` adalah versi yang ditingkatkan dari sintaks `with`, yang memperkenalkan pengecekan keberadaan untuk mengakses objek yang mungkin nil secara aman tanpa pemeriksaan null eksplisit.

```yuescript
with? obj
  print .name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
with? obj
  print .name
```

</div>
</div>
