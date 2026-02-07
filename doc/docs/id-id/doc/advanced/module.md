# Modul

## Import

Pernyataan `import` adalah sintaks sugar untuk me-require modul atau membantu mengekstrak item dari modul yang diimpor. Item yang diimpor bersifat `const` secara default.

```yuescript
-- digunakan sebagai destrukturisasi tabel
do
  import insert, concat from table
  -- akan error saat meng-assign ke insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- shortcut untuk require implisit
  import x, y, z from 'mymodule'
  -- import gaya Python
  from 'module' import a, b, c

-- shortcut untuk require modul
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- require modul dengan aliasing atau destrukturisasi tabel
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

<YueDisplay>

```yue
-- digunakan sebagai destrukturisasi tabel
do
  import insert, concat from table
  -- akan error saat meng-assign ke insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- shortcut untuk require implisit
  import x, y, z from 'mymodule'
  -- import gaya Python
  from 'module' import a, b, c

-- shortcut untuk require modul
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- require modul dengan aliasing atau destrukturisasi tabel
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

</YueDisplay>

## Import Global

Anda dapat mengimpor global tertentu ke variabel local dengan `import`. Saat mengimpor rangkaian akses variabel global, field terakhir akan di-assign ke variabel local.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

<YueDisplay>

```yue
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

</YueDisplay>

### Import Variabel Global Otomatis

Anda dapat menempatkan `import global` di awal blok untuk mengimpor secara otomatis semua nama yang belum dideklarasikan atau di-assign secara eksplisit di scope saat ini sebagai global. Import implisit ini diperlakukan sebagai local const yang mereferensikan global terkait pada posisi pernyataan tersebut.

Nama yang secara eksplisit dideklarasikan sebagai global di scope yang sama tidak akan diimpor, sehingga Anda masih bisa meng-assign ke mereka.

```yuescript
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- error: imported globals are const

do
  -- variabel global eksplisit tidak akan diimpor
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

<YueDisplay>

```yue
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- error: imported globals are const

do
  -- variabel global eksplisit tidak akan diimpor
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

</YueDisplay>

## Export

Pernyataan `export` menawarkan cara ringkas untuk mendefinisikan modul.

### Export Bernama

Export bernama akan mendefinisikan variabel local sekaligus menambahkan field di tabel export.

```yuescript
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

<YueDisplay>

```yue
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

</YueDisplay>

Melakukan export bernama dengan destrukturisasi.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

<YueDisplay>

```yue
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

</YueDisplay>

Export item bernama dari modul tanpa membuat variabel local.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

<YueDisplay>

```yue
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

</YueDisplay>

### Export Tanpa Nama

Export tanpa nama akan menambahkan item target ke bagian array dari tabel export.

```yuescript
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

<YueDisplay>

```yue
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

</YueDisplay>

### Export Default

Gunakan kata kunci **default** dalam pernyataan export untuk mengganti tabel export dengan apa pun.

```yuescript
export default ->
  print "hello"
  123
```

<YueDisplay>

```yue
export default ->
  print "hello"
  123
```

</YueDisplay>
