# Stub Fungsi

Sering kali fungsi dari sebuah objek diteruskan sebagai nilai, misalnya meneruskan method instance ke fungsi lain sebagai callback. Jika fungsi mengharapkan objek yang dioperasikan sebagai argumen pertama, maka Anda harus menggabungkan objek tersebut dengan fungsi agar dapat dipanggil dengan benar.

Sintaks stub fungsi adalah singkatan untuk membuat fungsi closure baru yang menggabungkan objek dan fungsi. Fungsi baru ini memanggil fungsi yang dibungkus dalam konteks objek yang benar.

Sintaksnya sama seperti memanggil method instance dengan operator `\`, tetapi tanpa menyediakan daftar argumen.

```yuescript
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- ini tidak akan berfungsi:
-- fungsi tidak memiliki referensi ke my_object
run_callback my_object.write

-- sintaks stub fungsi
-- memungkinkan kita membundel objek ke fungsi baru
run_callback my_object\write
```

<YueDisplay>

```yue
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- ini tidak akan berfungsi:
-- fungsi tidak memiliki referensi ke my_object
run_callback my_object.write

-- sintaks stub fungsi
-- memungkinkan kita membundel objek ke fungsi baru
run_callback my_object\write
```

</YueDisplay>
