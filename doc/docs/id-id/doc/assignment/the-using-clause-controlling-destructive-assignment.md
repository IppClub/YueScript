# Klausa Using; Mengendalikan Penugasan Destruktif

Meskipun scope leksikal sangat membantu mengurangi kompleksitas kode yang kita tulis, hal ini bisa menjadi sulit ketika ukuran kode membesar. Pertimbangkan cuplikan berikut:

```yuescript
i = 100

-- banyak baris kode...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- akan mencetak 0
```

<YueDisplay>

```yue
i = 100

-- banyak baris kode...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- akan mencetak 0
```

</YueDisplay>

Di `my_func`, kita tanpa sengaja menimpa nilai `i`. Dalam contoh ini halnya cukup jelas, tetapi bayangkan kode besar atau basis kode asing di mana tidak jelas nama apa saja yang sudah dideklarasikan.

Akan sangat membantu jika kita dapat menyatakan variabel mana dari scope luar yang memang ingin kita ubah, agar mencegah mengubah yang lain secara tidak sengaja.

Kata kunci `using` memungkinkan kita melakukan itu. `using nil` memastikan bahwa tidak ada variabel tertutup yang ditimpa dalam assignment. Klausa `using` ditempatkan setelah daftar argumen pada fungsi, atau menggantikannya jika tidak ada argumen.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- variabel local baru dibuat di sini

my_func!
print i -- mencetak 100, i tidak terpengaruh
```

<YueDisplay>

```yue
i = 100

my_func = (using nil) ->
  i = "hello" -- variabel local baru dibuat di sini

my_func!
print i -- mencetak 100, i tidak terpengaruh
```

</YueDisplay>

Beberapa nama dapat dipisahkan dengan koma. Nilai closure tetap bisa diakses, hanya saja tidak dapat dimodifikasi:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- tmp local baru dibuat
  i += tmp
  k += tmp

my_func(22)
print i, k -- ini telah diperbarui
```

<YueDisplay>

```yue
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- tmp local baru dibuat
  i += tmp
  k += tmp

my_func(22)
print i, k -- ini telah diperbarui
```

</YueDisplay>
