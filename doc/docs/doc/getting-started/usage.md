# Usage

## Lua Module

Use YueScript module in Lua:

* **Case 1**

	Require "your_yuescript_entry.yue" in Lua.
	```Lua
	require("yue")("your_yuescript_entry")
	```
	And this code still works when you compile "your_yuescript_entry.yue"  to "your_yuescript_entry.lua" in the same path. In the rest YueScript files just use the normal **require** or **import**. The code line numbers in error messages will also be handled correctly.

* **Case 2**

	Require YueScript module and rewite message by hand.

	```lua
	local yue = require("yue")
	yue.insert_loader()
	local success, result = xpcall(function()
	  return require("yuescript_module_name")
	end, function(err)
	  return yue.traceback(err)
	end)
	```

* **Case 3**

	Use the YueScript compiler function in Lua.

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

## YueScript Tool

Use YueScript tool with:

```shell
> yue -h
Usage: yue
       [options] [<file/directory>] ...
       yue -e <code_or_file> [args...]
       yue -w [<directory>] [options]
       yue -

Notes:
   - '-' / '--' must be the first and only argument.
   - '-o/--output' can not be used with multiple input files.
   - '-w/--watch' can not be used with file input (directory only).
   - with '-e/--execute', remaining tokens are treated as script args.

Options:
   -h, --help                 Show this help message and exit.
   -e <str>, --execute <str>  Execute a file or raw codes
   -m, --minify               Generate minified codes
   -r, --rewrite              Rewrite output to match original line numbers
   -t <output_to>, --output-to <output_to>
                              Specify where to place compiled files
   -o <file>, --output <file> Write output to file
   -p, --print                Write output to standard out
   -b, --benchmark            Dump compile time (doesn't write output)
   -g, --globals              Dump global variables used in NAME LINE COLUMN
   -s, --spaces               Use spaces in generated codes instead of tabs
   -l, --line-numbers         Write line numbers from source codes
   -j, --no-implicit-return   Disable implicit return at end of file
   -c, --reserve-comments     Reserve comments before statement from source codes
   -w [<dir>], --watch [<dir>]
                              Watch changes and compile every file under directory
   -v, --version              Print version
   -                          Read from standard in, print to standard out
                              (Must be first and only argument)
   --                         Same as '-' (kept for backward compatibility)

   --target <version>         Specify the Lua version that codes will be generated to
                              (version can only be 5.1 to 5.5)
   --path <path_str>          Append an extra Lua search path string to package.path
   --<key>=<value>            Pass compiler option in key=value form (existing behavior)

   Execute without options to enter REPL, type symbol '$'
   in a single line to start/stop multi-line mode
```
Use cases:

Recursively compile every YueScript file with extension **.yue** under current path:  **yue .**

Compile and save results to a target path:  **yue -t /target/path/ .**

Compile and reserve debug info:  **yue -l .**

Compile and generate minified codes:  **yue -m .**

Execute raw codes:  **yue -e 'print 123'**

Execute a YueScript file:  **yue -e main.yue**
