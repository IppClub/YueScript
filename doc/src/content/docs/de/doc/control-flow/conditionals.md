---
title: Bedingungen
sidebar:
  order: 18
---

```yuescript
have_coins = false
if have_coins
  print "Münzen erhalten"
else
  print "Keine Münzen"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins
  print "Münzen erhalten"
else
  print "Keine Münzen"
```

</div>
</div>

Eine Kurzsyntax für einzelne Anweisungen kann ebenfalls verwendet werden:

```yuescript
have_coins = false
if have_coins then print "Münzen erhalten" else print "Keine Münzen"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
if have_coins then print "Münzen erhalten" else print "Keine Münzen"
```

</div>
</div>

Da `if`-Anweisungen als Ausdrücke verwendet werden können, kann man das auch so schreiben:

```yuescript
have_coins = false
print if have_coins then "Münzen erhalten" else "Keine Münzen"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
have_coins = false
print if have_coins then "Münzen erhalten" else "Keine Münzen"
```

</div>
</div>

Bedingungen können auch in `return`-Anweisungen und Zuweisungen verwendet werden:

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Ich bin sehr groß"
else
  "Ich bin nicht so groß"

print message -- gibt aus: Ich bin sehr groß
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Ich bin sehr groß"
else
  "Ich bin nicht so groß"

print message -- gibt aus: Ich bin sehr groß
```

</div>
</div>

Das Gegenteil von `if` ist `unless`:

```yuescript
unless os.date("%A") == "Monday"
  print "Es ist nicht Montag!"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
unless os.date("%A") == "Monday"
  print "Es ist nicht Montag!"
```

</div>
</div>

```yuescript
print "You're lucky!" unless math.random! > 0.1
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
print "You're lucky!" unless math.random! > 0.1
```

</div>
</div>

## In-Ausdruck

Mit einem `in`-Ausdruck kannst du Bereichsprüfungen schreiben.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "Gleichheitsprüfung mit diskreten Werten"

if a in list
  print "Prüfen, ob `a` in einer Liste ist"
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 5

if a in [1, 3, 5, 7]
  print "Gleichheitsprüfung mit diskreten Werten"

if a in list
  print "Prüfen, ob `a` in einer Liste ist"
```

</div>
</div>

Der `in`-Operator kann auch mit Tabellen verwendet werden und unterstützt die Variante `not in` für Verneinungen:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a ist in der Tabelle"

not_exist = item not in list

check = -> value not in table
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a ist in der Tabelle"

not_exist = item not in list

check = -> value not in table
```

</div>
</div>

Eine Ein-Element-Liste oder Tabelle prüft auf Gleichheit mit diesem Element:

```yuescript
-- [1,] prüft, ob wert == 1
c = a in [1,]

-- {1} prüft auch, ob wert == 1
c = a in {1}

-- Ohne Komma ist [1] ein Indexzugriff (tb[1])
with tb
  c = a in [1]
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
-- [1,] prüft, ob wert == 1
c = a in [1,]

-- {1} prüft auch, ob wert == 1
c = a in {1}

-- Ohne Komma ist [1] ein Indexzugriff (tb[1])
with tb
  c = a in [1]
```

</div>
</div>
