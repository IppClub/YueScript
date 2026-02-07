# Uso

## Módulo Lua

Use o módulo YueScript em Lua:

- **Caso 1**

  Use require em "your_yuescript_entry.yue" no Lua.

  ```Lua
  require("yue")("your_yuescript_entry")
  ```

  E esse código continua funcionando quando você compila "your_yuescript_entry.yue" para "your_yuescript_entry.lua" no mesmo caminho. Nos demais arquivos YueScript, use normalmente o **require** ou **import**. Os números de linha nas mensagens de erro também serão tratados corretamente.

- **Caso 2**

  Requerer o módulo YueScript e reescrever a mensagem manualmente.

  ```lua
  local yue = require("yue")
  yue.insert_loader()
  local success, result = xpcall(function()
    return require("yuescript_module_name")
  end, function(err)
    return yue.traceback(err)
  end)
  ```

- **Caso 3**

  Usar a função compiladora do YueScript em Lua.

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

## Ferramenta YueScript

Use a ferramenta YueScript com:

```shell
> yue -h
Usage: yue
       [options] [<file/directory>] ...
       yue -e <code_or_file> [args...]
       yue -w [<directory>] [options]
       yue -

Notas:
   - '-' / '--' deve ser o primeiro e único argumento.
   - '-o/--output' não pode ser usado com múltiplos arquivos de entrada.
   - '-w/--watch' não pode ser usado com entrada de arquivo (apenas diretório).
   - com '-e/--execute', os tokens restantes são tratados como argumentos do script.

Opções:
   -h, --help                 Mostrar esta mensagem de ajuda e sair.
   -e <str>, --execute <str>  Executar um arquivo ou código bruto
   -m, --minify               Gerar código minificado
   -r, --rewrite              Reescrever saída para corresponder aos números de linha originais
   -t <output_to>, --output-to <output_to>
                              Especificar onde colocar os arquivos compilados
   -o <file>, --output <file> Escrever saída em arquivo
   -p, --print                Escrever saída na saída padrão
   -b, --benchmark            Mostrar tempo de compilação (não grava saída)
   -g, --globals              Listar variáveis globais usadas em NOME LINHA COLUNA
   -s, --spaces               Usar espaços no código gerado em vez de tabulações
   -l, --line-numbers         Escrever números de linha do código fonte
   -j, --no-implicit-return   Desabilitar retorno implícito no final do arquivo
   -c, --reserve-comments     Preservar comentários antes de instruções do código fonte
   -w [<dir>], --watch [<dir>]
                              Observar alterações e compilar cada arquivo no diretório
   -v, --version              Imprimir versão
   -                          Ler da entrada padrão, imprimir na saída padrão
                              (Deve ser o primeiro e único argumento)
   --                         Igual a '-' (mantido para compatibilidade retroativa)

   --target <version>         Especificar a versão do Lua para a qual o código será gerado
                              (a versão pode ser apenas 5.1 a 5.5)
   --path <path_str>          Adicionar um caminho de busca Lua extra ao package.path
   --<key>=<value>            Passar opção do compilador no formato key=value (comportamento existente)

   Execute sem opções para entrar no REPL, digite o símbolo '$'
   em uma única linha para iniciar/parar o modo multilinha
```

Casos de uso:

Compilar recursivamente todos os arquivos YueScript com extensão **.yue** no caminho atual: **yue .**

Compilar e salvar resultados em um caminho de destino: **yue -t /target/path/ .**

Compilar e preservar informações de debug: **yue -l .**

Compilar e gerar código minificado: **yue -m .**

Executar código bruto: **yue -e 'print 123'**

Executar um arquivo YueScript: **yue -e main.yue**
