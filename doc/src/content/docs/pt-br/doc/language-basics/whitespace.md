---
title: Espaço em branco
sidebar:
  order: 4
---

YueScript é uma linguagem sensível a espaço em branco. Você precisa escrever blocos de código na mesma indentação com espaço **' '** ou tabulação **'\t'**, como corpo de função, lista de valores e alguns blocos de controle. E expressões contendo diferentes espaços em branco podem significar coisas diferentes. Tabulação é tratada como 4 espaços, mas é melhor não misturar o uso de espaços e tabulações.

## Separador de instrução

Uma instrução normalmente termina em uma quebra de linha. Você também pode usar ponto e vírgula `;` para terminar explicitamente uma instrução, o que permite escrever múltiplas instruções na mesma linha:

```yuescript
a = 1; b = 2; print a + b
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
a = 1; b = 2; print a + b
```

</div>
</div>

## Encadeamento multilinha

Você pode escrever chamadas de função encadeadas em múltiplas linhas com a mesma indentação.

```yuescript
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

<div class="yue-example">
<button type="button" data-yue-compile>Compile</button>
<div hidden data-pagefind-ignore>

```yue
Rx.Observable
  .fromRange 1, 8
  \filter (x) -> x % 2 == 0
  \concat Rx.Observable.of 'who do we appreciate'
  \map (value) -> value .. '!'
  \subscribe print
```

</div>
</div>
