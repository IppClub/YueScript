---
title: Backcall
sidebar:
  order: 16
---

Backcall digunakan untuk meratakan callback yang bersarang. Backcall didefinisikan menggunakan panah yang mengarah ke kiri sebagai parameter terakhir secara default yang akan mengisi pemanggilan fungsi. Semua sintaks pada dasarnya sama seperti fungsi panah biasa, kecuali arahnya berlawanan dan badan fungsi tidak memerlukan indentasi.

```yuescript
x <- f
print "hello" .. x
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
x <- f
print "hello" .. x
```

</div>
</div>

Fungsi panah tebal juga tersedia.

```yuescript
<= f
print @value
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
<= f
print @value
```

</div>
</div>

Anda dapat menentukan placeholder untuk posisi fungsi backcall sebagai parameter.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
(x) <- map _, [1, 2, 3]
x * 2
```

</div>
</div>

Jika Anda ingin menulis kode lanjutan setelah backcall, Anda dapat memisahkannya dengan pernyataan `do`. Tanda kurung dapat dihilangkan untuk fungsi panah non-tebal.

```yuescript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

</div>
</div>
