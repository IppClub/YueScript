# Leerraum

YueScript ist eine whitespace-sensible Sprache. Du musst bestimmte Code-Blöcke mit derselben Einrückung (Leerzeichen **' '** oder Tab **'\t'**) schreiben, z. B. Funktionskörper, Wertelisten und Kontrollblöcke. Ausdrücke mit unterschiedlichem Leerraum können unterschiedliche Bedeutungen haben. Ein Tab wird wie 4 Leerzeichen behandelt, aber es ist besser, Leerzeichen und Tabs nicht zu mischen.

## Anweisungs-Trenner

Eine Anweisung endet normalerweise an einem Zeilenumbruch. Du kannst auch ein Semikolon `;` verwenden, um eine Anweisung explizit zu beenden, wodurch mehrere Anweisungen in einer Zeile möglich sind:

```yuescript
a = 1; b = 2; print a + b
```

<YueDisplay>

```yue
a = 1; b = 2; print a + b
```

</YueDisplay>

## Mehrzeiliges Chaining

Du kannst mehrzeilige, verkettete Funktionsaufrufe mit derselben Einrückung schreiben.

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
