---
title: Penugasan pada If
sidebar:
  order: 12
---

Blok `if` dan `elseif` dapat menerima assignment sebagai ganti ekspresi kondisional. Saat kondisi dievaluasi, assignment akan dilakukan dan nilai yang di-assign akan digunakan sebagai ekspresi kondisional. Variabel yang di-assign hanya berada dalam scope badan kondisional, artinya tidak pernah tersedia jika nilai tidak truthy. Dan Anda harus menggunakan "walrus operator" `:=` sebagai ganti `=` untuk melakukan assignment.

```yuescript
if user := database.find_user "moon"
  print user.name
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
if user := database.find_user "moon"
  print user.name
```

</div>
</div>

```yuescript
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```

</div>
</div>

Assignment if dengan beberapa nilai return. Hanya nilai pertama yang dicek, nilai lainnya tetap berada dalam scope.

```yuescript
if success, result := pcall -> "get result without problems"
  print result -- variabel result berada dalam scope
print "OK"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
if success, result := pcall -> "get result without problems"
  print result -- variabel result berada dalam scope
print "OK"
```

</div>
</div>

## Assignment pada While

Anda juga bisa menggunakan assignment if di loop while untuk mendapatkan nilai sebagai kondisi loop.

```yuescript
while byte := stream\read_one!
  -- lakukan sesuatu dengan byte
  print byte
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
while byte := stream\read_one!
  -- lakukan sesuatu dengan byte
  print byte
```

</div>
</div>
