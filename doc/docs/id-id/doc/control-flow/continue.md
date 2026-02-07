# Pernyataan Continue

Pernyataan continue dapat digunakan untuk melewati iterasi saat ini di dalam loop.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

<YueDisplay>

```yue
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

</YueDisplay>

continue juga bisa digunakan bersama ekspresi loop untuk mencegah iterasi tersebut diakumulasikan ke hasil. Contoh ini memfilter tabel array menjadi hanya angka genap:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

<YueDisplay>

```yue
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

</YueDisplay>
