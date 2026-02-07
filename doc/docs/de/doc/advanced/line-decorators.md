# Line-Decorators

Zur Vereinfachung können `for`-Schleifen und `if`-Anweisungen auf einzelne Anweisungen am Zeilenende angewendet werden:

```yuescript
print "Hallo Welt" if name == "Rob"
```

<YueDisplay>

```yue
print "Hallo Welt" if name == "Rob"
```

</YueDisplay>

Und mit einfachen Schleifen:

```yuescript
print "Element: ", item for item in *items
```

<YueDisplay>

```yue
print "Element: ", item for item in *items
```

</YueDisplay>

Und mit `while`-Schleifen:

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

<YueDisplay>

```yue
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

</YueDisplay>
