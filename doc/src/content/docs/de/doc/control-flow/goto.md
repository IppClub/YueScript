---
title: Goto
sidebar:
  order: 22
---

YueScript unterstützt die goto-Anweisung und die Label-Syntax zur Steuerung des Programmflusses, wobei die gleichen Regeln wie bei Luas goto-Anweisung gelten. **Hinweis:** Die goto-Anweisung erfordert Lua 5.2 oder höher. Beim Kompilieren zu Lua 5.1 führt die Verwendung der goto-Syntax zu einem Kompilierfehler.

Ein Label wird mit doppelten Doppelpunkten definiert:

```yuescript
::start::
::done::
::mein_label::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
::start::
::done::
::mein_label::
```

</div>
</div>

Die goto-Anweisung springt zu einem angegebenen Label:

```yuescript
a = 0
::start::
a += 1
goto done if a == 5
goto start
::done::
print "a ist jetzt 5"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 0
::start::
a += 1
goto done if a == 5
goto start
::done::
print "a ist jetzt 5"
```

</div>
</div>

Die goto-Anweisung ist nützlich, um aus tief verschachtelten Schleifen zu springen:

```yuescript
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print 'Pythagoreisches Tripel gefunden:', x, y, z
      goto ok
::ok::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for z = 1, 10
  for y = 1, 10 do for x = 1, 10
    if x^2 + y^2 == z^2
      print 'Pythagoreisches Tripel gefunden:', x, y, z
      goto ok
::ok::
```

</div>
</div>

Sie können auch Labels verwenden, um zu einer bestimmten Schleifenebene zu springen:

```yuescript
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print 'Pythagoreisches Tripel gefunden:', x, y, z
        print 'versuche nächstes z...'
        goto zcontinue
  ::zcontinue::
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
for z = 1, 10
  for y = 1, 10
    for x = 1, 10
      if x^2 + y^2 == z^2
        print 'Pythagoreisches Tripel gefunden:', x, y, z
        print 'versuche nächstes z...'
        goto zcontinue
  ::zcontinue::
```

</div>
</div>

## Hinweise

- Labels müssen innerhalb ihres Geltungsbereichs eindeutig sein
- goto kann zu Labels auf derselben oder äußeren Geltungsbereichsebenen springen
- goto kann nicht in innere Geltungsbereiche springen (wie in Blöcke oder Schleifen)
- Verwenden Sie goto sparsam, da es den Code schwieriger zu lesen und zu warten machen kann
