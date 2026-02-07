# Kondisional

```yuescript
have_coins = false
if have_coins
  print "Dapat koin"
else
  print "Tidak ada koin"
```

<YueDisplay>

```yue
have_coins = false
if have_coins
  print "Dapat koin"
else
  print "Tidak ada koin"
```

</YueDisplay>

Sintaks pendek untuk pernyataan tunggal juga bisa digunakan:

```yuescript
have_coins = false
if have_coins then print "Dapat koin" else print "Tidak ada koin"
```

<YueDisplay>

```yue
have_coins = false
if have_coins then print "Dapat koin" else print "Tidak ada koin"
```

</YueDisplay>

Karena pernyataan if dapat digunakan sebagai ekspresi, ini juga bisa ditulis sebagai:

```yuescript
have_coins = false
print if have_coins then "Dapat koin" else "Tidak ada koin"
```

<YueDisplay>

```yue
have_coins = false
print if have_coins then "Dapat koin" else "Tidak ada koin"
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Kebalikan dari if adalah unless:

```yuescript
unless os.date("%A") == "Monday"
  print "hari ini bukan Senin!"
```

<YueDisplay>

```yue
unless os.date("%A") == "Monday"
  print "hari ini bukan Senin!"
```

</YueDisplay>

```yuescript
print "Kamu beruntung!" unless math.random! > 0.1
```

<YueDisplay>

```yue
print "Kamu beruntung!" unless math.random! > 0.1
```

</YueDisplay>

## Ekspresi In

Anda dapat menulis kode pengecekan rentang dengan `ekspresi in`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "memeriksa kesamaan dengan nilai-nilai diskrit"

if a in list
  print "memeriksa apakah `a` ada di dalam daftar"
```

<YueDisplay>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "memeriksa kesamaan dengan nilai-nilai diskrit"

if a in list
  print "memeriksa apakah `a` ada di dalam daftar"
```

</YueDisplay>
