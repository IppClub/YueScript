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

<YueDisplay>

```yue
class Inventory
  new: =>
    @items = {}

  add_item: (name) =>
    if @items[name]
      @items[name] += 1
    else
      @items[name] = 1
```

</YueDisplay>

Uma classe é declarada com uma instrução class seguida de uma declaração semelhante a tabela onde todos os métodos e propriedades são listados.

A propriedade new é especial pois se tornará o construtor.

Observe como todos os métodos da classe usam a sintaxe de função seta fat. Ao chamar métodos em uma instância, a própria instância é enviada como primeiro argumento. A seta fat cuida da criação do argumento self.

O prefixo @ em um nome de variável é abreviação para self.. @items torna-se self.items.

Criar uma instância da classe é feito chamando o nome da classe como uma função.

```yuescript
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

<YueDisplay>

```yue
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

A forma correta de evitar esse problema é criar o estado mutável do objeto no construtor:

```yuescript
class Person
  new: =>
    @clothes = []
```

<YueDisplay>

```yue
class Person
  new: =>
    @clothes = []
```

</YueDisplay>

## Herança

A palavra-chave extends pode ser usada em uma declaração de classe para herdar as propriedades e métodos de outra classe.

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```

<YueDisplay>

```yue
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "backpack is full"
    super name
```

</YueDisplay>

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

<YueDisplay>

```yue
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- vai imprimir: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```

</YueDisplay>

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

<YueDisplay>

```yue
class MyClass extends ParentClass
  a_method: =>
    -- os seguintes têm o mesmo efeito:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super como valor é igual à classe pai:
    assert super == ParentClass
```

</YueDisplay>

**super** também pode ser usado no lado esquerdo de um Function Stub. A única diferença principal é que, em vez da função resultante estar vinculada ao valor de super, ela está vinculada a self.

## Tipos

Cada instância de uma classe carrega seu tipo consigo. Isso é armazenado na propriedade especial \_\_class. Esta propriedade contém o objeto da classe. O objeto da classe é o que chamamos para construir uma nova instância. Também podemos indexar o objeto da classe para recuperar métodos e propriedades da classe.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- imprime 10
```

<YueDisplay>

```yue
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- imprime 10
```

</YueDisplay>

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

<YueDisplay>

```yue
print BackPack.__name -- imprime Backpack
```

</YueDisplay>

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

<YueDisplay>

```yue
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- variáveis de classe não visíveis em instâncias
assert Things().some_func == nil
```

</YueDisplay>

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

<YueDisplay>

```yue
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- imprime 2
```

</YueDisplay>

A semântica de chamada de @@ é semelhante a @. Chamar um nome @@ passará a classe como primeiro argumento usando a sintaxe de dois pontos do Lua.

```yuescript
@@hello 1,2,3,4
```

<YueDisplay>

```yue
@@hello 1,2,3,4
```

</YueDisplay>

## Instruções de declaração de classe

No corpo de uma declaração de classe, podemos ter expressões normais além de pares chave/valor. Neste contexto, self é igual ao objeto da classe.

Aqui está uma forma alternativa de criar variável de classe comparada ao descrito acima:

```yuescript
class Things
  @class_var = "hello world"
```

<YueDisplay>

```yue
class Things
  @class_var = "hello world"
```

</YueDisplay>

Estas expressões são executadas após todas as propriedades terem sido adicionadas à base.

Todas as variáveis declaradas no corpo da classe são locais às propriedades da classe. Isso é conveniente para colocar valores privados ou funções auxiliares que apenas os métodos da classe podem acessar:

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

<YueDisplay>

```yue
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

</YueDisplay>

## Valores @ e @@

Quando @ e @@ são prefixados na frente de um nome, eles representam, respectivamente, esse nome acessado em self e self.\_\_class.

Se forem usados sozinhos, são aliases para self e self.\_\_class.

```yuescript
assert @ == self
assert @@ == self.__class
```

<YueDisplay>

```yue
assert @ == self
assert @@ == self.__class
```

</YueDisplay>

Por exemplo, uma forma rápida de criar uma nova instância da mesma classe a partir de um método de instância usando @@:

```yuescript
some_instance_method = (...) => @@ ...
```

<YueDisplay>

```yue
some_instance_method = (...) => @@ ...
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>

Você também pode usar esta sintaxe para uma função comum para inicializar os campos de um objeto.

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

<YueDisplay>

```yue
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

</YueDisplay>

## Expressões de classe

A sintaxe de classe também pode ser usada como expressão que pode ser atribuída a uma variável ou retornada explicitamente.

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

<YueDisplay>

```yue
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

</YueDisplay>

## Classes anônimas

O nome pode ser omitido ao declarar uma classe. O atributo \_\_name será nil, a menos que a expressão da classe esteja em uma atribuição. O nome no lado esquerdo da atribuição é usado em vez de nil.

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

<YueDisplay>

```yue
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

</YueDisplay>

Você pode até omitir o corpo, significando que pode escrever uma classe anônima em branco assim:

```yuescript
x = class
```

<YueDisplay>

```yue
x = class
```

</YueDisplay>

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

<YueDisplay>

```yue
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

</YueDisplay>
