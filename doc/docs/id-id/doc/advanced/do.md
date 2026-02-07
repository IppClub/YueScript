# Do

Saat digunakan sebagai pernyataan, `do` bekerja seperti di Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil di sini
```

<YueDisplay>

```yue
do
  var = "hello"
  print var
print var -- nil di sini
```

</YueDisplay>

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

<YueDisplay>

```yue
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

</YueDisplay>

```yuescript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

<YueDisplay>

```yue
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

</YueDisplay>
