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

<YueDisplay>

```yue
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

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>
