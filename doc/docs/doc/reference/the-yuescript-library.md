# The YueScript Library

Access it by `local yue = require("yue")` in Lua.

## yue

**Description:**

The YueScript language library.

### version

**Type:** Field.

**Description:**

The YueScript version.

**Signature:**

```lua
version: string
```

### dirsep

**Type:** Field.

**Description:**

The file separator for the current platform.

**Signature:**

```lua
dirsep: string
```

### yue_compiled

**Type:** Field.

**Description:**

The compiled module code cache.

**Signature:**

```lua
yue_compiled: {string: string}
```

### to_lua

**Type:** Function.

**Description:**

The YueScript compiling function. It compiles the YueScript code to Lua code.

**Signature:**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| code      | string | The YueScript code.              |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type                         | Description                                                                                                                   |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| string \| nil                       | The compiled Lua code, or nil if the compilation failed.                                                                      |
| string \| nil                       | The error message, or nil if the compilation succeeded.                                                                       |
| {{string, integer, integer}} \| nil | The global variables appearing in the code (with name, row and column), or nil if the compiler option `lint_global` is false. |

### file_exist

**Type:** Function.

**Description:**

The source file existence checking function. Can be overridden to customize the behavior.

**Signature:**

```lua
file_exist: function(filename: string): boolean
```

**Parameters:**

| Parameter | Type   | Description    |
| --------- | ------ | -------------- |
| filename  | string | The file name. |

**Returns:**

| Return Type | Description              |
| ----------- | ------------------------ |
| boolean     | Whether the file exists. |

### read_file

**Type:** Function.

**Description:**

The source file reading function. Can be overridden to customize the behavior.

**Signature:**

```lua
read_file: function(filename: string): string
```

**Parameters:**

| Parameter | Type   | Description    |
| --------- | ------ | -------------- |
| filename  | string | The file name. |

**Returns:**

| Return Type | Description       |
| ----------- | ----------------- |
| string      | The file content. |

### insert_loader

**Type:** Function.

**Description:**

Insert the YueScript loader to the package loaders (searchers).

**Signature:**

```lua
insert_loader: function(pos?: integer): boolean
```

**Parameters:**

| Parameter | Type    | Description                                                 |
| --------- | ------- | ----------------------------------------------------------- |
| pos       | integer | [Optional] The position to insert the loader. Default is 3. |

**Returns:**

| Return Type | Description                                                                                  |
| ----------- | -------------------------------------------------------------------------------------------- |
| boolean     | Whether the loader is inserted successfully. It will fail if the loader is already inserted. |

### remove_loader

**Type:** Function.

**Description:**

Remove the YueScript loader from the package loaders (searchers).

**Signature:**

```lua
remove_loader: function(): boolean
```

**Returns:**

| Return Type | Description                                                                             |
| ----------- | --------------------------------------------------------------------------------------- |
| boolean     | Whether the loader is removed successfully. It will fail if the loader is not inserted. |

### loadstring

**Type:** Function.

**Description:**

Loads YueScript code from a string into a function.

**Signature:**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| input     | string | The YueScript code.              |
| chunkname | string | The name of the code chunk.      |
| env       | table  | The environment table.           |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type     | Description                                         |
| --------------- | --------------------------------------------------- |
| function \| nil | The loaded function, or nil if the loading failed.  |
| string \| nil   | The error message, or nil if the loading succeeded. |

### loadstring

**Type:** Function.

**Description:**

Loads YueScript code from a string into a function.

**Signature:**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| input     | string | The YueScript code.              |
| chunkname | string | The name of the code chunk.      |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type     | Description                                         |
| --------------- | --------------------------------------------------- |
| function \| nil | The loaded function, or nil if the loading failed.  |
| string \| nil   | The error message, or nil if the loading succeeded. |

### loadstring

**Type:** Function.

**Description:**

Loads YueScript code from a string into a function.

**Signature:**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| input     | string | The YueScript code.              |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type     | Description                                         |
| --------------- | --------------------------------------------------- |
| function \| nil | The loaded function, or nil if the loading failed.  |
| string \| nil   | The error message, or nil if the loading succeeded. |

### loadfile

**Type:** Function.

**Description:**

Loads YueScript code from a file into a function.

**Signature:**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| filename  | string | The file name.                   |
| env       | table  | The environment table.           |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type     | Description                                         |
| --------------- | --------------------------------------------------- |
| function \| nil | The loaded function, or nil if the loading failed.  |
| string \| nil   | The error message, or nil if the loading succeeded. |

### loadfile

**Type:** Function.

**Description:**

Loads YueScript code from a file into a function.

**Signature:**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| filename  | string | The file name.                   |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type     | Description                                         |
| --------------- | --------------------------------------------------- |
| function \| nil | The loaded function, or nil if the loading failed.  |
| string \| nil   | The error message, or nil if the loading succeeded. |

### dofile

**Type:** Function.

**Description:**

Loads YueScript code from a file into a function and executes it.

**Signature:**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| filename  | string | The file name.                   |
| env       | table  | The environment table.           |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description                               |
| ----------- | ----------------------------------------- |
| any...      | The return values of the loaded function. |

### dofile

**Type:** Function.

**Description:**

Loads YueScript code from a file into a function and executes it.

**Signature:**

```lua
dofile: function(filename: string, config?: Config): any...
```

**Parameters:**

| Parameter | Type   | Description                      |
| --------- | ------ | -------------------------------- |
| filename  | string | The file name.                   |
| config    | Config | [Optional] The compiler options. |

**Returns:**

| Return Type | Description                               |
| ----------- | ----------------------------------------- |
| any...      | The return values of the loaded function. |

### find_modulepath

**Type:** Function.

**Description:**

Resolves the YueScript module name to the file path.

**Signature:**

```lua
find_modulepath: function(name: string): string
```

**Parameters:**

| Parameter | Type   | Description      |
| --------- | ------ | ---------------- |
| name      | string | The module name. |

**Returns:**

| Return Type | Description    |
| ----------- | -------------- |
| string      | The file path. |

### pcall

**Type:** Function.

**Description:**

Calls a function in protected mode.
Catches any errors and returns a status code and results or error object.
Rewrites the error line number to the original line number in the YueScript code when errors occur.

**Signature:**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**Parameters:**

| Parameter | Type     | Description                        |
| --------- | -------- | ---------------------------------- |
| f         | function | The function to call.              |
| ...       | any      | Arguments to pass to the function. |

**Returns:**

| Return Type  | Description                                       |
| ------------ | ------------------------------------------------- |
| boolean, ... | Status code and function results or error object. |

### require

**Type:** Function.

**Description:**

Loads a given module. Can be either a Lua module or a YueScript module.
Rewrites the error line number to the original line number in the YueScript code if the module is a YueScript module and loading fails.

**Signature:**

```lua
require: function(name: string): any...
```

**Parameters:**

| Parameter | Type   | Description                     |
| --------- | ------ | ------------------------------- |
| modname   | string | The name of the module to load. |

**Returns:**

| Return Type | Description                                                                                                                                                                                                |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| any         | The value stored at package.loaded[modname] if the module is already loaded.Otherwise, tries to find a loader and returns the final value of package.loaded[modname] and a loader data as a second result. |

### p

**Type:** Function.

**Description:**

Inspects the structures of the passed values and prints string representations.

**Signature:**

```lua
p: function(...: any)
```

**Parameters:**

| Parameter | Type | Description            |
| --------- | ---- | ---------------------- |
| ...       | any  | The values to inspect. |

### options

**Type:** Field.

**Description:**

The current compiler options.

**Signature:**

```lua
options: Config.Options
```

### traceback

**Type:** Function.

**Description:**

The traceback function that rewrites the stack trace line numbers to the original line numbers in the YueScript code.

**Signature:**

```lua
traceback: function(message: string): string
```

**Parameters:**

| Parameter | Type   | Description            |
| --------- | ------ | ---------------------- |
| message   | string | The traceback message. |

**Returns:**

| Return Type | Description                      |
| ----------- | -------------------------------- |
| string      | The rewritten traceback message. |

### is_ast

**Type:** Function.

**Description:**

Checks whether the code matches the specified AST.

**Signature:**

```lua
is_ast: function(astName: string, code: string): boolean
```

**Parameters:**

| Parameter | Type   | Description   |
| --------- | ------ | ------------- |
| astName   | string | The AST name. |
| code      | string | The code.     |

**Returns:**

| Return Type | Description                       |
| ----------- | --------------------------------- |
| boolean     | Whether the code matches the AST. |

### AST

**Type:** Field.

**Description:**

The AST type definition with name, row, column and sub nodes.

**Signature:**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**Type:** Function.

**Description:**

Converts the code to the AST.

**Signature:**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**Parameters:**

| Parameter      | Type    | Description                                                                                   |
| -------------- | ------- | --------------------------------------------------------------------------------------------- |
| code           | string  | The code.                                                                                     |
| flattenLevel   | integer | [Optional] The flatten level. Higher level means more flattening. Default is 0. Maximum is 2. |
| astName        | string  | [Optional] The AST name. Default is "File".                                                   |
| reserveComment | boolean | [Optional] Whether to reserve the original comments. Default is false.                        |

**Returns:**

| Return Type   | Description                                            |
| ------------- | ------------------------------------------------------ |
| AST \| nil    | The AST, or nil if the conversion failed.              |
| string \| nil | The error message, or nil if the conversion succeeded. |

### format

**Type:** Function.

**Description:**

Formats the YueScript code.

**Signature:**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**Parameters:**

| Parameter      | Type    | Description                                                           |
| -------------- | ------- | --------------------------------------------------------------------- |
| code           | string  | The code.                                                             |
| tabSize        | integer | [Optional] The tab size. Default is 4.                                |
| reserveComment | boolean | [Optional] Whether to reserve the original comments. Default is true. |

**Returns:**

| Return Type | Description         |
| ----------- | ------------------- |
| string      | The formatted code. |

### \_\_call

**Type:** Metamethod.

**Description:**

Requires the YueScript module.
Rewrites the error line number to the original line number in the YueScript code when loading fails.

**Signature:**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**Parameters:**

| Parameter | Type   | Description      |
| --------- | ------ | ---------------- |
| module    | string | The module name. |

**Returns:**

| Return Type | Description       |
| ----------- | ----------------- |
| any         | The module value. |

## Config

**Description:**

The compiler compile options.

### lint_global

**Type:** Field.

**Description:**

Whether the compiler should collect the global variables appearing in the code.

**Signature:**

```lua
lint_global: boolean
```

### implicit_return_root

**Type:** Field.

**Description:**

Whether the compiler should do an implicit return for the root code block.

**Signature:**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**Type:** Field.

**Description:**

Whether the compiler should reserve the original line number in the compiled code.

**Signature:**

```lua
reserve_line_number: boolean
```

### reserve_comment

**Type:** Field.

**Description:**

Whether the compiler should reserve the original comments in the compiled code.

**Signature:**

```lua
reserve_comment: boolean
```

### space_over_tab

**Type:** Field.

**Description:**

Whether the compiler should use the space character instead of the tab character in the compiled code.

**Signature:**

```lua
space_over_tab: boolean
```

### same_module

**Type:** Field.

**Description:**

Whether the compiler should treat the code to be compiled as the same currently being compiled module. For internal use only.

**Signature:**

```lua
same_module: boolean
```

### line_offset

**Type:** Field.

**Description:**

Whether the compiler error message should include the line number offset. For internal use only.

**Signature:**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**Type:** Enumeration.

**Description:**

The target Lua version enumeration.

**Signature:**

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

**Type:** Field.

**Description:**

The extra options to be passed to the compilation function.

**Signature:**

```lua
options: Options
```

## Options

**Description:**

The extra compiler options definition.

### target

**Type:** Field.

**Description:**

The target Lua version for the compilation.

**Signature:**

```lua
target: LuaTarget
```

### path

**Type:** Field.

**Description:**

The extra module search path.

**Signature:**

```lua
path: string
```

### dump_locals

**Type:** Field.

**Description:**

Whether to dump the local variables in the traceback error message. Default is false.

**Signature:**

```lua
dump_locals: boolean
```

### simplified

**Type:** Field.

**Description:**

Whether to simplify the error message. Default is true.

**Signature:**

```lua
simplified: boolean
```
