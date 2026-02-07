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
