# Operator

Semua operator biner dan unari Lua tersedia. Selain itu **!=** adalah alias untuk **~=**, dan **\\** atau **::** bisa digunakan untuk menulis pemanggilan fungsi berantai seperti `tb\func!` atau `tb::func!`. YueScript juga menawarkan beberapa operator khusus lain untuk menulis kode yang lebih ekspresif.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

<YueDisplay>

```yue
tb\func! if tb ~= nil
tb::func! if tb != nil
```

</YueDisplay>

## Perbandingan Berantai

Perbandingan bisa dirantai secara bebas:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
```

<YueDisplay>

```yue
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
```

</YueDisplay>

Perhatikan perilaku evaluasi perbandingan berantai:

```yuescript
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  output:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  output:
  2
  1
  false
]]
```

<YueDisplay>

```yue
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  output:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  output:
  2
  1
  false
]]
```

</YueDisplay>

Ekspresi tengah hanya dievaluasi sekali, bukan dua kali seperti jika ekspresi ditulis sebagai `v(1) < v(2) and v(2) <= v(3)`. Namun, urutan evaluasi pada perbandingan berantai tidak didefinisikan. Sangat disarankan untuk tidak menggunakan ekspresi dengan efek samping (seperti `print`) di perbandingan berantai. Jika efek samping diperlukan, operator short-circuit `and` sebaiknya digunakan secara eksplisit.

## Menambahkan ke Tabel

Operator **[] =** digunakan untuk menambahkan nilai ke tabel.

```yuescript
tab = []
tab[] = "Value"
```

<YueDisplay>

```yue
tab = []
tab[] = "Value"
```

</YueDisplay>

Anda juga bisa memakai operator spread `...` untuk menambahkan semua elemen dari satu list ke list lain:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA sekarang [1, 2, 3, 4, 5, 6]
```

<YueDisplay>

```yue
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA sekarang [1, 2, 3, 4, 5, 6]
```

</YueDisplay>

## Penyebaran Tabel

Anda bisa menggabungkan tabel array atau tabel hash menggunakan operator spread `...` sebelum ekspresi di literal tabel.

```yuescript
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

<YueDisplay>

```yue
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

</YueDisplay>

## Indeks Balik Tabel

Anda dapat menggunakan operator **#** untuk mendapatkan elemen terakhir dari tabel.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

<YueDisplay>

```yue
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

</YueDisplay>

## Metatable

Operator **<>** dapat digunakan sebagai pintasan untuk manipulasi metatable.

### Pembuatan Metatable

Buat tabel normal dengan tanda kurung siku kosong **<>** atau kunci metamethod yang dikelilingi oleh **<>**.

```yuescript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- set field dengan variabel bernama sama
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "out of scope"
```

<YueDisplay>

```yue
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- set field dengan variabel bernama sama
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "out of scope"
```

</YueDisplay>

### Mengakses Metatable

Akses metatable dengan **<>**, nama metamethod yang dikelilingi **<>**, atau menulis ekspresi di dalam **<>**.

```yuescript
-- dibuat dengan metatable yang berisi field "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```

<YueDisplay>

```yue
-- dibuat dengan metatable yang berisi field "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value
tb.<> = __index: {item: "hello"}
print tb.item
```

</YueDisplay>

### Destrukturisasi Metatable

Destrukturisasi metatable dengan kunci metamethod yang dikelilingi **<>**.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

<YueDisplay>

```yue
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

</YueDisplay>

## Keberadaan

Operator **?** dapat digunakan dalam berbagai konteks untuk memeriksa keberadaan.

```yuescript
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

<YueDisplay>

```yue
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

</YueDisplay>

## Piping

Sebagai ganti serangkaian pemanggilan fungsi bersarang, Anda bisa mengalirkan nilai dengan operator **|>**.

```yuescript
"hello" |> print
1 |> print 2 -- sisipkan nilai pipe sebagai argumen pertama
2 |> print 1, _, 3 -- pipe dengan placeholder

-- ekspresi pipe multi-baris
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

<YueDisplay>

```yue
"hello" |> print
1 |> print 2 -- sisipkan nilai pipe sebagai argumen pertama
2 |> print 1, _, 3 -- pipe dengan placeholder
-- ekspresi pipe multi-baris
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

</YueDisplay>

## Nil Coalescing

Operator nil-coalescing **??** mengembalikan nilai dari operan kiri jika bukan **nil**; jika tidak, operator mengevaluasi operan kanan dan mengembalikan hasilnya. Operator **??** tidak mengevaluasi operan kanan jika operan kiri bernilai non-nil.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

<YueDisplay>

```yue
local a, b, c, d
a = b ?? c ?? d
func a ?? {}
a ??= false
```

</YueDisplay>

## Objek Implisit

Anda dapat menulis daftar struktur implisit yang diawali simbol **\*** atau **-** di dalam blok tabel. Jika Anda membuat objek implisit, field objek harus berada pada indentasi yang sama.

```yuescript
-- assignment dengan objek implisit
list =
  * 1
  * 2
  * 3

-- pemanggilan fungsi dengan objek implisit
func
  * 1
  * 2
  * 3

-- return dengan objek implisit
f = ->
  return
    * 1
    * 2
    * 3

-- tabel dengan objek implisit
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }

```

<YueDisplay>

```yue
-- assignment dengan objek implisit
list =
  * 1
  * 2
  * 3

-- pemanggilan fungsi dengan objek implisit
func
  * 1
  * 2
  * 3

-- return dengan objek implisit
f = ->
  return
    * 1
    * 2
    * 3

-- tabel dengan objek implisit
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }
```

</YueDisplay>
