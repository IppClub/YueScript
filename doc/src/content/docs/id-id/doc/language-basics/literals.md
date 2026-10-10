---
title: Literal
sidebar:
  order: 6
---

Semua literal primitif di Lua dapat digunakan. Ini berlaku untuk angka, string, boolean, dan **nil**.

Berbeda dengan Lua, pemisah baris diizinkan di dalam string bertanda kutip tunggal maupun ganda tanpa urutan escape:

```yuescript
some_string = "Here is a string
  that has a line break in it."

-- Anda dapat mencampur ekspresi ke dalam literal string dengan sintaks #{}.
-- Interpolasi string hanya tersedia pada string dengan tanda kutip ganda.
print "I am #{math.random! * 100}% sure."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_string = "Here is a string
  that has a line break in it."

-- Anda dapat mencampur ekspresi ke dalam literal string dengan sintaks #{}.
-- Interpolasi string hanya tersedia pada string dengan tanda kutip ganda.
print "I am #{math.random! * 100}% sure."
```

</div>
</div>

## Literal Angka

Anda bisa menggunakan garis bawah pada literal angka untuk meningkatkan keterbacaan.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

</div>
</div>

## String Multibaris YAML

Prefiks `|` memperkenalkan literal string multibaris bergaya YAML:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
str = |
  key: value
  list:
    - item1
    - #{expr}
```

</div>
</div>

Ini memungkinkan penulisan teks multibaris terstruktur dengan mudah. Semua pemisah baris dan indentasi dipertahankan relatif terhadap baris non-kosong pertama, dan ekspresi di dalam `#{...}` diinterpolasi otomatis sebagai `tostring(expr)`.

String Multibaris YAML secara otomatis mendeteksi prefiks spasi awal yang sama (indentasi minimum di seluruh baris non-kosong) dan menghapusnya dari semua baris. Ini memudahkan untuk mengindentasi kode secara visual tanpa memengaruhi isi string yang dihasilkan.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

</div>
</div>

Indentasi internal dipertahankan relatif terhadap prefiks umum yang dihapus, sehingga struktur bertingkat tetap rapi.

Semua karakter khusus seperti tanda kutip (`"`) dan backslash (`\`) di dalam blok YAMLMultiline di-escape secara otomatis agar string Lua yang dihasilkan valid secara sintaks dan berperilaku sebagaimana mestinya.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

</div>
</div>
