---
title: 注释
sidebar:
  order: 5
---

```yuescript
-- 我是一个注释

str = --[[
这是一个多行注释。
没问题。
]] strA \ -- 注释 1
  .. strB \ -- 注释 2
  .. strC

func --[[端口]] 3000, --[[ip]] "192.168.1.1"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- 我是一个注释

str = --[[
这是一个多行注释。
没问题。
]] strA \ -- 注释 1
  .. strB \ -- 注释 2
  .. strC

func --[[端口]] 3000, --[[ip]] "192.168.1.1"
```

</div>
</div>
