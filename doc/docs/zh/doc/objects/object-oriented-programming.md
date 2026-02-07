# 面向对象编程

&emsp;&emsp;在以下的示例中，月之脚本生成的 Lua 代码可能看起来会很复杂。所以最好主要关注月之脚本代码层面的意义，然后如果你想知道关于面向对象功能的实现细节，再查看 Lua 代码。

&emsp;&emsp;一个简单的类：

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

&emsp;&emsp;在月之脚本中采用面向对象的编程方式时，通常会使用类声明语句结合 Lua 表格字面量来做类定义。这个类的定义包含了它的所有方法和属性。在这种结构中，键名为 “new” 的成员扮演了一个重要的角色，是作为构造函数来使用。

&emsp;&emsp;值得注意的是，类中的方法都采用了粗箭头函数语法。当在类的实例上调用方法时，该实例会自动作为第一个参数被传入，因此粗箭头函数用于生成一个名为 “self” 的参数。

&emsp;&emsp;此外，“@” 前缀在变量名上起到了简化作用，代表 “self”。例如，`@items` 就等同于 `self.items`。

&emsp;&emsp;为了创建类的一个新实例，可以将类名当作一个函数来调用，这样就可以生成并返回一个新的实例。

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

&emsp;&emsp;在月之脚本的类中，由于需要将类的实例作为参数传入到调用的方法中，因此使用了 **\\** 操作符做类的成员函数调用。

&emsp;&emsp;需要特别注意的是，类的所有属性在其实例之间是共享的。这对于函数类型的成员属性通常不会造成问题，但对于其他类型的属性，可能会导致意外的结果。

&emsp;&emsp;例如，在下面的示例中，clothes 属性在所有实例之间共享。因此，对这个属性在一个实例中的修改，将会影响到其他所有实例。

```yuescript
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "pants"
b\give_item "shirt"

-- 会同时打印出裤子和衬衫
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

-- 会同时打印出裤子和衬衫
print item for item in *a.clothes
```

</YueDisplay>

&emsp;&emsp;避免这个问题的正确方法是在构造函数中创建对象的可变状态：

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

## 继承

&emsp;&emsp;`extends` 关键字可以在类声明中使用，以继承另一个类的属性和方法。

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "背包已满"
    super name
```

<YueDisplay>

```yue
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "背包已满"
    super name
```

</YueDisplay>

&emsp;&emsp;在这一部分，我们对月之脚本中的 `Inventory` 类进行了扩展，加入了对可以携带物品数量的限制。

&emsp;&emsp;在这个特定的例子中，子类并没有定义自己的构造函数。因此，当创建一个新的实例时，系统会默认调用父类的构造函数。但如果我们在子类中定义了构造函数，我们可以利用 `super` 方法来调用并执行父类的构造函数。

&emsp;&emsp;此外，当一个类继承自另一个类时，它会尝试调用父类上的 `__inherited` 方法（如果这个方法存在的话），以此来向父类发送通知。这个 `__inherited` 函数接受两个参数：被继承的父类和继承的子类。

```yuescript
class Shelf
  @__inherited: (child) =>
    print @__name, "被", child.__name, "继承"

-- 将打印: Shelf 被 Cupboard 继承
class Cupboard extends Shelf
```

<YueDisplay>

```yue
class Shelf
  @__inherited: (child) =>
    print @__name, "被", child.__name, "继承"

-- 将打印: Shelf 被 Cupboard 继承
class Cupboard extends Shelf
```

</YueDisplay>

## super 关键字

&emsp;&emsp;`super` 是一个特别的关键字，它有两种不同的使用方式：既可以当作一个对象来看待，也可以像调用函数那样使用。它仅在类的内部使用时具有特殊的功能。

&emsp;&emsp;当 `super` 被作为一个函数调用时，它将调用父类中与之同名的函数。此时，当前的 `self` 会自动作为第一个参数传递，正如上面提到的继承示例所展示的那样。

&emsp;&emsp;在将 `super` 当作普通值使用时，它实际上是对父类对象的引用。通过这种方式，我们可以访问父类中可能被子类覆盖的值，就像访问任何普通对象一样。

&emsp;&emsp;此外，当使用 `\` 操作符与 `super` 一起使用时，`self`将被插入为第一个参数，而不是使用 `super` 本身的值。而在使用`.`操作符来检索函数时，则会返回父类中的原始函数。

&emsp;&emsp;下面是一些使用 `super` 的不同方法的示例：

```yuescript
class MyClass extends ParentClass
  a_method: =>
    -- 以下效果相同：
    super "你好", "世界"
    super\a_method "你好", "世界"
    super.a_method self, "你好", "世界"

    -- super 作为值等于父类：
    assert super == ParentClass
```

<YueDisplay>

```yue
class MyClass extends ParentClass
  a_method: =>
    -- 以下效果相同：
    super "你好", "世界"
    super\a_method "你好", "世界"
    super.a_method self, "你好", "世界"

    -- super 作为值等于父类：
    assert super == ParentClass
```

</YueDisplay>

&emsp;&emsp;**super** 也可以用在函数存根的左侧。唯一的主要区别是，生成的函数不是绑定到 super 的值，而是绑定到 self。

## 类型

&emsp;&emsp;每个类的实例都带有它的类型。这存储在特殊的 \_\_class 属性中。此属性会保存类对象。类对象是我们用来构建新实例的对象。我们还可以索引类对象以检索类方法和属性。

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- 打印 10
```

<YueDisplay>

```yue
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- 打印 10
```

</YueDisplay>

## 类对象

&emsp;&emsp;在月之脚本中，当我们编写类的定义语句时，实际上是在创建一个类对象。这个类对象被保存在一个与该类同名的变量中。

&emsp;&emsp;类对象具有函数的特性，可以被调用来创建新的实例。这正是我们在之前示例中所展示的创建类实例的方式。

&emsp;&emsp;一个类由两个表构成：类表本身和一个基表。基表作为所有实例的元表。在类声明中列出的所有属性都存放在基表中。

&emsp;&emsp;如果在类对象的元表中找不到某个属性，系统会从基表中检索该属性。这就意味着我们可以直接从类本身访问到其方法和属性。

&emsp;&emsp;需要特别注意的是，对类对象的赋值并不会影响到基表，因此这不是向实例添加新方法的正确方式。相反，需要直接修改基表。关于这点，可以参考下面的 “\_\_base” 字段。

&emsp;&emsp;此外，类对象包含几个特殊的属性：当类被声明时，类的名称会作为一个字符串存储在类对象的 “\_\_name” 字段中。

```yuescript
print BackPack.__name -- 打印 Backpack
```

<YueDisplay>

```yue
print BackPack.__name -- 打印 Backpack
```

</YueDisplay>

&emsp;&emsp;基础对象被保存在一个名为 `__base` 的特殊表中。我们可以编辑这个表，以便为那些已经创建出来的实例和还未创建的实例增加新的功能。

&emsp;&emsp;另外，如果一个类是从另一个类派生而来的，那么其父类对象则会被存储在名为 `__parent` 的地方。这种机制允许在类之间实现继承和功能扩展。

## 类变量

&emsp;&emsp;我们可以直接在类对象中创建变量，而不是在类的基对象中，通过在类声明中的属性名前使用 @。

```yuescript
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- 类变量在实例中不可见
assert Things().some_func == nil
```

<YueDisplay>

```yue
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- 类变量在实例中不可见
assert Things().some_func == nil
```

</YueDisplay>

&emsp;&emsp;在表达式中，我们可以使用 @@ 来访问存储在 `self.__class` 中的值。因此，`@@hello` 是 `self.__class.hello` 的简写。

```yuescript
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- 输出 2
```

<YueDisplay>

```yue
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- 输出 2
```

</YueDisplay>

&emsp;&emsp;@@ 的调用语义与 @ 类似。调用 @@ 时，会使用 Lua 的冒号语法将类作为第一个参数传入。

```yuescript
@@hello 1,2,3,4
```

<YueDisplay>

```yue
@@hello 1,2,3,4
```

</YueDisplay>

## 类声明语句

&emsp;&emsp;在类声明的主体中，除了键/值对外，我们还可以编写普通的表达式。在这种类声明体中的普通代码的上下文中，self 等于类对象，而不是实例对象。

&emsp;&emsp;以下是创建类变量的另一种方法：

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

&emsp;&emsp;这些表达式会在所有属性被添加到类的基对象后执行。

&emsp;&emsp;在类的主体中声明的所有变量都会限制作用域只在类声明的范围。这对于放置只有类方法可以访问的私有值或辅助函数很方便：

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

## @ 和 @@ 值

&emsp;&emsp;当 @ 和 @@ 前缀在一个名字前时，它们分别代表在 self 和 self.\_\_class 中访问的那个名字。

&emsp;&emsp;如果它们单独使用，它们是 self 和 self.\_\_class 的别名。

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

&emsp;&emsp;例如，使用 @@ 从实例方法快速创建同一类的新实例的方法：

```yuescript
some_instance_method = (...) => @@ ...
```

<YueDisplay>

```yue
some_instance_method = (...) => @@ ...
```

</YueDisplay>

## 构造属性提升

&emsp;&emsp;为了减少编写简单值对象定义的代码。你可以这样简单写一个类：

```yuescript
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- 这是以下声明的简写形式

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

-- 这是以下声明的简写形式

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```

</YueDisplay>

&emsp;&emsp;你也可以使用这种语法为一个函数初始化传入对象的字段。

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

## 类表达式

&emsp;&emsp;类声明的语法也可以作为一个表达式使用，可以赋值给一个变量或者被返回语句返回。

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

## 匿名类

&emsp;&emsp;声明类时可以省略名称。如果类的表达式不在赋值语句中，\_\_name 属性将为 nil。如果出现在赋值语句中，赋值操作左侧的名称将代替 nil。

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

&emsp;&emsp;你甚至可以省略掉主体，这意味着你可以这样写一个空白的匿名类：

```yuescript
x = class
```

<YueDisplay>

```yue
x = class
```

</YueDisplay>

## 类混合

&emsp;&emsp;你可以通过使用 `using` 关键字来实现类混合。这意味着你可以从一个普通 Lua 表格或已定义的类对象中，复制函数到你创建的新类中。当你使用普通 Lua 表格进行类混合时，你有机会用自己的实现来重写类的索引方法（例如元方法 `__index`）。然而，当你从一个类对象做混合时，需要注意的是该类对象的元方法将不会被复制到新类。

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

assert y.__class.__parent ~= X -- X 不是 Y 的父类
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

assert y.__class.__parent ~= X -- X 不是 Y 的父类
```

</YueDisplay>
