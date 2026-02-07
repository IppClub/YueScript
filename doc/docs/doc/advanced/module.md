# Module

## Import

The import statement is a syntax sugar for requiring a module or help extracting items from an imported module. The imported items are const by default.

```yuescript
-- used as table destructuring
do
  import insert, concat from table
  -- report error when assigning to insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- shortcut for implicit requiring
  import x, y, z from 'mymodule'
  -- import with Python style
  from 'module' import a, b, c

-- shortcut for requring a module
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requring module with aliasing or table destructuring
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

<YueDisplay>

```yue
-- used as table destructuring
do
  import insert, concat from table
  -- report error when assigning to insert, concat
  import C, Ct, Cmt from require "lpeg"
  -- shortcut for implicit requiring
  import x, y, z from 'mymodule'
  -- import with Python style
  from 'module' import a, b, c

-- shortcut for requring a module
do
  import 'module'
  import 'module_x'
  import "d-a-s-h-e-s"
  import "module.part"

-- requring module with aliasing or table destructuring
do
  import "player" as PlayerModule
  import "lpeg" as :C, :Ct, :Cmt
  import "export" as {one, two, Something:{umm:{ch}}}
```

</YueDisplay>

## Import Global

You can import specific globals into local variables with `import`. When importing a chain of global variable accessings, the last field will be assigned to the local variable.

```yuescript
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

<YueDisplay>

```yue
do
  import tostring
  import table.concat
  print concat ["a", tostring 1]
```

</YueDisplay>

### Automatic Global Variable Import

You can place `import global` at the top of a block to automatically import all names that have not been explicitly declared or assigned in the current scope as globals. These implicit imports are treated as local consts that reference the corresponding globals at the position of the statement.

Names that are explicitly declared as globals in the same scope will not be imported, so you can still assign to them.

```yuescript
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- error: imported globals are const

do
  -- explicit global variable will not be imported
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

<YueDisplay>

```yue
do
  import global
  print "hello"
  math.random 3
  -- print = nil -- error: imported globals are const

do
  -- explicit global variable will not be imported
  import global
  global FLAG
  print FLAG
  FLAG = 123
```

</YueDisplay>

## Export

The export statement offers a concise way to define modules.

### Named Export

Named export will define a local variable as well as adding a field in the exported table.

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

<YueDisplay>

```yue
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

</YueDisplay>

Doing named export with destructuring.

```yuescript
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

<YueDisplay>

```yue
export :loadstring, to_lua: tolua = yue
export {itemA: {:fieldA = 'default'}} = tb
```

</YueDisplay>

Export named items from module without creating local variables.

```yuescript
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

<YueDisplay>

```yue
export.itemA = tb
export.<index> = items
export["a-b-c"] = 123
```

</YueDisplay>

### Unnamed Export

Unnamed export will add the target item into the array part of the exported table.

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

<YueDisplay>

```yue
d, e, f = 3, 2, 1
export d, e, f

export if this
  123
else
  456

export with tmp
  j = 2000
```

</YueDisplay>

### Default Export

Using the **default** keyword in export statement to replace the exported table with any thing.

```yuescript
export default ->
  print "hello"
  123
```

<YueDisplay>

```yue
export default ->
  print "hello"
  123
```

</YueDisplay>
