# Atribut

Dukungan sintaks untuk atribut Lua 5.4. Anda juga masih bisa menggunakan deklarasi `const` dan `close` dan mendapatkan pemeriksaan konstanta serta callback berbatas-scope ketika menargetkan versi Lua di bawah 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Out of scope."
```

<YueDisplay>

```yue
const a = 123
close _ = <close>: -> print "Out of scope."
```

</YueDisplay>

Anda dapat melakukan destrukturisasi dengan variabel yang diberi atribut sebagai konstanta.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<YueDisplay>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</YueDisplay>

Anda juga bisa mendeklarasikan variabel global sebagai `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

<YueDisplay>

```yue
global const Constant = 123
-- Constant = 1
```

</YueDisplay>
