---
title: Tabellenliterale
sidebar:
  order: 24
---

Wie in Lua werden Tabellen mit geschweiften Klammern definiert.

```yuescript
some_values = {1, 2, 3, 4}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_values = {1, 2, 3, 4}
```

</div>
</div>

Anders als in Lua weist man einem Schlüssel in einer Tabelle mit **:** (statt **=**) einen Wert zu.

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["Lieblingsessen"]: "Reis"
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["Lieblingsessen"]: "Reis"
}
```

</div>
</div>

Die geschweiften Klammern können weggelassen werden, wenn eine einzelne Tabelle aus Schlüssel-Wert-Paaren zugewiesen wird.

```yuescript
profile =
  height: "4 Fuß",
  shoe_size: 13,
  favorite_foods: ["Eis", "Donuts"]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
profile =
  height: "4 Fuß",
  shoe_size: 13,
  favorite_foods: ["Eis", "Donuts"]
```

</div>
</div>

Zeilenumbrüche können Werte statt eines Kommas trennen (oder zusätzlich):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "Superman"
  occupation: "Verbrechensbekämpfung"
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "Superman"
  occupation: "Verbrechensbekämpfung"
}
```

</div>
</div>

Beim Erstellen eines einzeiligen Tabellenliterals können die geschweiften Klammern ebenfalls weggelassen werden:

```yuescript
my_function dance: "Tango", partner: "keiner"

y = type: "Hund", legs: 4, tails: 1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
my_function dance: "Tango", partner: "keiner"

y = type: "Hund", legs: 4, tails: 1
```

</div>
</div>

Die Schlüssel eines Tabellenliterals können Sprach-Schlüsselwörter sein, ohne sie zu escapen:

```yuescript
tbl = {
  do: "etwas"
  end: "Hunger"
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
tbl = {
  do: "etwas"
  end: "Hunger"
}
```

</div>
</div>

Wenn du eine Tabelle aus Variablen konstruierst und die Schlüssel den Variablennamen entsprechen sollen, kannst du den Präfix-Operator **:** verwenden:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</div>
</div>

Wenn der Schlüssel eines Feldes das Ergebnis eines Ausdrucks sein soll, kannst du ihn wie in Lua in **[ ]** setzen. Du kannst auch ein String-Literal direkt als Schlüssel verwenden und die eckigen Klammern weglassen. Das ist nützlich, wenn dein Schlüssel Sonderzeichen enthält.

```yuescript
t = {
  [1 + 2]: "hallo"
  "Hallo Welt": true
}
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
t = {
  [1 + 2]: "hallo"
  "Hallo Welt": true
}
```

</div>
</div>

Lua-Tabellen haben sowohl einen Array-Teil als auch einen Hash-Teil, aber manchmal ist es nützlich, hier eine semantische Unterscheidung zu treffen. Du kannst **[ ]** anstelle von **{ }** verwenden, um eine Tabelle explizit als Array zu deklarieren; dadurch wird verhindert, dass Schlüssel-Wert-Paare hineingeschrieben werden.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

</div>
</div>
