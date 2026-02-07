# Tabellenliterale

Wie in Lua werden Tabellen mit geschweiften Klammern definiert.

```yuescript
some_values = [1, 2, 3, 4]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
```

</YueDisplay>

Anders als in Lua weist man einem Schlüssel in einer Tabelle mit **:** (statt **=**) einen Wert zu.

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["Lieblingsessen"]: "Reis"
}
```

<YueDisplay>

```yue
some_values = {
  name: "Bill",
  age: 200,
  ["Lieblingsessen"]: "Reis"
}
```

</YueDisplay>

Die geschweiften Klammern können weggelassen werden, wenn eine einzelne Tabelle aus Schlüssel-Wert-Paaren zugewiesen wird.

```yuescript
profile =
  height: "4 Fuß",
  shoe_size: 13,
  favorite_foods: ["Eis", "Donuts"]
```

<YueDisplay>

```yue
profile =
  height: "4 Fuß",
  shoe_size: 13,
  favorite_foods: ["Eis", "Donuts"]
```

</YueDisplay>

Zeilenumbrüche können Werte statt eines Kommas trennen (oder zusätzlich):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "Superman"
  occupation: "Verbrechensbekämpfung"
}
```

<YueDisplay>

```yue
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "Superman"
  occupation: "Verbrechensbekämpfung"
}
```

</YueDisplay>

Beim Erstellen eines einzeiligen Tabellenliterals können die geschweiften Klammern ebenfalls weggelassen werden:

```yuescript
my_function dance: "Tango", partner: "keiner"

y = type: "Hund", legs: 4, tails: 1
```

<YueDisplay>

```yue
my_function dance: "Tango", partner: "keiner"

y = type: "Hund", legs: 4, tails: 1
```

</YueDisplay>

Die Schlüssel eines Tabellenliterals können Sprach-Schlüsselwörter sein, ohne sie zu escapen:

```yuescript
tbl = {
  do: "etwas"
  end: "Hunger"
}
```

<YueDisplay>

```yue
tbl = {
  do: "etwas"
  end: "Hunger"
}
```

</YueDisplay>

Wenn du eine Tabelle aus Variablen konstruierst und die Schlüssel den Variablennamen entsprechen sollen, kannst du den Präfix-Operator **:** verwenden:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

<YueDisplay>

```yue
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

</YueDisplay>

Wenn der Schlüssel eines Feldes das Ergebnis eines Ausdrucks sein soll, kannst du ihn wie in Lua in **[ ]** setzen. Du kannst auch ein String-Literal direkt als Schlüssel verwenden und die eckigen Klammern weglassen. Das ist nützlich, wenn dein Schlüssel Sonderzeichen enthält.

```yuescript
t = {
  [1 + 2]: "hallo"
  "Hallo Welt": true
}
```

<YueDisplay>

```yue
t = {
  [1 + 2]: "hallo"
  "Hallo Welt": true
}
```

</YueDisplay>

Lua-Tabellen haben einen Array-Teil und einen Hash-Teil, aber manchmal möchte man beim Schreiben von Lua-Tabellen eine semantische Unterscheidung zwischen Array- und Hash-Nutzung machen. Dann kannst du eine Lua-Tabelle mit **[ ]** statt **{ }** schreiben, um eine Array-Tabelle darzustellen, und das Schreiben von Schlüssel-Wert-Paaren in einer Listentabelle ist nicht erlaubt.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

<YueDisplay>

```yue
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

</YueDisplay>
