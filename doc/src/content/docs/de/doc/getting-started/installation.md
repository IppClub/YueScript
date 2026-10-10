---
title: Installation
sidebar:
  order: 2
---

## Lua-Modul

Installiere [luarocks](https://luarocks.org), einen Paketmanager für Lua-Module. Installiere YueScript dann als Lua-Modul und ausführbare Datei mit:

```shell
luarocks install yuescript
```

Oder du kannst die Datei `yue.so` bauen mit:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Anschließend findest du die Binärdatei unter **bin/shared/yue.so**.

## Binär-Tool bauen

Klone dieses Repo und baue/installiere die ausführbare Datei mit:

```shell
make install
```

YueScript-Tool ohne Makro-Feature bauen:

```shell
make install NO_MACRO=true
```

YueScript-Tool ohne eingebautes Lua-Binary bauen:

```shell
make install NO_LUA=true
```

## Vorgefertigtes Binary herunterladen

Du kannst vorkompilierte Binärdateien herunterladen, inklusive ausführbarer Dateien für unterschiedliche Lua-Versionen und Bibliotheksdateien.

Lade vorkompilierte Binärdateien von [hier](https://github.com/IppClub/YueScript/releases) herunter.
