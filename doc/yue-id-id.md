# Dokumentasi YueScript

Selamat datang di dokumentasi resmi <b>YueScript</b>!<br/>
Di sini Anda dapat menemukan fitur bahasa, penggunaan, contoh referensi, dan sumber daya.<br/>
Silakan pilih bab dari sidebar untuk mulai mempelajari YueScript.

# Do

Saat digunakan sebagai pernyataan, `do` bekerja seperti di Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil di sini
```

`do` di YueScript juga bisa digunakan sebagai ekspresi, memungkinkan Anda menggabungkan beberapa baris menjadi satu. Hasil ekspresi `do` adalah pernyataan terakhir di badannya.

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

```yuescript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

Ekspresi `do` mendukung penggunaan `break` untuk memutus alur eksekusi dan mengembalikan banyak nilai lebih awal.

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

# Dekorator Baris

Untuk kemudahan, loop for dan pernyataan if dapat diterapkan pada pernyataan tunggal di akhir baris:

```yuescript
print "hello world" if name == "Rob"
```

Dan dengan loop dasar:

```yuescript
print "item: ", item for item in *items
```

Dan dengan loop while:

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

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

## Macro Bawaan

Ada beberapa macro bawaan tetapi Anda bisa menimpanya dengan mendeklarasikan macro dengan nama yang sama.

```yuescript
print $FILE -- mendapatkan string nama modul saat ini
print $LINE -- mendapatkan angka 2
```

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

```yuescript
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

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

Jika Anda membutuhkan pengecekan argumen yang lebih fleksibel, Anda dapat menggunakan fungsi macro bawaan `$is_ast` untuk memeriksa secara manual pada tempat yang tepat.

```yuescript
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

Untuk detail lebih lanjut tentang node AST yang tersedia, silakan lihat definisi huruf besar di [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp).

# Try

Sintaks untuk penanganan error Lua dalam bentuk umum.

```yuescript
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- bekerja dengan pola if assignment
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

## Try?

`try?` adalah bentuk sederhana untuk penanganan error yang menghilangkan status boolean dari pernyataan `try`, dan akan mengembalikan hasil dari blok try ketika berhasil, atau mengembalikan nil alih-alih objek error bila gagal.

```yuescript
a, b, c = try? func!

-- dengan operator nil coalescing
a = (try? func!) ?? "default"

-- sebagai argumen fungsi
f try? func!

-- dengan blok catch
f try?
  print 123
  func!
catch e
  print e
  e
```

# Literal Tabel

Seperti di Lua, tabel dibatasi dengan kurung kurawal.

```yuescript
some_values = {1, 2, 3, 4}
```

Berbeda dengan Lua, assignment nilai ke sebuah kunci di tabel dilakukan dengan **:** (bukan **=**).

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

Kurung kurawal dapat dihilangkan jika hanya satu tabel pasangan key-value yang di-assign.

```yuescript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

Baris baru dapat digunakan untuk memisahkan nilai sebagai ganti koma (atau keduanya):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

Saat membuat literal tabel satu baris, kurung kurawal juga bisa dihilangkan:

```yuescript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

Kunci literal tabel dapat berupa kata kunci bahasa tanpa perlu di-escape:

```yuescript
tbl = {
  do: "something"
  end: "hunger"
}
```

Jika Anda membangun tabel dari variabel dan ingin kunci sama dengan nama variabel, maka operator prefiks **:** dapat digunakan:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

Jika Anda ingin kunci field dalam tabel menjadi hasil suatu ekspresi, Anda dapat membungkusnya dengan **[ ]**, seperti di Lua. Anda juga bisa menggunakan literal string langsung sebagai kunci tanpa tanda kurung siku. Ini berguna jika kunci memiliki karakter khusus.

```yuescript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

Tabel Lua memiliki bagian array dan bagian hash, tetapi kadang-kadang berguna untuk membuat perbedaan semantik di antara keduanya. Anda dapat menggunakan **[ ]** sebagai ganti **{ }** untuk mendeklarasikan tabel secara eksplisit sebagai array, dengan begitu akan mencegah pasangan key-value dituliskan di dalamnya.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

# Komprehensi

Komprehensi menyediakan sintaks yang nyaman untuk membangun tabel baru dengan mengiterasi objek yang ada dan menerapkan ekspresi pada nilainya. Ada dua jenis komprehensi: komprehensi list dan komprehensi tabel. Keduanya menghasilkan tabel Lua; komprehensi list mengakumulasi nilai ke tabel mirip array, dan komprehensi tabel memungkinkan Anda menetapkan kunci dan nilai pada setiap iterasi.

## Komprehensi List

Berikut membuat salinan tabel `items` tetapi semua nilainya digandakan.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

Item yang disertakan dalam tabel baru bisa dibatasi dengan klausa `when`:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

Karena umum untuk mengiterasi nilai dari tabel berindeks numerik, operator **\*** diperkenalkan. Contoh `doubled` bisa ditulis ulang sebagai:

```yuescript
doubled = [item * 2 for item in *items]
```

Dalam komprehensi list, Anda juga bisa menggunakan operator spread `...` untuk meratakan list bertingkat, menghasilkan efek flat map:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat sekarang [1, 2, 3, 4, 5, 6]
```

Klausa `for` dan `when` dapat dirantai sebanyak yang diinginkan. Satu-satunya syarat adalah komprehensi memiliki setidaknya satu klausa `for`.

Menggunakan beberapa klausa `for` sama seperti menggunakan loop bertingkat:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

Perulangan for numerik juga bisa digunakan dalam komprehensi:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

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

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

Operator **\*** juga didukung. Di sini kita membuat tabel lookup akar kuadrat untuk beberapa angka.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

Tuple key-value dalam komprehensi tabel juga bisa berasal dari satu ekspresi, yang berarti ekspresi tersebut harus mengembalikan dua nilai. Nilai pertama digunakan sebagai kunci dan nilai kedua digunakan sebagai nilai:

Dalam contoh ini kita mengonversi array pasangan menjadi tabel di mana item pertama dalam pasangan menjadi kunci dan item kedua menjadi nilai.

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

## Slicing

Sintaks khusus disediakan untuk membatasi item yang diiterasi saat menggunakan operator **\***. Ini setara dengan mengatur batas iterasi dan ukuran langkah pada loop for.

Di sini kita bisa menetapkan batas minimum dan maksimum, mengambil semua item dengan indeks antara 1 dan 5 (inklusif):

```yuescript
slice = [item for item in *items[1, 5]]
```

Salah satu argumen slice boleh dikosongkan untuk menggunakan default yang masuk akal. Pada contoh ini, jika indeks maksimum dikosongkan, defaultnya adalah panjang tabel. Ini akan mengambil semua item kecuali elemen pertama:

```yuescript
slice = [item for item in *items[2,]]
```

Jika batas minimum dikosongkan, defaultnya adalah 1. Di sini kita hanya memberikan ukuran langkah dan membiarkan batas lainnya kosong. Ini akan mengambil semua item berindeks ganjil: (1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

Batas minimum dan maksimum bisa bernilai negatif, yang berarti batas dihitung dari akhir tabel.

```yuescript
-- ambil 4 item terakhir
slice = [item for item in *items[-4,-1]]
```

Ukuran langkah juga bisa negatif, yang berarti item diambil dalam urutan terbalik.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

### Ekspresi Slicing

Slicing juga bisa digunakan sebagai ekspresi. Ini berguna untuk mendapatkan sub-list dari sebuah tabel.

```yuescript
-- ambil item ke-2 dan ke-4 sebagai list baru
sub_list = items[2, 4]

-- ambil 4 item terakhir
last_four_items = items[-4, -1]
```

# Pemrograman Berorientasi Objek

Dalam contoh-contoh ini, kode Lua yang dihasilkan mungkin tampak berat. Sebaiknya fokus dulu pada makna kode YueScript, lalu lihat kode Lua jika Anda ingin mengetahui detail implementasinya.

Kelas sederhana:

```yuescript
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```

Kelas dideklarasikan dengan pernyataan `class` diikuti deklarasi mirip tabel di mana semua method dan properti dicantumkan.

Properti `new` bersifat khusus karena akan menjadi konstruktor.

Perhatikan bahwa semua method di kelas menggunakan sintaks fungsi panah tebal. Saat memanggil method pada instance, instance itu sendiri dikirim sebagai argumen pertama. Panah tebal menangani pembuatan argumen `self`.

Prefiks `@` pada nama variabel adalah singkatan untuk `self.`. `@items` menjadi `self.items`.

Blok kelas juga mendukung field metatable dengan menulis key metamethod dalam tanda kurung sudut, misalnya `<tostring>`.

```yuescript
class User
  new: (@name) =>
  <tostring>: => "User(#{@name})"

print tostring User "Yue"
```

Membuat instance kelas dilakukan dengan memanggil nama kelas sebagai fungsi.

```yuescript
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

Karena instance kelas perlu dikirim ke method saat dipanggil, operator `\` digunakan.

Semua properti kelas dibagikan di antara instance. Ini baik untuk fungsi, tetapi untuk jenis objek lain dapat menimbulkan hasil yang tidak diinginkan.

Pertimbangkan contoh di bawah ini, properti `clothes` dibagikan di antara semua instance, sehingga perubahan di satu instance akan terlihat di instance lainnya:

```yuescript
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "pants"
b\give_item "shirt"

-- akan mencetak pants dan shirt
print item for item in *a.clothes
```

Cara yang benar untuk menghindari masalah ini adalah membuat state yang dapat berubah di konstruktor:

```yuescript
class Person
  new: =>
    @clothes = []
```

## Pewarisan

Kata kunci `extends` dapat digunakan dalam deklarasi kelas untuk mewarisi properti dan method dari kelas lain.

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```

Di sini kita memperluas kelas Inventory, dan membatasi jumlah item yang bisa dibawa.

Dalam contoh ini, kita tidak mendefinisikan konstruktor pada subclass, sehingga konstruktor kelas induk dipanggil ketika membuat instance baru. Jika kita mendefinisikan konstruktor, kita bisa menggunakan method `super` untuk memanggil konstruktor induk.

Setiap kali sebuah kelas mewarisi dari kelas lain, ia mengirim pesan ke kelas induk dengan memanggil method `__inherited` pada kelas induk jika ada. Fungsi menerima dua argumen, kelas yang diwarisi dan kelas anak.

```yuescript
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- akan mencetak: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```

## Super

**super** adalah kata kunci khusus yang dapat digunakan dengan dua cara: sebagai objek, atau dipanggil seperti fungsi. Ia hanya memiliki fungsi khusus ketika berada di dalam kelas.

Ketika dipanggil sebagai fungsi, ia akan memanggil fungsi dengan nama yang sama di kelas induk. `self` saat ini akan otomatis dikirim sebagai argumen pertama. (Seperti pada contoh pewarisan di atas)

Ketika `super` digunakan sebagai nilai normal, ia merupakan referensi ke objek kelas induk.

Ia dapat diakses seperti objek biasa untuk mengambil nilai di kelas induk yang mungkin tertutup oleh kelas anak.

Ketika operator pemanggilan `\` digunakan dengan `super`, `self` disisipkan sebagai argumen pertama alih-alih nilai `super` itu sendiri. Saat menggunakan `.` untuk mengambil fungsi, fungsi mentah dikembalikan.

Beberapa contoh penggunaan `super` dengan cara berbeda:

```yuescript
class MyClass extends ParentClass
  a_method: =>
    -- berikut memiliki efek yang sama:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super sebagai nilai sama dengan kelas induk:
    assert super == ParentClass
```

**super** juga dapat digunakan di sisi kiri Function Stub. Perbedaan utamanya adalah, alih-alih fungsi hasil terikat pada nilai `super`, fungsi terikat pada `self`.

## Tipe

Setiap instance kelas membawa tipenya sendiri. Ini disimpan di properti khusus `__class`. Properti ini memuat objek kelas. Objek kelas adalah yang kita panggil untuk membuat instance baru. Kita juga dapat mengindeks objek kelas untuk mengambil method dan properti kelas.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- mencetak 10
```

## Objek Kelas

Objek kelas adalah yang kita buat saat menggunakan pernyataan `class`. Objek kelas disimpan dalam variabel dengan nama yang sama dengan kelas.

Objek kelas dapat dipanggil seperti fungsi untuk membuat instance baru. Begitulah cara kita membuat instance kelas pada contoh di atas.

Sebuah kelas terdiri dari dua tabel: tabel kelas itu sendiri dan tabel base. Base digunakan sebagai metatable untuk semua instance. Semua properti yang dicantumkan dalam deklarasi kelas ditempatkan di base.

Metatable objek kelas membaca properti dari base jika tidak ada di objek kelas. Ini berarti kita dapat mengakses fungsi dan properti langsung dari kelas.

Penting untuk dicatat bahwa assignment ke objek kelas tidak meng-assign ke base, sehingga itu bukan cara yang valid untuk menambahkan method baru ke instance. Sebagai gantinya, base harus diubah secara eksplisit. Lihat field `__base` di bawah.

Objek kelas memiliki beberapa properti khusus:

Nama kelas saat dideklarasikan disimpan sebagai string di field `__name` pada objek kelas.

```yuescript
print BackPack.__name -- mencetak Backpack
```

Objek base disimpan di `__base`. Kita dapat memodifikasi tabel ini untuk menambahkan fungsionalitas ke instance yang sudah dibuat maupun yang akan dibuat.

Jika kelas memperluas kelas lain, objek kelas induk disimpan di `__parent`.

## Variabel Kelas

Kita dapat membuat variabel langsung di objek kelas alih-alih di base dengan menggunakan `@` di depan nama properti pada deklarasi kelas.

```yuescript
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- variabel kelas tidak terlihat pada instance
assert Things().some_func == nil
```

Dalam ekspresi, kita dapat menggunakan `@@` untuk mengakses nilai yang disimpan di `__class` milik `self`. Jadi, `@@hello` adalah singkatan dari `self.__class.hello`.

```yuescript
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- mencetak 2
```

Semantik pemanggilan `@@` mirip dengan `@`. Memanggil nama `@@` akan meneruskan kelas sebagai argumen pertama menggunakan sintaks kolon Lua.

```yuescript
@@hello 1,2,3,4
```

## Pernyataan Deklarasi Kelas

Di dalam badan deklarasi kelas, kita bisa memiliki ekspresi normal selain pasangan key/value. Dalam konteks ini, `self` sama dengan objek kelas.

Berikut cara alternatif untuk membuat variabel kelas dibandingkan yang dijelaskan di atas:

```yuescript
class Things
  @class_var = "hello world"
```

Ekspresi ini dieksekusi setelah semua properti ditambahkan ke base.

Semua variabel yang dideklarasikan di badan kelas bersifat lokal terhadap properti kelas. Ini berguna untuk menempatkan nilai privat atau fungsi pembantu yang hanya dapat diakses oleh method kelas:

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

## Nilai @ dan @@

Ketika `@` dan `@@` diprefiks di depan sebuah nama, masing-masing merepresentasikan nama tersebut yang diakses di `self` dan `self.__class`.

Jika digunakan sendirian, keduanya adalah alias untuk `self` dan `self.__class`.

```yuescript
assert @ == self
assert @@ == self.__class
```

Contohnya, cara cepat untuk membuat instance baru dari kelas yang sama dari method instance menggunakan `@@`:

```yuescript
some_instance_method = (...) => @@ ...
```

## Promosi Properti Konstruktor

Untuk mengurangi boilerplate saat mendefinisikan objek nilai sederhana, Anda dapat menulis kelas sederhana seperti:

```yuescript
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- Yang merupakan singkatan dari

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```

Anda juga bisa menggunakan sintaks ini untuk fungsi umum guna menginisialisasi field objek.

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

## Ekspresi Kelas

Sintaks kelas juga bisa digunakan sebagai ekspresi yang dapat di-assign ke variabel atau di-return secara eksplisit.

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

## Kelas Anonim

Nama bisa dihilangkan saat mendeklarasikan kelas. Atribut `__name` akan bernilai nil, kecuali ekspresi kelas berada dalam assignment. Nama di sisi kiri assignment digunakan sebagai ganti nil.

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

Anda bahkan bisa menghilangkan badan kelas, artinya Anda bisa menulis kelas anonim kosong seperti ini:

```yuescript
x = class
```

## Pencampuran Kelas

Anda bisa melakukan mixing dengan kata kunci `using` untuk menyalin fungsi dari tabel biasa atau objek kelas yang sudah didefinisikan ke kelas baru Anda. Saat mixing dengan tabel biasa, Anda dapat mengganti fungsi pengindeksan kelas (metamethod `__index`) dengan implementasi kustom. Saat mixing dengan objek kelas yang sudah ada, metamethod objek kelas tidak akan disalin.

```yuescript
MyIndex = __index: var: 1

class X using MyIndex
  func: =>
    print 123

x = X!
print x.var

class Y using X

y = Y!
y\func!

assert y.__class.__parent ~= X -- X bukan parent dari Y
```

# Pernyataan With

Pola umum saat membuat objek adalah memanggil serangkaian fungsi dan mengatur serangkaian properti segera setelah objek dibuat.

Hal ini menyebabkan nama objek diulang berkali-kali di kode, menambah noise yang tidak perlu. Solusi umum untuk ini adalah meneruskan tabel sebagai argumen yang berisi kumpulan kunci dan nilai untuk ditimpa. Kekurangannya adalah konstruktor objek harus mendukung bentuk ini.

Blok `with` membantu mengatasi hal ini. Di dalam blok `with`, kita bisa menggunakan pernyataan khusus yang diawali dengan `.` atau `\` yang merepresentasikan operasi tersebut diterapkan pada objek yang sedang dipakai.

Sebagai contoh, kita bekerja dengan objek yang baru dibuat:

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

Pernyataan `with` juga bisa digunakan sebagai ekspresi yang mengembalikan nilai yang diberi akses.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

Ekspresi `with` mendukung `break` dengan satu nilai:

```yuescript
result = with obj
  break .value
```

Setelah `break value` digunakan di dalam `with`, ekspresi `with` tidak lagi mengembalikan objek targetnya, melainkan mengembalikan nilai dari `break`.

```yuescript
a = with obj
  .x = 1
-- a adalah obj

b = with obj
  break .x
-- b adalah .x, bukan obj
```

Berbeda dari `for` / `while` / `repeat` / `do`, `with` hanya mendukung satu nilai `break`.

Atau…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

Dalam penggunaan ini, `with` dapat dilihat sebagai bentuk khusus dari kombinator K.

Ekspresi pada pernyataan `with` juga bisa berupa assignment jika Anda ingin memberi nama pada ekspresi tersebut.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

Anda bisa mengakses kunci khusus dengan `[]` di dalam pernyataan `with`.

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- menambahkan ke "tb"
```

`with?` adalah versi yang ditingkatkan dari sintaks `with`, yang memperkenalkan pengecekan keberadaan untuk mengakses objek yang mungkin nil secara aman tanpa pemeriksaan null eksplisit.

```yuescript
with? obj
  print .name
```

# Penugasan

Variabel bersifat bertipe dinamis dan secara default dideklarasikan sebagai local. Namun Anda dapat mengubah cakupan deklarasi dengan pernyataan **local** dan **global**.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- menggunakan variabel yang sudah ada
```

## Pembaruan Nilai

Anda dapat melakukan assignment pembaruan dengan banyak operator biner.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- akan menambah local baru jika variabel local belum ada
arg or= "default value"
```

## Assignment Berantai

Anda bisa melakukan assignment berantai untuk menetapkan beberapa item ke nilai yang sama.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

## Local Eksplisit

```yuescript
do
  local a = 1
  local *
  print "deklarasikan semua variabel sebagai local di awal"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "hanya deklarasikan variabel huruf besar sebagai local di awal"
  a = 1
  B = 2
```

## Global Eksplisit

```yuescript
do
  global a = 1
  global *
  print "deklarasikan semua variabel sebagai global"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "hanya deklarasikan variabel huruf besar sebagai global"
  a = 1
  B = 2
  local Temp = "a local value"
```

# Penugasan Varargs

Anda dapat meng-assign hasil yang dikembalikan dari sebuah fungsi ke simbol varargs `...`. Lalu akses isinya menggunakan cara Lua.

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

# Penugasan pada If

Blok `if` dan `elseif` dapat menerima assignment sebagai ganti ekspresi kondisional. Saat kondisi dievaluasi, assignment akan dilakukan dan nilai yang di-assign akan digunakan sebagai ekspresi kondisional. Variabel yang di-assign hanya berada dalam scope badan kondisional, artinya tidak pernah tersedia jika nilai tidak truthy. Dan Anda harus menggunakan "walrus operator" `:=` sebagai ganti `=` untuk melakukan assignment.

```yuescript
if user := database.find_user "moon"
  print user.name
```

```yuescript
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```

Assignment if dengan beberapa nilai return. Hanya nilai pertama yang dicek, nilai lainnya tetap berada dalam scope.

```yuescript
if success, result := pcall -> "get result without problems"
  print result -- variabel result berada dalam scope
print "OK"
```

## Assignment pada While

Anda juga bisa menggunakan assignment if di loop while untuk mendapatkan nilai sebagai kondisi loop.

```yuescript
while byte := stream\read_one!
  -- lakukan sesuatu dengan byte
  print byte
```

# Penugasan Destrukturisasi

Assignment destrukturisasi adalah cara cepat untuk mengekstrak nilai dari sebuah tabel berdasarkan nama kunci atau posisinya pada tabel berbasis array.

Biasanya ketika Anda melihat literal tabel, `{1,2,3}`, ia berada di sisi kanan assignment karena merupakan nilai. Assignment destrukturisasi menukar peran literal tabel dan menaruhnya di sisi kiri pernyataan assignment.

Ini paling mudah dijelaskan dengan contoh. Berikut cara membongkar dua nilai pertama dari sebuah tabel:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

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

Jika pernyataan destrukturisasi kompleks, Anda bisa memecahnya ke beberapa baris. Contoh yang sedikit lebih rumit:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

Umumnya mengekstrak nilai dari tabel lalu menugaskannya ke variabel local dengan nama yang sama dengan kuncinya. Untuk menghindari pengulangan, kita bisa menggunakan operator prefiks **:**:

```yuescript
{:concat, :insert} = table
```

Ini secara efektif sama seperti import, tetapi kita dapat mengganti nama field yang ingin diekstrak dengan menggabungkan sintaks:

```yuescript
{:mix, :max, random: rand} = math
```

Anda bisa menulis nilai default saat destrukturisasi seperti:

```yuescript
{:name = "nameless", :job = "jobless"} = person
```

Anda dapat menggunakan `_` sebagai placeholder saat destrukturisasi list:

```yuescript
[_, two, _, four] = items
```

## Destrukturisasi Rentang

Anda dapat menggunakan operator spread `...` pada destrukturisasi list untuk menangkap rentang nilai. Ini berguna ketika Anda ingin mengekstrak elemen tertentu dari awal dan akhir list sambil mengumpulkan sisanya di tengah.

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- prints: first
print bulk   -- prints: {"second", "third", "fourth"}
print last   -- prints: last
```

Operator spread dapat digunakan pada posisi berbeda untuk menangkap rentang yang berbeda, dan Anda bisa memakai `_` sebagai placeholder untuk nilai yang tidak ingin ditangkap:

```yuescript
-- Tangkap semuanya setelah elemen pertama
[first, ...rest] = orders

-- Tangkap semuanya sebelum elemen terakhir
[...start, last] = orders

-- Tangkap semuanya kecuali elemen tengah
[first, ..._, last] = orders
```

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

Kita tahu setiap elemen pada tabel array adalah tuple dua item, sehingga kita dapat membongkarnya langsung di klausa nama pada pernyataan for menggunakan destrukturisasi.

# Klausa Using; Mengendalikan Penugasan Destruktif

Meskipun scope leksikal sangat membantu mengurangi kompleksitas kode yang kita tulis, hal ini bisa menjadi sulit ketika ukuran kode membesar. Pertimbangkan cuplikan berikut:

```yuescript
i = 100

-- banyak baris kode...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- akan mencetak 0
```

Di `my_func`, kita tanpa sengaja menimpa nilai `i`. Dalam contoh ini halnya cukup jelas, tetapi bayangkan kode besar atau basis kode asing di mana tidak jelas nama apa saja yang sudah dideklarasikan.

Akan sangat membantu jika kita dapat menyatakan variabel mana dari scope luar yang memang ingin kita ubah, agar mencegah mengubah yang lain secara tidak sengaja.

Kata kunci `using` memungkinkan kita melakukan itu. `using nil` memastikan bahwa tidak ada variabel tertutup yang ditimpa dalam assignment. Klausa `using` ditempatkan setelah daftar argumen pada fungsi, atau menggantikannya jika tidak ada argumen.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- variabel local baru dibuat di sini

my_func!
print i -- mencetak 100, i tidak terpengaruh
```

Beberapa nama dapat dipisahkan dengan koma. Nilai closure tetap bisa diakses, hanya saja tidak dapat dimodifikasi:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- tmp local baru dibuat
  i += tmp
  k += tmp

my_func(22)
print i, k -- ini telah diperbarui
```

# Penggunaan

## Modul Lua

Gunakan modul YueScript di Lua:

- **Kasus 1**

  Require "your_yuescript_entry.yue" di Lua.

  ```lua
  require("yue")("your_yuescript_entry")
  ```

  Dan kode ini tetap bekerja ketika Anda mengompilasi "your_yuescript_entry.yue" menjadi "your_yuescript_entry.lua" di path yang sama. Pada file YueScript lainnya cukup gunakan **require** atau **import** biasa. Nomor baris pada pesan error juga akan ditangani dengan benar.

- **Kasus 2**

  Require modul YueScript dan tulis ulang pesan secara manual.

  ```lua
  local yue = require("yue")
  yue.insert_loader()
  local success, result = xpcall(function()
    return require("yuescript_module_name")
  end, function(err)
    return yue.traceback(err)
  end)
  ```

- **Kasus 3**

  Gunakan fungsi kompiler YueScript di Lua.

  ```lua
  local yue = require("yue")
  local codes, err, globals = yue.to_lua([[
    f = ->
      print "hello world"
    f!
  ]],{
    implicit_return_root = true,
    reserve_line_number = true,
    lint_global = true,
    space_over_tab = false,
    options = {
      target = "5.4",
      path = "/script"
    }
  })
  ```

## Tool YueScript

Gunakan tool YueScript dengan:

```shell
> yue -h
Penggunaan: yue
           [opsi] [<file/direktori>] ...
           yue -e <kode_atau_file> [argumen...]
           yue -w [<direktori>] [opsi]
           yue -

Catatan:
   - '-' / '--' harus menjadi argumen pertama dan satu-satunya.
   - '-o/--output' tidak dapat digunakan dengan beberapa file input.
   - '-w/--watch' tidak dapat digunakan dengan file input (khusus direktori).
   - dengan '-e/--execute', token sisanya dianggap sebagai argumen skrip.

Opsi:
   -h, --help                 Tampilkan pesan bantuan ini dan keluar.
   -e <str>, --execute <str>  Eksekusi file atau kode mentah
   -m, --minify               Menghasilkan kode yang sudah diminimasi
   -r, --rewrite              Tulis ulang output agar sesuai dengan nomor baris asal
   -t <output_to>, --output-to <output_to>
                              Tentukan lokasi untuk menaruh file hasil kompilasi
   -o <file>, --output <file> Tulis output ke file
   -p, --print                Tulis output ke standar output
   -b, --benchmark            Tampilkan waktu kompilasi (tanpa menulis output)
   -g, --globals              Tampilkan variabel global yang digunakan dalam FORMAT NAMA BARIS KOLOM
   -s, --spaces               Pakai spasi di kode hasil kompilasi (bukan tab)
   -l, --line-numbers         Tulis nomor baris dari kode sumber
   -j, --no-implicit-return   Nonaktifkan return implisit di akhir file
   -c, --reserve-comments     Pertahankan komentar sebelum pernyataan dari kode sumber
   -w [<dir>], --watch [<dir>]
                              Pantau perubahan dan kompilasi setiap file di bawah direktori
   -v, --version              Tampilkan versi
   -                          Baca dari standar input, tulis ke standar output
                              (harus menjadi argumen pertama dan satu-satunya)
   --                         Sama dengan '-', dipertahankan untuk kompatibilitas lama

   --target <versi>           Tentukan versi Lua yang akan dihasilkan kodenya
                              (versi hanya bisa dari 5.1 sampai 5.5)
   --path <path_str>          Tambahkan path pencarian Lua tambahan ke package.path
   --<key>=<value>            Kirim opsi kompilasi dalam bentuk key=value (perilaku standar)

   Jalankan tanpa opsi untuk masuk ke REPL, ketik simbol '$'
   dalam satu baris untuk memulai/mengakhiri mode multi-baris
```

Gunakan kasus:

Kompilasi semua file YueScript dengan ekstensi **.yue** secara rekursif di bawah path saat ini: **yue .**

Kompilasi dan simpan hasil ke path target: **yue -t /target/path/ .**

Kompilasi dan pertahankan info debug: **yue -l .**

Kompilasi dan hasilkan kode yang diminisasi: **yue -m .**

Eksekusi kode mentah: **yue -e 'print 123'**

Eksekusi file YueScript: **yue -e main.yue**

# Pendahuluan

YueScript adalah bahasa dinamis yang dikompilasi ke Lua, dan merupakan dialek [MoonScript](https://github.com/leafo/moonscript). Kode yang ditulis dengan YueScript ekspresif dan sangat ringkas. YueScript cocok untuk menulis logika aplikasi yang sering berubah dengan kode yang lebih mudah dipelihara, serta berjalan di lingkungan embed Lua seperti game atau server situs web.

Yue (月) adalah kata untuk bulan dalam bahasa Tionghoa dan diucapkan sebagai [jyɛ].

## Ikhtisar YueScript

```yuescript
-- import syntax
import p, to_lua from "yue"

-- object literals
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- list comprehension
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- pipe operator
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- metatable manipulation
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- js-like export syntax
export 🌛 = "Skrip Bulan"
```

## Tentang Dora SSR

YueScript dikembangkan dan dipelihara bersama mesin game open-source [Dora SSR](https://github.com/Dora-SSR/Dora-SSR). YueScript telah digunakan untuk membuat alat mesin, demo game, dan prototipe, membuktikan kemampuannya dalam skenario dunia nyata sekaligus meningkatkan pengalaman pengembangan Dora SSR.

# Instalasi

## Modul Lua

Instal [luarocks](https://luarocks.org), manajer paket untuk modul Lua. Lalu instal sebagai modul Lua dan executable dengan:

```shell
luarocks install yuescript
```

Atau Anda dapat membangun file `yue.so` dengan:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Lalu ambil file biner dari path **bin/shared/yue.so**.

## Membangun Tool Biner

Klon repo ini, lalu bangun dan instal executable dengan:

```shell
make install
```

Bangun tool YueScript tanpa fitur macro:

```shell
make install NO_MACRO=true
```

Bangun tool YueScript tanpa biner Lua bawaan:

```shell
make install NO_LUA=true
```

## Unduh Biner Pra-kompilasi

Anda dapat mengunduh file biner pra-kompilasi, termasuk file executable biner yang kompatibel dengan berbagai versi Lua dan file library.

Unduh file biner pra-kompilasi dari [sini](https://github.com/IppClub/YueScript/releases).

# Kondisional

```yuescript
have_coins = false
if have_coins
  print "Dapat koin"
else
  print "Tidak ada koin"
```

Sintaks pendek untuk pernyataan tunggal juga bisa digunakan:

```yuescript
have_coins = false
if have_coins then print "Dapat koin" else print "Tidak ada koin"
```

Karena pernyataan if dapat digunakan sebagai ekspresi, ini juga bisa ditulis sebagai:

```yuescript
have_coins = false
print if have_coins then "Dapat koin" else "Tidak ada koin"
```

Kondisional juga bisa digunakan di pernyataan return dan assignment:

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Saya sangat tinggi"
else
  "Saya tidak terlalu tinggi"

print message -- prints: Saya sangat tinggi
```

Kebalikan dari if adalah unless:

```yuescript
unless os.date("%A") == "Monday"
  print "hari ini bukan Senin!"
```

```yuescript
print "Kamu beruntung!" unless math.random! > 0.1
```

## Ekspresi In

Anda dapat menulis kode pengecekan rentang dengan `ekspresi in`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "memeriksa kesamaan dengan nilai-nilai diskrit"

if a in list
  print "memeriksa apakah `a` ada di dalam daftar"
```

Operator `in` juga dapat digunakan dengan tabel dan mendukung varian `not in` untuk negasi:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a ada di dalam tabel"

not_exist = item not in list

check = -> value not in table
```

Daftar atau tabel dengan satu elemen memeriksa kesamaan dengan elemen tersebut:

```yuescript
-- [1,] memeriksa apakah nilai == 1
c = a in [1,]

-- {1} juga memeriksa apakah nilai == 1
c = a in {1}

-- Tanpa koma, [1] adalah akses indeks (tb[1])
with tb
  c = a in [1]
```

# Perulangan For

Ada dua bentuk perulangan for, seperti di Lua. Satu numerik dan satu generik:

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- an optional step provided
  print k

for key, value in pairs object
  print key, value
```

Operator slicing dan **\*** dapat digunakan, seperti pada comprehension:

```yuescript
for item in *items[2, 4]
  print item
```

Sintaks yang lebih singkat juga tersedia untuk semua variasi ketika badan hanya satu baris:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

Perulangan for juga bisa digunakan sebagai ekspresi. Pernyataan terakhir di badan for dipaksa menjadi ekspresi dan ditambahkan ke tabel array yang terakumulasi.

Menggandakan setiap bilangan genap:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

Selain itu, loop for mendukung break dengan nilai kembalian, sehingga loop itu sendiri bisa dipakai sebagai ekspresi yang keluar lebih awal dengan hasil bermakna. Ekspresi `for` mendukung `break` dengan banyak nilai.

Contohnya, untuk menemukan angka pertama yang lebih besar dari 10:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

Sintaks break-dengan-nilai ini memungkinkan pola pencarian atau keluar-lebih-awal yang ringkas langsung di dalam ekspresi loop.

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

Anda juga bisa memfilter nilai dengan menggabungkan ekspresi for dengan pernyataan continue.

Loop for di akhir badan fungsi tidak diakumulasikan menjadi tabel untuk nilai kembalian (sebaliknya fungsi akan mengembalikan nil). Gunakan pernyataan return eksplisit, atau ubah loop menjadi list comprehension.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- prints nil
print func_b! -- prints table object
```

# Pernyataan Continue

Pernyataan continue dapat digunakan untuk melewati iterasi saat ini di dalam loop.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

continue juga bisa digunakan bersama ekspresi loop untuk mencegah iterasi tersebut diakumulasikan ke hasil. Contoh ini memfilter tabel array menjadi hanya angka genap:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

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

Kita bisa memakai kata kunci `then` untuk menulis blok when switch pada satu baris. Tidak ada kata kunci tambahan yang dibutuhkan untuk menulis blok else pada satu baris.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "you are lucky"
  when 2 then "you are almost lucky"
  else "not so lucky"
```

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

Anda dapat menggunakan nilai default untuk mendestrukturisasi tabel secara opsional pada beberapa field.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- get error: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- table destructuring will still pass
```

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

Cocokkan terhadap daftar dan tangkap rentang elemen.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- prints: {"admin", "users"}
    print "Resource:", resource -- prints: "logs"
    print "Action:", action -- prints: "view"
```

# Perulangan While

Perulangan while juga memiliki empat variasi:

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

Seperti loop for, loop while juga bisa digunakan sebagai ekspresi. Ekspresi `while` dan `until` mendukung `break` dengan banyak nilai.

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

Selain itu, agar sebuah fungsi mengembalikan nilai akumulasi dari loop while, pernyataannya harus di-return secara eksplisit.

## Repeat Loop

Loop repeat berasal dari Lua:

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

Ekspresi `repeat` juga mendukung `break` dengan banyak nilai:

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

# Stub Fungsi

Sering kali fungsi dari sebuah objek diteruskan sebagai nilai, misalnya meneruskan method instance ke fungsi lain sebagai callback. Jika fungsi mengharapkan objek yang dioperasikan sebagai argumen pertama, maka Anda harus menggabungkan objek tersebut dengan fungsi agar dapat dipanggil dengan benar.

Sintaks stub fungsi adalah singkatan untuk membuat fungsi closure baru yang menggabungkan objek dan fungsi. Fungsi baru ini memanggil fungsi yang dibungkus dalam konteks objek yang benar.

Sintaksnya sama seperti memanggil method instance dengan operator `\`, tetapi tanpa menyediakan daftar argumen.

```yuescript
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- ini tidak akan berfungsi:
-- fungsi tidak memiliki referensi ke my_object
run_callback my_object.write

-- sintaks stub fungsi
-- memungkinkan kita membundel objek ke fungsi baru
run_callback my_object\write
```

# Backcall

Backcall digunakan untuk meratakan callback yang bersarang. Backcall didefinisikan menggunakan panah yang mengarah ke kiri sebagai parameter terakhir secara default yang akan mengisi pemanggilan fungsi. Semua sintaks pada dasarnya sama seperti fungsi panah biasa, kecuali arahnya berlawanan dan badan fungsi tidak memerlukan indentasi.

```yuescript
x <- f
print "hello" .. x
```

Fungsi panah tebal juga tersedia.

```yuescript
<= f
print @value
```

Anda dapat menentukan placeholder untuk posisi fungsi backcall sebagai parameter.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

Jika Anda ingin menulis kode lanjutan setelah backcall, Anda dapat memisahkannya dengan pernyataan `do`. Tanda kurung dapat dihilangkan untuk fungsi panah non-tebal.

```yuescript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

# Literal Fungsi

Semua fungsi dibuat menggunakan ekspresi fungsi. Fungsi sederhana ditandai dengan panah: **->**.

```yuescript
my_function = ->
my_function() -- memanggil fungsi kosong
```

Badan fungsi bisa berupa satu pernyataan yang ditulis langsung setelah panah, atau berupa serangkaian pernyataan yang diindentasi di baris berikutnya:

```yuescript
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

Jika fungsi tidak memiliki argumen, ia dapat dipanggil menggunakan operator `!`, sebagai ganti tanda kurung kosong. Pemanggilan `!` adalah cara yang disarankan untuk memanggil fungsi tanpa argumen.

```yuescript
func_a!
func_b()
```

Fungsi dengan argumen dapat dibuat dengan menaruh daftar nama argumen dalam tanda kurung sebelum panah:

```yuescript
sum = (x, y) -> print "sum", x + y
```

Fungsi dapat dipanggil dengan menuliskan argumen setelah nama ekspresi yang mengevaluasi ke fungsi. Saat merangkai pemanggilan fungsi, argumen diterapkan ke fungsi terdekat di sebelah kiri.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

Untuk menghindari ambiguitas saat memanggil fungsi, tanda kurung juga bisa digunakan untuk mengelilingi argumen. Ini diperlukan di sini agar argumen yang tepat dikirim ke fungsi yang tepat.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

Tidak boleh ada spasi antara tanda kurung buka dan nama fungsi.

Fungsi akan memaksa pernyataan terakhir di badannya menjadi pernyataan return, ini disebut return implisit:

```yuescript
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

Dan jika Anda perlu return secara eksplisit, Anda bisa menggunakan kata kunci `return`:

```yuescript
sum = (x, y) -> return x + y
```

Seperti di Lua, fungsi dapat mengembalikan beberapa nilai. Pernyataan terakhir harus berupa daftar nilai yang dipisahkan koma:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

## Panah Tebal

Karena sudah menjadi idiom di Lua untuk mengirim objek sebagai argumen pertama saat memanggil method, disediakan sintaks khusus untuk membuat fungsi yang otomatis menyertakan argumen `self`.

```yuescript
func = (num) => @value + num
```

## Nilai Default Argumen

Dimungkinkan untuk menyediakan nilai default bagi argumen fungsi. Argumen dianggap kosong jika nilainya nil. Argumen nil yang memiliki nilai default akan diganti sebelum badan fungsi dijalankan.

```yuescript
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

Ekspresi nilai default argumen dievaluasi di dalam badan fungsi sesuai urutan deklarasi argumen. Karena itu, nilai default dapat mengakses argumen yang dideklarasikan sebelumnya.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

## Pertimbangan

Karena cara pemanggilan fungsi tanpa tanda kurung yang ekspresif, beberapa pembatasan harus diterapkan untuk menghindari ambiguitas parsing yang melibatkan spasi.

Tanda minus memiliki dua peran, operator negasi unari dan operator pengurangan biner. Perhatikan bagaimana contoh berikut dikompilasi:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

Prioritas argumen pertama pada pemanggilan fungsi dapat dikendalikan menggunakan spasi jika argumennya adalah literal string. Di Lua, sudah umum untuk menghilangkan tanda kurung saat memanggil fungsi dengan satu literal string atau tabel.

Ketika tidak ada spasi antara variabel dan literal string, pemanggilan fungsi akan memiliki prioritas atas ekspresi yang mengikuti. Tidak ada argumen lain yang dapat diberikan pada fungsi ketika dipanggil dengan cara ini.

Ketika ada spasi setelah variabel dan literal string, pemanggilan fungsi bertindak seperti yang dijelaskan di atas. Literal string menjadi milik ekspresi berikutnya (jika ada), yang berfungsi sebagai daftar argumen.

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```

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

Jenis pemanggilan ini dapat dinest. Tingkat indentasi digunakan untuk menentukan argumen milik fungsi yang mana.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

Karena tabel juga menggunakan koma sebagai pemisah, sintaks indentasi ini membantu agar nilai menjadi bagian dari daftar argumen, bukan bagian dari tabel.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

Meskipun jarang, perhatikan bahwa kita bisa memberikan indentasi yang lebih dalam untuk argumen fungsi jika kita tahu akan menggunakan indentasi yang lebih dangkal di bagian selanjutnya.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

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

# Spasi Kosong

YueScript adalah bahasa yang peka terhadap spasi. Anda harus menulis beberapa blok kode dengan indentasi yang sama menggunakan spasi **' '** atau tab **'\t'** seperti badan fungsi, daftar nilai, dan beberapa blok kontrol. Ekspresi yang mengandung spasi berbeda dapat bermakna berbeda. Tab diperlakukan seperti 4 spasi, tetapi sebaiknya jangan mencampur penggunaan spasi dan tab.

## Pemisah Pernyataan

Sebuah pernyataan biasanya berakhir pada pergantian baris. Anda juga bisa memakai titik koma `;` untuk mengakhiri pernyataan secara eksplisit, yang memungkinkan menulis beberapa pernyataan pada satu baris:

```yuescript
a = 1; b = 2; print a + b
```

## Rantai Multibaris

Anda bisa menulis pemanggilan fungsi berantai multi-baris dengan indentasi yang sama.

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

# Komentar

```yuescript
-- Saya adalah komentar

str = --[[
Ini komentar multi-baris.
Tidak masalah.
]] strA \ -- komentar 1
  .. strB \ -- komentar 2
  .. strC

func --[[port]] 3000, --[[ip]] "192.168.1.1"
```

# Atribut

Dukungan sintaks untuk atribut Lua 5.4. Anda juga masih bisa menggunakan deklarasi `const` dan `close` dan mendapatkan pemeriksaan konstanta serta callback berbatas-scope ketika menargetkan versi Lua di bawah 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Out of scope."
```

Anda dapat melakukan destrukturisasi dengan variabel yang diberi atribut sebagai konstanta.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

Anda juga bisa mendeklarasikan variabel global sebagai `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

# Operator

Semua operator biner dan unari Lua tersedia. Selain itu **!=** adalah alias untuk **~=**, dan **\\** atau **::** bisa digunakan untuk menulis pemanggilan fungsi berantai seperti `tb\func!` atau `tb::func!`. YueScript juga menawarkan beberapa operator khusus lain untuk menulis kode yang lebih ekspresif.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

## Perbandingan Berantai

Perbandingan bisa dirantai secara bebas:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- output: true

a = 5
print 1 <= a <= 10
-- output: true
```

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

Ekspresi tengah hanya dievaluasi sekali, bukan dua kali seperti jika ekspresi ditulis sebagai `v(1) < v(2) and v(2) <= v(3)`. Namun, urutan evaluasi pada perbandingan berantai tidak didefinisikan. Sangat disarankan untuk tidak menggunakan ekspresi dengan efek samping (seperti `print`) di perbandingan berantai. Jika efek samping diperlukan, operator short-circuit `and` sebaiknya digunakan secara eksplisit.

## Menambahkan ke Tabel

Operator **[] =** digunakan untuk menambahkan nilai ke tabel.

```yuescript
tab = []
tab[] = "Value"
```

Anda juga bisa memakai operator spread `...` untuk menambahkan semua elemen dari satu list ke list lain:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA sekarang [1, 2, 3, 4, 5, 6]
```

## Penyebaran Tabel

Anda bisa menggabungkan tabel array atau tabel hash menggunakan operator spread `...` sebelum ekspresi di literal tabel.

Saat melakukan spread ke literal tabel dengan kurung kurawal (misalnya `{...other}`), bagian array dan bagian hash dari tabel Lua akan disalin.

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

### Penyebaran Tabel List

Saat melakukan spread ke literal tabel dengan kurung siku (misalnya `[...other,]`), hanya bagian array yang disalin.

```yuescript
source = {1, 2, 3, name: "Yue"}
fullCopy = {...source}
listCopy = [...source,]
-- fullCopy => {1, 2, 3, name: "Yue"}
-- listCopy => [1, 2, 3]
```

## Indeks Balik Tabel

Anda dapat menggunakan operator **#** untuk mendapatkan elemen terakhir dari tabel.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

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

### Destrukturisasi Metatable

Destrukturisasi metatable dengan kunci metamethod yang dikelilingi **<>**.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

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

## Nil Coalescing

Operator nil-coalescing **??** mengembalikan nilai dari operan kiri jika bukan **nil**; jika tidak, operator mengevaluasi operan kanan dan mengembalikan hasilnya. Operator **??** tidak mengevaluasi operan kanan jika operan kiri bernilai non-nil.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

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

# Literal

Semua literal primitif di Lua dapat digunakan. Ini berlaku untuk angka, string, boolean, dan **nil**.

Berbeda dengan Lua, pemisah baris diizinkan di dalam string bertanda kutip tunggal maupun ganda tanpa urutan escape:

```yuescript
some_string = "Here is a string
  that has a line break in it."

-- Anda dapat mencampur ekspresi ke dalam literal string dengan sintaks #{}.
-- Interpolasi string hanya tersedia pada string dengan tanda kutip ganda.
print "I am #{math.random! * 100}% sure."
```

## Literal Angka

Anda bisa menggunakan garis bawah pada literal angka untuk meningkatkan keterbacaan.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

## String Multibaris YAML

Prefiks `|` memperkenalkan literal string multibaris bergaya YAML:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

Ini memungkinkan penulisan teks multibaris terstruktur dengan mudah. Semua pemisah baris dan indentasi dipertahankan relatif terhadap baris non-kosong pertama, dan ekspresi di dalam `#{...}` diinterpolasi otomatis sebagai `tostring(expr)`.

String Multibaris YAML secara otomatis mendeteksi prefiks spasi awal yang sama (indentasi minimum di seluruh baris non-kosong) dan menghapusnya dari semua baris. Ini memudahkan untuk mengindentasi kode secara visual tanpa memengaruhi isi string yang dihasilkan.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

Indentasi internal dipertahankan relatif terhadap prefiks umum yang dihapus, sehingga struktur bertingkat tetap rapi.

Semua karakter khusus seperti tanda kutip (`"`) dan backslash (`\`) di dalam blok YAMLMultiline di-escape secara otomatis agar string Lua yang dihasilkan valid secara sintaks dan berperilaku sebagaimana mestinya.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

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

## Import Global

Anda dapat mengimpor global tertentu ke variabel local dengan `import`. Saat mengimpor rangkaian akses variabel global, field terakhir akan di-assign ke variabel local.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

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

Melakukan export bernama dengan destrukturisasi.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

Export item bernama dari modul tanpa membuat variabel local.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

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

### Export Default

Gunakan kata kunci **default** dalam pernyataan export untuk mengganti tabel export dengan apa pun.

```yuescript
export default ->
  print "hello"
  123
```

# Lisensi: MIT

Copyright (c) 2017-2026 Li Jin <dragon-fly@qq.com>

Izin dengan ini diberikan, tanpa biaya, kepada siapa pun yang memperoleh salinan
perangkat lunak ini beserta file dokumentasi terkait ("Perangkat Lunak"), untuk
berurusan dengan Perangkat Lunak tanpa pembatasan, termasuk tanpa batasan hak
untuk menggunakan, menyalin, memodifikasi, menggabungkan, menerbitkan,
mendistribusikan, mensublisensikan, dan/atau menjual salinan Perangkat Lunak,
dan untuk mengizinkan orang yang menerima Perangkat Lunak untuk melakukannya,
dengan syarat-syarat berikut:

Pemberitahuan hak cipta di atas dan pemberitahuan izin ini harus disertakan dalam
semua salinan atau bagian substansial dari Perangkat Lunak.

PERANGKAT LUNAK DISEDIAKAN "APA ADANYA", TANPA JAMINAN APA PUN, BAIK TERSURAT
MAUPUN TERSIRAT, TERMASUK NAMUN TIDAK TERBATAS PADA JAMINAN KELAYAKAN
DIPERDAGANGKAN, KESESUAIAN UNTUK TUJUAN TERTENTU, DAN TIDAK MELANGGAR HAK.
DALAM KEADAAN APA PUN, PENULIS ATAU PEMEGANG HAK CIPTA TIDAK BERTANGGUNG JAWAB
ATAS KLAIM, KERUSAKAN, ATAU KEWAJIBAN LAINNYA, BAIK DALAM TINDAKAN KONTRAK,
PERBUATAN MELAWAN HUKUM, ATAU LAINNYA, YANG TIMBUL DARI, DI LUAR, ATAU TERKAIT
DENGAN PERANGKAT LUNAK ATAU PENGGUNAAN ATAU URUSAN LAIN DALAM PERANGKAT LUNAK.

# Pustaka YueScript

Akses dengan `local yue = require("yue")` di Lua.

## yue

**Deskripsi:**

Pustaka bahasa YueScript.

### version

**Tipe:** Field.

**Deskripsi:**

Versi YueScript.

**Signature:**

```lua
version: string
```

### dirsep

**Tipe:** Field.

**Deskripsi:**

Pemisah file untuk platform saat ini.

**Signature:**

```lua
dirsep: string
```

### yue_compiled

**Tipe:** Field.

**Deskripsi:**

Cache kode modul yang telah dikompilasi.

**Signature:**

```lua
yue_compiled: {string: string}
```

### to_lua

**Tipe:** Function.

**Deskripsi:**

Fungsi kompilasi YueScript. Mengompilasi kode YueScript menjadi kode Lua.

**Signature:**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| code      | string | Kode YueScript.           |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return                         | Deskripsi                                                                                                                         |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| string \| nil                       | Kode Lua hasil kompilasi, atau nil jika kompilasi gagal.                                                                          |
| string \| nil                       | Pesan error, atau nil jika kompilasi berhasil.                                                                                    |
| {{string, integer, integer}} \| nil | Variabel global yang muncul dalam kode (dengan nama, baris, dan kolom), atau nil jika opsi kompiler `lint_global` bernilai false. |

### file_exist

**Tipe:** Function.

**Deskripsi:**

Fungsi untuk memeriksa keberadaan file sumber. Dapat ditimpa untuk menyesuaikan perilaku.

**Signature:**

```lua
file_exist: function(filename: string): boolean
```

**Parameter:**

| Parameter | Tipe   | Deskripsi  |
| --------- | ------ | ---------- |
| filename  | string | Nama file. |

**Return:**

| Tipe Return | Deskripsi        |
| ----------- | ---------------- |
| boolean     | Apakah file ada. |

### read_file

**Tipe:** Function.

**Deskripsi:**

Fungsi untuk membaca file sumber. Dapat ditimpa untuk menyesuaikan perilaku.

**Signature:**

```lua
read_file: function(filename: string): string
```

**Parameter:**

| Parameter | Tipe   | Deskripsi  |
| --------- | ------ | ---------- |
| filename  | string | Nama file. |

**Return:**

| Tipe Return | Deskripsi |
| ----------- | --------- |
| string      | Isi file. |

### insert_loader

**Tipe:** Function.

**Deskripsi:**

Menyisipkan loader YueScript ke package loaders (searchers).

**Signature:**

```lua
insert_loader: function(pos?: integer): boolean
```

**Parameter:**

| Parameter | Tipe    | Deskripsi                                                     |
| --------- | ------- | ------------------------------------------------------------- |
| pos       | integer | [Opsional] Posisi untuk menyisipkan loader. Default adalah 3. |

**Return:**

| Tipe Return | Deskripsi                                                                   |
| ----------- | --------------------------------------------------------------------------- |
| boolean     | Apakah loader berhasil disisipkan. Akan gagal jika loader sudah disisipkan. |

### remove_loader

**Tipe:** Function.

**Deskripsi:**

Menghapus loader YueScript dari package loaders (searchers).

**Signature:**

```lua
remove_loader: function(): boolean
```

**Return:**

| Tipe Return | Deskripsi                                                                |
| ----------- | ------------------------------------------------------------------------ |
| boolean     | Apakah loader berhasil dihapus. Akan gagal jika loader belum disisipkan. |

### loadstring

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari string menjadi fungsi.

**Signature:**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| input     | string | Kode YueScript.           |
| chunkname | string | Nama chunk kode.          |
| env       | table  | Tabel environment.        |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return     | Deskripsi                                         |
| --------------- | ------------------------------------------------- |
| function \| nil | Fungsi yang dimuat, atau nil jika pemuatan gagal. |
| string \| nil   | Pesan error, atau nil jika pemuatan berhasil.     |

### loadstring

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari string menjadi fungsi.

**Signature:**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| input     | string | Kode YueScript.           |
| chunkname | string | Nama chunk kode.          |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return     | Deskripsi                                         |
| --------------- | ------------------------------------------------- |
| function \| nil | Fungsi yang dimuat, atau nil jika pemuatan gagal. |
| string \| nil   | Pesan error, atau nil jika pemuatan berhasil.     |

### loadstring

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari string menjadi fungsi.

**Signature:**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| input     | string | Kode YueScript.           |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return     | Deskripsi                                         |
| --------------- | ------------------------------------------------- |
| function \| nil | Fungsi yang dimuat, atau nil jika pemuatan gagal. |
| string \| nil   | Pesan error, atau nil jika pemuatan berhasil.     |

### loadfile

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari file menjadi fungsi.

**Signature:**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| filename  | string | Nama file.                |
| env       | table  | Tabel environment.        |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return     | Deskripsi                                         |
| --------------- | ------------------------------------------------- |
| function \| nil | Fungsi yang dimuat, atau nil jika pemuatan gagal. |
| string \| nil   | Pesan error, atau nil jika pemuatan berhasil.     |

### loadfile

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari file menjadi fungsi.

**Signature:**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| filename  | string | Nama file.                |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return     | Deskripsi                                         |
| --------------- | ------------------------------------------------- |
| function \| nil | Fungsi yang dimuat, atau nil jika pemuatan gagal. |
| string \| nil   | Pesan error, atau nil jika pemuatan berhasil.     |

### dofile

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari file menjadi fungsi dan mengeksekusinya.

**Signature:**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| filename  | string | Nama file.                |
| env       | table  | Tabel environment.        |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return | Deskripsi                             |
| ----------- | ------------------------------------- |
| any...      | Nilai return dari fungsi yang dimuat. |

### dofile

**Tipe:** Function.

**Deskripsi:**

Memuat kode YueScript dari file menjadi fungsi dan mengeksekusinya.

**Signature:**

```lua
dofile: function(filename: string, config?: Config): any...
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                 |
| --------- | ------ | ------------------------- |
| filename  | string | Nama file.                |
| config    | Config | [Opsional] Opsi kompiler. |

**Return:**

| Tipe Return | Deskripsi                             |
| ----------- | ------------------------------------- |
| any...      | Nilai return dari fungsi yang dimuat. |

### find_modulepath

**Tipe:** Function.

**Deskripsi:**

Menguraikan nama modul YueScript menjadi path file.

**Signature:**

```lua
find_modulepath: function(name: string): string
```

**Parameter:**

| Parameter | Tipe   | Deskripsi   |
| --------- | ------ | ----------- |
| name      | string | Nama modul. |

**Return:**

| Tipe Return | Deskripsi  |
| ----------- | ---------- |
| string      | Path file. |

### pcall

**Tipe:** Function.

**Deskripsi:**

Memanggil fungsi dalam mode terlindungi.
Menangkap error apa pun dan mengembalikan kode status beserta hasil atau objek error.
Menulis ulang nomor baris error ke nomor baris asli di kode YueScript saat error terjadi.

**Signature:**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**Parameter:**

| Parameter | Tipe     | Deskripsi                          |
| --------- | -------- | ---------------------------------- |
| f         | function | Fungsi yang akan dipanggil.        |
| ...       | any      | Argumen yang diteruskan ke fungsi. |

**Return:**

| Tipe Return  | Deskripsi                                      |
| ------------ | ---------------------------------------------- |
| boolean, ... | Kode status dan hasil fungsi atau objek error. |

### require

**Tipe:** Function.

**Deskripsi:**

Memuat modul tertentu. Bisa berupa modul Lua atau modul YueScript.
Menulis ulang nomor baris error ke nomor baris asli di kode YueScript jika modul adalah modul YueScript dan pemuatan gagal.

**Signature:**

```lua
require: function(name: string): any...
```

**Parameter:**

| Parameter | Tipe   | Deskripsi                    |
| --------- | ------ | ---------------------------- |
| modname   | string | Nama modul yang akan dimuat. |

**Return:**

| Tipe Return | Deskripsi                                                                                                                                                                                               |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| any         | Nilai yang disimpan di package.loaded[modname] jika modul sudah dimuat. Jika belum, mencoba mencari loader dan mengembalikan nilai akhir package.loaded[modname] serta data loader sebagai hasil kedua. |

### p

**Tipe:** Function.

**Deskripsi:**

Memeriksa struktur nilai yang diteruskan dan mencetak representasi string.

**Signature:**

```lua
p: function(...: any)
```

**Parameter:**

| Parameter | Tipe | Deskripsi                  |
| --------- | ---- | -------------------------- |
| ...       | any  | Nilai yang akan diperiksa. |

### options

**Tipe:** Field.

**Deskripsi:**

Opsi kompiler saat ini.

**Signature:**

```lua
options: Config.Options
```

### traceback

**Tipe:** Function.

**Deskripsi:**

Fungsi traceback yang menulis ulang nomor baris stack trace ke nomor baris asli di kode YueScript.

**Signature:**

```lua
traceback: function(message: string): string
```

**Parameter:**

| Parameter | Tipe   | Deskripsi        |
| --------- | ------ | ---------------- |
| message   | string | Pesan traceback. |

**Return:**

| Tipe Return | Deskripsi                                 |
| ----------- | ----------------------------------------- |
| string      | Pesan traceback yang telah ditulis ulang. |

### is_ast

**Tipe:** Function.

**Deskripsi:**

Memeriksa apakah kode cocok dengan AST yang ditentukan.

**Signature:**

```lua
is_ast: function(astName: string, code: string): boolean
```

**Parameter:**

| Parameter | Tipe   | Deskripsi |
| --------- | ------ | --------- |
| astName   | string | Nama AST. |
| code      | string | Kode.     |

**Return:**

| Tipe Return | Deskripsi                     |
| ----------- | ----------------------------- |
| boolean     | Apakah kode cocok dengan AST. |

### AST

**Tipe:** Field.

**Deskripsi:**

Definisi tipe AST dengan nama, baris, kolom, dan sub-node.

**Signature:**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**Tipe:** Function.

**Deskripsi:**

Mengonversi kode menjadi AST.

**Signature:**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**Parameter:**

| Parameter      | Tipe    | Deskripsi                                                                                |
| -------------- | ------- | ---------------------------------------------------------------------------------------- |
| code           | string  | Kode.                                                                                    |
| flattenLevel   | integer | [Opsional] Tingkat perataan. Semakin tinggi berarti semakin rata. Default 0. Maksimum 2. |
| astName        | string  | [Opsional] Nama AST. Default "File".                                                     |
| reserveComment | boolean | [Opsional] Apakah akan mempertahankan komentar asli. Default false.                      |

**Return:**

| Tipe Return   | Deskripsi                                     |
| ------------- | --------------------------------------------- |
| AST \| nil    | AST, atau nil jika konversi gagal.            |
| string \| nil | Pesan error, atau nil jika konversi berhasil. |

### format

**Tipe:** Function.

**Deskripsi:**

Memformat kode YueScript.

**Signature:**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**Parameter:**

| Parameter      | Tipe    | Deskripsi                                                     |
| -------------- | ------- | ------------------------------------------------------------- |
| code           | string  | Kode.                                                         |
| tabSize        | integer | [Opsional] Ukuran tab. Default 4.                             |
| reserveComment | boolean | [Opsional] Apakah mempertahankan komentar asli. Default true. |

**Return:**

| Tipe Return | Deskripsi                 |
| ----------- | ------------------------- |
| string      | Kode yang telah diformat. |

### \_\_call

**Tipe:** Metamethod.

**Deskripsi:**

Me-require modul YueScript.
Menulis ulang nomor baris error ke nomor baris asli di kode YueScript saat pemuatan gagal.

**Signature:**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**Parameter:**

| Parameter | Tipe   | Deskripsi   |
| --------- | ------ | ----------- |
| module    | string | Nama modul. |

**Return:**

| Tipe Return | Deskripsi    |
| ----------- | ------------ |
| any         | Nilai modul. |

## Config

**Deskripsi:**

Opsi kompilasi kompiler.

### lint_global

**Tipe:** Field.

**Deskripsi:**

Apakah kompiler harus mengumpulkan variabel global yang muncul dalam kode.

**Signature:**

```lua
lint_global: boolean
```

### implicit_return_root

**Tipe:** Field.

**Deskripsi:**

Apakah kompiler harus melakukan return implisit untuk blok kode root.

**Signature:**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**Tipe:** Field.

**Deskripsi:**

Apakah kompiler harus mempertahankan nomor baris asli di kode hasil kompilasi.

**Signature:**

```lua
reserve_line_number: boolean
```

### reserve_comment

**Tipe:** Field.

**Deskripsi:**

Apakah kompiler harus mempertahankan komentar asli di kode hasil kompilasi.

**Signature:**

```lua
reserve_comment: boolean
```

### space_over_tab

**Tipe:** Field.

**Deskripsi:**

Apakah kompiler harus menggunakan karakter spasi alih-alih tab di kode hasil kompilasi.

**Signature:**

```lua
space_over_tab: boolean
```

### same_module

**Tipe:** Field.

**Deskripsi:**

Apakah kompiler harus memperlakukan kode yang akan dikompilasi sebagai modul yang sama dengan modul yang sedang dikompilasi. Untuk penggunaan internal saja.

**Signature:**

```lua
same_module: boolean
```

### line_offset

**Tipe:** Field.

**Deskripsi:**

Apakah pesan error kompiler harus menyertakan offset nomor baris. Untuk penggunaan internal saja.

**Signature:**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**Tipe:** Enumeration.

**Deskripsi:**

Enumerasi versi Lua target.

**Signature:**

```lua
enum LuaTarget
  "5.1"
  "5.2"
  "5.3"
  "5.4"
  "5.5"
end
```

### options

**Tipe:** Field.

**Deskripsi:**

Opsi tambahan untuk diteruskan ke fungsi kompilasi.

**Signature:**

```lua
options: Options
```

## Options

**Deskripsi:**

Definisi opsi kompiler tambahan.

### target

**Tipe:** Field.

**Deskripsi:**

Versi Lua target untuk kompilasi.

**Signature:**

```lua
target: LuaTarget
```

### path

**Tipe:** Field.

**Deskripsi:**

Path pencarian modul tambahan.

**Signature:**

```lua
path: string
```

### dump_locals

**Tipe:** Field.

**Deskripsi:**

Apakah akan menampilkan variabel local dalam pesan error traceback. Default false.

**Signature:**

```lua
dump_locals: boolean
```

### simplified

**Tipe:** Field.

**Deskripsi:**

Apakah akan menyederhanakan pesan error. Default true.

**Signature:**

```lua
simplified: boolean
```
