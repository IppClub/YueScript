# Dekorator Baris

Untuk kemudahan, loop for dan pernyataan if dapat diterapkan pada pernyataan tunggal di akhir baris:

```yuescript
print "hello world" if name == "Rob"
```

<YueDisplay>

```yue
print "hello world" if name == "Rob"
```

</YueDisplay>

Dan dengan loop dasar:

```yuescript
print "item: ", item for item in *items
```

<YueDisplay>

```yue
print "item: ", item for item in *items
```

</YueDisplay>

Dan dengan loop while:

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
