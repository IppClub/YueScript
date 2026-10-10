---
title: Dekorator Baris
sidebar:
  order: 29
---

Untuk kemudahan, loop for dan pernyataan if dapat diterapkan pada pernyataan tunggal di akhir baris:

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

Dan dengan loop dasar:

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

Dan dengan loop while:

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
