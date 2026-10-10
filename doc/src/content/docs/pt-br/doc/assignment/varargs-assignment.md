---
title: Atribuição de varargs
sidebar:
  order: 13
---

Você pode atribuir os resultados retornados de uma função a um símbolo varargs `...`. E então acessar seu conteúdo da forma Lua.

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

</div>
</div>
