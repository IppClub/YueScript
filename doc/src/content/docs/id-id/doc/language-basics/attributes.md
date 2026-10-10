---
title: Atribut
sidebar:
  order: 8
---

Dukungan sintaks untuk atribut Lua 5.4. Anda juga masih bisa menggunakan deklarasi `const` dan `close` dan mendapatkan pemeriksaan konstanta serta callback berbatas-scope ketika menargetkan versi Lua di bawah 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Out of scope."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const a = 123
close _ = <close>: -> print "Out of scope."
```

</div>
</div>

Anda dapat melakukan destrukturisasi dengan variabel yang diberi atribut sebagai konstanta.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</div>
</div>

Anda juga bisa mendeklarasikan variabel global sebagai `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
global const Constant = 123
-- Constant = 1
```

</div>
</div>
