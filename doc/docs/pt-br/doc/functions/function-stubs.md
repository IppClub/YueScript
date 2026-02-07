# Stubs de função

É comum passar uma função de um objeto como valor, por exemplo, passando um método de instância para uma função como callback. Se a função espera o objeto em que está operando como primeiro argumento, então você deve de alguma forma empacotar esse objeto com a função para que ela possa ser chamada corretamente.

A sintaxe de function stub é uma forma abreviada de criar uma nova função closure que empacota tanto o objeto quanto a função. Esta nova função chama a função empacotada no contexto correto do objeto.

Sua sintaxe é a mesma que chamar um método de instância com o operador \, mas sem lista de argumentos fornecida.

```yuescript
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- isso não funcionará:
-- a função não tem referência a my_object
run_callback my_object.write

-- sintaxe de function stub
-- nos permite empacotar o objeto em uma nova função
run_callback my_object\write
```

<YueDisplay>

```yue
my_object = {
  value: 1000
  write: => print "the value:", @value
}

run_callback = (func) ->
  print "running callback..."
  func!

-- isso não funcionará:
-- a função não tem referência a my_object
run_callback my_object.write

-- sintaxe de function stub
-- nos permite empacotar o objeto em uma nova função
run_callback my_object\write
```

</YueDisplay>
