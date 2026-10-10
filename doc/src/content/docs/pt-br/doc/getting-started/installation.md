---
title: Instalação
sidebar:
  order: 2
---

## Módulo Lua

Instale o [luarocks](https://luarocks.org), um gerenciador de pacotes para módulos Lua. Em seguida, instale-o como módulo Lua e executável com:

```shell
luarocks install yuescript
```

Ou você pode compilar o arquivo `yue.so` com:

```shell
make shared LUAI=/usr/local/include/lua LUAL=/usr/local/lib/lua
```

Depois, obtenha o arquivo binário no caminho **bin/shared/yue.so**.

## Compilar ferramenta binária

Clone este repositório e compile e instale o executável com:

```shell
make install
```

Compilar a ferramenta YueScript sem o recurso de macro:

```shell
make install NO_MACRO=true
```

Compilar a ferramenta YueScript sem o binário Lua embutido:

```shell
make install NO_LUA=true
```

## Baixar binário pré-compilado

Você pode baixar arquivos binários pré-compilados, incluindo executáveis compatíveis com diferentes versões do Lua e arquivos de biblioteca.

Baixe os arquivos binários pré-compilados [aqui](https://github.com/IppClub/YueScript/releases).
