# Literal Tabel

Seperti di Lua, tabel dibatasi dengan kurung kurawal.

```yuescript
some_values = [1, 2, 3, 4]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
```

</YueDisplay>

Berbeda dengan Lua, assignment nilai ke sebuah kunci di tabel dilakukan dengan **:** (bukan **=**).

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

<YueDisplay>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

</YueDisplay>

Kurung kurawal dapat dihilangkan jika hanya satu tabel pasangan key-value yang di-assign.

```yuescript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

<YueDisplay>

```yue
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

</YueDisplay>

Baris baru dapat digunakan untuk memisahkan nilai sebagai ganti koma (atau keduanya):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

<YueDisplay>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

</YueDisplay>

Saat membuat literal tabel satu baris, kurung kurawal juga bisa dihilangkan:

```yuescript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

<YueDisplay>

```yue
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

</YueDisplay>

Kunci literal tabel dapat berupa kata kunci bahasa tanpa perlu di-escape:

```yuescript
tbl = {
  do: "something"
  end: "hunger"
}
```

<YueDisplay>

```yue
tbl = {
  do: "something"
  end: "hunger"
}
```

</YueDisplay>

Jika Anda membangun tabel dari variabel dan ingin kunci sama dengan nama variabel, maka operator prefiks **:** dapat digunakan:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

<YueDisplay>

```yue
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</YueDisplay>

Jika Anda ingin kunci field dalam tabel menjadi hasil suatu ekspresi, Anda dapat membungkusnya dengan **[ ]**, seperti di Lua. Anda juga bisa menggunakan literal string langsung sebagai kunci tanpa tanda kurung siku. Ini berguna jika kunci memiliki karakter khusus.

```yuescript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

<YueDisplay>

```yue
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

</YueDisplay>

Tabel Lua memiliki bagian array dan bagian hash, tetapi terkadang Anda ingin membedakan penggunaan array dan hash secara semantik saat menulis tabel Lua. Maka Anda bisa menulis tabel Lua dengan **[ ]** alih-alih **{ }** untuk merepresentasikan tabel array, dan menuliskan pasangan key-value di tabel list tidak akan diizinkan.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

</YueDisplay>
