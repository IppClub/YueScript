---
title: Decoradores de linha
sidebar:
  order: 29
---

Por conveniência, o loop for e a instrução if podem ser aplicados a instruções únicas no final da linha:

```yuescript
print "hello world" if name == "Rob"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "hello world" if name == "Rob"
```

</div>
</div>

E com loops básicos:

```yuescript
print "item: ", item for item in *items
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "item: ", item for item in *items
```

</div>
</div>

E com loops while:

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

</div>
</div>
