# Literals

All of the primitive literals in Lua can be used. This applies to numbers, strings, booleans, and **nil**.

Unlike Lua, Line breaks are allowed inside of single and double quote strings without an escape sequence:

```yuescript
some_string = "Here is a string
  that has a line break in it."

-- You can mix expressions into string literals using #{} syntax.
-- String interpolation is only available in double quoted strings.
print "I am #{math.random! * 100}% sure."
```
<YueDisplay>

```yue
some_string = "Here is a string
  that has a line break in it."

-- You can mix expressions into string literals using #{} syntax.
-- String interpolation is only available in double quoted strings.
print "I am #{math.random! * 100}% sure."
```

</YueDisplay>

## Number Literals

You can use underscores in a number literal to increase readability.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```
<YueDisplay>

```yue
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

</YueDisplay>

## YAML Multiline String

The `|` prefix introduces a YAML-style multiline string literal:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```
<YueDisplay>

```yue
str = |
  key: value
  list:
    - item1
    - #{expr}
```

</YueDisplay>

This allows writing structured multiline text conveniently. All line breaks and indentation are preserved relative to the first non-empty line, and expressions inside `#{...}` are interpolated automatically as `tostring(expr)`.

YAML Multiline String automatically detects the common leading whitespace prefix (minimum indentation across all non-empty lines) and removes it from all lines. This makes it easy to indent your code visually without affecting the resulting string content.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```
<YueDisplay>

```yue
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

</YueDisplay>

Internal indentation is preserved relative to the removed common prefix, allowing clean nested structures.

All special characters like quotes (`"`) and backslashes (`\`) in the YAMLMultiline block are automatically escaped so that the generated Lua string is syntactically valid and behaves as expected.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```
<YueDisplay>

```yue
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

</YueDisplay>
