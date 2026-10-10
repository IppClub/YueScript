---
title: Line Decorators
sidebar:
  order: 29
---

For convenience, the for loop and if statement can be applied to single statements at the end of the line:

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

And with basic loops:

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

And with while loops:

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
