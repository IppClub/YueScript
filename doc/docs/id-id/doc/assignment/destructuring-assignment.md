# Penugasan Destrukturisasi

Assignment destrukturisasi adalah cara cepat untuk mengekstrak nilai dari sebuah tabel berdasarkan nama kunci atau posisinya pada tabel berbasis array.

Biasanya ketika Anda melihat literal tabel, `{1,2,3}`, ia berada di sisi kanan assignment karena merupakan nilai. Assignment destrukturisasi menukar peran literal tabel dan menaruhnya di sisi kiri pernyataan assignment.

Ini paling mudah dijelaskan dengan contoh. Berikut cara membongkar dua nilai pertama dari sebuah tabel:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

<YueDisplay>

```yue
thing = [1, 2]

[a, b] = thing
print a, b
```

</YueDisplay>

Di literal tabel destrukturisasi, kunci mewakili kunci yang dibaca dari sisi kanan, dan nilai mewakili nama yang akan menerima nilai tersebut.

```yuescript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK untuk destrukturisasi sederhana tanpa kurung
```

<YueDisplay>

```yue
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK untuk destrukturisasi sederhana tanpa kurung
```

</YueDisplay>

Ini juga bekerja pada struktur data bertingkat:

```yuescript
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

<YueDisplay>

```yue
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

</YueDisplay>

Jika pernyataan destrukturisasi kompleks, Anda bisa memecahnya ke beberapa baris. Contoh yang sedikit lebih rumit:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

<YueDisplay>

```yue
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

</YueDisplay>

Umumnya mengekstrak nilai dari tabel lalu menugaskannya ke variabel local dengan nama yang sama dengan kuncinya. Untuk menghindari pengulangan, kita bisa menggunakan operator prefiks **:**:

```yuescript
{:concat, :insert} = table
```

<YueDisplay>

```yue
{:concat, :insert} = table
```

</YueDisplay>

Ini secara efektif sama seperti import, tetapi kita dapat mengganti nama field yang ingin diekstrak dengan menggabungkan sintaks:

```yuescript
{:mix, :max, random: rand} = math
```

<YueDisplay>

```yue
{:mix, :max, random: rand} = math
```

</YueDisplay>

Anda bisa menulis nilai default saat destrukturisasi seperti:

```yuescript
{:name = "nameless", :job = "jobless"} = person
```

<YueDisplay>

```yue
{:name = "nameless", :job = "jobless"} = person
```

</YueDisplay>

Anda dapat menggunakan `_` sebagai placeholder saat destrukturisasi list:

```yuescript
[_, two, _, four] = items
```

<YueDisplay>

```yue
[_, two, _, four] = items
```

</YueDisplay>

## Destrukturisasi Rentang

Anda dapat menggunakan operator spread `...` pada destrukturisasi list untuk menangkap rentang nilai. Ini berguna ketika Anda ingin mengekstrak elemen tertentu dari awal dan akhir list sambil mengumpulkan sisanya di tengah.

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- prints: first
print bulk   -- prints: {"second", "third", "fourth"}
print last   -- prints: last
```

<YueDisplay>

```yue
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- prints: first
print bulk   -- prints: {"second", "third", "fourth"}
print last   -- prints: last
```

</YueDisplay>

Operator spread dapat digunakan pada posisi berbeda untuk menangkap rentang yang berbeda, dan Anda bisa memakai `_` sebagai placeholder untuk nilai yang tidak ingin ditangkap:

```yuescript
-- Tangkap semuanya setelah elemen pertama
[first, ...rest] = orders

-- Tangkap semuanya sebelum elemen terakhir
[...start, last] = orders

-- Tangkap semuanya kecuali elemen tengah
[first, ..._, last] = orders
```

<YueDisplay>

```yue
-- Tangkap semuanya setelah elemen pertama
[first, ...rest] = orders

-- Tangkap semuanya sebelum elemen terakhir
[...start, last] = orders

-- Tangkap semuanya kecuali elemen tengah
[first, ..._, last] = orders
```

</YueDisplay>

## Destrukturisasi di Tempat Lain

Destrukturisasi juga dapat muncul di tempat-tempat di mana assignment terjadi secara implisit. Contohnya adalah perulangan for:

```yuescript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

<YueDisplay>

```yue
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

</YueDisplay>

Kita tahu setiap elemen pada tabel array adalah tuple dua item, sehingga kita dapat membongkarnya langsung di klausa nama pada pernyataan for menggunakan destrukturisasi.
