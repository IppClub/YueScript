# Pernyataan Switch

Pernyataan switch adalah bentuk singkat untuk menulis serangkaian if yang membandingkan nilai yang sama. Perhatikan bahwa nilainya hanya dievaluasi sekali. Seperti if, switch bisa memiliki blok else untuk menangani tidak ada yang cocok. Perbandingan dilakukan dengan operator `==`. Di dalam switch, Anda juga bisa memakai ekspresi assignment untuk menyimpan nilai variabel sementara.

```yuescript
switch name := "Dan"
  when "Robert"
    print "You are Robert"
  when "Dan", "Daniel"
    print "Your name, it's Dan"
  else
    print "I don't know about you with name #{name}"
```

<YueDisplay>

```yue
switch name := "Dan"
  when "Robert"
    print "You are Robert"
  when "Dan", "Daniel"
    print "Your name, it's Dan"
  else
    print "I don't know about you with name #{name}"
```

</YueDisplay>

Klausa when pada switch bisa mencocokkan beberapa nilai dengan menuliskannya dipisah koma.

Switch juga bisa dipakai sebagai ekspresi; di sini kita dapat menetapkan hasil switch ke sebuah variabel:

```yuescript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "can't count that high!"
```

<YueDisplay>

```yue
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "can't count that high!"
```

</YueDisplay>

Kita bisa memakai kata kunci `then` untuk menulis blok when switch pada satu baris. Tidak ada kata kunci tambahan yang dibutuhkan untuk menulis blok else pada satu baris.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
```

<YueDisplay>

```yue
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
```

</YueDisplay>

Jika Anda ingin menulis kode dengan satu indentasi lebih sedikit saat menulis switch, Anda bisa menaruh klausa when pertama pada baris awal pernyataan, lalu semua klausa lain dapat ditulis dengan satu indentasi lebih sedikit.

```yuescript
switch math.random(1, 5)
  when 1
    print "you are lucky" -- two indents
  else
    print "not so lucky"

switch math.random(1, 5) when 1
  print "you are lucky" -- one indent
else
  print "not so lucky"
```

<YueDisplay>

```yue
switch math.random(1, 5)
  when 1
    print "you are lucky" -- two indents
  else
    print "not so lucky"

switch math.random(1, 5) when 1
  print "you are lucky" -- one indent
else
  print "not so lucky"
```

</YueDisplay>

Perlu dicatat urutan ekspresi perbandingan kasus. Ekspresi kasus berada di sisi kiri. Ini bisa berguna jika ekspresi kasus ingin mengganti cara perbandingan dengan mendefinisikan metamethod `eq`.

## Pencocokan Tabel

Anda bisa melakukan pencocokan tabel dalam klausa when switch, jika tabel dapat didestrukturisasi oleh struktur tertentu dan mendapatkan nilai non-nil.

```yuescript
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "size #{width}, #{height}"
```

<YueDisplay>

```yue
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "size #{width}, #{height}"
```

</YueDisplay>

Anda dapat menggunakan nilai default untuk mendestrukturisasi tabel secara opsional pada beberapa field.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
```

<YueDisplay>

```yue
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
```

</YueDisplay>

Anda juga bisa mencocokkan elemen array, field tabel, dan bahkan struktur bertingkat dengan literal array atau tabel.

Cocokkan terhadap elemen array.

```yuescript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b has a default value
    print "1, 2, #{b}"
```

<YueDisplay>

```yue
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b has a default value
    print "1, 2, #{b}"
```

</YueDisplay>

Cocokkan terhadap field tabel dengan destrukturisasi.

```yuescript
switch tb
  when success: true, :result
    print "success", result
  when success: false
    print "failed", result
  else
    print "invalid"
```

<YueDisplay>

```yue
switch tb
  when success: true, :result
    print "success", result
  when success: false
    print "failed", result
  else
    print "invalid"
```

</YueDisplay>

Cocokkan terhadap struktur tabel bertingkat.

```yuescript
switch tb
  when data: {type: "success", :content}
    print "success", content
  when data: {type: "error", :content}
    print "failed", content
  else
    print "invalid"
```

<YueDisplay>

```yue
switch tb
  when data: {type: "success", :content}
    print "success", content
  when data: {type: "error", :content}
    print "failed", content
  else
    print "invalid"
```

</YueDisplay>

Cocokkan terhadap array dari tabel.

```yuescript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "matched", fourth
```

<YueDisplay>

```yue
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "matched", fourth
```

</YueDisplay>

Cocokkan terhadap daftar dan tangkap rentang elemen.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- prints: {"admin", "users"}
    print "Resource:", resource -- prints: "logs"
    print "Action:", action -- prints: "view"
```

<YueDisplay>

```yue
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- prints: {"admin", "users"}
    print "Resource:", resource -- prints: "logs"
    print "Action:", action -- prints: "view"
```

</YueDisplay>
