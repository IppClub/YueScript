---
title: Attribute
sidebar:
  order: 8
---

Syntax-Unterstützung für Lua-5.4-Attribute. Du kannst weiterhin die Deklarationen `const` und `close` verwenden und erhältst Konstantenprüfung sowie Scoped-Callbacks, wenn du auf Lua-Versionen unter 5.4 zielst.

```yuescript
const a = 123
close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs."
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
const a = 123
close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs."
```

</div>
</div>

Du kannst Destructuring mit als konstant markierten Variablen verwenden.

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

Du kannst auch eine globale Variable als `const` deklarieren.

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
