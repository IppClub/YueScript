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

<YueDisplay>

```yue
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```

</YueDisplay>

Kelas dideklarasikan dengan pernyataan `class` diikuti deklarasi mirip tabel di mana semua method dan properti dicantumkan.

Properti `new` bersifat khusus karena akan menjadi konstruktor.

Perhatikan bahwa semua method di kelas menggunakan sintaks fungsi panah tebal. Saat memanggil method pada instance, instance itu sendiri dikirim sebagai argumen pertama. Panah tebal menangani pembuatan argumen `self`.

Prefiks `@` pada nama variabel adalah singkatan untuk `self.`. `@items` menjadi `self.items`.

Membuat instance kelas dilakukan dengan memanggil nama kelas sebagai fungsi.

```yuescript
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

<YueDisplay>

```yue
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Cara yang benar untuk menghindari masalah ini adalah membuat state yang dapat berubah di konstruktor:

```yuescript
class Person
  new: =>
    @clothes = []
```

<YueDisplay>

```yue
class Person
  new: =>
    @clothes = []
```

</YueDisplay>

## Pewarisan

Kata kunci `extends` dapat digunakan dalam deklarasi kelas untuk mewarisi properti dan method dari kelas lain.

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```

<YueDisplay>

```yue
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```

</YueDisplay>

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

<YueDisplay>

```yue
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- akan mencetak: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```

</YueDisplay>

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

<YueDisplay>

```yue
class MyClass extends ParentClass
  a_method: =>
    -- berikut memiliki efek yang sama:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super sebagai nilai sama dengan kelas induk:
    assert super == ParentClass
```

</YueDisplay>

**super** juga dapat digunakan di sisi kiri Function Stub. Perbedaan utamanya adalah, alih-alih fungsi hasil terikat pada nilai `super`, fungsi terikat pada `self`.

## Tipe

Setiap instance kelas membawa tipenya sendiri. Ini disimpan di properti khusus `__class`. Properti ini memuat objek kelas. Objek kelas adalah yang kita panggil untuk membuat instance baru. Kita juga dapat mengindeks objek kelas untuk mengambil method dan properti kelas.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- mencetak 10
```

<YueDisplay>

```yue
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- mencetak 10
```

</YueDisplay>

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

<YueDisplay>

```yue
print BackPack.__name -- mencetak Backpack
```

</YueDisplay>

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

<YueDisplay>

```yue
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- variabel kelas tidak terlihat pada instance
assert Things().some_func == nil
```

</YueDisplay>

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

<YueDisplay>

```yue
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- mencetak 2
```

</YueDisplay>

Semantik pemanggilan `@@` mirip dengan `@`. Memanggil nama `@@` akan meneruskan kelas sebagai argumen pertama menggunakan sintaks kolon Lua.

```yuescript
@@hello 1,2,3,4
```

<YueDisplay>

```yue
@@hello 1,2,3,4
```

</YueDisplay>

## Pernyataan Deklarasi Kelas

Di dalam badan deklarasi kelas, kita bisa memiliki ekspresi normal selain pasangan key/value. Dalam konteks ini, `self` sama dengan objek kelas.

Berikut cara alternatif untuk membuat variabel kelas dibandingkan yang dijelaskan di atas:

```yuescript
class Things
  @class_var = "hello world"
```

<YueDisplay>

```yue
class Things
  @class_var = "hello world"
```

</YueDisplay>

Ekspresi ini dieksekusi setelah semua properti ditambahkan ke base.

Semua variabel yang dideklarasikan di badan kelas bersifat lokal terhadap properti kelas. Ini berguna untuk menempatkan nilai privat atau fungsi pembantu yang hanya dapat diakses oleh method kelas:

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

<YueDisplay>

```yue
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

</YueDisplay>

## Nilai @ dan @@

Ketika `@` dan `@@` diprefiks di depan sebuah nama, masing-masing merepresentasikan nama tersebut yang diakses di `self` dan `self.__class`.

Jika digunakan sendirian, keduanya adalah alias untuk `self` dan `self.__class`.

```yuescript
assert @ == self
assert @@ == self.__class
```

<YueDisplay>

```yue
assert @ == self
assert @@ == self.__class
```

</YueDisplay>

Contohnya, cara cepat untuk membuat instance baru dari kelas yang sama dari method instance menggunakan `@@`:

```yuescript
some_instance_method = (...) => @@ ...
```

<YueDisplay>

```yue
some_instance_method = (...) => @@ ...
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Anda juga bisa menggunakan sintaks ini untuk fungsi umum guna menginisialisasi field objek.

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

<YueDisplay>

```yue
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

</YueDisplay>

## Ekspresi Kelas

Sintaks kelas juga bisa digunakan sebagai ekspresi yang dapat di-assign ke variabel atau di-return secara eksplisit.

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

<YueDisplay>

```yue
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

</YueDisplay>

## Kelas Anonim

Nama bisa dihilangkan saat mendeklarasikan kelas. Atribut `__name` akan bernilai nil, kecuali ekspresi kelas berada dalam assignment. Nama di sisi kiri assignment digunakan sebagai ganti nil.

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

<YueDisplay>

```yue
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

</YueDisplay>

Anda bahkan bisa menghilangkan badan kelas, artinya Anda bisa menulis kelas anonim kosong seperti ini:

```yuescript
x = class
```

<YueDisplay>

```yue
x = class
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>
