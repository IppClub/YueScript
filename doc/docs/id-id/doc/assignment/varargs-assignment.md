# Penugasan Varargs

Anda dapat meng-assign hasil yang dikembalikan dari sebuah fungsi ke simbol varargs `...`. Lalu akses isinya menggunakan cara Lua.

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

<YueDisplay>

```yue
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

</YueDisplay>
