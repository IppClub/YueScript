# Komprehensi

Komprehensi menyediakan sintaks yang nyaman untuk membangun tabel baru dengan mengiterasi objek yang ada dan menerapkan ekspresi pada nilainya. Ada dua jenis komprehensi: komprehensi list dan komprehensi tabel. Keduanya menghasilkan tabel Lua; komprehensi list mengakumulasi nilai ke tabel mirip array, dan komprehensi tabel memungkinkan Anda menetapkan kunci dan nilai pada setiap iterasi.

## Komprehensi List

Berikut membuat salinan tabel `items` tetapi semua nilainya digandakan.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

<YueDisplay>

```yue
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

</YueDisplay>

Item yang disertakan dalam tabel baru bisa dibatasi dengan klausa `when`:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

<YueDisplay>

```yue
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

</YueDisplay>

Karena umum untuk mengiterasi nilai dari tabel berindeks numerik, operator **\*** diperkenalkan. Contoh `doubled` bisa ditulis ulang sebagai:

```yuescript
doubled = [item * 2 for item in *items]
```

<YueDisplay>

```yue
doubled = [item * 2 for item in *items]
```

</YueDisplay>

Dalam komprehensi list, Anda juga bisa menggunakan operator spread `...` untuk meratakan list bertingkat, menghasilkan efek flat map:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat sekarang [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat sekarang [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

Klausa `for` dan `when` dapat dirantai sebanyak yang diinginkan. Satu-satunya syarat adalah komprehensi memiliki setidaknya satu klausa `for`.

Menggunakan beberapa klausa `for` sama seperti menggunakan loop bertingkat:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

<YueDisplay>

```yue
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

</YueDisplay>

Perulangan for numerik juga bisa digunakan dalam komprehensi:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

<YueDisplay>

```yue
evens = [i for i = 1, 100 when i % 2 == 0]
```

</YueDisplay>

## Komprehensi Tabel

Sintaks untuk komprehensi tabel sangat mirip, hanya berbeda dengan penggunaan **{** dan **}** serta mengambil dua nilai dari setiap iterasi.

Contoh ini membuat salinan tabel `thing`:

```yuescript
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

<YueDisplay>

```yue
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

</YueDisplay>

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

<YueDisplay>

```yue
no_color = {k, v for k, v in pairs thing when k != "color"}
```

</YueDisplay>

Operator **\*** juga didukung. Di sini kita membuat tabel lookup akar kuadrat untuk beberapa angka.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

<YueDisplay>

```yue
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

</YueDisplay>

Tuple key-value dalam komprehensi tabel juga bisa berasal dari satu ekspresi, yang berarti ekspresi tersebut harus mengembalikan dua nilai. Nilai pertama digunakan sebagai kunci dan nilai kedua digunakan sebagai nilai:

Dalam contoh ini kita mengonversi array pasangan menjadi tabel di mana item pertama dalam pasangan menjadi kunci dan item kedua menjadi nilai.

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

<YueDisplay>

```yue
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

</YueDisplay>

## Slicing

Sintaks khusus disediakan untuk membatasi item yang diiterasi saat menggunakan operator **\***. Ini setara dengan mengatur batas iterasi dan ukuran langkah pada loop for.

Di sini kita bisa menetapkan batas minimum dan maksimum, mengambil semua item dengan indeks antara 1 dan 5 (inklusif):

```yuescript
slice = [item for item in *items[1, 5]]
```

<YueDisplay>

```yue
slice = [item for item in *items[1, 5]]
```

</YueDisplay>

Salah satu argumen slice boleh dikosongkan untuk menggunakan default yang masuk akal. Pada contoh ini, jika indeks maksimum dikosongkan, defaultnya adalah panjang tabel. Ini akan mengambil semua item kecuali elemen pertama:

```yuescript
slice = [item for item in *items[2,]]
```

<YueDisplay>

```yue
slice = [item for item in *items[2,]]
```

</YueDisplay>

Jika batas minimum dikosongkan, defaultnya adalah 1. Di sini kita hanya memberikan ukuran langkah dan membiarkan batas lainnya kosong. Ini akan mengambil semua item berindeks ganjil: (1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

<YueDisplay>

```yue
slice = [item for item in *items[,,2]]
```

</YueDisplay>

Batas minimum dan maksimum bisa bernilai negatif, yang berarti batas dihitung dari akhir tabel.

```yuescript
-- ambil 4 item terakhir
slice = [item for item in *items[-4,-1]]
```

<YueDisplay>

```yue
-- ambil 4 item terakhir
slice = [item for item in *items[-4,-1]]
```

</YueDisplay>

Ukuran langkah juga bisa negatif, yang berarti item diambil dalam urutan terbalik.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

<YueDisplay>

```yue
reverse_slice = [item for item in *items[-1,1,-1]]
```

</YueDisplay>

### Ekspresi Slicing

Slicing juga bisa digunakan sebagai ekspresi. Ini berguna untuk mendapatkan sub-list dari sebuah tabel.

```yuescript
-- ambil item ke-2 dan ke-4 sebagai list baru
sub_list = items[2, 4]

-- ambil 4 item terakhir
last_four_items = items[-4, -1]
```

<YueDisplay>

```yue
-- ambil item ke-2 dan ke-4 sebagai list baru
sub_list = items[2, 4]

-- ambil 4 item terakhir
last_four_items = items[-4, -1]
```

</YueDisplay>
