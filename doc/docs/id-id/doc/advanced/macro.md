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

## Menghasilkan kode multi-baris

Saat macro mengembalikan kode Yue multi-baris, penggunaan string multi-baris di dalam tanda kutip tidak direkomendasikan. Sebaiknya gunakan `-> |`.

String bertanda kutip mempertahankan teks apa adanya, sedangkan string multi-baris YAML menghapus indentasi awal yang sama. Ini biasanya membuat blok Yue yang dihasilkan lebih stabil, terutama ketika kode yang dihasilkan berisi komentar atau blok bertingkat.

```yuescript
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

<YueDisplay>

```yue
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

</YueDisplay>

```yuescript
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

<YueDisplay>

```yue
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
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

## Pernyataan anotasi

Pernyataan anotasi menerapkan sebuah macro ke pernyataan yang tepat mengikutinya.

Ini setara dengan memanggil macro sambil menambahkan kode sumber dari pernyataan berikutnya sebagai argumen terakhir.

```yuescript
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

<YueDisplay>

```yue
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

</YueDisplay>

Saat macro anotasi mengembalikan tabel konfigurasi, field opsional `before` mengatur apakah hasil yang dihasilkan akan diletakkan sebelum atau sesudah pernyataan yang dianotasi.

```yuescript
macro Tag = (tag, code) ->
  tableName = code\match "^[%w_]+"
  return
    type: "text"
    before: tag == "before"
    code: "-- #{tag}:#{tableName}"

$[Tag before]
tableA = {}

$[Tag after]
tableB = {}

return
```

<YueDisplay>

```yue
macro Tag = (tag, code) ->
  tableName = code\match "^[%w_]+"
  return
    type: "text"
    before: tag == "before"
    code: "-- #{tag}:#{tableName}"

$[Tag before]
tableA = {}

$[Tag after]
tableB = {}

return
```

</YueDisplay>

Karena pernyataan berikutnya diteruskan sebagai argumen macro tambahan, anotasi juga bisa digunakan untuk menghasilkan kode registrasi langsung dari deklarasi class. Anda juga dapat menggunakan pemeriksaan argumen AST yang sama seperti pada macro biasa.

```yuescript
macro Register = (registry, code`ClassDecl) ->
  className = code\match "^class%s+(%w+)"
  return |
    #{registry}["#{className}"] = #{className}

registry = {}

$[Register(registry)]
class Worker
  run: => "ok"

return
```

<YueDisplay>

```yue
macro Register = (registry, code`ClassDecl) ->
  className = code\match "^class%s+(%w+)"
  return |
    #{registry}["#{className}"] = #{className}

registry = {}

$[Register(registry)]
class Worker
  run: => "ok"

return
```

</YueDisplay>

Anotasi juga bisa menyisipkan kode pembungkus di sekitar fungsi:

```yuescript
macro ValidateNumberArgs = (code) ->
  funcName = code\match "^(%w+)%s*="
  return |
    local __orig_#{funcName} = #{funcName}
    #{funcName} = (...) ->
      for i = 1, select "#", ...
        assert type(select i, ...) == "number", "expected number for arg \#{i}"
      __orig_#{funcName} ...

$[ValidateNumberArgs]
add = (a, b) -> a + b
```

<YueDisplay>

```yue
macro ValidateNumberArgs = (code) ->
  funcName = code\match "^(%w+)%s*="
  return |
    local __orig_#{funcName} = #{funcName}
    #{funcName} = (...) ->
      for i = 1, select "#", ...
        assert type(select i, ...) == "number", "expected number for arg \#{i}"
      __orig_#{funcName} ...

$[ValidateNumberArgs]
add = (a, b) -> a + b
```

</YueDisplay>

Sebuah anotasi harus selalu diikuti oleh sebuah pernyataan, dan tidak bisa diterapkan ke pernyataan `return`. Jika pernyataan yang dianotasi berada di akhir sebuah blok dan Anda membutuhkan bentuk AST mentah dari pernyataan itu, tambahkan `return` eksplisit setelahnya agar ia tidak dibungkus menjadi ekspresi yang dikembalikan secara implisit.
