---
title: Do
sidebar:
  order: 30
---

Saat digunakan sebagai pernyataan, `do` bekerja seperti di Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil di sini
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
do
  var = "hello"
  print var
print var -- nil di sini
```

</div>
</div>

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

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</div>
</div>

```yuescript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

</div>
</div>

Ekspresi `do` mendukung penggunaan `break` untuk memutus alur eksekusi dan mengembalikan banyak nilai lebih awal.

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

</div>
</div>
