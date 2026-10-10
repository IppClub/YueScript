---
title: Literals
sidebar:
  order: 6
---

All of the primitive literals in Lua can be used. This applies to numbers, strings, booleans, and **nil**.

Unlike Lua, Line breaks are allowed inside of single and double quote strings without an escape sequence:

```yuescript
some_string = "Here is a string
  that has a line break in it."

-- You can mix expressions into string literals using #{} syntax.
-- String interpolation is only available in double quoted strings.
print "I am #{math.random! * 100}% sure."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_string = "Here is a string
  that has a line break in it."

-- You can mix expressions into string literals using #{} syntax.
-- String interpolation is only available in double quoted strings.
print "I am #{math.random! * 100}% sure."
```

</div>
</div>

## Number Literals

You can use underscores in a number literal to increase readability.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

</div>
</div>

## YAML Multiline String

The `|` prefix introduces a YAML-style multiline string literal:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
str = |
  key: value
  list:
    - item1
    - #{expr}
```

</div>
</div>

This allows writing structured multiline text conveniently. All line breaks and indentation are preserved relative to the first non-empty line, and expressions inside `#{...}` are interpolated automatically as `tostring(expr)`.

YAML Multiline String automatically detects the common leading whitespace prefix (minimum indentation across all non-empty lines) and removes it from all lines. This makes it easy to indent your code visually without affecting the resulting string content.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

</div>
</div>

Internal indentation is preserved relative to the removed common prefix, allowing clean nested structures.

All special characters like quotes (`"`) and backslashes (`\`) in the YAMLMultiline block are automatically escaped so that the generated Lua string is syntactically valid and behaves as expected.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

</div>
</div>
