# Backcall

Backcall digunakan untuk meratakan callback yang bersarang. Backcall didefinisikan menggunakan panah yang mengarah ke kiri sebagai parameter terakhir secara default yang akan mengisi pemanggilan fungsi. Semua sintaks pada dasarnya sama seperti fungsi panah biasa, kecuali arahnya berlawanan dan badan fungsi tidak memerlukan indentasi.

```yuescript
x <- f
print "hello" .. x
```

<YueDisplay>

```yue
x <- f
print "hello" .. x
```

</YueDisplay>

Fungsi panah tebal juga tersedia.

```yuescript
<= f
print @value
```

<YueDisplay>

```yue
<= f
print @value
```

</YueDisplay>

Anda dapat menentukan placeholder untuk posisi fungsi backcall sebagai parameter.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

<YueDisplay>

```yue
(x) <- map _, [1, 2, 3]
x * 2
```

</YueDisplay>

Jika Anda ingin menulis kode lanjutan setelah backcall, Anda dapat memisahkannya dengan pernyataan `do`. Tanda kurung dapat dihilangkan untuk fungsi panah non-tebal.

```yuescript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

<YueDisplay>

```yue
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

</YueDisplay>
