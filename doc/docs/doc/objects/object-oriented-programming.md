# Object Oriented Programming

In these examples, the generated Lua code may appear overwhelming. It is best to focus on the meaning of the YueScript code at first, then look into the Lua code if you wish to know the implementation details.

A simple class:

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

A class is declared with a class statement followed by a table-like declaration where all of the methods and properties are listed.

The new property is special in that it will become the constructor.

Notice how all the methods in the class use the fat arrow function syntax. When calling methods on a instance, the instance itself is sent in as the first argument. The fat arrow handles the creation of a self argument.

The @ prefix on a variable name is shorthand for self.. @items becomes self.items.

Creating an instance of the class is done by calling the name of the class as a function.

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

Because the instance of the class needs to be sent to the methods when they are called, the \ operator is used.

All properties of a class are shared among the instances. This is fine for functions, but for other types of objects, undesired results may occur.

Consider the example below, the clothes property is shared amongst all instances, so modifications to it in one instance will show up in another:

```yuescript
class Person
  clothes: []
  give_item: (name) =>
    table.insert @clothes, name

a = Person!
b = Person!

a\give_item "pants"
b\give_item "shirt"

-- will print both pants and shirt
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

-- will print both pants and shirt
print item for item in *a.clothes
```

</YueDisplay>

The proper way to avoid this problem is to create the mutable state of the object in the constructor:

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

## Inheritance

The extends keyword can be used in a class declaration to inherit the properties and methods from another class.

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

Here we extend our Inventory class, and limit the amount of items it can carry.

In this example, we don't define a constructor on the subclass, so the parent class' constructor is called when we make a new instance. If we did define a constructor then we can use the super method to call the parent constructor.

Whenever a class inherits from another, it sends a message to the parent class by calling the method \_\_inherited on the parent class if it exists. The function receives two arguments, the class that is being inherited and the child class.

```yuescript
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- will print: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```

<YueDisplay>

```yue
class Shelf
  @__inherited: (child) =>
    print @__name, "was inherited by", child.__name

-- will print: Shelf was inherited by Cupboard
class Cupboard extends Shelf
```

</YueDisplay>

## Super

**super** is a special keyword that can be used in two different ways: It can be treated as an object, or it can be called like a function. It only has special functionality when inside a class.

When called as a function, it will call the function of the same name in the parent class. The current self will automatically be passed as the first argument. (As seen in the inheritance example above)

When super is used as a normal value, it is a reference to the parent class object.

It can be accessed like any of object in order to retrieve values in the parent class that might have been shadowed by the child class.

When the \ calling operator is used with super, self is inserted as the first argument instead of the value of super itself. When using . to retrieve a function, the raw function is returned.

A few examples of using super in different ways:

```yuescript
class MyClass extends ParentClass
  a_method: =>
    -- the following have the same effect:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super as a value is equal to the parent class:
    assert super == ParentClass
```

<YueDisplay>

```yue
class MyClass extends ParentClass
  a_method: =>
    -- the following have the same effect:
    super "hello", "world"
    super\a_method "hello", "world"
    super.a_method self, "hello", "world"

    -- super as a value is equal to the parent class:
    assert super == ParentClass
```

</YueDisplay>

**super** can also be used on left side of a Function Stub. The only major difference is that instead of the resulting function being bound to the value of super, it is bound to self.

## Types

Every instance of a class carries its type with it. This is stored in the special \_\_class property. This property holds the class object. The class object is what we call to build a new instance. We can also index the class object to retrieve class methods and properties.

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- prints 10
```

<YueDisplay>

```yue
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- prints 10
```

</YueDisplay>

## Class Objects

The class object is what we create when we use a class statement. The class object is stored in a variable of the same name of the class.

The class object can be called like a function in order to create new instances. That's how we created instances of classes in the examples above.

A class is made up of two tables. The class table itself, and the base table. The base is used as the metatable for all the instances. All properties listed in the class declaration are placed in the base.

The class object's metatable reads properties from the base if they don't exist in the class object. This means we can access functions and properties directly from the class.

It is important to note that assigning to the class object does not assign into the base, so it's not a valid way to add new methods to instances. Instead the base must explicitly be changed. See the \_\_base field below.

The class object has a couple special properties:

The name of the class as when it was declared is stored as a string in the \_\_name field of the class object.

```yuescript
print BackPack.__name -- prints Backpack
```

<YueDisplay>

```yue
print BackPack.__name -- prints Backpack
```

</YueDisplay>

The base object is stored in \_\_base. We can modify this table to add functionality to instances that have already been created and ones that are yet to be created.

If the class extends from anything, the parent class object is stored in \_\_parent.

## Class Variables

We can create variables directly in the class object instead of in the base by using @ in the front of the property name in a class declaration.

```yuescript
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- class variables not visible in instances
assert Things().some_func == nil
```

<YueDisplay>

```yue
class Things
  @some_func: => print "Hello from", @__name

Things\some_func!

-- class variables not visible in instances
assert Things().some_func == nil
```

</YueDisplay>

In expressions, we can use @@ to access a value that is stored in the **class of self. Thus, @@hello is shorthand for self.**class.hello.

```yuescript
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- prints 2
```

<YueDisplay>

```yue
class Counter
  @count: 0

  new: =>
    @@count += 1

Counter!
Counter!

print Counter.count -- prints 2
```

</YueDisplay>

The calling semantics of @@ are similar to @. Calling a @@ name will pass the class in as the first argument using Lua's colon syntax.

```yuescript
@@hello 1,2,3,4
```

<YueDisplay>

```yue
@@hello 1,2,3,4
```

</YueDisplay>

## Class Declaration Statements

In the body of a class declaration, we can have normal expressions in addition to key/value pairs. In this context, self is equal to the class object.

Here is an alternative way to create a class variable compared to what's described above:

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

These expressions are executed after all the properties have been added to the base.

All variables declared in the body of the class are local to the classes properties. This is convenient for placing private values or helper functions that only the class methods can access:

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

## @ and @@ Values

When @ and @@ are prefixed in front of a name they represent, respectively, that name accessed in self and self.\_\_class.

If they are used all by themselves, they are aliases for self and self.\_\_class.

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

For example, a quick way to create a new instance of the same class from an instance method using @@:

```yuescript
some_instance_method = (...) => @@ ...
```

<YueDisplay>

```yue
some_instance_method = (...) => @@ ...
```

</YueDisplay>

## Constructor Property Promotion

To reduce the boilerplate code for definition of simple value objects. You can write a simple class like:

```yuescript
class Something
  new: (@foo, @bar, @@biz, @@baz) =>

-- Which is short for

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

-- Which is short for

class Something
  new: (foo, bar, biz, baz) =>
    @foo = foo
    @bar = bar
    @@biz = biz
    @@baz = baz
```

</YueDisplay>

You can also use this syntax for a common function to initialize a object's fields.

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

## Class Expressions

The class syntax can also be used as an expression which can be assigned to a variable or explicitly returned.

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

## Anonymous classes

The name can be left out when declaring a class. The \_\_name attribute will be nil, unless the class expression is in an assignment. The name on the left hand side of the assignment is used instead of nil.

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

You can even leave off the body, meaning you can write a blank anonymous class like this:

```yuescript
x = class
```

<YueDisplay>

```yue
x = class
```

</YueDisplay>

## Class Mixing

You can do mixing with keyword `using` to copy functions from either a plain table or a predefined class object into your new class. When doing mixing with a plain table, you can override the class indexing function (metamethod `__index`) to your customized implementation. When doing mixing with an existing class object, the class object's metamethods won't be copied.

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

assert y.__class.__parent ~= X -- X is not parent of Y
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

assert y.__class.__parent ~= X -- X is not parent of Y
```

</YueDisplay>
