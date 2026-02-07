# Atribuição de varargs

Você pode atribuir os resultados retornados de uma função a um símbolo varargs `...`. E então acessar seu conteúdo da forma Lua.

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
