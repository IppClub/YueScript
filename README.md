# YueScript

<table align="center">
  <tr>
    <td align="center" valign="middle" width="150" height="150">
      <img src="doc/docs/.vitepress/public/image/yuescript.png" alt="YueScript logo"/><br/>
    </td>
    <td valign="middle">
      <strong>A delightful language that compiles to Lua</strong><br/>
      <sub>Dynamic, expressive, and concise syntax for Lua development.</sub><br/>
      <sub>
        <a href="https://yuescript.org/doc">Docs</a> ·
        <a href="https://yuescript.org/try">Try Online</a> ·
        <a href="https://discord.gg/cRJ2VAm2NV">Discord</a>
      </sub>
    </td>
  </tr>
</table>

<p align="center">
  <img src="doc/docs/.vitepress/public/image/mascot/electrichearts_20260211A_yuescript_xiaoyu.png" width="360" alt="Xiaoyu, the YueScript mascot"/>
</p>

<p align="center">
  <sub><b>Xiaoyu (小玉)</b> · Official YueScript Mascot</sub>
</p>

[![IppClub](https://img.shields.io/badge/IppClub-Certified-11A7E2?logo=data%3Aimage%2Fsvg%2Bxml%3Bcharset%3Dutf-8%3Bbase64%2CPHN2ZyB2aWV3Qm94PSIwIDAgMjg4IDI3NCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWw6c3BhY2U9InByZXNlcnZlIiBzdHlsZT0iZmlsbC1ydWxlOmV2ZW5vZGQ7Y2xpcC1ydWxlOmV2ZW5vZGQ7c3Ryb2tlLWxpbmVqb2luOnJvdW5kO3N0cm9rZS1taXRlcmxpbWl0OjIiPjxwYXRoIGQ9Im0xNDYgMzEgNzIgNTVWMzFoLTcyWiIgc3R5bGU9ImZpbGw6I2Y2YTgwNjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0xNjkgODYtMjMtNTUgNzIgNTVoLTQ5WiIgc3R5bGU9ImZpbGw6I2VmN2EwMDtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Ik0yNiAzMXY1NWg4MEw4MSAzMUgyNloiIHN0eWxlPSJmaWxsOiMwN2ExN2M7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMTA4IDkydjExMmwzMS00OC0zMS02NFoiIHN0eWxlPSJmaWxsOiNkZTAwNWQ7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMCAyNzR2LTUyaDk3bC0zMyA1MkgwWiIgc3R5bGU9ImZpbGw6I2Y2YTgwNjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im03NyAyNzQgNjctMTA3djEwN0g3N1oiIHN0eWxlPSJmaWxsOiNkZjI0MzM7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMTUyIDI3NGgyOWwtMjktNTN2NTNaIiBzdHlsZT0iZmlsbDojMzM0ODVkO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTE5MSAyNzRoNzl2LTUySDE2N2wyNCA1MloiIHN0eWxlPSJmaWxsOiM0ZTI3NWE7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNMjg4IDEwMGgtMTdWODVoLTEzdjE1aC0xN3YxM2gxN3YxNmgxM3YtMTZoMTd2LTEzWiIgc3R5bGU9ImZpbGw6I2M1MTgxZjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0yNiA4NiA1Ni01NUgyNnY1NVoiIHN0eWxlPSJmaWxsOiMzMzQ4NWQ7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJNOTMgMzFoNDJsLTMwIDI5LTEyLTI5WiIgc3R5bGU9ImZpbGw6IzExYTdlMjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Ik0xNTggMTc2Vjg2bC0zNCAxNCAzNCA3NloiIHN0eWxlPSJmaWxsOiMwMDU5OGU7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJtMTA2IDU5IDQxLTEtMTItMjgtMjkgMjlaIiBzdHlsZT0iZmlsbDojMDU3Y2I3O2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0ibTEyNCAxMDAgMjItNDEgMTIgMjctMzQgMTRaIiBzdHlsZT0iZmlsbDojNGUyNzVhO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0ibTEwNiA2MCA0MS0xLTIzIDQxLTE4LTQwWiIgc3R5bGU9ImZpbGw6IzdiMTI4NTtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0xMDggMjA0IDMxLTQ4aC0zMXY0OFoiIHN0eWxlPSJmaWxsOiNiYTAwNzc7ZmlsbC1ydWxlOm5vbnplcm8iLz48cGF0aCBkPSJtNjUgMjc0IDMzLTUySDBsNjUgNTJaIiBzdHlsZT0iZmlsbDojZWY3YTAwO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTc3IDI3NGg2N2wtNDAtNDUtMjcgNDVaIiBzdHlsZT0iZmlsbDojYTgxZTI0O2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTE2NyAyMjJoNThsLTM0IDUyLTI0LTUyWiIgc3R5bGU9ImZpbGw6IzExYTdlMjtmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Im0yNzAgMjc0LTQ0LTUyLTM1IDUyaDc5WiIgc3R5bGU9ImZpbGw6IzA1N2NiNztmaWxsLXJ1bGU6bm9uemVybyIvPjxwYXRoIGQ9Ik0yNzUgNTVoLTU3VjBoMjV2MzFoMzJ2MjRaIiBzdHlsZT0iZmlsbDojZGUwMDVkO2ZpbGwtcnVsZTpub256ZXJvIi8%2BPHBhdGggZD0iTTE4NSAzMWg1N3Y1NWgtMjVWNTVoLTMyVjMxWiIgc3R5bGU9ImZpbGw6I2M1MTgxZjtmaWxsLXJ1bGU6bm9uemVybyIvPjwvc3ZnPg%3D%3D&labelColor=fff)](https://ippclub.org) [![Ubuntu](https://github.com/pigpigyyy/Yuescript/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/pigpigyyy/Yuescript/actions/workflows/ubuntu.yml) [![Windows](https://github.com/pigpigyyy/Yuescript/actions/workflows/windows.yml/badge.svg)](https://github.com/pigpigyyy/Yuescript/actions/workflows/windows.yml) [![macOS](https://github.com/pigpigyyy/Yuescript/actions/workflows/macos.yml/badge.svg)](https://github.com/pigpigyyy/Yuescript/actions/workflows/macos.yml) [![Discord Badge](https://img.shields.io/discord/844031511208001577?color=5865F2&label=Discord&logo=discord&logoColor=white&style=flat-square)](https://discord.gg/cRJ2VAm2NV)

YueScript is a language that compiles to Lua. It is derived from [MoonScript](https://github.com/leafo/moonscript) `0.5.0` and continues to adopt new features to stay up to date.

## Quick Links

- Website: <https://yuescript.org>
- Documentation: <https://yuescript.org/doc>
- Changelog: [`CHANGELOG.md`](./CHANGELOG.md)
- Discord: <https://discord.gg/cRJ2VAm2NV>

## Overview

MoonScript has been used to build real-world projects such as [Lapis](https://github.com/leafo/lapis), [itch.io](https://itch.io), and [streak.club](https://streak.club). MoonScript itself was also influenced by languages such as CoffeeScript. As the original implementation became harder to evolve without risking compatibility, YueScript was created as a modernized code base for pushing the language forward.

YueScript is both a production-ready compiler and a playground for exploring new syntax and programming paradigms that make Lua development more expressive and productive.

Yue (月) is the Chinese word for moon and is pronounced [jyɛ].

## About Dora SSR

YueScript is being developed and maintained alongside the open-source game engine [Dora SSR](https://github.com/ippclub/Dora-SSR). It has been used to create engine tools, game demos and prototypes, validating its capabilities in real-world scenarios while enhancing the Dora SSR development experience.

## Features

- Based on a modified [parserlib](https://github.com/axilmar/parserlib) with performance enhancements. `lpeg` is no longer required.
- Written in C++17.
- Supports most MoonScript features and generates Lua code in a style compatible with the original compiler.
- Preserves source line numbers in generated Lua to improve debugging.
- Adds features like macros, existential operator, pipe operator, JavaScript-like export syntax, and more.
- See [`CHANGELOG.md`](./CHANGELOG.md) for more details.

## Installation

### Lua Module

Build `yue.so` with:

```sh
> make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Then get the binary file from `bin/shared/yue.so`.

Or install via [LuaRocks](https://luarocks.org):

```sh
> luarocks install yuescript
```

Then require the YueScript module in Lua:

```lua
require("yue")("main") -- require `main.yue`

local yue = require("yue")
local codes, err, globals = yue.to_lua([[
f = -> print "hello world"
f!
]],{
  implicit_return_root = true,
  reserve_line_number = true,
  lint_global = true
})
```

### Binary Tool (CLI)

Clone this repo, then build and install executable with:

```sh
> make install
```

Build YueScript tool without macro feature:

```sh
> make install NO_MACRO=true
```

Build YueScript tool without built-in Lua binary:

```sh
> make install NO_LUA=true
```

Use YueScript tool with:

```sh
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

### Common Usage

- Recursively compile every YueScript file with extension `.yue` under current path: `yue .`
- Compile and save results to a target path: `yue -t /target/path/ .`
- Compile and reserve debug info: `yue -l .`
- Compile and generate minified codes: `yue -m .`
- Execute raw codes: `yue -e 'print 123'`
- Execute a YueScript file: `yue -e main.yue`

## Mascot (Xiaoyu / 小玉)

Xiaoyu (小玉) is YueScript's official mascot, a cyber rabbit often seen perched on a crescent moon and coding on a laptop.

- English page: [here](https://yuescript.org/doc/extras/mascot.html)
- Artwork by [Tyson Tan](https://tysontan.com)

## Editor Support

- [Vim](https://github.com/pigpigyyy/YueScript-vim)
- [ZeroBraneStudio](https://github.com/pkulchenko/ZeroBraneStudio/issues/1134) (Syntax highlighting)
- [Visual Studio Code](https://github.com/pigpigyyy/yuescript-vscode)

## License

MIT
