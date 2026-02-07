# Literal Fungsi

Semua fungsi dibuat menggunakan ekspresi fungsi. Fungsi sederhana ditandai dengan panah: **->**.

```yuescript
my_function = ->
my_function() -- memanggil fungsi kosong
```

<YueDisplay>

```yue
my_function = ->
my_function() -- memanggil fungsi kosong
```

</YueDisplay>

Badan fungsi bisa berupa satu pernyataan yang ditulis langsung setelah panah, atau berupa serangkaian pernyataan yang diindentasi di baris berikutnya:

```yuescript
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

<YueDisplay>

```yue
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

</YueDisplay>

Jika fungsi tidak memiliki argumen, ia dapat dipanggil menggunakan operator `!`, sebagai ganti tanda kurung kosong. Pemanggilan `!` adalah cara yang disarankan untuk memanggil fungsi tanpa argumen.

```yuescript
func_a!
func_b()
```

<YueDisplay>

```yue
func_a!
func_b()
```

</YueDisplay>

Fungsi dengan argumen dapat dibuat dengan menaruh daftar nama argumen dalam tanda kurung sebelum panah:

```yuescript
sum = (x, y) -> print "sum", x + y
```

<YueDisplay>

```yue
sum = (x, y) -> print "sum", x + y
```

</YueDisplay>

Fungsi dapat dipanggil dengan menuliskan argumen setelah nama ekspresi yang mengevaluasi ke fungsi. Saat merangkai pemanggilan fungsi, argumen diterapkan ke fungsi terdekat di sebelah kiri.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

<YueDisplay>

```yue
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

</YueDisplay>

Untuk menghindari ambiguitas saat memanggil fungsi, tanda kurung juga bisa digunakan untuk mengelilingi argumen. Ini diperlukan di sini agar argumen yang tepat dikirim ke fungsi yang tepat.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

<YueDisplay>

```yue
print "x:", sum(10, 20), "y:", sum(30, 40)
```

</YueDisplay>

Tidak boleh ada spasi antara tanda kurung buka dan nama fungsi.

Fungsi akan memaksa pernyataan terakhir di badannya menjadi pernyataan return, ini disebut return implisit:

```yuescript
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

<YueDisplay>

```yue
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

</YueDisplay>

Dan jika Anda perlu return secara eksplisit, Anda bisa menggunakan kata kunci `return`:

```yuescript
sum = (x, y) -> return x + y
```

<YueDisplay>

```yue
sum = (x, y) -> return x + y
```

</YueDisplay>

Seperti di Lua, fungsi dapat mengembalikan beberapa nilai. Pernyataan terakhir harus berupa daftar nilai yang dipisahkan koma:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

<YueDisplay>

```yue
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

</YueDisplay>

## Panah Tebal

Karena sudah menjadi idiom di Lua untuk mengirim objek sebagai argumen pertama saat memanggil method, disediakan sintaks khusus untuk membuat fungsi yang otomatis menyertakan argumen `self`.

```yuescript
func = (num) => @value + num
```

<YueDisplay>

```yue
func = (num) => @value + num
```

</YueDisplay>

## Nilai Default Argumen

Dimungkinkan untuk menyediakan nilai default bagi argumen fungsi. Argumen dianggap kosong jika nilainya nil. Argumen nil yang memiliki nilai default akan diganti sebelum badan fungsi dijalankan.

```yuescript
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

<YueDisplay>

```yue
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

</YueDisplay>

Ekspresi nilai default argumen dievaluasi di dalam badan fungsi sesuai urutan deklarasi argumen. Karena itu, nilai default dapat mengakses argumen yang dideklarasikan sebelumnya.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

<YueDisplay>

```yue
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

</YueDisplay>

## Pertimbangan

Karena cara pemanggilan fungsi tanpa tanda kurung yang ekspresif, beberapa pembatasan harus diterapkan untuk menghindari ambiguitas parsing yang melibatkan spasi.

Tanda minus memiliki dua peran, operator negasi unari dan operator pengurangan biner. Perhatikan bagaimana contoh berikut dikompilasi:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

<YueDisplay>

```yue
a = x - 10
b = x-10
c = x -y
d = x- z
```

</YueDisplay>

Prioritas argumen pertama pada pemanggilan fungsi dapat dikendalikan menggunakan spasi jika argumennya adalah literal string. Di Lua, sudah umum untuk menghilangkan tanda kurung saat memanggil fungsi dengan satu literal string atau tabel.

Ketika tidak ada spasi antara variabel dan literal string, pemanggilan fungsi akan memiliki prioritas atas ekspresi yang mengikuti. Tidak ada argumen lain yang dapat diberikan pada fungsi ketika dipanggil dengan cara ini.

Ketika ada spasi setelah variabel dan literal string, pemanggilan fungsi bertindak seperti yang dijelaskan di atas. Literal string menjadi milik ekspresi berikutnya (jika ada), yang berfungsi sebagai daftar argumen.

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```

<YueDisplay>

```yue
x = func"hello" + 100
y = func "hello" + 100
```

</YueDisplay>

## Argumen Multi-baris

Saat memanggil fungsi yang menerima banyak argumen, akan lebih nyaman untuk memecah daftar argumen menjadi beberapa baris. Karena sifat bahasa yang peka terhadap spasi, perlu hati-hati saat memecah daftar argumen.

Jika daftar argumen akan dilanjutkan ke baris berikutnya, baris saat ini harus diakhiri dengan koma. Dan baris berikutnya harus lebih terindentasi daripada indentasi saat ini. Setelah diindentasi, semua baris argumen lainnya harus berada pada tingkat indentasi yang sama agar menjadi bagian dari daftar argumen.

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

<YueDisplay>

```yue
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

</YueDisplay>

Jenis pemanggilan ini dapat dinest. Tingkat indentasi digunakan untuk menentukan argumen milik fungsi yang mana.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

<YueDisplay>

```yue
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

</YueDisplay>

Karena tabel juga menggunakan koma sebagai pemisah, sintaks indentasi ini membantu agar nilai menjadi bagian dari daftar argumen, bukan bagian dari tabel.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

<YueDisplay>

```yue
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

</YueDisplay>

Meskipun jarang, perhatikan bahwa kita bisa memberikan indentasi yang lebih dalam untuk argumen fungsi jika kita tahu akan menggunakan indentasi yang lebih dangkal di bagian selanjutnya.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

<YueDisplay>

```yue
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

</YueDisplay>

Hal yang sama juga dapat dilakukan pada pernyataan tingkat blok lainnya seperti kondisional. Kita bisa menggunakan tingkat indentasi untuk menentukan nilai milik pernyataan apa:

```yuescript
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
```

<YueDisplay>

```yue
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
```

</YueDisplay>

## Destrukturisasi Parameter

YueScript kini mendukung destrukturisasi parameter fungsi ketika argumen berupa objek. Dua bentuk destrukturisasi literal tabel tersedia:

- **Literal berkurung kurawal/parameter objek**, memungkinkan nilai default opsional ketika field hilang (misalnya, `{:a, :b}`, `{a: a1 = 123}`).

- **Sintaks tabel sederhana tanpa pembungkus**, dimulai dengan urutan key-value atau binding singkat dan berlanjut sampai ekspresi lain menghentikannya (misalnya, `:a, b: b1, :c`). Bentuk ini mengekstrak beberapa field dari objek yang sama.

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

<YueDisplay>

```yue
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

</YueDisplay>

## Ekspresi Return Berawalan

Saat bekerja dengan badan fungsi yang sangat bertingkat, menjaga keterbacaan dan konsistensi nilai return bisa terasa melelahkan. Untuk mengatasinya, YueScript memperkenalkan sintaks **Ekspresi Return Berawalan**. Bentuknya sebagai berikut:

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

<YueDisplay>

```yue
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

</YueDisplay>

Ini setara dengan:

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

<YueDisplay>

```yue
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

</YueDisplay>

Satu-satunya perbedaan adalah Anda dapat memindahkan ekspresi return terakhir sebelum token `->` atau `=>` untuk menunjukkan nilai return implisit fungsi sebagai pernyataan terakhir. Dengan cara ini, bahkan pada fungsi dengan banyak loop bertingkat atau cabang kondisional, Anda tidak lagi perlu menulis ekspresi return di akhir badan fungsi, sehingga struktur logika menjadi lebih lurus dan mudah diikuti.

## Varargs Bernama

Anda dapat menggunakan sintaks `(...t) ->` untuk otomatis menyimpan varargs ke tabel bernama. Tabel ini berisi semua argumen yang diteruskan (termasuk nilai `nil`), dan field `n` pada tabel menyimpan jumlah argumen yang benar-benar diteruskan (termasuk nilai `nil`).

```yuescript
f = (...t) ->
  print "argument count:", t.n
  print "table length:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Menangani kasus dengan nilai nil
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

<YueDisplay>

```yue
f = (...t) ->
  print "argument count:", t.n
  print "table length:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Menangani kasus dengan nilai nil
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

</YueDisplay>
