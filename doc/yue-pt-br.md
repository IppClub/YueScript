# Documentação do YueScript

Bem-vindo à documentação oficial do <b>YueScript</b>!<br/>
Aqui você encontra recursos da linguagem, uso, exemplos de referência e materiais úteis.<br/>
Selecione um capítulo na barra lateral para começar a aprender YueScript.

# Do

Quando usado como instrução, do funciona exatamente como no Lua.

```yuescript
do
  var = "hello"
  print var
print var -- nil aqui
```

O **do** do YueScript também pode ser usado como expressão. Permitindo combinar múltiplas linhas em uma. O resultado da expressão do é a última instrução em seu corpo.

```yuescript
counter = do
  i = 0
  ->
    i += 1
    i

print counter!
print counter!
```

```yuescript
tbl = {
  key: do
    print "assigning key!"
    1234
}
```

Expressões `do` suportam usar `break` para interromper o fluxo de execução e retornar múltiplos valores antecipadamente.

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

# Decoradores de linha

Por conveniência, o loop for e a instrução if podem ser aplicados a instruções únicas no final da linha:

```yuescript
print "hello world" if name == "Rob"
```

E com loops básicos:

```yuescript
print "item: ", item for item in *items
```

E com loops while:

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

# Macro

## Uso comum

A função macro é usada para avaliar uma string em tempo de compilação e inserir os códigos gerados na compilação final.

```yuescript
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'hello world'"
print $HELLO

macro config = (debugging) ->
  global debugMode = debugging == "true"
  ""

macro asserts = (cond) ->
  debugMode and "assert #{cond}" or ""

macro assert = (cond) ->
  debugMode and "assert #{cond}" or "#{cond}"

$config true
$asserts item ~= nil

$config false
value = $assert item

-- as expressões passadas são tratadas como strings
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

## Inserir códigos brutos

Uma função macro pode retornar uma string YueScript ou uma tabela de configuração contendo códigos Lua.

```yuescript
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "fail to assign to the Yue macro defined variable"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "fail to assign to the Lua macro defined variable"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- os símbolos inicial e final da string bruta são aparados automaticamente
$lua[==[
-- inserção de códigos Lua brutos
if cond then
  print("output")
end
]==]
```

## Exportar macro

Funções macro podem ser exportadas de um módulo e importadas em outro módulo. Você deve colocar funções export macro em um único arquivo para uso, e apenas definição de macro, importação de macro e expansão de macro inline podem ser colocadas no módulo exportador de macro.

```yuescript
-- arquivo: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- arquivo main.yue
import "utils" as {
  $, -- símbolo para importar todas as macros
  $foreach: $each -- renomear macro $foreach para $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```

## Macro embutida

Existem algumas macros embutidas, mas você pode sobrescrevê-las declarando macros com os mesmos nomes.

```yuescript
print $FILE -- obtém string do nome do módulo atual
print $LINE -- obtém número 2
```

## Gerando macros com macros

No YueScript, as funções macro permitem que você gere código em tempo de compilação. Aninhando funções macro, você pode criar padrões de geração mais complexos. Este recurso permite que você defina uma função macro que gera outra função macro, permitindo geração de código mais dinâmica.

```yuescript
macro Enum = (...) ->
  items = {...}
  itemSet = {item, true for item in *items}
  (item) ->
    error "got \"#{item}\", expecting one of #{table.concat items, ', '}" unless itemSet[item]
    "\"#{item}\""

macro BodyType = $Enum(
  Static
  Dynamic
  Kinematic
)

print "Valid enum type:", $BodyType Static
-- print "Compilation error with enum type:", $BodyType Unknown
```

## Gerando código em múltiplas linhas

Quando uma macro retorna código Yue em múltiplas linhas, não é recomendado usar uma string multilinha entre aspas. Prefira `-> |`.

Uma string entre aspas preserva o texto literal, enquanto uma string multilinha estilo YAML remove a indentação inicial comum. Isso normalmente deixa os blocos Yue gerados mais estáveis, especialmente quando o código gerado contém comentários ou blocos aninhados.

```yuescript
macro default_conf = (conf) -> "
  -- useful; only set once
#{conf}.identity = 'LOVE'
#{conf}.version = \"11.5\"
  "

love.conf = (t) ->
  $default_conf t
```

```yuescript
macro default_conf = (conf) -> |
  -- useful; only set once
  #{conf}.identity = 'LOVE'
  #{conf}.version = "11.5"

love.conf = (t) ->
  $default_conf t
```

## Validação de argumentos

Você pode declarar os tipos de nós AST esperados na lista de argumentos e verificar se os argumentos da macro recebidos atendem às expectativas em tempo de compilação.

```yuescript
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

Se você precisar de verificação de argumentos mais flexível, pode usar a função macro embutida `$is_ast` para verificar manualmente no lugar apropriado.

```yuescript
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

Para mais detalhes sobre os nós AST disponíveis, consulte as definições em maiúsculas em [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp).

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

# Literais de tabela

Como no Lua, as tabelas são delimitadas por chaves.

```yuescript
some_values = {1, 2, 3, 4}
```

Diferente do Lua, atribuir um valor a uma chave em uma tabela é feito com **:** (em vez de **=**).

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

As chaves podem ser omitidas se uma única tabela de pares chave-valor está sendo atribuída.

```yuescript
profile =
  height: "4 feet",
  shoe_size: 13,
  favorite_foods: ["ice cream", "donuts"]
```

Quebras de linha podem ser usadas para delimitar valores em vez de vírgula (ou ambos):

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "superman"
  occupation: "crime fighting"
}
```

Ao criar um literal de tabela em uma única linha, as chaves também podem ser omitidas:

```yuescript
my_function dance: "Tango", partner: "none"

y = type: "dog", legs: 4, tails: 1
```

As chaves de um literal de tabela podem ser palavras-chave da linguagem sem precisar escapar:

```yuescript
tbl = {
  do: "something"
  end: "hunger"
}
```

Se você está construindo uma tabela a partir de variáveis e deseja que as chaves sejam iguais aos nomes das variáveis, então o operador de prefixo **:** pode ser usado:

```yuescript
hair = "golden"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

Se você quiser que a chave de um campo na tabela seja o resultado de uma expressão, então pode envolvê-la em **[ ]**, assim como no Lua. Você também pode usar um literal de string diretamente como chave, omitindo os colchetes. Isso é útil se sua chave tiver caracteres especiais.

```yuescript
t = {
  [1 + 2]: "hello"
  "hello world": true
}
```

As tabelas Lua têm tanto uma parte array quanto uma parte hash, mas às vezes é útil fazer uma distinção semântica entre as duas. Você pode usar **[ ]** em vez de **{ }** para declarar explicitamente uma tabela como um array, fazer isso impedirá que quaisquer pares chave-valor sejam escritos dentro dela.

```yuescript
some_values = [1, 2, 3, 4]
list_with_one_element = [1, ]
```

# Compreensões

As compreensões fornecem uma sintaxe conveniente para construir uma nova tabela iterando sobre algum objeto existente e aplicando uma expressão a seus valores. Existem dois tipos de compreensões: compreensões de lista e compreensões de tabela. Ambas produzem tabelas Lua; as compreensões de lista acumulam valores em uma tabela semelhante a array, e as compreensões de tabela permitem definir tanto a chave quanto o valor em cada iteração.

## Compreensões de lista

O seguinte cria uma cópia da tabela items mas com todos os valores dobrados.

```yuescript
items = [ 1, 2, 3, 4 ]
doubled = [item * 2 for i, item in ipairs items]
```

Os itens incluídos na nova tabela podem ser restringidos com uma cláusula when:

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

Como é comum iterar sobre os valores de uma tabela indexada numericamente, um operador **\*** é introduzido. O exemplo doubled pode ser reescrito como:

```yuescript
doubled = [item * 2 for item in *items]
```

Nas compreensões de lista, você também pode usar o operador spread `...` para achatar listas aninhadas, alcançando um efeito de flat map:

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat agora é [1, 2, 3, 4, 5, 6]
```

As cláusulas for e when podem ser encadeadas tanto quanto desejado. O único requisito é que uma compreensão tenha pelo menos uma cláusula for.

Usar múltiplas cláusulas for é o mesmo que usar loops aninhados:

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

Loops for numéricos também podem ser usados em compreensões:

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

## Compreensões de tabela

A sintaxe para compreensões de tabela é muito semelhante, diferindo apenas por usar **{** e **}** e receber dois valores de cada iteração.

Este exemplo faz uma cópia da tabela thing:

```yuescript
thing = {
  color: "red"
  name: "fast"
  width: 123
}

thing_copy = {k, v for k, v in pairs thing}
```

```yuescript
no_color = {k, v for k, v in pairs thing when k != "color"}
```

O operador **\*** também é suportado. Aqui criamos uma tabela de consulta de raiz quadrada para alguns números.

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

A tupla chave-valor em uma compreensão de tabela também pode vir de uma única expressão, caso em que a expressão deve retornar dois valores. O primeiro é usado como chave e o segundo é usado como valor:

Neste exemplo convertemos um array de pares em uma tabela onde o primeiro item do par é a chave e o segundo é o valor.

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

## Slicing

Uma sintaxe especial é fornecida para restringir os itens sobre os quais se itera ao usar o operador **\***. Isso é equivalente a definir os limites de iteração e um tamanho de passo em um loop for.

Aqui podemos definir os limites mínimo e máximo, pegando todos os itens com índices entre 1 e 5 inclusive:

```yuescript
slice = [item for item in *items[1, 5]]
```

Qualquer um dos argumentos do slice pode ser omitido para usar um padrão sensato. Neste exemplo, se o índice máximo for omitido, ele usa como padrão o comprimento da tabela. Isso pegará tudo exceto o primeiro elemento:

```yuescript
slice = [item for item in *items[2,]]
```

Se o limite mínimo for omitido, ele usa como padrão 1. Aqui fornecemos apenas um tamanho de passo e deixamos os outros limites em branco. Isso pega todos os itens com índice ímpar: (1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

Tanto o limite mínimo quanto o máximo podem ser negativos, o que significa que os limites são contados a partir do fim da tabela.

```yuescript
-- pegar os últimos 4 itens
slice = [item for item in *items[-4,-1]]
```

O tamanho do passo também pode ser negativo, o que significa que os itens são tomados em ordem reversa.

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

### Expressão de slicing

O slicing também pode ser usado como expressão. Isso é útil para obter uma sublista de uma tabela.

```yuescript
-- pegar o 2º e 4º itens como nova lista
sub_list = items[2, 4]

-- pegar os últimos 4 itens
last_four_items = items[-4, -1]
```

# Programação orientada a objetos

Nestes exemplos, o código Lua gerado pode parecer avassalador. É melhor focar primeiro no significado do código YueScript e depois olhar o código Lua se desejar conhecer os detalhes da implementação.

Uma classe simples:

```yuescript
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```

Uma classe é declarada com uma instrução class seguida de uma declaração semelhante a tabela onde todos os métodos e propriedades são listados.

A propriedade new é especial pois se tornará o construtor.

Observe como todos os métodos da classe usam a sintaxe de função seta fat. Ao chamar métodos em uma instância, a própria instância é enviada como primeiro argumento. A seta fat cuida da criação do argumento self.

O prefixo @ em um nome de variável é abreviação para self.. @items torna-se self.items.

O bloco da classe também suporta campos de metatable escrevendo chaves de metamétodo entre `<>`, como `<tostring>`.

```yuescript
class User
  new: (@name) =>
  <tostring>: => "User(#{@name})"

print tostring User "Yue"
```

Criar uma instância da classe é feito chamando o nome da classe como uma função.

```yuescript
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

Como a instância da classe precisa ser enviada aos métodos quando são chamados, o operador \ é usado.

Todas as propriedades de uma classe são compartilhadas entre as instâncias. Isso é bom para funções, mas para outros tipos de objetos, resultados indesejados podem ocorrer.

Considere o exemplo abaixo, a propriedade clothes é compartilhada entre todas as instâncias, então modificações nela em uma instância aparecerão em outra:

```yuescript
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "pants"
b\give_item "shirt"

-- vai imprimir tanto pants quanto shirt
print item for item in *a.clothes
```

A forma correta de evitar esse problema é criar o estado mutável do objeto no construtor:

```yuescript
class Person
  new: =>
    @clothes = []
```

## Herança

A palavra-chave extends pode ser usada em uma declaração de classe para herdar as propriedades e métodos de outra classe.

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```

Aqui estendemos nossa classe Inventory e limitamos a quantidade de itens que ela pode carregar.

Neste exemplo, não definimos um construtor na subclasse, então o construtor da classe pai é chamado quando criamos uma nova instância. Se definirmos um construtor, podemos usar o método super para chamar o construtor pai.

Sempre que uma classe herda de outra, ela envia uma mensagem à classe pai chamando o método \_\_inherited na classe pai se ele existir. A função recebe dois argumentos: a classe que está sendo herdada e a classe filha.

```yuescript
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- vai imprimir: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```

## Super

**super** é uma palavra-chave especial que pode ser usada de duas formas diferentes: pode ser tratado como um objeto, ou pode ser chamado como uma função. Só tem funcionalidade especial quando está dentro de uma classe.

Quando chamado como função, chamará a função de mesmo nome na classe pai. O self atual será automaticamente passado como primeiro argumento. (Como visto no exemplo de herança acima)

Quando super é usado como valor normal, é uma referência ao objeto da classe pai.

Pode ser acessado como qualquer objeto para recuperar valores na classe pai que possam ter sido sombreados pela classe filha.

Quando o operador de chamada \ é usado com super, self é inserido como primeiro argumento em vez do valor do próprio super. Ao usar . para recuperar uma função, a função bruta é retornada.

Alguns exemplos de uso de super de diferentes formas:

```yuescript
class MyClass extends ParentClass
  a_method: =>
    -- os seguintes têm o mesmo efeito:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super como valor é igual à classe pai:
    assert super == ParentClass
```

**super** também pode ser usado no lado esquerdo de um Function Stub. A única diferença principal é que, em vez da função resultante estar vinculada ao valor de super, ela está vinculada a self.

## Tipos

Cada instância de uma classe carrega seu tipo consigo. Isso é armazenado na propriedade especial \_\_class. Esta propriedade contém o objeto da classe. O objeto da classe é o que chamamos para construir uma nova instância. Também podemos indexar o objeto da classe para recuperar métodos e propriedades da classe.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- imprime 10
```

## Objetos de classe

O objeto da classe é o que criamos quando usamos uma instrução class. O objeto da classe é armazenado em uma variável com o mesmo nome da classe.

O objeto da classe pode ser chamado como uma função para criar novas instâncias. É assim que criamos instâncias de classes nos exemplos acima.

Uma classe é composta por duas tabelas. A própria tabela da classe e a tabela base. A base é usada como metatable para todas as instâncias. Todas as propriedades listadas na declaração da classe são colocadas na base.

A metatable do objeto da classe lê propriedades da base se não existirem no objeto da classe. Isso significa que podemos acessar funções e propriedades diretamente da classe.

É importante notar que atribuir ao objeto da classe não atribui à base, então não é uma forma válida de adicionar novos métodos às instâncias. Em vez disso, a base deve ser alterada explicitamente. Veja o campo \_\_base abaixo.

O objeto da classe tem algumas propriedades especiais:

O nome da classe quando foi declarada é armazenado como string no campo \_\_name do objeto da classe.

```yuescript
print BackPack.__name -- imprime Backpack
```

O objeto base é armazenado em \_\_base. Podemos modificar esta tabela para adicionar funcionalidade a instâncias que já foram criadas e às que ainda serão criadas.

Se a classe estende de algo, o objeto da classe pai é armazenado em \_\_parent.

## Variáveis de classe

Podemos criar variáveis diretamente no objeto da classe em vez da base usando @ na frente do nome da propriedade em uma declaração de classe.

```yuescript
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- variáveis de classe não visíveis em instâncias
assert Things().some_func == nil
```

Em expressões, podemos usar @@ para acessar um valor armazenado no **class de self. Assim, @@hello é abreviação para self.**class.hello.

```yuescript
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- imprime 2
```

A semântica de chamada de @@ é semelhante a @. Chamar um nome @@ passará a classe como primeiro argumento usando a sintaxe de dois pontos do Lua.

```yuescript
@@hello 1,2,3,4
```

## Instruções de declaração de classe

No corpo de uma declaração de classe, podemos ter expressões normais além de pares chave/valor. Neste contexto, self é igual ao objeto da classe.

Aqui está uma forma alternativa de criar variável de classe comparada ao descrito acima:

```yuescript
class Things
  @class_var = "hello world"
```

Estas expressões são executadas após todas as propriedades terem sido adicionadas à base.

Todas as variáveis declaradas no corpo da classe são locais às propriedades da classe. Isso é conveniente para colocar valores privados ou funções auxiliares que apenas os métodos da classe podem acessar:

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

## Valores @ e @@

Quando @ e @@ são prefixados na frente de um nome, eles representam, respectivamente, esse nome acessado em self e self.\_\_class.

Se forem usados sozinhos, são aliases para self e self.\_\_class.

```yuescript
assert @ == self
assert @@ == self.__class
```

Por exemplo, uma forma rápida de criar uma nova instância da mesma classe a partir de um método de instância usando @@:

```yuescript
some_instance_method = (...) => @@ ...
```

## Promoção de propriedade no construtor

Para reduzir o código repetitivo na definição de objetos de valor simples. Você pode escrever uma classe simples como:

```yuescript
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- O que é abreviação para

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```

Você também pode usar esta sintaxe para uma função comum para inicializar os campos de um objeto.

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

## Expressões de classe

A sintaxe de classe também pode ser usada como expressão que pode ser atribuída a uma variável ou retornada explicitamente.

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

## Classes anônimas

O nome pode ser omitido ao declarar uma classe. O atributo \_\_name será nil, a menos que a expressão da classe esteja em uma atribuição. O nome no lado esquerdo da atribuição é usado em vez de nil.

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

Você pode até omitir o corpo, significando que pode escrever uma classe anônima em branco assim:

```yuescript
x = class
```

## Mistura de classes

Você pode fazer mistura com a palavra-chave `using` para copiar funções de uma tabela simples ou de um objeto de classe predefinido para sua nova classe. Ao fazer mistura com uma tabela simples, você pode sobrescrever a função de indexação da classe (metamétodo `__index`) para sua implementação personalizada. Ao fazer mistura com um objeto de classe existente, os metamétodos do objeto da classe não serão copiados.

```yuescript
MyIndex = __index: var: 1

class X using MyIndex
  func: =>
    print 123

x = X!
print x.var

class Y using X

y = Y!
y\func!

assert y.__class.__parent ~= X -- X não é pai de Y
```

# Instrução With

Um padrão comum envolvendo a criação de um objeto é chamar uma série de funções e definir uma série de propriedades imediatamente após criá-lo.

Isso resulta em repetir o nome do objeto várias vezes no código, adicionando ruído desnecessário. Uma solução comum para isso é passar uma tabela como argumento que contém uma coleção de chaves e valores para sobrescrever. O inconveniente é que o construtor desse objeto deve suportar essa forma.

O bloco with ajuda a aliviar isso. Dentro de um bloco with podemos usar instruções especiais que começam com . ou \ que representam essas operações aplicadas ao objeto com o qual estamos usando with.

Por exemplo, trabalhamos com um objeto recém-criado:

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

A instrução with também pode ser usada como expressão que retorna o valor ao qual foi dado acesso.

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

Expressões `with` suportam `break` com um valor:

```yuescript
result = with obj
  break .value
```

Depois que `break value` é usado dentro de `with`, a expressão `with` deixa de retornar seu objeto-alvo e passa a retornar o valor de `break`.

```yuescript
a = with obj
  .x = 1
-- a é obj

b = with obj
  break .x
-- b é .x, não obj
```

Diferente de `for` / `while` / `repeat` / `do`, `with` suporta apenas um valor de `break`.

Ou…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

Neste uso, with pode ser visto como uma forma especial do combinador K.

A expressão na instrução with também pode ser uma atribuição, se você quiser dar um nome à expressão.

```yuescript
with str := "Hello"
  print "original:", str
  print "upper:", \upper!
```

Você pode acessar chaves especiais com `[]` em uma instrução `with`.

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- anexando a "tb"
```

`with?` é uma versão aprimorada da sintaxe `with`, que introduz uma verificação existencial para acessar com segurança objetos que podem ser nil sem verificações explícitas de null.

```yuescript
with? obj
  print .name
```

# Atribuição

A variável é tipada dinamicamente e é definida como local por padrão. Mas você pode alterar o escopo da declaração pelas instruções **local** e **global**.

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- usa a variável existente
```

## Atualização

Você pode realizar atribuição de atualização com muitos operadores binários.

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- adiciona um novo local se a variável local não existir
arg or= "valor padrão"
```

## Atribuição encadeada

Você pode fazer atribuição encadeada para atribuir múltiplos itens ao mesmo valor.

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

## Locais explícitos

```yuescript
do
  local a = 1
  local *
  print "declarar antecipadamente todas as variáveis como locais"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "declarar antecipadamente apenas variáveis em maiúsculas"
  a = 1
  B = 2
```

## Globais explícitos

```yuescript
do
  global a = 1
  global *
  print "declarar todas as variáveis como globais"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global X = 1
  global ^
  print "declarar apenas variáveis em maiúsculas como globais"
  a = 1
  B = 2
  local Temp = "um valor local"
```

# Atribuição de varargs

Você pode atribuir os resultados retornados de uma função a um símbolo varargs `...`. E então acessar seu conteúdo da forma Lua.

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

# Atribuição em if

Os blocos `if` e `elseif` podem receber uma atribuição no lugar de uma expressão condicional. Ao avaliar o condicional, a atribuição será realizada e o valor que foi atribuído será usado como expressão condicional. A variável atribuída está no escopo apenas para o corpo do condicional, ou seja, nunca está disponível se o valor não for truthy. E você precisa usar o "operador walrus" `:=` em vez de `=` para fazer a atribuição.

```yuescript
if user := database.find_user "moon"
  print user.name
```

```yuescript
if hello := os.getenv "hello"
  print "Você tem hello", hello
elseif world := os.getenv "world"
  print "você tem world", world
else
  print "nada :("
```

Atribuição em if com múltiplos valores de retorno. Apenas o primeiro valor é verificado, os outros valores estão no escopo.

```yuescript
if success, result := pcall -> "obter resultado sem problemas"
  print result -- variável result está no escopo
print "OK"
```

## Atribuição em while

Você também pode usar atribuição em if em um loop while para obter o valor como condição do loop.

```yuescript
while byte := stream\read_one!
  -- fazer algo com o byte
  print byte
```

# Atribuição por desestruturação

A atribuição por desestruturação é uma forma de extrair rapidamente valores de uma tabela por seu nome ou posição em tabelas baseadas em array.

Tipicamente, quando você vê um literal de tabela, {1,2,3}, ele está no lado direito de uma atribuição porque é um valor. A atribuição por desestruturação troca o papel do literal de tabela e o coloca no lado esquerdo de uma instrução de atribuição.

Isso é melhor explicado com exemplos. Assim você extrairia os dois primeiros valores de uma tabela:

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

No literal de tabela de desestruturação, a chave representa a chave para ler do lado direito, e o valor representa o nome ao qual o valor lido será atribuído.

```yuescript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- OK fazer desestruturação simples sem chaves
```

Isso também funciona com estruturas de dados aninhadas:

```yuescript
obj2 = {
  numbers: [1, 2, 3, 4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

Se a instrução de desestruturação for complicada, sinta-se à vontade para espalhá-la em várias linhas. Um exemplo um pouco mais complicado:

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

É comum extrair valores de uma tabela e atribuí-los a variáveis locais que têm o mesmo nome da chave. Para evitar repetição, podemos usar o operador de prefixo **:**:

```yuescript
{:concat, :insert} = table
```

Isso é efetivamente o mesmo que import, mas podemos renomear campos que queremos extrair misturando a sintaxe:

```yuescript
{:mix, :max, random: rand} = math
```

Você pode escrever valores padrão ao fazer desestruturação:

```yuescript
{:name = "sem nome", :job = "sem emprego"} = person
```

Você pode usar `_` como placeholder ao fazer desestruturação de lista:

```yuescript
[_, two, _, four] = items
```

## Desestruturação por intervalo

Você pode usar o operador spread `...` na desestruturação de lista para capturar um intervalo de valores. Isso é útil quando você quer extrair elementos específicos do início e do fim de uma lista enquanto coleta o restante entre eles.

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- imprime: first
print bulk   -- imprime: {"second", "third", "fourth"}
print last   -- imprime: last
```

O operador spread pode ser usado em diferentes posições para capturar diferentes intervalos, e você pode usar `_` como placeholder para os valores que não quer capturar:

```yuescript
-- Capturar tudo após o primeiro elemento
[first, ...rest] = orders

-- Capturar tudo antes do último elemento
[...start, last] = orders

-- Capturar tudo exceto os elementos do meio
[first, ..._, last] = orders
```

## Desestruturação em outros lugares

A desestruturação também pode aparecer em lugares onde uma atribuição ocorre implicitamente. Um exemplo disso é um loop for:

```yuescript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

Sabemos que cada elemento na tabela array é uma tupla de dois itens, então podemos desempacotá-lo diretamente na cláusula de nomes da instrução for usando desestruturação.

# A cláusula Using; controlando atribuição destrutiva

Embora o escopo léxico possa ser uma grande ajuda na redução da complexidade do código que escrevemos, as coisas podem ficar difíceis de gerenciar conforme o tamanho do código aumenta. Considere o seguinte trecho:

```yuescript
i = 100

-- muitas linhas de código...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- vai imprimir 0
```

Em my_func, sobrescrevemos o valor de i por engano. Neste exemplo é bem óbvio, mas considere uma base de código grande ou estrangeira onde não está claro quais nomes já foram declarados.

Seria útil dizer quais variáveis do escopo envolvente pretendemos alterar, para evitar que alteremos outras por acidente.

A palavra-chave using nos permite fazer isso. using nil garante que nenhuma variável fechada seja sobrescrita na atribuição. A cláusula using é colocada após a lista de argumentos em uma função, ou no lugar dela se não houver argumentos.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- uma nova variável local é criada aqui

my_func!
print i -- imprime 100, i não é afetado
```

Múltiplos nomes podem ser separados por vírgulas. Os valores do closure ainda podem ser acessados, apenas não podem ser modificados:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- uma nova variável local tmp é criada
  i += tmp
  k += tmp

my_func(22)
print i, k -- estes foram atualizados
```

# Uso

## Módulo Lua

Use o módulo YueScript em Lua:

- **Caso 1**

  Use require em "your_yuescript_entry.yue" no Lua.

  ```lua
  require("yue")("your_yuescript_entry")
  ```

  E esse código continua funcionando quando você compila "your_yuescript_entry.yue" para "your_yuescript_entry.lua" no mesmo caminho. Nos demais arquivos YueScript, use normalmente o **require** ou **import**. Os números de linha nas mensagens de erro também serão tratados corretamente.

- **Caso 2**

  Requerer o módulo YueScript e reescrever a mensagem manualmente.

  ```lua
  local yue = require("yue")
  yue.insert_loader()
  local success, result = xpcall(function()
    return require("yuescript_module_name")
  end, function(err)
    return yue.traceback(err)
  end)
  ```

- **Caso 3**

  Usar a função compiladora do YueScript em Lua.

  ```lua
  local yue = require("yue")
  local codes, err, globals = yue.to_lua([[
    f = ->
      print "hello world"
    f!
  ]],{
    implicit_return_root = true,
    reserve_line_number = true,
    lint_global = true,
    space_over_tab = false,
    options = {
      target = "5.4",
      path = "/script"
    }
  })
  ```

## Ferramenta YueScript

Use a ferramenta YueScript com:

```shell
> yue -h
Usage: yue
       [options] [<file/directory>] ...
       yue -e <code_or_file> [args...]
       yue -w [<directory>] [options]
       yue -

Notas:
   - '-' / '--' deve ser o primeiro e único argumento.
   - '-o/--output' não pode ser usado com múltiplos arquivos de entrada.
   - '-w/--watch' não pode ser usado com entrada de arquivo (apenas diretório).
   - com '-e/--execute', os tokens restantes são tratados como argumentos do script.

Opções:
   -h, --help                 Mostrar esta mensagem de ajuda e sair.
   -e <str>, --execute <str>  Executar um arquivo ou código bruto
   -m, --minify               Gerar código minificado
   -r, --rewrite              Reescrever saída para corresponder aos números de linha originais
   -t <output_to>, --output-to <output_to>
                              Especificar onde colocar os arquivos compilados
   -o <file>, --output <file> Escrever saída em arquivo
   -p, --print                Escrever saída na saída padrão
   -b, --benchmark            Mostrar tempo de compilação (não grava saída)
   -g, --globals              Listar variáveis globais usadas em NOME LINHA COLUNA
   -s, --spaces               Usar espaços no código gerado em vez de tabulações
   -l, --line-numbers         Escrever números de linha do código fonte
   -j, --no-implicit-return   Desabilitar retorno implícito no final do arquivo
   -c, --reserve-comments     Preservar comentários antes de instruções do código fonte
   -w [<dir>], --watch [<dir>]
                              Observar alterações e compilar cada arquivo no diretório
   -v, --version              Imprimir versão
   -                          Ler da entrada padrão, imprimir na saída padrão
                              (Deve ser o primeiro e único argumento)
   --                         Igual a '-' (mantido para compatibilidade retroativa)

   --target <version>         Especificar a versão do Lua para a qual o código será gerado
                              (a versão pode ser apenas 5.1 a 5.5)
   --path <path_str>          Adicionar um caminho de busca Lua extra ao package.path
   --<key>=<value>            Passar opção do compilador no formato key=value (comportamento existente)

   Execute sem opções para entrar no REPL, digite o símbolo '$'
   em uma única linha para iniciar/parar o modo multilinha
```

Casos de uso:

Compilar recursivamente todos os arquivos YueScript com extensão **.yue** no caminho atual: **yue .**

Compilar e salvar resultados em um caminho de destino: **yue -t /target/path/ .**

Compilar e preservar informações de debug: **yue -l .**

Compilar e gerar código minificado: **yue -m .**

Executar código bruto: **yue -e 'print 123'**

Executar um arquivo YueScript: **yue -e main.yue**

# Introdução

YueScript é uma linguagem dinâmica que compila para Lua. É um dialeto do [MoonScript](https://github.com/leafo/moonscript). O código escrito em YueScript é expressivo e extremamente conciso. É adequado para escrever lógica de aplicação variável com código mais manutenível e roda em ambientes Lua embutidos, como jogos ou servidores web.

Yue (月) é o nome da lua em chinês e é pronunciado como [jyɛ].

## Uma visão geral do YueScript

```yuescript
-- sintaxe de importação
import p, to_lua from "yue"

-- literais de objeto
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- compreensão de lista
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- operador pipe
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- manipulação de metatable
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- sintaxe de exportação estilo js
export 🌛 = "Script da Lua"
```

## Sobre o Dora SSR

O YueScript está sendo desenvolvido e mantido em conjunto com o motor de jogo open-source [Dora SSR](https://github.com/Dora-SSR/Dora-SSR). Tem sido usado para criar ferramentas do motor, demonstrações de jogos e protótipos, validando suas capacidades em cenários do mundo real e aprimorando a experiência de desenvolvimento do Dora SSR.

# Instalação

## Módulo Lua

Instale o [luarocks](https://luarocks.org), um gerenciador de pacotes para módulos Lua. Em seguida, instale-o como módulo Lua e executável com:

```shell
luarocks install yuescript
```

Ou você pode compilar o arquivo `yue.so` com:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Depois, obtenha o arquivo binário no caminho **bin/shared/yue.so**.

## Compilar ferramenta binária

Clone este repositório e compile e instale o executável com:

```shell
make install
```

Compilar a ferramenta YueScript sem o recurso de macro:

```shell
make install NO_MACRO=true
```

Compilar a ferramenta YueScript sem o binário Lua embutido:

```shell
make install NO_LUA=true
```

## Baixar binário pré-compilado

Você pode baixar arquivos binários pré-compilados, incluindo executáveis compatíveis com diferentes versões do Lua e arquivos de biblioteca.

Baixe os arquivos binários pré-compilados [aqui](https://github.com/IppClub/YueScript/releases).

# Condicionais

```yuescript
have_coins = false
if have_coins
  print "Tem moedas"
else
  print "Sem moedas"
```

Uma sintaxe curta para instruções únicas também pode ser usada:

```yuescript
have_coins = false
if have_coins then print "Tem moedas" else print "Sem moedas"
```

Como instruções if podem ser usadas como expressões, isso também pode ser escrito como:

```yuescript
have_coins = false
print if have_coins then "Tem moedas" else "Sem moedas"
```

Condicionais também podem ser usados em instruções de retorno e atribuições:

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "Sou muito alto"
else
  "Não sou tão alto"

print message -- imprime: Sou muito alto
```

O oposto de if é unless:

```yuescript
unless os.date("%A") == "Monday"
  print "não é segunda-feira!"
```

```yuescript
print "Você tem sorte!" unless math.random! > 0.1
```

## Em expressão

Você pode escrever código de verificação de intervalo com uma `in-expression`.

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "verificando igualdade com valores discretos"

if a in list
  print "verificando se `a` está na lista"
```

O operador `in` também pode ser usado com tabelas e suporta a variante `not in` para negação:

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a está na tabela"

not_exist = item not in list

check = -> value not in table
```

Uma lista ou tabela de único elemento verifica igualdade com esse elemento:

```yuescript
-- [1,] verifica se valor == 1
c = a in [1,]

-- {1} também verifica se valor == 1
c = a in {1}

-- Sem vírgula, [1] é acesso por índice (tb[1])
with tb
  c = a in [1]
```

# Loop For

Existem duas formas de loop for, assim como no Lua. Uma numérica e uma genérica:

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- um passo opcional fornecido
  print k

for key, value in pairs object
  print key, value
```

Os operadores de slicing e **\*** podem ser usados, assim como com compreensões:

```yuescript
for item in *items[2, 4]
  print item
```

Uma sintaxe mais curta também está disponível para todas as variações quando o corpo é apenas uma linha:

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

Um loop for também pode ser usado como expressão. A última instrução no corpo do loop for é convertida em expressão e anexada a uma tabela array acumuladora.

Dobrando cada número par:

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

Além disso, os loops for suportam break com valores de retorno, permitindo que o próprio loop seja usado como expressão que sai antecipadamente com um resultado significativo. Expressões `for` suportam `break` com múltiplos valores.

Por exemplo, para encontrar o primeiro número maior que 10:

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

Esta sintaxe de break-com-valor permite padrões concisos e expressivos de busca ou saída antecipada diretamente em expressões de loop.

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

Você também pode filtrar valores combinando a expressão do loop for com a instrução continue.

Loops for no final do corpo de uma função não são acumulados em uma tabela para valor de retorno (em vez disso, a função retornará nil). Uma instrução return explícita pode ser usada, ou o loop pode ser convertido em compreensão de lista.

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- imprime nil
print func_b! -- imprime objeto table
```

Isso é feito para evitar a criação desnecessária de tabelas para funções que não precisam retornar os resultados do loop.

# Continue

Uma instrução continue pode ser usada para pular a iteração atual em um loop.

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

continue também pode ser usado com expressões de loop para impedir que essa iteração seja acumulada no resultado. Este exemplo filtra a tabela array para apenas números pares:

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

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

Podemos usar a palavra-chave then para escrever o bloco when de um switch em uma única linha. Nenhuma palavra-chave extra é necessária para escrever o bloco else em uma única linha.

```yuescript
msg = switch math.random(1, 5)
  when 1 then "você tem sorte"
  when 2 then "você quase tem sorte"
  else "não tão sortudo"
```

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

Você pode usar valores padrão para opcionalmente desestruturar a tabela para alguns campos.

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- obtém erro: attempt to index a nil value (field 'pos')

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- a desestruturação de tabela ainda passará
```

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

Corresponder contra uma lista e capturar um intervalo de elementos.

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Grupo:", groups -- imprime: {"admin", "users"}
    print "Recurso:", resource -- imprime: "logs"
    print "Ação:", action -- imprime: "view"
```

# Loop While

O loop while também vem em quatro variações:

```yuescript
i = 10
while i > 0
  print i
  i -= 1

while running == true do my_function!
```

```yuescript
i = 10
until i == 0
  print i
  i -= 1

until running == false do my_function!
```

Como os loops for, o loop while também pode ser usado como expressão. Expressões `while` e `until` suportam `break` com múltiplos valores.

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

Além disso, para uma função retornar o valor acumulado de um loop while, a instrução deve ser explicitamente retornada.

## Loop Repeat

O loop repeat vem do Lua:

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

Expressões `repeat` também suportam `break` com múltiplos valores:

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

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

# Backcalls

Backcalls são usados para desaninhar callbacks. Eles são definidos usando setas apontando para a esquerda como o último parâmetro, preenchendo por padrão uma chamada de função. Toda a sintaxe é basicamente a mesma das funções seta regulares, exceto que apenas aponta para o outro lado e o corpo da função não requer indentação.

```yuescript
x <- f
print "hello" .. x
```

Funções seta "fat" também estão disponíveis.

```yuescript
<= f
print @value
```

Você pode especificar um placeholder para onde deseja que a função backcall vá como parâmetro.

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

Se você desejar ter mais código após seus backcalls, pode colocá-los em uma instrução do. E os parênteses podem ser omitidos com funções seta não-fat.

```yuescript
result, msg = do
  data <- readAsync "filename.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

# Literais de função

Todas as funções são criadas usando uma expressão de função. Uma função simples é denotada usando a seta: **->**.

```yuescript
my_function = ->
my_function() -- chama a função vazia
```

O corpo da função pode ser uma instrução colocada diretamente após a seta, ou pode ser uma série de instruções indentadas nas linhas seguintes:

```yuescript
func_a = -> print "hello world"

func_b = ->
  value = 100
  print "The value:", value
```

Se uma função não tem argumentos, ela pode ser chamada usando o operador !, em vez de parênteses vazios. A invocação ! é a forma preferida de chamar funções sem argumentos.

```yuescript
func_a!
func_b()
```

Funções com argumentos podem ser criadas precedendo a seta com uma lista de nomes de argumentos entre parênteses:

```yuescript
sum = (x, y) -> print "sum", x + y
```

Funções podem ser chamadas listando os argumentos após o nome de uma expressão que avalia para uma função. Ao encadear chamadas de função, os argumentos são aplicados à função mais próxima à esquerda.

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

Para evitar ambiguidade ao chamar funções, parênteses também podem ser usados para envolver os argumentos. Isso é necessário aqui para garantir que os argumentos certos sejam enviados às funções certas.

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

Não deve haver espaço entre o parêntese de abertura e a função.

As funções convertem a última instrução em seu corpo em uma instrução de retorno, isso é chamado de retorno implícito:

```yuescript
sum = (x, y) -> x + y
print "The sum is ", sum 10, 20
```

E se você precisar retornar explicitamente, pode usar a palavra-chave return:

```yuescript
sum = (x, y) -> return x + y
```

Assim como no Lua, as funções podem retornar múltiplos valores. A última instrução deve ser uma lista de valores separados por vírgulas:

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

## Setas fat

Como é um idioma em Lua enviar um objeto como primeiro argumento ao chamar um método, uma sintaxe especial é fornecida para criar funções que incluem automaticamente um argumento self.

```yuescript
func = (num) => @value + num
```

## Valores padrão de argumentos

É possível fornecer valores padrão para os argumentos de uma função. Um argumento é determinado como vazio se seu valor for nil. Qualquer argumento nil que tenha valor padrão será substituído antes da execução do corpo da função.

```yuescript
my_function = (name = "something", height = 100) ->
  print "Hello I am", name
  print "My height is", height
```

Uma expressão de valor padrão de argumento é avaliada no corpo da função na ordem das declarações de argumentos. Por esse motivo, os valores padrão têm acesso aos argumentos declarados anteriormente.

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

## Considerações

Devido à forma expressiva de chamar funções sem parênteses, algumas restrições devem ser colocadas para evitar ambiguidade de análise envolvendo espaço em branco.

O sinal de menos desempenha dois papéis: um operador de negação unário e um operador de subtração binário. Considere como os seguintes exemplos compilam:

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

A precedência do primeiro argumento de uma chamada de função pode ser controlada usando espaço em branco se o argumento for um literal de string. Em Lua, é comum omitir parênteses ao chamar uma função com uma única string ou literal de tabela.

Quando não há espaço entre uma variável e um literal de string, a chamada de função tem precedência sobre quaisquer expressões seguintes. Nenhum outro argumento pode ser passado para a função quando ela é chamada dessa forma.

Quando há um espaço após uma variável e um literal de string, a chamada de função age como mostrado acima. O literal de string pertence a quaisquer expressões seguintes (se existirem), que servem como lista de argumentos.

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```

## Argumentos multilinha

Ao chamar funções que recebem um grande número de argumentos, é conveniente dividir a lista de argumentos em várias linhas. Devido à natureza sensível a espaço em branco da linguagem, deve-se ter cuidado ao dividir a lista de argumentos.

Se uma lista de argumentos for continuada na próxima linha, a linha atual deve terminar em vírgula. E a linha seguinte deve estar mais indentada que a indentação atual. Uma vez indentada, todas as outras linhas de argumentos devem estar no mesmo nível de indentação para fazer parte da lista de argumentos.

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

Este tipo de invocação pode ser aninhado. O nível de indentação é usado para determinar a qual função os argumentos pertencem.

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

Como as tabelas também usam vírgula como delimitador, esta sintaxe de indentação ajuda a deixar os valores fazerem parte da lista de argumentos em vez de fazerem parte da tabela.

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

Embora incomum, observe como podemos dar uma indentação mais profunda para argumentos de função se soubermos que usaremos uma indentação menor mais adiante.

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

A mesma coisa pode ser feita com outras instruções em nível de bloco como condicionais. Podemos usar o nível de indentação para determinar a qual instrução um valor pertence:

```yuescript
if func 1, 2, 3,
  "hello",
  "world"
    print "hello"
    print "I am inside if"

if func 1, 2, 3,
    "hello",
    "world"
  print "hello"
  print "I am inside if"
```

## Desestruturação de parâmetros

YueScript agora suporta desestruturação de parâmetros de função quando o argumento é um objeto. Duas formas de literais de tabela de desestruturação estão disponíveis:

- **Literais/parâmetros de objeto envolvidos em chaves**, permitindo valores padrão opcionais quando os campos estão ausentes (ex.: `{:a, :b}`, `{a: a1 = 123}`).

- **Sintaxe de tabela simples não envolvida**, começando com uma sequência de ligações chave-valor ou abreviadas e continuando até outra expressão terminá-la (ex.: `:a, b: b1, :c`). Esta forma extrai múltiplos campos do mesmo objeto.

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

## Expressão de retorno prefixada

Ao trabalhar com corpos de função profundamente aninhados, pode ser tedioso manter a legibilidade e consistência do valor de retorno. Para resolver isso, YueScript introduz a sintaxe **Expressão de Retorno Prefixada**. Sua forma é a seguinte:

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

Isso é equivalente a:

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

A única diferença é que você pode mover a expressão de retorno final antes do token `->` ou `=>` para indicar o valor de retorno implícito da função como última instrução. Dessa forma, mesmo em funções com múltiplos loops aninhados ou ramificações condicionais, você não precisa mais escrever uma expressão de retorno no final do corpo da função, tornando a estrutura lógica mais direta e fácil de seguir.

## Varargs nomeados

Você pode usar a sintaxe `(...t) ->` para armazenar automaticamente varargs em uma tabela nomeada. Esta tabela conterá todos os argumentos passados (incluindo valores `nil`), e o campo `n` da tabela armazenará o número real de argumentos passados (incluindo valores `nil`).

```yuescript
f = (...t) ->
  print "contagem de argumentos:", t.n
  print "comprimento da tabela:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- Tratando casos com valores nil
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

# Espaço em branco

YueScript é uma linguagem sensível a espaço em branco. Você precisa escrever blocos de código na mesma indentação com espaço **' '** ou tabulação **'\t'**, como corpo de função, lista de valores e alguns blocos de controle. E expressões contendo diferentes espaços em branco podem significar coisas diferentes. Tabulação é tratada como 4 espaços, mas é melhor não misturar o uso de espaços e tabulações.

## Separador de instrução

Uma instrução normalmente termina em uma quebra de linha. Você também pode usar ponto e vírgula `;` para terminar explicitamente uma instrução, o que permite escrever múltiplas instruções na mesma linha:

```yuescript
a = 1; b = 2; print a + b
```

## Encadeamento multilinha

Você pode escrever chamadas de função encadeadas em múltiplas linhas com a mesma indentação.

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

# Comentário

```yuescript
-- Eu sou um comentário

str = --[[
Este é um comentário multilinha.
Está OK.
]] strA \ -- comentário 1
  .. strB \ -- comentário 2
  .. strC

func --[[port]] 3000, --[[ip]] "192.168.1.1"
```

# Atributos

Suporte de sintaxe para atributos do Lua 5.4. E você ainda pode usar tanto a declaração `const` quanto `close` e obter verificação de constante e callback com escopo funcionando ao direcionar para versões do Lua abaixo da 5.4.

```yuescript
const a = 123
close _ = <close>: -> print "Fora do escopo."
```

Você pode fazer desestruturação com variáveis atribuídas como constante.

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

Você também pode declarar uma variável global como `const`.

```yuescript
global const Constant = 123
-- Constant = 1
```

# Operador

Todos os operadores binários e unários do Lua estão disponíveis. Além disso, **!=** é um alias para **~=**, e **\\** ou **::** podem ser usados para escrever uma chamada de função encadeada como `tb\func!` ou `tb::func!`. E o YueScript oferece alguns outros operadores especiais para escrever códigos mais expressivos.

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

## Comparações encadeadas

Comparações podem ser encadeadas arbitrariamente:

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- saída: true

a = 5
print 1 <= a <= 10
-- saída: true
```

Observe o comportamento de avaliação das comparações encadeadas:

```yuescript
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  saída:
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  saída:
  2
  1
  false
]]
```

A expressão do meio é avaliada apenas uma vez, em vez de duas vezes como seria se a expressão fosse escrita como `v(1) < v(2) and v(2) <= v(3)`. No entanto, a ordem das avaliações em uma comparação encadeada é indefinida. É fortemente recomendado não usar expressões com efeitos colaterais (como impressão) em comparações encadeadas. Se efeitos colaterais forem necessários, o operador de curto-circuito `and` deve ser usado explicitamente.

## Anexar à tabela

O operador **[] =** é usado para anexar valores a tabelas.

```yuescript
tab = []
tab[] = "Value"
```

Você também pode usar o operador spread `...` para anexar todos os elementos de uma lista a outra:

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA agora é [1, 2, 3, 4, 5, 6]
```

## Spread de tabela

Você pode concatenar tabelas de array ou tabelas hash usando o operador spread `...` antes de expressões em literais de tabela.

Ao fazer spread em um literal de tabela com chaves (por exemplo, `{...other}`), tanto a parte de array quanto a parte hash da tabela Lua são copiadas.

```yuescript
parts =
  * "shoulders"
  * "knees"
lyrics =
  * "head"
  * ...parts
  * "and"
  * "toes"

copy = {...other}

a = {1, 2, 3, x: 1}
b = {4, 5, y: 1}
merge = {...a, ...b}
```

### Spread de tabela de lista

Ao fazer spread em um literal de tabela com colchetes (por exemplo, `[...other,]`), apenas a parte de array é copiada.

```yuescript
source = {1, 2, 3, name: "Yue"}
fullCopy = {...source}
listCopy = [...source,]
-- fullCopy => {1, 2, 3, name: "Yue"}
-- listCopy => [1, 2, 3]
```

## Indexação reversa de tabela

Você pode usar o operador **#** para obter os últimos elementos de uma tabela.

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

## Metatable

O operador **<>** pode ser usado como atalho para manipulação de metatable.

### Criação de metatable

Crie tabela normal com chaves vazias **<>** ou chave de metamétodo cercada por **<>**.

```yuescript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
 -- definir campo com variável de mesmo nome
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "fora do escopo"
```

### Acesso à metatable

Acesse a metatable com **<>** ou nome do metamétodo cercado por **<>** ou escrevendo alguma expressão em **<>**.

```yuescript
-- criar com metatable contendo campo "value"
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```

### Desestruturação de metatable

Desestruture a metatable com chave de metamétodo cercada por **<>**.

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

## Existência

O operador **?** pode ser usado em diversos contextos para verificar existência.

```yuescript
func?!
print abc?["hello world"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "hello"
  \close!
```

## Pipe

Em vez de uma série de chamadas de função aninhadas, você pode encaminhar valores com o operador **|>**.

```yuescript
"hello" |> print
1 |> print 2 -- insere o item do pipe como primeiro argumento
2 |> print 1, _, 3 -- pipe com um placeholder

-- expressão pipe em multilinha
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

## Coalescência de nil

O operador de coalescência de nil **??** retorna o valor do operando esquerdo se não for **nil**; caso contrário, avalia o operando direito e retorna seu resultado. O operador **??** não avalia seu operando direito se o operando esquerdo avaliar para não-nil.

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

## Objeto implícito

Você pode escrever uma lista de estruturas implícitas que começa com o símbolo **\*** ou **-** dentro de um bloco de tabela. Se você está criando objeto implícito, os campos do objeto devem estar com a mesma indentação.

```yuescript
-- atribuição com objeto implícito
list =
  * 1
  * 2
  * 3

-- chamada de função com objeto implícito
func
  * 1
  * 2
  * 3

-- retorno com objeto implícito
f = ->
  return
    * 1
    * 2
    * 3

-- tabela com objeto implícito
tb =
  name: "abc"

  values:
    - "a"
    - "b"
    - "c"

  objects:
    - name: "a"
      value: 1
      func: => @value + 1
      tb:
        fieldA: 1

    - name: "b"
      value: 2
      func: => @value + 2
      tb: { }

```

# Literais

Todos os literais primitivos do Lua podem ser usados. Isso se aplica a números, strings, booleanos e **nil**.

Diferente do Lua, quebras de linha são permitidas dentro de strings com aspas simples e duplas sem sequência de escape:

```yuescript
some_string = "Aqui está uma string
  que tem uma quebra de linha."

-- Você pode misturar expressões em literais de string usando a sintaxe #{}.
-- Interpolação de string está disponível apenas em strings com aspas duplas.
print "Tenho #{math.random! * 100}% de certeza."
```

## Literais numéricos

Você pode usar underscores em um literal numérico para aumentar a legibilidade.

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

## String multilinha estilo YAML

O prefixo `|` introduz um literal de string multilinha no estilo YAML:

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

Isso permite escrever texto estruturado multilinha convenientemente. Todas as quebras de linha e indentação são preservadas em relação à primeira linha não vazia, e expressões dentro de `#{...}` são interpoladas automaticamente como `tostring(expr)`.

A string multilinha YAML detecta automaticamente o prefixo comum de espaço em branco à esquerda (indentação mínima em todas as linhas não vazias) e remove-o de todas as linhas. Isso facilita a indentação visual do seu código sem afetar o conteúdo da string resultante.

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

A indentação interna é preservada em relação ao prefixo comum removido, permitindo estruturas aninhadas limpas.

Todos os caracteres especiais como aspas (`"`) e barras invertidas (`\`) no bloco YAML Multiline são escapados automaticamente para que a string Lua gerada seja sintaticamente válida e se comporte como esperado.

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'Ele disse: "#{Hello}!"'
```

# Módulo

## Import

A instrução import é um açúcar sintático para requerer um módulo ou ajudar a extrair itens de um módulo importado. Os itens importados são const por padrão.

```yuescript
-- usado como desestruturação de tabela
do
  import insert, concat from table
  -- reporta erro ao atribuir a insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- atalho para require implícito
  import x, y, z from 'mymodule'
  -- import com estilo Python
  from 'module' import a, b, c

-- atalho para requerer um módulo
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requerer módulo com aliasing ou desestruturação de tabela
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

## Import Global

Você pode importar globais específicos para variáveis locais com `import`. Ao importar uma cadeia de acessos a variáveis globais, o último campo será atribuído à variável local.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

### Importação automática de variável global

Você pode colocar `import global` no topo de um bloco para importar automaticamente todos os nomes que não foram explicitamente declarados ou atribuídos no escopo atual como globais. Essas importações implícitas são tratadas como consts locais que referenciam os globais correspondentes na posição da instrução.

Nomes que foram explicitamente declarados como globais no mesmo escopo não serão importados, então você ainda pode atribuir a eles.

```yuescript
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- erro: globais importados são const

do
  -- variável global explícita não será importada
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

## Export

A instrução export oferece uma forma concisa de definir módulos.

### Export nomeado

Export nomeado definirá uma variável local e também adicionará um campo na tabela exportada.

```yuescript
export a, b, c = 1, 2, 3
export cool = "cat"

export What = if this
  "abc"
else
  "def"

export y = ->
  hallo = 3434

export class Something
  umm: "cool"
```

Fazendo export nomeado com desestruturação.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

Exportar itens nomeados do módulo sem criar variáveis locais.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

### Export sem nome

Export sem nome adicionará o item alvo na parte array da tabela exportada.

```yuescript
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

### Export padrão

Usar a palavra-chave **default** na instrução export para substituir a tabela exportada por qualquer coisa.

```yuescript
export default ->
  print "hello"
  123
```

# Licença: MIT

Copyright (c) 2017-2026 Li Jin \<dragon-fly@qq.com\>

A permissão é concedida, gratuitamente, a qualquer pessoa que obtenha uma cópia
deste software e dos arquivos de documentação associados (o "Software"), para negociar
o Software sem restrições, incluindo, sem limitação, os direitos de usar, copiar,
modificar, mesclar, publicar, distribuir, sublicenciar e/ou vender
cópias do Software, e permitir que pessoas a quem o Software seja fornecido o façam,
sujeito às seguintes condições:

O aviso de direitos autorais acima e este aviso de permissão devem ser incluídos em todas as
cópias ou partes substanciais do Software.

O SOFTWARE É FORNECIDO "NO ESTADO EM QUE SE ENCONTRA", SEM GARANTIA DE QUALQUER TIPO,
EXPRESSA OU IMPLÍCITA, INCLUINDO, MAS NÃO SE LIMITANDO ÀS GARANTIAS DE COMERCIALIZAÇÃO,
ADEQUAÇÃO A UM DETERMINADO FIM E NÃO VIOLAÇÃO. EM NENHUMA HIPÓTESE OS AUTORES OU
DETENTORES DOS DIREITOS AUTORAIS SERÃO RESPONSÁVEIS POR QUAISQUER REIVINDICAÇÕES,
DANOS OU OUTRAS RESPONSABILIDADES, SEJA EM UMA AÇÃO DE CONTRATO, ATO ILÍCITO OU OUTRA,
DECORRENTES DE, FORA DE OU RELACIONADAS COM O SOFTWARE OU O USO OU OUTRAS NEGOCIAÇÕES
NO SOFTWARE.

# A biblioteca YueScript

Acesse com `local yue = require("yue")` no Lua.

## yue

**Descrição:**

A biblioteca da linguagem YueScript.

### version

**Tipo:** Campo.

**Descrição:**

A versão do YueScript.

**Assinatura:**

```lua
version: string
```

### dirsep

**Tipo:** Campo.

**Descrição:**

O separador de arquivos da plataforma atual.

**Assinatura:**

```lua
dirsep: string
```

### yue_compiled

**Tipo:** Campo.

**Descrição:**

O cache de código de módulo compilado.

**Assinatura:**

```lua
yue_compiled: {string: string}
```

### to_lua

**Tipo:** Função.

**Descrição:**

A função de compilação do YueScript. Compila o código YueScript para código Lua.

**Assinatura:**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| code      | string | O código YueScript.                 |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno                     | Descrição                                                                                                                        |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| string \| nil                       | O código Lua compilado, ou nil se a compilação falhou.                                                                           |
| string \| nil                       | A mensagem de erro, ou nil se a compilação foi bem-sucedida.                                                                     |
| {{string, integer, integer}} \| nil | As variáveis globais que aparecem no código (com nome, linha e coluna), ou nil se a opção do compilador `lint_global` for false. |

### file_exist

**Tipo:** Função.

**Descrição:**

Função de verificação de existência do arquivo fonte. Pode ser sobrescrita para personalizar o comportamento.

**Assinatura:**

```lua
file_exist: function(filename: string): boolean
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição          |
| --------- | ------ | ------------------ |
| filename  | string | O nome do arquivo. |

**Retorna:**

| Tipo de Retorno | Descrição            |
| --------------- | -------------------- |
| boolean         | Se o arquivo existe. |

### read_file

**Tipo:** Função.

**Descrição:**

Função de leitura do arquivo fonte. Pode ser sobrescrita para personalizar o comportamento.

**Assinatura:**

```lua
read_file: function(filename: string): string
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição          |
| --------- | ------ | ------------------ |
| filename  | string | O nome do arquivo. |

**Retorna:**

| Tipo de Retorno | Descrição              |
| --------------- | ---------------------- |
| string          | O conteúdo do arquivo. |

### insert_loader

**Tipo:** Função.

**Descrição:**

Insere o carregador YueScript nos carregadores de pacote (searchers).

**Assinatura:**

```lua
insert_loader: function(pos?: integer): boolean
```

**Parâmetros:**

| Parâmetro | Tipo    | Descrição                                                   |
| --------- | ------- | ----------------------------------------------------------- |
| pos       | integer | [Opcional] A posição para inserir o carregador. Padrão é 3. |

**Retorna:**

| Tipo de Retorno | Descrição                                                                              |
| --------------- | -------------------------------------------------------------------------------------- |
| boolean         | Se o carregador foi inserido com sucesso. Falhará se o carregador já estiver inserido. |

### remove_loader

**Tipo:** Função.

**Descrição:**

Remove o carregador YueScript dos carregadores de pacote (searchers).

**Assinatura:**

```lua
remove_loader: function(): boolean
```

**Retorna:**

| Tipo de Retorno | Descrição                                                                               |
| --------------- | --------------------------------------------------------------------------------------- |
| boolean         | Se o carregador foi removido com sucesso. Falhará se o carregador não estiver inserido. |

### loadstring

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de uma string em uma função.

**Assinatura:**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| input     | string | O código YueScript.                 |
| chunkname | string | O nome do chunk de código.          |
| env       | table  | A tabela de ambiente.               |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadstring

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de uma string em uma função.

**Assinatura:**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| input     | string | O código YueScript.                 |
| chunkname | string | O nome do chunk de código.          |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadstring

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de uma string em uma função.

**Assinatura:**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| input     | string | O código YueScript.                 |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadfile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função.

**Assinatura:**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| env       | table  | A tabela de ambiente.               |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadfile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função.

**Assinatura:**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### dofile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função e o executa.

**Assinatura:**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| env       | table  | A tabela de ambiente.               |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                  |
| --------------- | ------------------------------------------ |
| any...          | Os valores de retorno da função carregada. |

### dofile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função e o executa.

**Assinatura:**

```lua
dofile: function(filename: string, config?: Config): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                  |
| --------------- | ------------------------------------------ |
| any...          | Os valores de retorno da função carregada. |

### find_modulepath

**Tipo:** Função.

**Descrição:**

Resolve o nome do módulo YueScript para o caminho do arquivo.

**Assinatura:**

```lua
find_modulepath: function(name: string): string
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição         |
| --------- | ------ | ----------------- |
| name      | string | O nome do módulo. |

**Retorna:**

| Tipo de Retorno | Descrição             |
| --------------- | --------------------- |
| string          | O caminho do arquivo. |

### pcall

**Tipo:** Função.

**Descrição:**

Chama uma função em modo protegido.
Captura quaisquer erros e retorna um código de status e resultados ou objeto de erro.
Reescreve o número da linha do erro para o número da linha original no código YueScript quando ocorrem erros.

**Assinatura:**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**Parâmetros:**

| Parâmetro | Tipo     | Descrição                          |
| --------- | -------- | ---------------------------------- |
| f         | function | A função a chamar.                 |
| ...       | any      | Argumentos a passar para a função. |

**Retorna:**

| Tipo de Retorno | Descrição                                                  |
| --------------- | ---------------------------------------------------------- |
| boolean, ...    | Código de status e resultados da função ou objeto de erro. |

### require

**Tipo:** Função.

**Descrição:**

Carrega um módulo dado. Pode ser um módulo Lua ou um módulo YueScript.
Reescreve o número da linha do erro para o número da linha original no código YueScript se o módulo for um módulo YueScript e o carregamento falhar.

**Assinatura:**

```lua
require: function(name: string): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                    |
| --------- | ------ | ---------------------------- |
| modname   | string | O nome do módulo a carregar. |

**Retorna:**

| Tipo de Retorno | Descrição                                                                                                                                                                                                                         |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| any             | O valor armazenado em package.loaded[modname] se o módulo já estiver carregado. Caso contrário, tenta encontrar um carregador e retorna o valor final de package.loaded[modname] e os dados do carregador como segundo resultado. |

### p

**Tipo:** Função.

**Descrição:**

Inspeciona as estruturas dos valores passados e imprime representações em string.

**Assinatura:**

```lua
p: function(...: any)
```

**Parâmetros:**

| Parâmetro | Tipo | Descrição                 |
| --------- | ---- | ------------------------- |
| ...       | any  | Os valores a inspecionar. |

### options

**Tipo:** Campo.

**Descrição:**

As opções atuais do compilador.

**Assinatura:**

```lua
options: Config.Options
```

### traceback

**Tipo:** Função.

**Descrição:**

A função traceback que reescreve os números das linhas do stack trace para os números das linhas originais no código YueScript.

**Assinatura:**

```lua
traceback: function(message: string): string
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                |
| --------- | ------ | ------------------------ |
| message   | string | A mensagem de traceback. |

**Retorna:**

| Tipo de Retorno | Descrição                          |
| --------------- | ---------------------------------- |
| string          | A mensagem de traceback reescrita. |

### is_ast

**Tipo:** Função.

**Descrição:**

Verifica se o código corresponde ao AST especificado.

**Assinatura:**

```lua
is_ast: function(astName: string, code: string): boolean
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição      |
| --------- | ------ | -------------- |
| astName   | string | O nome do AST. |
| code      | string | O código.      |

**Retorna:**

| Tipo de Retorno | Descrição                       |
| --------------- | ------------------------------- |
| boolean         | Se o código corresponde ao AST. |

### AST

**Tipo:** Campo.

**Descrição:**

A definição do tipo AST com nome, linha, coluna e subnós.

**Assinatura:**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**Tipo:** Função.

**Descrição:**

Converte o código para o AST.

**Assinatura:**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**Parâmetros:**

| Parâmetro      | Tipo    | Descrição                                                                                              |
| -------------- | ------- | ------------------------------------------------------------------------------------------------------ |
| code           | string  | O código.                                                                                              |
| flattenLevel   | integer | [Opcional] O nível de achatamento. Nível mais alto significa mais achatamento. Padrão é 0. Máximo é 2. |
| astName        | string  | [Opcional] O nome do AST. Padrão é "File".                                                             |
| reserveComment | boolean | [Opcional] Se deve preservar os comentários originais. Padrão é false.                                 |

**Retorna:**

| Tipo de Retorno | Descrição                                                   |
| --------------- | ----------------------------------------------------------- |
| AST \| nil      | O AST, ou nil se a conversão falhou.                        |
| string \| nil   | A mensagem de erro, ou nil se a conversão foi bem-sucedida. |

### format

**Tipo:** Função.

**Descrição:**

Formata o código YueScript.

**Assinatura:**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**Parâmetros:**

| Parâmetro      | Tipo    | Descrição                                                             |
| -------------- | ------- | --------------------------------------------------------------------- |
| code           | string  | O código.                                                             |
| tabSize        | integer | [Opcional] O tamanho da tabulação. Padrão é 4.                        |
| reserveComment | boolean | [Opcional] Se deve preservar os comentários originais. Padrão é true. |

**Retorna:**

| Tipo de Retorno | Descrição           |
| --------------- | ------------------- |
| string          | O código formatado. |

### \_\_call

**Tipo:** Metamétodo.

**Descrição:**

Requer o módulo YueScript.
Reescreve o número da linha do erro para o número da linha original no código YueScript quando o carregamento falha.

**Assinatura:**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição         |
| --------- | ------ | ----------------- |
| module    | string | O nome do módulo. |

**Retorna:**

| Tipo de Retorno | Descrição          |
| --------------- | ------------------ |
| any             | O valor do módulo. |

## Config

**Descrição:**

As opções de compilação do compilador.

### lint_global

**Tipo:** Campo.

**Descrição:**

Se o compilador deve coletar as variáveis globais que aparecem no código.

**Assinatura:**

```lua
lint_global: boolean
```

### implicit_return_root

**Tipo:** Campo.

**Descrição:**

Se o compilador deve fazer retorno implícito para o bloco de código raiz.

**Assinatura:**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**Tipo:** Campo.

**Descrição:**

Se o compilador deve preservar o número da linha original no código compilado.

**Assinatura:**

```lua
reserve_line_number: boolean
```

### reserve_comment

**Tipo:** Campo.

**Descrição:**

Se o compilador deve preservar os comentários originais no código compilado.

**Assinatura:**

```lua
reserve_comment: boolean
```

### space_over_tab

**Tipo:** Campo.

**Descrição:**

Se o compilador deve usar o caractere de espaço em vez do caractere de tabulação no código compilado.

**Assinatura:**

```lua
space_over_tab: boolean
```

### same_module

**Tipo:** Campo.

**Descrição:**

Se o compilador deve tratar o código a ser compilado como o mesmo módulo que está sendo compilado atualmente. Apenas para uso interno.

**Assinatura:**

```lua
same_module: boolean
```

### line_offset

**Tipo:** Campo.

**Descrição:**

Se a mensagem de erro do compilador deve incluir o deslocamento do número da linha. Apenas para uso interno.

**Assinatura:**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**Tipo:** Enumeração.

**Descrição:**

A enumeração da versão alvo do Lua.

**Assinatura:**

```lua
enum LuaTarget
  "5.1"
  "5.2"
  "5.3"
  "5.4"
  "5.5"
end
```

### options

**Tipo:** Campo.

**Descrição:**

As opções extras a serem passadas para a função de compilação.

**Assinatura:**

```lua
options: Options
```

## Options

**Descrição:**

A definição das opções extras do compilador.

### target

**Tipo:** Campo.

**Descrição:**

A versão alvo do Lua para a compilação.

**Assinatura:**

```lua
target: LuaTarget
```

### path

**Tipo:** Campo.

**Descrição:**

O caminho de busca de módulo extra.

**Assinatura:**

```lua
path: string
```

### dump_locals

**Tipo:** Campo.

**Descrição:**

Se deve incluir as variáveis locais na mensagem de erro do traceback. Padrão é false.

**Assinatura:**

```lua
dump_locals: boolean
```

### simplified

**Tipo:** Campo.

**Descrição:**

Se deve simplificar a mensagem de erro. Padrão é true.

**Assinatura:**

```lua
simplified: boolean
```
