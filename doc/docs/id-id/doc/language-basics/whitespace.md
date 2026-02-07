# Spasi Kosong

YueScript adalah bahasa yang peka terhadap spasi. Anda harus menulis beberapa blok kode dengan indentasi yang sama menggunakan spasi **' '** atau tab **'\t'** seperti badan fungsi, daftar nilai, dan beberapa blok kontrol. Ekspresi yang mengandung spasi berbeda dapat bermakna berbeda. Tab diperlakukan seperti 4 spasi, tetapi sebaiknya jangan mencampur penggunaan spasi dan tab.

## Pemisah Pernyataan

Sebuah pernyataan biasanya berakhir pada pergantian baris. Anda juga bisa memakai titik koma `;` untuk mengakhiri pernyataan secara eksplisit, yang memungkinkan menulis beberapa pernyataan pada satu baris:

```yuescript
a = 1; b = 2; print a + b
```

<YueDisplay>

```yue
a = 1; b = 2; print a + b
```

</YueDisplay>

## Rantai Multibaris

Anda bisa menulis pemanggilan fungsi berantai multi-baris dengan indentasi yang sama.

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

<YueDisplay>

```yue
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

</YueDisplay>
