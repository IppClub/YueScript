# Try

A sintaxe para tratamento de erros do Lua em uma forma comum.

```yuescript
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- funcionando com padrão de atribuição em if
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

<YueDisplay>

```yue
try
  func 1, 2, 3
catch err
  print yue.traceback err

success, result = try
  func 1, 2, 3
catch err
  yue.traceback err

try func 1, 2, 3
catch err
  print yue.traceback err

success, result = try func 1, 2, 3

try
  print "trying"
  func 1, 2, 3

-- funcionando com padrão de atribuição em if
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

</YueDisplay>

## Try?

`try?` é um uso simplificado para sintaxe de tratamento de erros que omite o status booleano da instrução `try`, e retornará o resultado do bloco try quando tiver sucesso, retornando nil em vez do objeto de erro caso contrário.

```yuescript
a, b, c = try? func!

-- com operador de coalescência de nil
a = (try? func!) ?? "default"

-- como argumento de função
f try? func!

-- com bloco catch
f try?
  print 123
  func!
catch e
  print e
  e
```

<YueDisplay>

```yue
a, b, c = try? func!

-- com operador de coalescência de nil
a = (try? func!) ?? "default"

-- como argumento de função
f try? func!

-- com bloco catch
f try?
  print 123
  func!
catch e
  print e
  e
```

</YueDisplay>
