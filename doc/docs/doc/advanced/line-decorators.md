# Line Decorators

For convenience, the for loop and if statement can be applied to single statements at the end of the line:

```yuescript
print "hello world" if name == "Rob"
```
<YueDisplay>

```yue
print "hello world" if name == "Rob"
```

</YueDisplay>

And with basic loops:

```yuescript
print "item: ", item for item in *items
```
<YueDisplay>

```yue
print "item: ", item for item in *items
```

</YueDisplay>

And with while loops:

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
