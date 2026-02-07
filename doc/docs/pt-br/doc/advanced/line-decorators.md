# Decoradores de linha

Por conveniência, o loop for e a instrução if podem ser aplicados a instruções únicas no final da linha:

```yuescript
print "hello world" if name == "Rob"
```

<YueDisplay>

```yue
print "hello world" if name == "Rob"
```

</YueDisplay>

E com loops básicos:

```yuescript
print "item: ", item for item in *items
```

<YueDisplay>

```yue
print "item: ", item for item in *items
```

</YueDisplay>

E com loops while:

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
