---
title: Attributes
sidebar:
  order: 8
---

Syntax support for Lua 5.4 attributes. And you can still use both the `const` and `close` declaration and get constant check and scoped callback working when targeting Lua versions below 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Out of scope."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const a = 123
close _ = <close>: -> print "Out of scope."
```

</div>
</div>

You can do desctructuring with variables attributed as constant.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const {:a, :b, c, d} = tb
-- a = 1
```

</div>
</div>

You can also declare a global variable to be `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
global const Constant = 123
-- Constant = 1
```

</div>
</div>
