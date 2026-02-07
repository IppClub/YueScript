# Switch

A instrução switch é uma forma abreviada de escrever uma série de instruções if que verificam o mesmo valor. Observe que o valor é avaliado apenas uma vez. Como as instruções if, os switches podem ter um bloco else para tratar ausência de correspondências. A comparação é feita com o operador ==. Na instrução switch, você também pode usar expressão de atribuição para armazenar valor de variável temporária.

```yuescript
switch name := "Dan"
  when "Robert"
    print "Você é Robert"
  when "Dan", "Daniel"
    print "Seu nome é Dan"
  else
    print "Não sei quem você é com o nome #{name}"
```

<YueDisplay>

```yue
switch name := "Dan"
  when "Robert"
    print "Você é Robert"
  when "Dan", "Daniel"
    print "Seu nome é Dan"
  else
    print "Não sei quem você é com o nome #{name}"
```

</YueDisplay>

Uma cláusula when de um switch pode corresponder a múltiplos valores listando-os separados por vírgula.

Os switches também podem ser usados como expressões; aqui podemos atribuir o resultado do switch a uma variável:

```yuescript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "não consigo contar tão alto!"
```

<YueDisplay>

```yue
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "não consigo contar tão alto!"
```

</YueDisplay>

Podemos usar a palavra-chave then para escrever o bloco when de um switch em uma única linha. Nenhuma palavra-chave extra é necessária para escrever o bloco else em uma única linha.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "você tem sorte"
  when 2 then "você quase tem sorte"
  else "não tão sortudo"
```

<YueDisplay>

```yue
msg = switch math.random(1, 5)
  when 1 then "você tem sorte"
  when 2 then "você quase tem sorte"
  else "não tão sortudo"
```

</YueDisplay>

Se você quiser escrever código com uma indentação a menos ao escrever uma instrução switch, pode colocar a primeira cláusula when na linha de início da instrução, e então todas as outras cláusulas podem ser escritas com uma indentação a menos.

```yuescript
switch math.random(1, 5)
  when 1
    print "você tem sorte" -- duas indentações
  else
    print "não tão sortudo"

switch math.random(1, 5) when 1
  print "você tem sorte" -- uma indentação
else
  print "não tão sortudo"
```

<YueDisplay>

```yue
switch math.random(1, 5)
  when 1
    print "você tem sorte" -- duas indentações
  else
    print "não tão sortudo"

switch math.random(1, 5) when 1
  print "você tem sorte" -- uma indentação
else
  print "não tão sortudo"
```

</YueDisplay>

Vale notar a ordem da expressão de comparação do case. A expressão do case está no lado esquerdo. Isso pode ser útil se a expressão do case quiser sobrescrever como a comparação é feita definindo um metamétodo eq.

## Correspondência de tabela

Você pode fazer correspondência de tabela em uma cláusula when de switch, se a tabela puder ser desestruturada por uma estrutura específica e obter valores não-nil.

```yuescript
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "tamanho #{width}, #{height}"
```

<YueDisplay>

```yue
items =
  * x: 100
    y: 200
  * width: 300
    height: 400

for item in *items
  switch item
    when :x, :y
      print "Vec2 #{x}, #{y}"
    when :width, :height
      print "tamanho #{width}, #{height}"
```

</YueDisplay>

Você pode usar valores padrão para opcionalmente desestruturar a tabela para alguns campos.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- obtém erro: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- a desestruturação de tabela ainda passará
```

<YueDisplay>

```yue
item = {}

{pos: {:x = 50, :y = 200}} = item -- obtém erro: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- a desestruturação de tabela ainda passará
```

</YueDisplay>

Você também pode corresponder contra elementos de array, campos de tabela, e até estruturas aninhadas com literais de array ou tabela.

Corresponder contra elementos de array.

```yuescript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b tem valor padrão
    print "1, 2, #{b}"
```

<YueDisplay>

```yue
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- b tem valor padrão
    print "1, 2, #{b}"
```

</YueDisplay>

Corresponder contra campos de tabela com desestruturação.

```yuescript
switch tb
  when success: true, :result
    print "sucesso", result
  when success: false
    print "falhou", result
  else
    print "inválido"
```

<YueDisplay>

```yue
switch tb
  when success: true, :result
    print "sucesso", result
  when success: false
    print "falhou", result
  else
    print "inválido"
```

</YueDisplay>

Corresponder contra estruturas de tabela aninhadas.

```yuescript
switch tb
  when data: {type: "success", :content}
    print "sucesso", content
  when data: {type: "error", :content}
    print "erro", content
  else
    print "inválido"
```

<YueDisplay>

```yue
switch tb
  when data: {type: "success", :content}
    print "sucesso", content
  when data: {type: "error", :content}
    print "erro", content
  else
    print "inválido"
```

</YueDisplay>

Corresponder contra array de tabelas.

```yuescript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "correspondido", fourth
```

<YueDisplay>

```yue
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "correspondido", fourth
```

</YueDisplay>

Corresponder contra uma lista e capturar um intervalo de elementos.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Grupo:", groups -- imprime: {"admin", "users"}
    print "Recurso:", resource -- imprime: "logs"
    print "Ação:", action -- imprime: "view"
```

<YueDisplay>

```yue
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Grupo:", groups -- imprime: {"admin", "users"}
    print "Recurso:", resource -- imprime: "logs"
    print "Ação:", action -- imprime: "view"
```

</YueDisplay>
