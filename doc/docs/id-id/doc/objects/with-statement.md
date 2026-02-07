# Pernyataan With

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

<YueDisplay>

```yue
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

</YueDisplay>

Pernyataan `with` juga bisa digunakan sebagai ekspresi yang mengembalikan nilai yang diberi akses.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

<YueDisplay>

```yue
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

</YueDisplay>

Atau…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

<YueDisplay>

```yue
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

</YueDisplay>

Dalam penggunaan ini, `with` dapat dilihat sebagai bentuk khusus dari kombinator K.

Ekspresi pada pernyataan `with` juga bisa berupa assignment jika Anda ingin memberi nama pada ekspresi tersebut.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

<YueDisplay>

```yue
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

</YueDisplay>

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

<YueDisplay>

```yue
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- menambahkan ke "tb"
```

</YueDisplay>

`with?` adalah versi yang ditingkatkan dari sintaks `with`, yang memperkenalkan pengecekan keberadaan untuk mengakses objek yang mungkin nil secara aman tanpa pemeriksaan null eksplisit.

```yuescript
with? obj
  print obj.name
```

<YueDisplay>

```yue
with? obj
  print obj.name
```

</YueDisplay>
