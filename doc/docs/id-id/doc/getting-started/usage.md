# Penggunaan

## Modul Lua

Gunakan modul YueScript di Lua:

- **Kasus 1**

  Require "your_yuescript_entry.yue" di Lua.

  ```Lua
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
