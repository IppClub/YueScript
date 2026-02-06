# Whitespace

YueScript is a whitespace significant language. You have to write some code block in the same indent with space **' '** or tab **'\t'** like function body, value list and some control blocks. And expressions containing different whitespaces might mean different things. Tab is treated like 4 space, but it's better not mix the use of spaces and tabs.

## Statement Separator

A statement normally ends at a line break. You can also use a semicolon `;` to explicitly terminate a statement, which allows writing multiple statements on the same line:

```yuescript
a = 1; b = 2; print a + b
```
<YueDisplay>

```yue
a = 1; b = 2; print a + b
```

</YueDisplay>

## Multiline Chaining

You can write multi-line chaining function calls with a same indent.

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```
<YueDisplay>

```yue
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

</YueDisplay>
