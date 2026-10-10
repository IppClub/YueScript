---
title: Literal Tabel
sidebar:
  order: 24
---

Seperti di Lua, tabel dibatasi dengan kurung kurawal.

```yuescript
some_values = {1, 2, 3, 4}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_values = {1, 2, 3, 4}
```

</div>
</div>

Berbeda dengan Lua, assignment nilai ke sebuah kunci di tabel dilakukan dengan **:** (bukan **=**).

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

</div>
</div>

Kurung kurawal dapat dihilangkan jika hanya satu tabel pasangan key-value yang di-assign.

```yuescript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

</div>
</div>

Baris baru dapat digunakan untuk memisahkan nilai sebagai ganti koma (atau keduanya):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

</div>
</div>

Saat membuat literal tabel satu baris, kurung kurawal juga bisa dihilangkan:

```yuescript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

</div>
</div>

Kunci literal tabel dapat berupa kata kunci bahasa tanpa perlu di-escape:

```yuescript
tbl = {
  do: "something"
  end: "hunger"
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  do: "something"
  end: "hunger"
}
```

</div>
</div>

Jika Anda membangun tabel dari variabel dan ingin kunci sama dengan nama variabel, maka operator prefiks **:** dapat digunakan:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</div>
</div>

Jika Anda ingin kunci field dalam tabel menjadi hasil suatu ekspresi, Anda dapat membungkusnya dengan **[ ]**, seperti di Lua. Anda juga bisa menggunakan literal string langsung sebagai kunci tanpa tanda kurung siku. Ini berguna jika kunci memiliki karakter khusus.

```yuescript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

</div>
</div>

Tabel Lua memiliki bagian array dan bagian hash, tetapi kadang-kadang berguna untuk membuat perbedaan semantik di antara keduanya. Anda dapat menggunakan **[ ]** sebagai ganti **{ }** untuk mendeklarasikan tabel secara eksplisit sebagai array, dengan begitu akan mencegah pasangan key-value dituliskan di dalamnya.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

</div>
</div>
