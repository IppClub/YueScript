---
title: Line-Decorators
sidebar:
  order: 29
---

Zur Vereinfachung können `for`-Schleifen und `if`-Anweisungen auf einzelne Anweisungen am Zeilenende angewendet werden:

```yuescript
print "Hallo Welt" if name == "Rob"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "Hallo Welt" if name == "Rob"
```

</div>
</div>

Und mit einfachen Schleifen:

```yuescript
print "Element: ", item for item in *items
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "Element: ", item for item in *items
```

</div>
</div>

Und mit `while`-Schleifen:

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
