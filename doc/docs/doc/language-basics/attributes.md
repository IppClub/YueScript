# Attributes

Syntax support for Lua 5.4 attributes. And you can still use both the `const` and `close` declaration and get constant check and scoped callback working when targeting Lua versions below 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Out of scope."
```

<YueDisplay>

```yue
const a = 123
close _ = <close>: -> print "Out of scope."
```

</YueDisplay>

You can do desctructuring with variables attributed as constant.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<YueDisplay>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</YueDisplay>

You can also declare a global variable to be `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

<YueDisplay>

```yue
global const Constant = 123
-- Constant = 1
```

</YueDisplay>
