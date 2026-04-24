# 月之脚本文档

欢迎来到 <b>月之脚本（YueScript）</b> 官方文档！<br/>
这里收录了语言特性、用法、参考示例和资源。<br/>
请选择左侧的章节索引或目录，开启你的月之脚本之旅 ☽

# do 语句

&emsp;&emsp;当用作语句时，do 语句的作用就像在 Lua 中差不多。

```yuescript
do
  var = "hello"
  print var
print var -- 这里是nil
```

&emsp;&emsp;月之脚本的 **do** 也可以用作表达式。允许你将多行代码的处理合并为一个表达式，并将 do 语句代码块的最后一个语句作为表达式返回的结果。

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
    print "分配键值!"
    1234
}
```

&emsp;&emsp;`do` 表达式支持通过 `break` 打断执行流并提前返回多个值。

```yuescript
status, value = do
  n = 12
  if n > 10
    break "large", n
  break "small", n
```

# 代码行修饰

&emsp;&emsp;为了方便编写代码，循环语句和 if 语句可以应用于单行代码语句的末尾：

```yuescript
print "你好，世界" if name == "Rob"
```

&emsp;&emsp;修饰 for 循环的示例：

```yuescript
print "项目: ", item for item in *items
```

&emsp;&emsp;修饰 while 循环的示例：

```yuescript
game\update! while game\isRunning!

reader\parse_line! until reader\eof!
```

# 宏

## 常见用法

&emsp;&emsp;宏函数用于在编译时执行一段代码来生成新的代码，并将生成的代码插入到最终编译结果中。

```yuescript
macro PI2 = -> math.pi * 2
area = $PI2 * 5

macro HELLO = -> "'你好 世界'"
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

-- 宏函数参数传递的表达式会被转换为字符串
macro and = (...) -> "#{ table.concat {...}, ' and ' }"
if $and f1!, f2!, f3!
  print "OK"
```

## 直接插入代码

&emsp;&emsp;宏函数可以返回一个包含月之脚本代码的字符串，或是一个包含 Lua 代码字符串的配置表。

```yuescript
macro yueFunc = (var) -> "local #{var} = ->"
$yueFunc funcA
funcA = -> "无法访问宏生成月之脚本里定义的变量"

macro luaFunc = (var) -> {
  code: "local function #{var}() end"
  type: "lua"
}
$luaFunc funcB
funcB = -> "无法访问宏生成 Lua 代码里定义的变量"

macro lua = (code) -> {
  :code
  type: "lua"
}

-- raw字符串的开始和结束符号会自动被去除了再传入宏函数
$lua[==[
-- 插入原始Lua代码
if cond then
  print("输出")
end
]==]
```

## 导出宏

&emsp;&emsp;宏函数可以从一个模块中导出，并在另一个模块中导入。你必须将导出的宏函数放在一个单独的文件中使用，而且只有宏定义、宏导入和宏展开可以放入这个宏导出模块中。

```yuescript
-- 文件: utils.yue
export macro map = (items, action) -> "[#{action} for _ in *#{items}]"
export macro filter = (items, action) -> "[_ for _ in *#{items} when #{action}]"
export macro foreach = (items, action) -> "for _ in *#{items}
  #{action}"

-- 文件 main.yue
import "utils" as {
  $, -- 表示导入所有宏的符号
  $foreach: $each -- 重命名宏 $foreach 为 $each
}
[1, 2, 3] |> $map(_ * 2) |> $filter(_ > 4) |> $each print _
```

## 内置宏

&emsp;&emsp;月之脚本中有一些内置可以直接使用的宏，但你可以通过声明相同名称的宏来覆盖它们。

```yuescript
print $FILE -- 获取当前模块名称的字符串
print $LINE -- 获取当前代码行数：2
```

## 用宏生成宏

&emsp;&emsp;在月之脚本中，宏函数允许你在编译时生成代码。通过嵌套的宏函数，你可以创建更复杂的生成模式。这个特性允许你定义一个宏函数，用它来生成另一个宏函数，从而实现更加动态的代码生成。

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

print "有效的枚举类型:", $BodyType Static
-- print "编译报错的枚举类型:", $BodyType Unknown
```

## 生成多行代码

&emsp;&emsp;当宏返回多行 Yue 代码时，不推荐使用带引号的多行字符串，建议优先使用 `-> |`。

&emsp;&emsp;带引号的字符串会按字面保留文本；而 YAML 风格多行字符串会移除公共前导缩进。对宏生成的 Yue 代码来说，这通常能让代码块结构更稳定，尤其是在生成代码里包含注释或嵌套块时。

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

## 宏参数检查

&emsp;&emsp;可以直接在参数列表中声明期望的 AST 节点类型，并在编译时检查传入的宏参数是否符合预期。

```yuescript
macro printNumAndStr = (num `Num, str `String) -> |
  print(
    #{num}
    #{str}
  )

$printNumAndStr 123, "hello"
```

&emsp;&emsp;如果需要做更加灵活的参数检查操作，可以使用内置的 `$is_ast` 宏函数在合适的位置进行手动检查。

```yuescript
macro printNumAndStr = (num, str) ->
  error "expected Num as first argument" unless $is_ast Num, num
  error "expected String as second argument" unless $is_ast String, str
  "print(#{num}, #{str})"

$printNumAndStr 123, "hello"
```

&emsp;&emsp;更多关于可用 AST 节点的详细信息，请参考 [yue_parser.cpp](https://github.com/IppClub/YueScript/blob/main/src/yuescript/yue_parser.cpp) 中大写的规则定义。

## 注解语句

&emsp;&emsp;注解语句会把一个宏应用到它后面的那条语句上。

&emsp;&emsp;这等价于调用该宏，并把后面那条语句的源码作为最后一个参数附加进去。

```yuescript
macro ShowName = (code) -> |
  print "#{code\match '^[%w_]*'}"

$[ShowName]
myFunc = ->

return
```

&emsp;&emsp;如果注解宏返回的是配置表，可选字段 `before` 可以控制生成结果插入到被注解语句之前还是之后。

```yuescript
macro Tag = (tag, code) ->
  tableName = code\match "^[%w_]+"
  return
    type: "text"
    before: tag == "before"
    code: "-- #{tag}:#{tableName}"

$[Tag before]
tableA = {}

$[Tag after]
tableB = {}

return
```

&emsp;&emsp;由于后面的语句会作为额外的宏参数传入，注解也可以从类声明生成注册代码。它同样可以使用普通宏支持的 AST 参数检查。

```yuescript
macro Register = (registry, code`ClassDecl) ->
  className = code\match "^class%s+(%w+)"
  return |
    #{registry}["#{className}"] = #{className}

registry = {}

$[Register(registry)]
class Worker
  run: => "ok"

return
```

&emsp;&emsp;注解也可以用来给函数注入包装代码。

```yuescript
macro ValidateNumberArgs = (code) ->
  funcName = code\match "^(%w+)%s*="
  return |
    local __orig_#{funcName} = #{funcName}
    #{funcName} = (...) ->
      for i = 1, select "#", ...
        assert type(select i, ...) == "number", "expected number for arg \#{i}"
      __orig_#{funcName} ...

$[ValidateNumberArgs]
add = (a, b) -> a + b
```

&emsp;&emsp;注解后面必须紧跟一条语句，而且不能作用在 `return` 语句上。如果被注解的语句正好位于代码块末尾，而你又需要拿到原始的语句 AST 形态，就需要额外补一个显式的 `return`，避免它被隐式返回表达式包起来。

# 错误处理

&emsp;&emsp;用于统一进行 Lua 错误处理的便捷语法。

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
  print "尝试中"
  func 1, 2, 3

-- 使用if赋值模式
if success, result := try func 1, 2, 3
catch err
    print yue.traceback err
  print result
```

## 错误处理简化

&emsp;&emsp;`try?` 是 `try` 的功能简化语法，它不再返回 `try` 语句的布尔状态，并在成功时直接返回 `try` 代码块的结果，失败时返回 `nil` 值而非错误对象。

```yuescript
a, b, c = try? func!

-- 与空值合并运算符一起使用
a = (try? func!) ?? "default"

-- 作为函数参数
f try? func!

-- 带 catch 块的 try!
f try?
  print 123
  func!
catch e
  print e
  e
```

# 表格字面量

&emsp;&emsp;和 Lua 一样，表格可以通过花括号进行定义。

```yuescript
some_values = {1, 2, 3, 4}
```

&emsp;&emsp;但与Lua不同的是，给表格中的键赋值是用 **:**（而不是 **=**）。

```yuescript
some_values = {
  name: "Bill",
  age: 200,
  ["favorite food"]: "rice"
}
```

&emsp;&emsp;如果只分配一个键值对的表格，可以省略花括号。

```yuescript
profile =
  height: "4英尺",
  shoe_size: 13,
  favorite_foods: ["冰淇淋", "甜甜圈"]
```

&emsp;&emsp;可以使用换行符而不使用逗号（或两者都用）来分隔表格中的值：

```yuescript
values = {
  1, 2, 3, 4
  5, 6, 7, 8
  name: "超人"
  occupation: "打击犯罪"
}
```

&emsp;&emsp;创建单行表格字面量时，也可以省略花括号：

```yuescript
my_function dance: "探戈", partner: "无"

y = type: "狗", legs: 4, tails: 1
```

&emsp;&emsp;表格字面量的键可以使用 Lua 语言的关键字，而无需转义：

```yuescript
tbl = {
  do: "某事"
  end: "饥饿"
}
```

&emsp;&emsp;如果你要构造一个由变量组成的表，并希望键与变量名相同，那么可以使用 **:** 前缀操作符：

```yuescript
hair = "金色"
height = 200
person = { :hair, :height, shoe_size: 40 }

print_table :hair, :height
```

&emsp;&emsp;如果你希望表中字段的键是某个表达式的结果，那么可以用 **[ ]** 包裹它，就像在 Lua 中一样。如果键中有任何特殊字符，也可以直接使用字符串字面量作为键，省略方括号。

```yuescript
t = {
  [1 + 2]: "你好"
  "你好 世界": true
}
```

&emsp;&emsp;Lua 的表同时具有数组部分和哈希部分，但有时候你会希望在书写 Lua 表时，对 Lua 表做数组和哈希不同用法的语义区分。然后你可以用 **[ ]** 而不是 **{ }** 来编写表示数组的 Lua 表，并且不允许在数组 Lua 表中写入任何键值对。

```yuescript
some_values = [ 1, 2, 3, 4 ]
list_with_one_element = [ 1, ]
```

# 推导式

&emsp;&emsp;推导式为我们提供了一种便捷的语法，通过遍历现有对象并对其值应用表达式来构造出新的表格。月之脚本有两种推导式：列表推导式和表格推导式。它们最终都是产生 Lua 表格；列表推导式将值累积到类似数组的表格中，而表格推导式允许你在每次遍历时设置新表格的键和值。

## 列表推导式

&emsp;&emsp;以下操作创建了一个 items 表的副本，但所有包含的值都翻倍了。

```yuescript
items = [1, 2, 3, 4]
doubled = [item * 2 for i, item in ipairs items]
```

&emsp;&emsp;可以使用 `when` 子句筛选新表中包含的项目：

```yuescript
slice = [item for i, item in ipairs items when i > 1 and i < 3]
```

&emsp;&emsp;因为我们常常需要迭代数值索引表的值，所以引入了 **\*** 操作符来做语法简化。doubled 示例可以重写为：

```yuescript
doubled = [item * 2 for item in *items]
```

&emsp;&emsp;在列表推导式中，你还可以使用展开操作符 `...` 来实现对列表嵌套层级进行扁平化的处理：

```yuescript
data =
  a: [1, 2, 3]
  b: [4, 5, 6]

flat = [...v for k,v in pairs data]
-- flat 现在为 [1, 2, 3, 4, 5, 6]
```

&emsp;&emsp;for 和 when 子句可以根据需要进行链式操作。唯一的要求是推导式中至少要有一个 for 子句。

&emsp;&emsp;使用多个 for 子句与使用多重循环的效果相同：

```yuescript
x_coords = [4, 5, 6, 7]
y_coords = [9, 2, 3]

points = [ [x, y] for x in *x_coords \
for y in *y_coords]
```

&emsp;&emsp;在推导式中也可以使用简单的数值 for 循环：

```yuescript
evens = [i for i = 1, 100 when i % 2 == 0]
```

## 表格推导式

&emsp;&emsp;表格推导式和列表推导式的语法非常相似，只是要使用 **{** 和 **}** 并从每次迭代中取两个值。

&emsp;&emsp;以下示例生成了表格 thing 的副本：

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

&emsp;&emsp;**\*** 操作符在表格推导式中能使用。在下面的例子里，我们为几个数字创建了一个平方根查找表。

```yuescript
numbers = [1, 2, 3, 4]
sqrts = {i, math.sqrt i for i in *numbers}
```

&emsp;&emsp;表格推导式中的键值元组也可以来自单个表达式，在这种情况下，表达式在计算后应返回两个值。第一个用作键，第二个用作值：

&emsp;&emsp;在下面的示例中，我们将一些数组转换为一个表，其中每个数组里的第一项是键，第二项是值。

```yuescript
tuples = [ ["hello", "world"], ["foo", "bar"]]
tbl = {unpack tuple for tuple in *tuples}
```

## 切片

&emsp;&emsp;当使用 **\*** 操作符时，月之脚本还提供了一种特殊的语法来限制要遍历的列表范围。这个语法也相当于在 for 循环中设置迭代边界和步长。

&emsp;&emsp;下面的案例中，我们在切片中设置最小和最大边界，取索引在 1 到 5 之间（包括 1 和 5）的所有项目：

```yuescript
slice = [item for item in *items[1, 5]]
```

&emsp;&emsp;切片的任意参数都可以省略，并会使用默认值。在如下示例中，如果省略了最大索引边界，它默认为表的长度。使下面的代码取除第一个元素之外的所有元素：

```yuescript
slice = [item for item in *items[2,]]
```

&emsp;&emsp;如果省略了最小边界，便默认会设置为 1。这里我们只提供一个步长，并留下其他边界为空。这样会使得代码取出所有奇数索引的项目：(1, 3, 5, …)

```yuescript
slice = [item for item in *items[,,2]]
```

&emsp;&emsp;最小和最大边界都可以是负数，使用负数意味着边界是从表的末尾开始计算的。

```yuescript
-- 取最后4个元素
slice = [item for item in *items[-4,-1]]
```

&emsp;&emsp;切片的步长也可以是负数，这意味着元素会以相反的顺序被取出。

```yuescript
reverse_slice = [item for item in *items[-1,1,-1]]
```

### 切片表达式

&emsp;&emsp;切片也可以作为表达式来使用。可以用于获取一个表包含的子列表。

```yuescript
-- 取第2和第4个元素作为新的列表
sub_list = items[2, 4]

-- 取最后4个元素作为新的列表
last_four_items = items[-4, -1]
```

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

&emsp;&emsp;在月之脚本中采用面向对象的编程方式时，通常会使用类声明语句结合 Lua 表格字面量来做类定义。这个类的定义包含了它的所有方法和属性。在这种结构中，键名为 “new” 的成员扮演了一个重要的角色，是作为构造函数来使用。

&emsp;&emsp;值得注意的是，类中的方法都采用了粗箭头函数语法。当在类的实例上调用方法时，该实例会自动作为第一个参数被传入，因此粗箭头函数用于生成一个名为 “self” 的参数。

&emsp;&emsp;此外，“@” 前缀在变量名上起到了简化作用，代表 “self”。例如，`@items` 就等同于 `self.items`。

&emsp;&emsp;类定义块中也支持通过尖括号写元方法字段，例如 `<tostring>`。

```yuescript
class User
  new: (@name) =>
  <tostring>: => "User(#{@name})"

print tostring User "Yue"
```

&emsp;&emsp;为了创建类的一个新实例，可以将类名当作一个函数来调用，这样就可以生成并返回一个新的实例。

```yuescript
inv = Inventory!
inv\add_item "t-shirt"
inv\add_item "pants"
```

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

&emsp;&emsp;避免这个问题的正确方法是在构造函数中创建对象的可变状态：

```yuescript
class Person
  new: =>
    @clothes = []
```

## 继承

&emsp;&emsp;`extends` 关键字可以在类声明中使用，以继承另一个类的属性和方法。

```yuescript
class BackPack extends Inventory
  size: 10
  add_item: (name) =>
    if #@items > size then error "背包已满"
    super name
```

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

&emsp;&emsp;**super** 也可以用在函数存根的左侧。唯一的主要区别是，生成的函数不是绑定到 super 的值，而是绑定到 self。

## 类型

&emsp;&emsp;每个类的实例都带有它的类型。这存储在特殊的 \_\_class 属性中。此属性会保存类对象。类对象是我们用来构建新实例的对象。我们还可以索引类对象以检索类方法和属性。

```yuescript
b = BackPack!
assert b.__class == BackPack

print BackPack.size -- 打印 10
```

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

&emsp;&emsp;@@ 的调用语义与 @ 类似。调用 @@ 时，会使用 Lua 的冒号语法将类作为第一个参数传入。

```yuescript
@@hello 1,2,3,4
```

## 类声明语句

&emsp;&emsp;在类声明的主体中，除了键/值对外，我们还可以编写普通的表达式。在这种类声明体中的普通代码的上下文中，self 等于类对象，而不是实例对象。

&emsp;&emsp;以下是创建类变量的另一种方法：

```yuescript
class Things
  @class_var = "hello world"
```

&emsp;&emsp;这些表达式会在所有属性被添加到类的基对象后执行。

&emsp;&emsp;在类的主体中声明的所有变量都会限制作用域只在类声明的范围。这对于放置只有类方法可以访问的私有值或辅助函数很方便：

```yuescript
class MoreThings
  secret = 123
  log = (msg) -> print "LOG:", msg

  some_method: =>
    log "hello world: " .. secret
```

## @ 和 @@ 值

&emsp;&emsp;当 @ 和 @@ 前缀在一个名字前时，它们分别代表在 self 和 self.\_\_class 中访问的那个名字。

&emsp;&emsp;如果它们单独使用，它们是 self 和 self.\_\_class 的别名。

```yuescript
assert @ == self
assert @@ == self.__class
```

&emsp;&emsp;例如，使用 @@ 从实例方法快速创建同一类的新实例的方法：

```yuescript
some_instance_method = (...) => @@ ...
```

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

&emsp;&emsp;你也可以使用这种语法为一个函数初始化传入对象的字段。

```yuescript
new = (@fieldA, @fieldB) => @
obj = new {}, 123, "abc"
print obj
```

## 类表达式

&emsp;&emsp;类声明的语法也可以作为一个表达式使用，可以赋值给一个变量或者被返回语句返回。

```yuescript
x = class Bucket
  drops: 0
  add_drop: => @drops += 1
```

## 匿名类

&emsp;&emsp;声明类时可以省略名称。如果类的表达式不在赋值语句中，\_\_name 属性将为 nil。如果出现在赋值语句中，赋值操作左侧的名称将代替 nil。

```yuescript
BigBucket = class extends Bucket
  add_drop: => @drops += 10

assert Bucket.__name == "BigBucket"
```

&emsp;&emsp;你甚至可以省略掉主体，这意味着你可以这样写一个空白的匿名类：

```yuescript
x = class
```

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

# with 语句

在编写 Lua 代码时，我们在创建对象后的常见操作是立即调用这个对象一系列操作函数并设置一系列属性。

这导致在代码中多次重复引用对象的名称，增加了不必要的文本噪音。一个常见的解决方案是在创建对象时，在构造函数传入一个表，该表包含要覆盖设置的键和值的集合。这样做的缺点是该对象的构造函数必须支持这种初始化形式。

with 块有助于简化编写这样的代码。在 with 块内，我们可以使用以 . 或 \ 开头的特殊语句，这些语句代表我们正在使用的对象的操作。

例如，我们可以这样处理一个新创建的对象：

```yuescript
with Person!
  .name = "Oswald"
  \add_relative my_dad
  \save!
  print .name
```

with 语句也可以用作一个表达式，并返回它的代码块正在处理的对象。

```yuescript
file = with File "favorite_foods.txt"
  \set_encoding "utf8"
```

`with` 表达式支持 `break` 返回一个值：

```yuescript
result = with obj
  break .value
```

在 `with` 中使用 `break value` 后，`with` 表达式将不再返回其目标对象，而是返回 `break` 给出的值。

```yuescript
a = with obj
  .x = 1
-- a 是 obj

b = with obj
  break .x
-- b 是 .x，不是 obj
```

与 `for` / `while` / `repeat` / `do` 不同，`with` 只支持一个 break 返回值。

或者…

```yuescript
create_person = (name,  relatives) ->
  with Person!
    .name = name
    \add_relative relative for relative in *relatives

me = create_person "Leaf", [dad, mother, sister]
```

在此用法中，with 可以被视为K组合子（k-combinator）的一种特殊形式。

如果你想给表达式另外起一个名称的话，with 语句中的表达式也可以是一个赋值语句。

```yuescript
with str := "你好"
  print "原始:", str
  print "大写:", \upper!
```

你可以在 `with` 语句中使用 `[]` 访问特殊键。

```yuescript
with tb
  [1] = 1
  print [2]
  with [abc]
    [3] = [2]\func!
    ["key-name"] = value
  [] = "abc" -- 追加到 "tb"
```

`with?` 是 `with` 语法的一个增强版本，引入了存在性检查，用于在不显式判空的情况下安全访问可能为 nil 的对象。

```yuescript
with? obj
  print .name
```

# 赋值

&emsp;&emsp;月之脚本中定义的变量是动态类型的，并默认为局部变量。但你可以通过 **local** 和 **global** 声明来改变声明变量的作用范围。

```yuescript
hello = "world"
a, b, c = 1, 2, 3
hello = 123 -- 访问现有的变量
```

## 执行更新

&emsp;&emsp;你可以使用各式二进制运算符执行更新赋值。

```yuescript
x = 1
x += 1
x -= 1
x *= 10
x /= 10
x %= 10
s ..= "world" -- 如果执行更新的局部变量不存在，将新建一个局部变量
arg or= "默认值"
```

## 链式赋值

&emsp;&emsp;你可以进行链式赋值，将多个项目赋予相同的值。

```yuescript
a = b = c = d = e = 0
x = y = z = f!
```

## 显式声明局部变量

```yuescript
do
  local a = 1
  local *
  print "预先声明后续所有变量为局部变量"
  x = -> 1 + y + z
  y, z = 2, 3
  global instance = Item\new!

do
  local X = 1
  local ^
  print "只预先声明后续大写的变量为局部变量"
  a = 1
  B = 2
```

## 显式声明全局变量

```yuescript
do
  global a = 1
  global *
  print "预先声明所有变量为全局变量"
  x = -> 1 + y + z
  y, z = 2, 3

do
  global x = 1
  global ^
  print "只预先声明大写的变量为全局变量"
  a = 1
  B = 2
  local Temp = "一个局部值"
```

# 可变参数赋值

&emsp;&emsp;你可以将函数返回的结果赋值给一个可变参数符号 `...`。然后使用 Lua 的方式访问其内容。

```yuescript
list = [1, 2, 3, 4, 5]
fn = (ok) -> ok, table.unpack list
ok, ... = fn true
count = select '#', ...
first = select 1, ...
print ok, count, first
```

# If 赋值

&emsp;&emsp;`if` 和 `elseif` 代码块可以在条件表达式的位置进行赋值。在代码执行到要计算条件时，会首先进行赋值计算，并使用赋与的值作为分支判断的条件。赋值的变量仅在条件分支的代码块内有效，这意味着如果值不是真值，那么它就不会被用到。注意，你必须使用“海象运算符” `:=` 而不是 `=` 来做赋值。

```yuescript
if user := database.find_user "moon"
  print user.name
```

```yuescript
if hello := os.getenv "hello"
  print "你有 hello", hello
elseif world := os.getenv "world"
  print "你有 world", world
else
  print "什么都没有 :("
```

&emsp;&emsp;使用多个返回值的 If 赋值。只有第一个值会被检查，其他值都有同样的作用域。

```yuescript
if success, result := pcall -> "无报错地获取结果"
  print result -- 变量 result 是有作用域的
print "好的"
```

## While 赋值

&emsp;&emsp;你可以在 while 循环中同样使用赋值来获取循环条件的值。

```yuescript
while byte := stream\read_one!
  -- 对 byte 做一些操作
  print byte
```

# 解构赋值

&emsp;&emsp;解构赋值是一种快速从 Lua 表中按名称或基于数组中的位置提取值的方法。

&emsp;&emsp;通常当你看到一个字面量的 Lua 表，比如 `{1,2,3}`，它位于赋值的右侧，因为它是一个值。解构赋值语句的写法就是交换了字面量 Lua 表的角色，并将其放在赋值语句的左侧。

&emsp;&emsp;最好是通过示例来解释。以下是如何从表格中解包前两个值的方法：

```yuescript
thing = [1, 2]

[a, b] = thing
print a, b
```

&emsp;&emsp;在解构表格字面量中，键代表从右侧读取的键，值代表读取的值将被赋予的名称。

```yuescript
obj = {
  hello: "world"
  day: "tuesday"
  length: 20
}

{hello: hello, day: the_day} = obj
print hello, the_day

:day = obj -- 可以不带大括号进行简单的解构
```

&emsp;&emsp;这也适用于嵌套的数据结构：

```yuescript
obj2 = {
  numbers: [1,2,3,4]
  properties: {
    color: "green"
    height: 13.5
  }
}

{numbers: [first, second], properties: {color: color}} = obj2
print first, second, color
```

&emsp;&emsp;如果解构语句很复杂，也可以任意将其分散在几行中。稍微复杂一些的示例：

```yuescript
{
  numbers: [first, second]
  properties: {
    color: color
  }
} = obj2
```

&emsp;&emsp;有时候我们会需要从 Lua 表中提取值并将它们赋给与键同名的局部变量。为了避免编写重复代码，我们可以使用 **:** 前缀操作符：

```yuescript
{:concat, :insert} = table
```

&emsp;&emsp;这样的用法与导入语法有些相似。但我们可以通过混合语法重命名我们想要提取的字段：

```yuescript
{:mix, :max, random: rand} = math
```

&emsp;&emsp;在进行解构时，你可以指定默认值，如：

```yuescript
{:name = "nameless", :job = "jobless"} = person
```

&emsp;&emsp;在进行列表解构时，你可以使用`_`作为占位符：

```yuescript
[_, two, _, four] = items
```

## 范围解构

&emsp;&emsp;你可以使用展开运算符 `...` 在列表解构中来捕获一个范围的值到子列表中。这在当你想要从列表的开头和结尾提取特定元素，同时收集中间的元素时非常有用。

```yuescript
orders = ["first", "second", "third", "fourth", "last"]
[first, ...bulk, last] = orders
print first  -- 打印: first
print bulk   -- 打印: {"second", "third", "fourth"}
print last   -- 打印: last
```

&emsp;&emsp;展开运算符可以用在不同的位置来捕获不同的范围，并且你可以使用 `_` 作为占位符来表示你想跳过对应范围的捕获：

```yuescript
-- 捕获第一个元素之后的所有元素
[first, ...rest] = orders

-- 捕获最后一个元素之前的所有元素
[...start, last] = orders

-- 跳过中间的元素，只捕获第一个和最后一个元素
[first, ..._, last] = orders
```

## 在其它地方的解构赋值

&emsp;&emsp;解构赋值也可以出现在其它隐式进行赋值的地方。一个例子是用在 for 循环中：

```yuescript
tuples = [
  ["hello", "world"]
  ["egg", "head"]
]

for [left, right] in *tuples
  print left, right
```

&emsp;&emsp;我们知道数组表中的每个元素都是一个两项的元组，所以我们可以直接在 for 语句的名称子句中使用解构来解包它。

# 使用 using 语句：防止破坏性赋值

&emsp;&emsp;Lua 的变量作用域是降低代码复杂度的重要工具。然而，随着代码量的增加，维护这些变量可能变得更加困难。比如，看看下面的代码片段：

```yuescript
i = 100

-- 许多代码行...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- 将打印 0
```

&emsp;&emsp;在 `my_func` 中，我们不小心覆盖了变量 `i` 的值。虽然在这个例子中这个问题很明显，但在一个庞大的或者是由多人共同维护的代码库中，很难追踪每个变量的声明情况。

&emsp;&emsp;如果我们可以明确指出哪些变量是我们想在当前作用域内修改的，并且防止我们不小心更改了其他作用域中同名的变量，那将大有裨益。

&emsp;&emsp;`using` 语句就是为此而生。`using nil` 确保函数内部的赋值不会意外地影响到外部作用域的变量。我们只需将 `using` 子句放在函数的参数列表之后；若函数没有参数，则直接放在括号内即可。

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- 这里创建了一个新的局部变量

my_func!
print i -- 打印 100，i 没有受到影响
```

&emsp;&emsp;using子句中可以填写多个用逗号分隔名称。指定可以访问和修改的外部变量的名称：

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- 创建了一个新的局部tmp
  i += tmp
  k += tmp

my_func(22)
print i, k -- 这些已经被更新
```

# 使用方法

## Lua 模块

&emsp;&emsp;在 Lua 中使用月之脚本模块：

- **用法 1**

  &emsp;&emsp;在 Lua 中引入 "你的脚本入口文件.yue"。

  ```lua
  require("yue")("你的脚本入口文件")
  ```

  &emsp;&emsp;当你在同一路径下把 "你的脚本入口文件.yue" 编译成了 "你的脚本入口文件.lua" 时，仍然可以使用这个代码加载 .lua 代码文件。在其余的月之脚本文件中，只需正常使用 **require** 或 **import** 进行脚本引用即可。错误消息中的代码行号也会被正确处理。

- **用法 2**

  &emsp;&emsp;手动引入月之脚本模块并重写错误消息来帮助调试。

  ```lua
  local yue = require("yue")
  yue.insert_loaders()
  local success, result = xpcall(function()
    return require("yuescript_module_name")
  end, function(err)
    return yue.traceback(err)
  end)
  ```

- **用法 3**

  &emsp;&emsp;在 Lua 中使用月之脚本编译器功能。

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

## 月之脚本编译工具

&emsp;&emsp;使用月之脚本编译工具：

```shell
> yue -h
命令行用法: yue
         [选项] [<文件/目录>] ...
         yue -e <代码或文件> [参数...]
         yue -w [<目录>] [选项]
         yue -

说明:
   - '-' 或 '--' 必须作为唯一且第一个参数，用于读取标准输入。
   - '-o/--output' 不能与多个输入文件一起使用。
   - '-w/--watch' 仅能用于目录，不能用于单个文件。
   - 使用 '-e/--execute' 时，后续的参数将作为脚本参数传递。

选项:
   -h, --help                 显示帮助信息并退出
   -e <字符串>, --execute <字符串>  执行文件或原始代码
   -m, --minify               生成压缩（最小化）代码
   -r, --rewrite              重写输出以匹配原始代码行号
   -t <目标路径>, --output-to <目标路径>
                              指定编译后文件的输出路径
   -o <文件>, --output <文件>  将输出写入文件
   -p, --print                输出到标准输出
   -b, --benchmark            输出编译耗时（不写入文件）
   -g, --globals              显示用到的全局变量及其所在的名称、行号、列号
   -s, --spaces               用空格代替制表符(tab)输出代码
   -l, --line-numbers         输出源代码的行号
   -j, --no-implicit-return   禁用文件末尾的隐式返回
   -c, --reserve-comments     保留源代码中的注释
   -w [<目录>], --watch [<目录>]
                              监视目录变化并自动编译
   -v, --version              显示版本信息
   -                          从标准输入读取，输出到标准输出（仅能作为唯一参数）
   --                         等同于 '-'，为兼容旧版本保留

   --target <版本>            指定生成代码的 Lua 版本 (只能为 5.1 ~ 5.5)
   --path <路径字符串>         附加一个 Lua 搜索路径到 package.path
   --<键>=<值>                以 key=value 形式传递编译器选项（保持已有用法）

   不带选项直接运行可进入交互模式（REPL），在交互模式里输入单独的符号 '$'
   可用于开始或结束多行模式。
```

&emsp;&emsp;使用案例：

&emsp;&emsp;递归编译当前路径下扩展名为 **.yue** 的每个月之脚本文件： **yue .**

&emsp;&emsp;编译并将结果保存到目标路径： **yue -t /target/path/ .**

&emsp;&emsp;编译并保留调试信息： **yue -l .**

&emsp;&emsp;编译并生成压缩代码： **yue -m .**

&emsp;&emsp;直接执行代码： **yue -e 'print 123'**

&emsp;&emsp;执行一个月之脚本文件： **yue -e main.yue**

# 介绍

月之脚本（YueScript）是一种动态语言，可以编译为 Lua。它是 [MoonScript](https://github.com/leafo/moonscript) 的方言。用月之脚本编写的代码既有表现力又非常简洁。它适合编写一些更易于维护的代码，并在嵌入 Lua 的环境中运行，如游戏或网站服务器。

Yue（月）是中文中“月亮”的名称。

## 月之脚本概览

```yuescript
-- 导入语法
import p, to_lua from "yue"

-- 隐式对象
inventory =
  equipment:
    - "sword"
    - "shield"
  items:
    - name: "potion"
      count: 10
    - name: "bread"
      count: 3

-- 列表推导
map = (arr, action) ->
  [action item for item in *arr]

filter = (arr, cond) ->
  [item for item in *arr when cond item]

reduce = (arr, init, action): init ->
  init = action init, item for item in *arr

-- 管道操作符
[1, 2, 3]
  |> map (x) -> x * 2
  |> filter (x) -> x > 4
  |> reduce 0, (a, b) -> a + b
  |> print

-- 元表操作
apple =
  size: 15
  <index>:
    color: 0x00ffff

with apple
  p .size, .color, .<index> if .<>?

-- 类似js的导出语法
export 🌛 = "月之脚本"
```

## 关于 Dora SSR

月之脚本是与开源游戏引擎 [Dora SSR](https://github.com/Dora-SSR/Dora-SSR) 一起开发和维护的。它已被用于创建引擎工具、游戏原型和演示，在实际的游戏项目中验证其能力，同时它也帮助增强了 Dora SSR 游戏引擎的开发体验。

# 安装

## Lua 模块

&emsp;安装 [luarocks](https://luarocks.org)，一个 Lua 模块的包管理器。然后作为 Lua 模块和可执行文件安装它：

```shell
luarocks install yuescript
```

&emsp;或者你可以自己构建 `yue.so` 文件：

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

&emsp;然后从路径 **bin/shared/yue.so** 获取二进制文件。

## 构建二进制工具

&emsp;克隆项目仓库，然后构建并安装可执行文件：

```shell
make install
```

&emsp;构建不带宏功能的月之脚本编译工具：

```shell
make install NO_MACRO=true
```

&emsp;构建不带内置Lua二进制文件的月之脚本编译工具：

```shell
make install NO_LUA=true
```

## 下载预编译的二进制程序

&emsp;你可以下载预编译的二进制程序，包括兼容不同 Lua 版本的二进制可执行文件和库文件。

&emsp;在[这里](https://github.com/IppClub/YueScript/releases)下载预编译的二进制程序。

# 条件语句

```yuescript
have_coins = false
if have_coins
  print "有硬币"
else
  print "没有硬币"
```

&emsp;&emsp;对于简单的语句，也可以使用简短的语法：

```yuescript
have_coins = false
if have_coins then print "有硬币" else print "没有硬币"
```

&emsp;&emsp;因为 if 语句可以用作表达式，所以也可以这样写：

```yuescript
have_coins = false
print if have_coins then "有硬币" else "没有硬币"
```

&emsp;&emsp;条件语句也可以作为表达式用在返回语句和赋值语句中：

```yuescript
is_tall = (name) ->
  if name == "Rob"
    true
  else
    false

message = if is_tall "Rob"
  "我很高"
else
  "我不是很高"

print message -- 打印: 我很高
```

&emsp;&emsp;if 的反义词是 unless（相当于 if not，正如“如果”对应“除非”）：

```yuescript
unless os.date("%A") == "Monday"
  print "今天不是星期一！"
```

```yuescript
print "你真幸运！" unless math.random! > 0.1
```

## 范围表达式

&emsp;&emsp;你可以使用范围表达式来编写进行范围检查的代码。

```yuescript
a = 5

if a in [1, 3, 5, 7]
  print "检查离散值的相等性"

if a in list
  print "检查`a`是否在列表中"
```

`in` 运算符也可以用于表，并支持 `not in` 变体来进行否定检查：

```yuescript
has = "foo" in {"bar", "foo"}

if a in {1, 2, 3}
  print "a 在表中"

not_exist = item not in list

check = -> value not in table
```

单元素列表或表会检查与该元素的相等性：

```yuescript
-- [1,] 检查 value == 1
c = a in [1,]

-- {1} 也是检查 value == 1
c = a in {1}

-- 没有逗号，[1] 是索引访问（tb[1]）
with tb
  c = a in [1]
```

# for 循环

&emsp;&emsp;Lua 中有两种 for 循环形式，数字型和通用型：

```yuescript
for i = 10, 20
  print i

for k = 1, 15, 2 -- 提供了一个遍历的步长
  print k

for key, value in pairs object
  print key, value
```

&emsp;&emsp;可以使用切片和 **\*** 操作符，就像在列表推导中一样：

```yuescript
for item in *items[2, 4]
  print item
```

&emsp;&emsp;当代码语句只有一行时，循环语句也都可以写作更短的语法：

```yuescript
for item in *items do print item

for j = 1, 10, 3 do print j
```

&emsp;&emsp;for 循环也可以用作表达式。for 循环主体中的最后一条语句会被强制转换为一个返回值的表达式，并会将表达式计算结果的值追加到一个作为结果的数组表中。

&emsp;&emsp;将每个偶数加倍：

```yuescript
doubled_evens = for i = 1, 20
  if i % 2 == 0
    i * 2
  else
    i
```

&emsp;&emsp;此外，for 循环还支持带返回值的 break 语句，这样循环本身就可以作为一个表达式，在满足条件时提前退出并返回有意义的结果。for 循环表达式支持 `break` 返回多个值。

&emsp;&emsp;例如，查找第一个大于 10 的数字：

```yuescript
first_large = for n in *numbers
  break n if n > 10
```

```yuescript
key, score = for k, v in pairs data
  break k, v * 10 if k == "target"
```

&emsp;&emsp;你还可以结合 for 循环表达式与 continue 语句来过滤值。

&emsp;&emsp;注意出现在函数体末尾的 for 循环，不会被当作是一个表达式并将循环结果累积到一个列表中作为返回值（相反，函数将返回 nil）。如果要函数末尾的循环转换为列表表达式，可以显式地使用返回语句加 for 循环表达式。

```yuescript
func_a = -> for i = 1, 10 do print i
func_b = -> return for i = 1, 10 do i

print func_a! -- 打印 nil
print func_b! -- 打印 table 对象
```

&emsp;&emsp;这样做是为了避免在不需要返回循环结果的函数，创建无效的返回值表格。

# continue 语句

&emsp;&emsp;继续语句可以用来跳出当前的循环迭代。

```yuescript
i = 0
while i < 10
  i += 1
  continue if i % 2 == 0
  print i
```

&emsp;&emsp;继续语句也可以与各种循环表达式一起使用，以防止当前的循环迭代结果累积到结果列表中。以下示例将数组表过滤为仅包含偶数的数组：

```yuescript
my_numbers = [1, 2, 3, 4, 5, 6]
odds = for x in *my_numbers
  continue if x % 2 == 1
  x
```

# switch 语句

&emsp;&emsp;switch 语句是为了简化检查一系列相同值的if语句而提供的简写语法。要注意用于比较检查的目标值只会计算一次。和 if 语句一样，switch 语句在最后可以接一个 else 代码块来处理没有匹配的情况。在生成的 Lua 代码中，进行比较是使用 == 操作符完成的。switch 语句中也可以使用赋值表达式来储存临时变量值。

```yuescript
switch name := "Dan"
  when "Robert"
    print "你是Robert"
  when "Dan", "Daniel"
    print "你的名字是Dan"
  else
    print "我不认识你，你的名字是#{name}"
```

&emsp;&emsp;switch 语句的 when 子句中可以通过使用逗号分隔的列表来匹配多个值。

&emsp;&emsp;switch 语句也可以作为表达式使用，下面我们可以将 switch 语句返回的结果分配给一个变量：

```yuescript
b = 1
next_number = switch b
  when 1
    2
  when 2
    3
  else
    error "数字数得太大了！"
```

&emsp;&emsp;我们可以使用 then 关键字在 when 子句的同一行上编写处理代码。else 代码块的后续代码中要写在同一行上不需要额外的关键字。

```yuescript
msg = switch math.random(1, 5)
  when 1 then "你很幸运"
  when 2 then "你差点很幸运"
  else "不太幸运"
```

&emsp;&emsp;如果在编写 switch 语句时希望少写一个缩进，那么你可以把第一个 when 子句放在 switch 开始语句的第一行，然后后续的子语句就都可以都少写一个缩进。

```yuescript
switch math.random(1, 5)
  when 1
    print "你很幸运" -- 两个缩进级别
  else
    print "不太幸运"

switch math.random(1, 5) when 1
  print "你很幸运" -- 一个缩进级别
else
  print "不太幸运"
```

&emsp;&emsp;值得注意的是，在生成 Lua 代码时，我们要做检查的目标变量会放在 == 表达式的右侧。当你希望给 when 子句的比较对象定义一个 \_\_eq 元方法来重载判断逻辑时，可能会有用。

## 表格匹配

&emsp;&emsp;在 switch 的 when 子句中，如果期待检查目标是一个表格，且可以通过特定的结构进行解构并获得非 nil 值，那么你可以尝试使用表格匹配的语法。

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
      print "尺寸 #{width}, #{height}"
```

&emsp;&emsp;你可以使用默认值来选择性地解构表格的某些字段。

```yuescript
item = {}

{pos: {:x = 50, :y = 200}} = item -- 获取错误：尝试索引nil值（字段'pos'）

switch item
  when {pos: {:x = 50, :y = 200}}
    print "Vec2 #{x}, #{y}" -- 表格解构仍然会通过
```

&emsp;&emsp;你也可以匹配数组元素、表格字段，甚至使用数组或表格字面量来匹配嵌套的结构。

&emsp;&emsp;匹配数组元素。

```yuescript
switch tb
  when [1, 2, 3]
    print "1, 2, 3"
  when [1, b, 3]
    print "1, #{b}, 3"
  when [1, 2, b = 3] -- 变量b有默认值
    print "1, 2, #{b}"
```

&emsp;&emsp;匹配表格字段。

```yuescript
switch tb
  when success: true, :result
    print "成功", result
  when success: false
    print "失败", result
  else
    print "无效值"
```

&emsp;&emsp;匹配嵌套的表格结构。

```yuescript
switch tb
  when data: {type: "success", :content}
    print "成功", content
  when data: {type: "error", :content}
    print "失败", content
  else
    print "无效值"
```

&emsp;&emsp;匹配表格数组。

```yuescript
switch tb
  when [
      {a: 1, b: 2}
      {a: 3, b: 4}
      {a: 5, b: 6}
      fourth
    ]
    print "匹配成功", fourth
```

&emsp;&emsp;匹配一个列表并捕获特定范围内的元素。

```yuescript
segments = ["admin", "users", "logs", "view"]
switch segments
  when [...groups, resource, action]
    print "Group:", groups -- 打印: {"admin", "users"}
    print "Resource:", resource -- 打印: "logs"
    print "Action:", action -- 打印: "view"
```

# while 循环

&emsp;&emsp;在月之脚本中的 while 循环支持几种不同的写法：

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

&emsp;&emsp;像 for 循环的语法一样，while 循环也可以作为一个表达式使用。while / until 循环表达式支持 `break` 返回多个值。

```yuescript
value, doubled = while true
  n = get_next!
  break n, n * 2 if n > 10
```

&emsp;&emsp;为了使函数返回 while 循环的累积列表值，必须明确使用返回语句返回 while 循环表达式。

## repeat 循环

&emsp;&emsp;repeat 循环是从 Lua 语言中搬过来的相似语法：

```yuescript
i = 10
repeat
  print i
  i -= 1
until i == 0
```

&emsp;&emsp;repeat 循环表达式同样支持 `break` 返回多个值：

```yuescript
i = 1
value, scaled = repeat
  break i, i * 100 if i > 3
  i += 1
until false
```

# 函数存根

&emsp;&emsp;在编程中，将对象的方法作为函数类型的值进行传递是一种常见做法，尤其是在将实例方法作为回调函数传递给其他函数的情形中。当目标函数需要将该对象作为其第一个参数时，我们需要找到一种方式将对象和函数绑定在一起，以便能够正确地调用该函数。

&emsp;&emsp;函数存根（stub）语法提供了一种便捷的方法来创建一个新的闭包函数，这个函数将对象和原函数绑定在一起。这样，当调用这个新创建的函数时，它会在正确的对象上下文中执行原有的函数。

&emsp;&emsp;这种语法类似于使用 \ 操作符调用实例方法的方式，区别在于，这里不需要在 \ 操作符后面附加参数列表。

```yuescript
my_object = {
  value: 1000
  write: => print "值为:", @value
}

run_callback = (func) ->
  print "运行回调..."
  func!

-- 这样写不起作用：
-- 函数没有引用my_object
run_callback my_object.write

-- 函数存根语法
-- 让我们把对象捆绑到一个新函数中
run_callback my_object\write
```

# 反向回调

&emsp;&emsp;反向回调用于减少函数回调的嵌套。它们使用指向左侧的箭头，并且默认会被定义为传入后续函数调用的最后一个参数。它的语法大部分与常规箭头函数相同，只是它指向另一方向，并且后续的函数体不需要进行缩进。

```yuescript
x <- f
print "hello" .. x
```

&emsp;&emsp;月之脚本也提供了粗箭头反向回调函数。

```yuescript
<= f
print @value
```

&emsp;&emsp;你可以通过一个占位符指定回调函数的传参位置。

```yuescript
(x) <- map _, [1, 2, 3]
x * 2
```

&emsp;&emsp;如果你希望在反向回调处理后继续编写更多其它的代码，可以使用 do 语句将不属于反向回调的代码分隔开。对于非粗箭头函数的反向回调，回调返回值的括号也是可以省略的。

```yuescript
result, msg = do
  data <- readAsync "文件名.txt"
  print data
  info <- processAsync data
  check info
print result, msg
```

# 函数字面量

&emsp;&emsp;所有函数都是使用月之脚本的函数表达式创建的。一个简单的函数可以用箭头表示为：**->**。

```yuescript
my_function = ->
my_function() -- 调用空函数
```

&emsp;&emsp;函数体可以是紧跟在箭头后的一个语句，或者是在后面的行上使用同样缩进的一系列语句：

```yuescript
func_a = -> print "你好，世界"

func_b = ->
  value = 100
  print "这个值是：", value
```

&emsp;&emsp;如果一个函数没有参数，可以使用 **\!** 操作符调用它，而不是空括号。使用 **\!** 调用没有参数的函数是推荐的写法。

```yuescript
func_a!
func_b()
```

&emsp;&emsp;带有参数的函数可以通过在箭头前加上括号中的参数名列表来进行创建：

```yuescript
sum = (x, y) -> print "数字的和", x + y
```

&emsp;&emsp;函数可以通过在函数名后列出参数来调用。当对函数做嵌套的调用时，后面列出的参数会应用于左侧最近的函数。

```yuescript
sum 10, 20
print sum 10, 20

a b c "a", "b", "c"
```

&emsp;&emsp;为了避免在调用函数时产生歧义，也可以使用括号将参数括起来。比如在以下的例子中是必需的，这样才能确保参数被传入到正确的函数。

```yuescript
print "x:", sum(10, 20), "y:", sum(30, 40)
```

&emsp;&emsp;注意：函数名与开始括号之间不能有任何空格。

&emsp;&emsp;函数会将函数体中的最后一个语句强制转换为返回语句，这被称作隐式返回：

```yuescript
sum = (x, y) -> x + y
print "数字的和是", sum 10, 20
```

&emsp;&emsp;如果你需要做显式返回，可以使用 return 关键字：

```yuescript
sum = (x, y) -> return x + y
```

&emsp;&emsp;就像在Lua中一样，函数可以返回多个值。最后一个语句必须是由逗号分隔的值列表：

```yuescript
mystery = (x, y) -> x + y, x - y
a, b = mystery 10, 20
```

## 粗箭头

&emsp;&emsp;因为在 Lua 中调用方法时，经常习惯将对象作为第一个参数传入，所以月之脚本提供了一种特殊的语法来创建自动包含 self 参数的函数。

```yuescript
func = (num) => @value + num
```

## 参数默认值

&emsp;&emsp;可以为函数的参数提供默认值。如果参数的值为 nil，则确定该参数为空。任何具有默认值的 nil 参数在函数体运行之前都会被替换。

```yuescript
my_function = (name = "某物", height = 100) ->
  print "你好，我是", name
  print "我的高度是", height
```

&emsp;&emsp;函数参数的默认值表达式在函数体中会按参数声明的顺序进行计算。因此，在默认值的表达式中可以访问先前声明的参数。

```yuescript
some_args = (x = 100, y = x + 1000) ->
  print x + y
```

## 注意事项

&emsp;&emsp;由于月之脚本支持无需括号的表达式式函数调用，因此为了避免因空白字符造成的解析歧义，需要进行一些限制。

&emsp;&emsp;减号（-）在表达式中既可以作为一元取反操作符，也可以作为二元减法操作符。请注意下面这些示例的编译方式：

```yuescript
a = x - 10
b = x-10
c = x -y
d = x- z
```

&emsp;&emsp;当函数调用的第一个参数是字符串字面量时，可以通过空白控制其优先级。在 Lua 中，常见的写法是调用仅有一个字符串或表字面量参数的函数时省略括号。

&emsp;&emsp;当变量名和字符串字面量之间没有空格时，函数的调用优先级高于后续表达式，因此此时无法再传入其他参数。

&emsp;&emsp;当变量名和字符串字面量之间有空格时，字符串字面量会作为后续表达式（如果存在）的参数，这样可以传递参数列表。

```yuescript
x = func"hello" + 100
y = func "hello" + 100
```

## 多行参数

&emsp;&emsp;当调用接收大量参数的函数时，将参数列表分成多行是很方便的。由于月之脚本语言对空白字符的敏感性，做参数列表的分割时务必要小心。

&emsp;&emsp;如果要将参数列表写到下一行，那么当前行必须以逗号结束。并且下一行的缩进必须比当前的缩进多。一旦做了参数的缩进，所有其他参数列表的行必须保持相同的缩进级别，以成为参数列表的一部分。

```yuescript
my_func 5, 4, 3,
  8, 9, 10

cool_func 1, 2,
  3, 4,
  5, 6,
  7, 8
```

&emsp;&emsp;这种调用方式可以做嵌套。并通过缩进级别来确定参数属于哪一个函数。

```yuescript
my_func 5, 6, 7,
  6, another_func 6, 7, 8,
    9, 1, 2,
  5, 4
```

&emsp;&emsp;因为 Lua 表也使用逗号作为分隔符，这种缩进语法有助于让值成为参数列表的一部分，而不是 Lua 表的一部分。

```yuescript
x = [
  1, 2, 3, 4, a_func 4, 5,
    5, 6,
  8, 9, 10
]
```

&emsp;&emsp;有个不常见的写法可以注意一下，如果我们将在后面使用较低的缩进，我们可以为函数参数提供更深的缩进来区分列表的归属。

```yuescript
y = [ my_func 1, 2, 3,
   4, 5,
  5, 6, 7
]
```

&emsp;&emsp;对于其它有代码块跟随的语句，比如条件语句，也可以通过小心安排缩进来做类似的事。比如我们可以通过调整缩进级别来控制一些值归属于哪个语句：

```yuescript
if func 1, 2, 3,
  "你好",
  "世界"
    print "你好"
    print "我在if内部"

if func 1, 2, 3,
    "你好",
    "世界"
  print "hello"
  print "我在if内部"
```

## 参数解构

&emsp;&emsp;月之脚本支持在函数形参位置对传入对象进行解构。适用两类解构表子面量：

- 使用 {} 包裹的字面量/对象形参，支持提供获得空字段时的默认值（例如 {:a, :b}、{a: a1 = 123}）。

- 无 {} 包裹、以键值/简写键序列开头，直至遇到其它表达式终止（例如 :a, b: b1, :c），表示从同一个对象中解构多个字段。

```yuescript
f1 = (:a, :b, :c) ->
  print a, b, c

f1 a: 1, b: "2", c: {}

f2 = ({a: a1 = 123, :b = 'abc'}, c = {}) ->
  print a1, b, c

arg1 = {a: 0}
f2 arg1, arg2
```

## 前置返回表达式

&emsp;&emsp;在深度嵌套的函数体中，为了提升返回值的可读性及编写便利性，我们新增了 “前置返回表达式” 语法。其形式如下：

```yuescript
findFirstEven = (list): nil ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
```

&emsp;&emsp;这个写法等价于：

```yuescript
findFirstEven = (list) ->
  for item in *list
    if type(item) == "table"
      for sub in *item
        if sub % 2 == 0
          return sub
  nil
```

&emsp;&emsp;唯一的区别在于：你可以将函数的返回值表达式提前写在 `->` 或 `=>` 前，用以指示该函数应隐式返回该表达式的值。这样即使在多层循环或条件判断的场景下，也无需编写尾行悬挂的返回表达式，逻辑结构会更加直观清晰。

## 命名变长参数

&emsp;&emsp;你可以使用 `(...t) ->` 语法来将变长参数自动存储到一个命名表中。这个表会包含所有传入的参数（包括 `nil` 值），并且会在表的 `n` 字段中存储实际传入的参数个数（包括 `nil` 值在内的个数）。

```yuescript
f = (...t) ->
  print "参数个数:", t.n
  print "表长度:", #t
  for i = 1, t.n
    print t[i]

f 1, 2, 3
f "a", "b", "c", "d"
f!

-- 处理包含 nil 的情况
process = (...args) ->
  sum = 0
  for i = 1, args.n
    if args[i] != nil and type(args[i]) == "number"
      sum += args[i]
  sum

process 1, nil, 3, nil, 5
```

# 空白

&emsp;&emsp;月之脚本是一个对空白敏感的语言。你必须在相同的缩进中使用空格 **' '** 或制表符 **'\t'** 来编写一些代码块，如函数体、值列表和一些控制块。包含不同空白的表达式可能意味着不同的事情。制表符被视为4个空格，但最好不要混合使用空格和制表符。

## 语句分隔符

&emsp;&emsp;一条语句通常以换行结束。你也可以使用分号 `;` 显式结束一条语句，从而在同一行中编写多条语句：

```yuescript
a = 1; b = 2; print a + b
```

## 多行链式调用

&emsp;&emsp;你可以使用相同的缩进来编写多行链式函数调用。

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

# 注释

```yuescript
-- 我是一个注释

str = --[[
这是一个多行注释。
没问题。
]] strA \ -- 注释 1
  .. strB \ -- 注释 2
  .. strC

func --[[端口]] 3000, --[[ip]] "192.168.1.1"
```

# 属性

&emsp;&emsp;月之脚本现在提供了 Lua 5.4 新增的叫做属性的语法支持。在月之脚本编译到的 Lua 目标版本低于 5.4 时，你仍然可以同时使用`const` 和 `close` 的属性声明语法，并获得常量检查和作用域回调的功能。

```yuescript
const a = 123
close _ = <close>: -> print "超出范围。"
```

&emsp;&emsp;你可以对进行解构得到的变量标记为常量。

```yuescript
const {:a, :b, c, d} = tb
-- a = 1
```

&emsp;&emsp;你也可以声明全局变量为常量。

```yuescript
global const Constant = 123
-- Constant = 1
```

# 操作符

&emsp;&emsp;Lua 的所有二元和一元操作符在月之脚本中都是可用的。此外，**!=** 符号是 **~=** 的别名，而 **\\** 或 **::** 均可用于编写链式函数调用，如写作 `tb\func!` 或 `tb::func!`。此外月之脚本还提供了一些其他特殊的操作符，以编写更具表达力的代码。

```yuescript
tb\func! if tb ~= nil
tb::func! if tb != nil
```

## 链式比较

&emsp;&emsp;你可以在月之脚本中进行比较表达式的链式书写：

```yuescript
print 1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
-- 输出：true

a = 5
print 1 <= a <= 10
-- 输出：true
```

&emsp;&emsp;可以注意一下链式比较表达式的求值行为：

```yuescript
v = (x) ->
  print x
  x

print v(1) < v(2) <= v(3)
--[[
  输出：
  2
  1
  3
  true
]]

print v(1) > v(2) <= v(3)
--[[
  输出：
  2
  1
  false
]]
```

&emsp;&emsp;在上面的例子里，中间的表达式 `v(2)` 仅被计算一次，如果把表达式写成 `v(1) < v(2) and v(2) <= v(3)` 的方式，中间的 `v(2)` 才会被计算两次。在链式比较中，求值的顺序往往是未定义的。所以强烈建议不要在链式比较中使用具有副作用（比如做打印操作）的表达式。如果需要使用有副作用的函数，应明确使用短路 `and` 运算符来做连接。

## 表追加

&emsp;&emsp;**[] =** 操作符用于向 Lua 表的最后插入值。

```yuescript
tab = []
tab[] = "Value"
```

&emsp;&emsp;你还可以使用展开操作符 `...` 来将一个列表中的所有元素追加到另一个列表中：

```yuescript
tbA = [1, 2, 3]
tbB = [4, 5, 6]
tbA[] = ...tbB
-- tbA 现在为 [1, 2, 3, 4, 5, 6]
```

## 表扩展

&emsp;&emsp;你可以使用前置 `...` 操作符在 Lua 表中插入数组表或哈希表。

&emsp;&emsp;使用花括号字面量做表扩展（例如 `{...other}`）时，会复制 Lua 表中的数组部分和哈希部分。

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

### 列表表扩展

&emsp;&emsp;使用中括号字面量做表扩展（例如 `[...other,]`）时，只会复制 Lua 表中的数组部分。

```yuescript
source = {1, 2, 3, name: "Yue"}
fullCopy = {...source}
listCopy = [...source,]
-- fullCopy => {1, 2, 3, name: "Yue"}
-- listCopy => [1, 2, 3]
```

## 表反向索引

&emsp;&emsp;你可以使用 **#** 操作符来反向索引表中的元素。

```yuescript
last = data.items[#]
second_last = data.items[#-1]
data.items[#] = 1
```

## 元表

&emsp;&emsp;**<>** 操作符可提供元表操作的快捷方式。

### 元表创建

&emsp;&emsp;使用空括号 **<>** 或被 **<>** 包围的元方法键创建普通的 Lua 表。

```yuescript
mt = {}
add = (right) => <>: mt, value: @value + right.value
mt.__add = add

a = <>: mt, value: 1
-- 使用与临时变量名相同的字段名，将临时变量赋值给元表
b = :<add>, value: 2
c = <add>: mt.__add, value: 3

d = a + b + c
print d.value

close _ = <close>: -> print "超出范围"
```

### 元表访问

&emsp;&emsp;使用 **<>** 或被 **<>** 包围的元方法名或在 **<>** 中编写某些表达式来访问元表。

```yuescript
-- 使用包含字段 "value" 的元表创建
tb = <"value">: 123
tb.<index> = tb.<>
print tb.value

tb.<> = __index: {item: "hello"}
print tb.item
```

### 元表解构

&emsp;&emsp;使用被 **<>** 包围的元方法键解构元表。

```yuescript
{item, :new, :<close>, <index>: getter} = tb
print item, new, close, getter
```

## 存在性

&emsp;&emsp;**?** 运算符可以在多种上下文中用来检查存在性。

```yuescript
func?!
print abc?["你好 世界"]?.xyz

x = tab?.value
len = utf8?.len or string?.len or (o) -> #o

if print and x?
  print x

with? io.open "test.txt", "w"
  \write "你好"
  \close!
```

## 管道

&emsp;&emsp;与其使用一系列嵌套的函数调用，你还可以考虑使用运算符 **|>** 来传递值。

```yuescript
"你好" |> print
1 |> print 2 -- 将管道项作为第一个参数插入
2 |> print 1, _, 3 -- 带有占位符的管道

-- 多行的管道表达式
readFile "example.txt"
  |> extract language, {}
  |> parse language
  |> emit
  |> render
  |> print
```

## 空值合并

&emsp;&emsp;如果其左操作数不是 **nil**，则nil合并运算符 **??** 返回其左操作数的值；否则，它将计算右操作数并返回其结果。如果左操作数计算结果为非 nil 的值，**??** 运算符将不再计算其右操作数。

```yuescript
local a, b, c, d
a = b ?? c ?? d
func a ?? {}

a ??= false
```

## 隐式对象

&emsp;&emsp;你可以在表格块内使用符号 **\*** 或是 **-** 开始编写一系列隐式结构。如果你正在创建隐式对象，对象的字段必须具有相同的缩进。

```yuescript
-- 赋值时使用隐式对象
list =
  * 1
  * 2
  * 3

-- 函数调用时使用隐式对象
func
  * 1
  * 2
  * 3

-- 返回时使用隐式对象
f = ->
  return
    * 1
    * 2
    * 3

-- 表格时使用隐式对象
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

# 字面量

&emsp;&emsp;Lua 中的所有基本字面量都可以在月之脚本中使用。包括数字、字符串、布尔值和 **nil**。

&emsp;&emsp;但与 Lua 不同的是，单引号和双引号字符串内部允许有换行：

```yuescript
some_string = "这是一个字符串
  并包括一个换行。"

-- 使用#{}语法可以将表达式插入到字符串字面量中。
-- 字符串插值只在双引号字符串中可用。
print "我有#{math.random! * 100}%的把握。"
```

## 数字字面量

&emsp;&emsp;你可以在数字字面量中使用下划线来增加可读性。

```yuescript
integer = 1_000_000
hex = 0xEF_BB_BF
binary = 0B10011
```

## YAML 风格字符串

&emsp;&emsp;使用 `|` 前缀标记一个多行 YAML 风格字符串：

```yuescript
str = |
  key: value
  list:
    - item1
    - #{expr}
```

&emsp;&emsp;其效果类似于原生 Lua 的多行拼接，所有文本（含换行）将被保留下来，并支持 `#{...}` 语法，通过 `tostring(expr)` 插入表达式结果。

&emsp;&emsp;YAML 风格的多行字符串会自动检测首行后最小的公共缩进，并从所有行中删除该前缀空白字符。这让你可以在代码中对齐文本，但输出字符串不会带多余缩进。

```yuescript
fn = ->
  str = |
    foo:
      bar: baz
  return str
```

&emsp;&emsp;输出字符串中的 foo: 对齐到行首，不会带有函数缩进空格。保留内部缩进的相对结构，适合书写结构化嵌套样式的内容。

&emsp;&emsp;支持自动处理字符中的引号、反斜杠等特殊符号，无需手动转义：

```yuescript
str = |
  path: "C:\Program Files\App"
  note: 'He said: "#{Hello}!"'
```

# 模块

## 导入

&emsp;&emsp;导入语句是一个语法糖，用于需要引入一个模块或者从已导入的模块中提取子项目。从模块导入的变量默认为不可修改的常量。

```yuescript
-- 用作表解构
do
  import insert, concat from table
  -- 当给 insert, concat 变量赋值时，编译器会报告错误
  import C, Ct, Cmt from require "lpeg"
  -- 快捷写法引入模块的子项
  import x, y, z from 'mymodule'
  -- 使用Python风格的导入
  from 'module' import a, b, c

-- 快捷地导入一个模块
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- 导入模块后起一个别名使用，或是进行导入模块表的解构
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

## 导入全局变量

&emsp;&emsp;你可以使用 `import` 将指定的全局变量导入到本地变量中。当导入一系列对全局变量的链式访问时，最后一个访问的字段将被赋值给本地变量。

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

### 自动全局变量导入

&emsp;&emsp;在一个代码块的顶部写 `import global`，会将当前作用域中尚未显式声明或赋值过的变量名，自动导入为本地常量，并在该语句的位置绑定到同名的全局变量。

&emsp;&emsp;但是在同一作用域中被显式声明为全局的变量不会被自动导入，因此可以继续进行赋值操作。

```yuescript
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- 报错：自动导入的全局变量为常量

do
  -- 被显式声明为全局的变量不会被自动导入
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

## 导出

&emsp;&emsp;导出语句提供了一种简洁的方式来定义当前的模块。

### 命名导出

&emsp;&emsp;带命名的导出将定义一个局部变量，并在导出的表中添加一个同名的字段。

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

&emsp;&emsp;使用解构进行命名导出。

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = '默认值'}} = tb
```

&emsp;&emsp;从模块导出命名项目时，可以不用创建局部变量。

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

### 未命名导出

&emsp;&emsp;未命名导出会将要导出的目标项目添加到导出表的数组部分。

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

### 默认导出

&emsp;&emsp;在导出语句中使用 **default** 关键字，来替换导出的表为一个目标的对象。

```yuescript
export default ->
  print "你好"
  123
```

# MIT 许可证

版权 (c) 2017-2026 李瑾 \<dragon-fly@qq.com\>

特此免费授予任何获得本软件副本和相关文档文件（下称“软件”）的人不受限制地处置该软件的权利，包括不受限制地使用、复制、修改、合并、发布、分发、转授许可和/或出售该软件副本，以及再授权被配发了本软件的人如上的权利，须在下列条件下：
上述版权声明和本许可声明应包含在该软件的所有副本或实质成分中。
本软件是“如此”提供的，没有任何形式的明示或暗示的保证，包括但不限于对适销性、特定用途的适用性和不侵权的保证。在任何情况下，作者或版权持有人都不对任何索赔、损害或其他责任负责，无论这些追责来自合同、侵权或其它行为中，还是产生于、源于或有关于本软件以及本软件的使用或其它处置。

# 月之脚本语言库

在 Lua 中使用 `local yue = require("yue")` 来访问。

## yue

**描述：**

月之脚本语言库。

### version

**类型：** 成员变量。

**描述：**

月之脚本版本。

**签名：**

```lua
version: string
```

### dirsep

**类型：** 成员变量。

**描述：**

当前平台的文件分隔符。

**签名：**

```lua
dirsep: string
```

### yue_compiled

**类型：** 成员变量。

**描述：**

编译模块代码缓存。

**签名：**

```lua
yue_compiled: {string: string}
```

### to_lua

**类型：** 函数。

**描述：**

月之脚本的编译函数。它将 YueScript 代码编译为 Lua 代码。

**签名：**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**参数：**

| 参数名 | 类型   | 描述                |
| ------ | ------ | ------------------- |
| code   | string | YueScript 代码。    |
| config | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型                            | 描述                                                                                       |
| ----------------------------------- | ------------------------------------------------------------------------------------------ |
| string \| nil                       | 编译后的 Lua 代码，如果编译失败则为 nil。                                                  |
| string \| nil                       | 错误消息，如果编译成功则为 nil。                                                           |
| {{string, integer, integer}} \| nil | 代码中出现的全局变量（带有名称、行和列），如果编译器选项 `lint_global` 为 false 则为 nil。 |

### file_exist

**类型：** 函数。

**描述：**

检查源文件是否存在的函数。可以覆盖该函数以自定义行为。

**签名：**

```lua
file_exist: function(filename: string): boolean
```

**参数：**

| 参数名   | 类型   | 描述     |
| -------- | ------ | -------- |
| filename | string | 文件名。 |

**返回值：**

| 返回类型 | 描述           |
| -------- | -------------- |
| boolean  | 文件是否存在。 |

### read_file

**类型：** 函数。

**描述：**

读取源文件的函数。可以覆盖该函数以自定义行为。

**签名：**

```lua
read_file: function(filename: string): string
```

**参数：**

| 参数名   | 类型   | 描述     |
| -------- | ------ | -------- |
| filename | string | 文件名。 |

**返回值：**

| 返回类型 | 描述       |
| -------- | ---------- |
| string   | 文件内容。 |

### insert_loader

**类型：** 函数。

**描述：**

将 YueScript 加载器插入到 Lua 包加载器（搜索器）中。

**签名：**

```lua
insert_loader: function(pos?: integer): boolean
```

**参数：**

| 参数名 | 类型    | 描述                                  |
| ------ | ------- | ------------------------------------- |
| pos    | integer | [可选] 要插入加载器的位置。默认为 3。 |

**返回值：**

| 返回类型 | 描述                                                 |
| -------- | ---------------------------------------------------- |
| boolean  | 是否成功插入加载器。如果加载器已经插入，则返回失败。 |

### remove_loader

**类型：** 函数。

**描述：**

从 Lua 包加载器（搜索器）中移除 YueScript 加载器。

**签名：**

```lua
remove_loader: function(): boolean
```

**返回值：**

| 返回类型 | 描述                                               |
| -------- | -------------------------------------------------- |
| boolean  | 是否成功移除加载器。如果加载器未插入，则返回失败。 |

### loadstring

**类型：** 函数。

**描述：**

将 YueScript 代码字符串加载为一个函数。

**签名：**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**参数：**

| 参数名    | 类型   | 描述                |
| --------- | ------ | ------------------- |
| input     | string | YueScript 代码。    |
| chunkname | string | 代码块的名称。      |
| env       | table  | 环境表。            |
| config    | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadstring

**类型：** 函数。

**描述：**

将 YueScript 代码字符串加载为一个函数。

**签名：**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**参数：**

| 参数名    | 类型   | 描述                |
| --------- | ------ | ------------------- |
| input     | string | YueScript 代码。    |
| chunkname | string | 代码块的名称。      |
| config    | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadstring

**类型：** 函数。

**描述：**

将 YueScript 代码字符串加载为一个函数。

**签名：**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**参数：**

| 参数名 | 类型   | 描述                |
| ------ | ------ | ------------------- |
| input  | string | YueScript 代码。    |
| config | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadfile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数。

**签名：**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| env      | table  | 环境表。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### loadfile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数。

**签名：**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型        | 描述                               |
| --------------- | ---------------------------------- |
| function \| nil | 加载的函数，如果加载失败则为 nil。 |
| string \| nil   | 错误消息，如果加载成功则为 nil。   |

### dofile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数并执行。

**签名：**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| env      | table  | 环境表。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型 | 描述                       |
| -------- | -------------------------- |
| any...   | 加载的函数执行后的返回值。 |

### dofile

**类型：** 函数。

**描述：**

将 YueScript 代码文件加载为一个函数并执行。

**签名：**

```lua
dofile: function(filename: string, config?: Config): any...
```

**参数：**

| 参数名   | 类型   | 描述                |
| -------- | ------ | ------------------- |
| filename | string | 文件名。            |
| config   | Config | [可选] 编译器选项。 |

**返回值：**

| 返回类型 | 描述                       |
| -------- | -------------------------- |
| any...   | 加载的函数执行后的返回值。 |

### find_modulepath

**类型：** 函数。

**描述：**

将 YueScript 模块名解析为文件路径。

**签名：**

```lua
find_modulepath: function(name: string): string
```

**参数：**

| 参数名 | 类型   | 描述     |
| ------ | ------ | -------- |
| name   | string | 模块名。 |

**返回值：**

| 返回类型 | 描述       |
| -------- | ---------- |
| string   | 文件路径。 |

### pcall

**类型：** 函数。

**描述：**

在保护模式下调用一个函数。
会捕获任何错误，执行成功则返回成功状态和结果，否则为失败状态和错误信息。
当发生错误时，将错误信息中的代码行号重写为 YueScript 代码中的原始行号。

**签名：**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**参数：**

| 参数名 | 类型     | 描述                 |
| ------ | -------- | -------------------- |
| f      | function | 要调用的函数。       |
| ...    | any      | 要传递给函数的参数。 |

**返回值：**

| 返回类型     | 描述                         |
| ------------ | ---------------------------- |
| boolean, ... | 状态码和函数结果或错误信息。 |

### require

**类型：** 函数。

**描述：**

加载给定的模块。可以是 Lua 模块或 YueScript 模块。
如果模块是 YueScript 模块且加载失败，则将错误信息中的代码行号重写为 YueScript 代码中的原始行号。

**签名：**

```lua
require: function(name: string): any...
```

**参数：**

| 参数名  | 类型   | 描述             |
| ------- | ------ | ---------------- |
| modname | string | 要加载的模块名。 |

**返回值：**

| 返回类型 | 描述                                                                                                                                                 |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| any      | 如果模块已经加载，则返回 package.loaded[modname] 中存储的值。否则，尝试查找加载器并返回 package.loaded[modname] 的最终值和加载器数据作为第二个结果。 |

### p

**类型：** 函数。

**描述：**

检查传递的值的内部结构，并打印值出它的字符串表示。

**签名：**

```lua
p: function(...: any)
```

**参数：**

| 参数名 | 类型 | 描述         |
| ------ | ---- | ------------ |
| ...    | any  | 要检查的值。 |

### options

**类型：** 成员变量。

**描述：**

当前编译器选项。

**签名：**

```lua
options: Config.Options
```

### traceback

**类型：** 函数。

**描述：**

重写堆栈跟踪中的行号为 YueScript 代码中的原始行号的 traceback 函数。

**签名：**

```lua
traceback: function(message: string): string
```

**参数：**

| 参数名  | 类型   | 描述           |
| ------- | ------ | -------------- |
| message | string | 堆栈跟踪消息。 |

**返回值：**

| 返回类型 | 描述                   |
| -------- | ---------------------- |
| string   | 重写后的堆栈跟踪消息。 |

### is_ast

**类型：** 函数。

**描述：**

检查代码是否匹配指定的 AST。

**签名：**

```lua
is_ast: function(astName: string, code: string): boolean
```

**参数：**

| 参数名  | 类型   | 描述       |
| ------- | ------ | ---------- |
| astName | string | AST 名称。 |
| code    | string | 代码。     |

**返回值：**

| 返回类型 | 描述               |
| -------- | ------------------ |
| boolean  | 代码是否匹配 AST。 |

### AST

**类型：** 成员变量。

**描述：**

AST 类型定义，带有名称、行、列和子节点。

**签名：**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**类型：** 函数。

**描述：**

将代码转换为 AST。

**签名：**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**参数：**

| 参数名         | 类型    | 描述                                                                           |
| -------------- | ------- | ------------------------------------------------------------------------------ |
| code           | string  | 代码。                                                                         |
| flattenLevel   | integer | [可选] 扁平化级别。级别越高，会消除更多的 AST 结构的嵌套。默认为 0。最大为 2。 |
| astName        | string  | [可选] AST 名称。默认为 "File"。                                               |
| reserveComment | boolean | [可选] 是否保留原始注释。默认为 false。                                        |

**返回值：**

| 返回类型      | 描述                             |
| ------------- | -------------------------------- |
| AST \| nil    | AST，如果转换失败则为 nil。      |
| string \| nil | 错误消息，如果转换成功则为 nil。 |

### format

**类型：** 函数。

**描述：**

格式化 YueScript 代码。

**签名：**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**参数：**

| 参数名         | 类型    | 描述                                   |
| -------------- | ------- | -------------------------------------- |
| code           | string  | 代码。                                 |
| tabSize        | integer | [可选] 制表符大小。默认为 4。          |
| reserveComment | boolean | [可选] 是否保留原始注释。默认为 true。 |

**返回值：**

| 返回类型 | 描述             |
| -------- | ---------------- |
| string   | 格式化后的代码。 |

### \_\_call

**类型：** 元方法。

**描述：**

导入 YueScript 模块。
如果发生加载失败，则将错误信息中的代码行号重写为 YueScript 代码中的原始行号。

**签名：**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**参数：**

| 参数名 | 类型   | 描述     |
| ------ | ------ | -------- |
| module | string | 模块名。 |

**返回值：**

| 返回类型 | 描述     |
| -------- | -------- |
| any      | 模块值。 |

## Config

**描述：**

编译器编译选项。

### lint_global

**类型：** 成员变量。

**描述：**

编译器是否应该收集代码中出现的全局变量。

**签名：**

```lua
lint_global: boolean
```

### implicit_return_root

**类型：** 成员变量。

**描述：**

编译器是否应该对根层级的代码块进行隐式的表达式返回。

**签名：**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**类型：** 成员变量。

**描述：**

编译器是否应该在编译后的代码中保留原始行号。

**签名：**

```lua
reserve_line_number: boolean
```

### reserve_comment

**类型：** 成员变量。

**描述：**

编译器是否应该在编译后的代码中保留原始注释。

**签名：**

```lua
reserve_comment: boolean
```

### space_over_tab

**类型：** 成员变量。

**描述：**

编译器是否应该在编译后的代码中使用空格字符而不是制表符字符。

**签名：**

```lua
space_over_tab: boolean
```

### same_module

**类型：** 成员变量。

**描述：**

编译器是否应该将要编译的代码视为当前正在编译的模块。仅供编译器内部使用。

**签名：**

```lua
same_module: boolean
```

### line_offset

**类型：** 成员变量。

**描述：**

编译器错误消息是否应该包含行号偏移量。仅供编译器内部使用。

**签名：**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**类型：** 枚举。

**描述：**

目标 Lua 版本枚举。

**签名：**

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

**类型：** 成员变量。

**描述：**

要传递给编译函数的额外选项。

**签名：**

```lua
options: Options
```

## Options

**描述：**

额外编译器选项定义。

### target

**类型：** 成员变量。

**描述：**

编译目标 Lua 版本。

**签名：**

```lua
target: LuaTarget
```

### path

**类型：** 成员变量。

**描述：**

额外模块搜索路径。

**签名：**

```lua
path: string
```

### dump_locals

**类型：** 成员变量。

**描述：**

是否在回溯错误消息中输出代码块的局部变量。默认为 false。

**签名：**

```lua
dump_locals: boolean
```

### simplified

**类型：** 成员变量。

**描述：**

是否简化输出的错误消息。默认为 true。

**签名：**

```lua
simplified: boolean
```
