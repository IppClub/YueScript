---
title: Instalasi
sidebar:
  order: 2
---

## Modul Lua

Instal [luarocks](https://luarocks.org), manajer paket untuk modul Lua. Lalu instal sebagai modul Lua dan executable dengan:

```shell
luarocks install yuescript
```

Atau Anda dapat membangun file `yue.so` dengan:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Lalu ambil file biner dari path **bin/shared/yue.so**.

## Membangun Tool Biner

Klon repo ini, lalu bangun dan instal executable dengan:

```shell
make install
```

Bangun tool YueScript tanpa fitur macro:

```shell
make install NO_MACRO=true
```

Bangun tool YueScript tanpa biner Lua bawaan:

```shell
make install NO_LUA=true
```

## Unduh Biner Pra-kompilasi

Anda dapat mengunduh file biner pra-kompilasi, termasuk file executable biner yang kompatibel dengan berbagai versi Lua dan file library.

Unduh file biner pra-kompilasi dari [sini](https://github.com/IppClub/YueScript/releases).
