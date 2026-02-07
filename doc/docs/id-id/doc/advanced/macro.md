# Makro

## Penggunaan Umum

Fungsi macro digunakan untuk mengevaluasi string pada waktu kompilasi dan menyisipkan kode yang dihasilkan ke kompilasi akhir.

```yuescript
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'hello world'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- ekspresi yang dikirim diperlakukan sebagai string
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

<YueDisplay>

```yue
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'hello world'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- ekspresi yang dikirim diperlakukan sebagai string
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

</YueDisplay>

## Menyisipkan Kode Mentah

Fungsi macro bisa mengembalikan string YueScript atau tabel konfigurasi yang berisi kode Lua.

```yuescript
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "gagal meng-assign ke variabel yang didefinisikan oleh macro Yue"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "gagal meng-assign ke variabel yang didefinisikan oleh macro Lua"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- simbol awal dan akhir string mentah otomatis di-trim
$lua[==[
-- penyisipan kode Lua mentah
if cond then
  print("output")
end
]==]
```

<YueDisplay>

```yue
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "gagal meng-assign ke variabel yang didefinisikan oleh macro Yue"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "gagal meng-assign ke variabel yang didefinisikan oleh macro Lua"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- simbol awal dan akhir string mentah otomatis di-trim
$lua[==[
-- penyisipan kode Lua mentah
if cond then
  print("output")
end
]==]
```

</YueDisplay>

## Export Macro

Fungsi macro dapat diekspor dari modul dan diimpor di modul lain. Anda harus menaruh fungsi macro export dalam satu file agar dapat digunakan, dan hanya definisi macro, impor macro, dan ekspansi macro yang boleh ada di modul export macro.

```yuescript
-- file: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- file main.yue
import "utils" as {
  $, -- simbol untuk mengimpor semua macro
  $foreach: $each -- ganti nama macro $foreach menjadi $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```

<YueDisplay>

```yue
-- file: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- file main.yue
-- fungsi import tidak tersedia di browser, coba di lingkungan nyata
--[[
import "utils" as {
  $, -- simbol untuk mengimpor semua macro
  $foreach: $each -- ganti nama macro $foreach menjadi $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
]]
```

</YueDisplay>

## Macro Bawaan

Ada beberapa macro bawaan tetapi Anda bisa menimpanya dengan mendeklarasikan macro dengan nama yang sama.

```yuescript
print $FILE -- mendapatkan string nama modul saat ini
print $LINE -- mendapatkan angka 2
```

<YueDisplay>

```yue
print $FILE -- mendapatkan string nama modul saat ini
print $LINE -- mendapatkan angka 2
```

</YueDisplay>

## Menghasilkan Macro dengan Macro

Di YueScript, fungsi macro memungkinkan Anda menghasilkan kode pada waktu kompilasi. Dengan menumpuk fungsi macro, Anda dapat membuat pola generasi yang lebih kompleks. Fitur ini memungkinkan Anda mendefinisikan fungsi macro yang menghasilkan fungsi macro lain, sehingga menghasilkan kode yang lebih dinamis.

```yuescript
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "Valid enum type:", $BodyType Static
-- print "Compilation error with enum type:", $BodyType Unknown
```

<YueDisplay>

```yue
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "Valid enum type:", $BodyType Static
-- print "Compilation error with enum type:", $BodyType Unknown
```

</YueDisplay>

## Validasi Argumen

Anda dapat mendeklarasikan tipe node AST yang diharapkan dalam daftar argumen, dan memeriksa apakah argumen macro yang masuk memenuhi harapan pada waktu kompilasi.

```yuescript
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

<YueDisplay>

```yue
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

</YueDisplay>

Jika Anda membutuhkan pengecekan argumen yang lebih fleksibel, Anda dapat menggunakan fungsi macro bawaan `$is_ast` untuk memeriksa secara manual pada tempat yang tepat.

```yuescript
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

<YueDisplay>

```yue
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

</YueDisplay>

Untuk detail lebih lanjut tentang node AST yang tersedia, silakan lihat definisi huruf besar di [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp).
