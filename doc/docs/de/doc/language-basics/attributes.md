# Attribute

Syntax-Unterstützung für Lua-5.4-Attribute. Du kannst weiterhin die Deklarationen `const` und `close` verwenden und erhältst Konstantenprüfung sowie Scoped-Callbacks, wenn du auf Lua-Versionen unter 5.4 zielst.

```yuescript
const a = 123
close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs."
```

<YueDisplay>

```yue
const a = 123
close _ = <close>: -> print "Außerhalb des Gültigkeitsbereichs."
```

</YueDisplay>

Du kannst Destructuring mit als konstant markierten Variablen verwenden.

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

Du kannst auch eine globale Variable als `const` deklarieren.

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
