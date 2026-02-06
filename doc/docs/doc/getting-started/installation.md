# Installation

## Lua Module

Install [luarocks](https://luarocks.org), a package manager for Lua modules. Then install it as a Lua module and executable with:

```shell
luarocks install yuescript
```

Or you can build `yue.so` file with:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Then get the binary file from path **bin/shared/yue.so**.

## Build Binary Tool

Clone this repo, then build and install executable with:

```shell
make install
```

Build YueScript tool without macro feature:

```shell
make install NO_MACRO=true
```

Build YueScript tool without built-in Lua binary:

```shell
make install NO_LUA=true
```

## Download Precompiled Binary

You can download precompiled binary files, including binary executable files compatible with different Lua versions and library files.

Download precompiled binary files from [here](https://github.com/IppClub/YueScript/releases).
