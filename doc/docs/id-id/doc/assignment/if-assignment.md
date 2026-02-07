# Penugasan pada If

Blok `if` dan `elseif` dapat menerima assignment sebagai ganti ekspresi kondisional. Saat kondisi dievaluasi, assignment akan dilakukan dan nilai yang di-assign akan digunakan sebagai ekspresi kondisional. Variabel yang di-assign hanya berada dalam scope badan kondisional, artinya tidak pernah tersedia jika nilai tidak truthy. Dan Anda harus menggunakan "walrus operator" `:=` sebagai ganti `=` untuk melakukan assignment.

```yuescript
if user := database.find_user "moon"
  print user.name
```

<YueDisplay>

```yue
if user := database.find_user "moon"
  print user.name
```

</YueDisplay>

```yuescript
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```

<YueDisplay>

```yue
if hello := os.getenv "hello"
  print "You have hello", hello
elseif world := os.getenv "world"
  print "you have world", world
else
  print "nothing :("
```

</YueDisplay>

Assignment if dengan beberapa nilai return. Hanya nilai pertama yang dicek, nilai lainnya tetap berada dalam scope.

```yuescript
if success, result := pcall -> "get result without problems"
  print result -- variabel result berada dalam scope
print "OK"
```

<YueDisplay>

```yue
if success, result := pcall -> "get result without problems"
  print result -- variabel result berada dalam scope
print "OK"
```

</YueDisplay>

## Assignment pada While

Anda juga bisa menggunakan assignment if di loop while untuk mendapatkan nilai sebagai kondisi loop.

```yuescript
while byte := stream\read_one!
  -- lakukan sesuatu dengan byte
  print byte
```

<YueDisplay>

```yue
while byte := stream\read_one!
  -- lakukan sesuatu dengan byte
  print byte
```

</YueDisplay>
