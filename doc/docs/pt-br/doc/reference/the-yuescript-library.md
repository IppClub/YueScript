# A biblioteca YueScript

Acesse com `local yue = require("yue")` no Lua.

## yue

**Descrição:**

A biblioteca da linguagem YueScript.

### version

**Tipo:** Campo.

**Descrição:**

A versão do YueScript.

**Assinatura:**

```lua
version: string
```

### dirsep

**Tipo:** Campo.

**Descrição:**

O separador de arquivos da plataforma atual.

**Assinatura:**

```lua
dirsep: string
```

### yue_compiled

**Tipo:** Campo.

**Descrição:**

O cache de código de módulo compilado.

**Assinatura:**

```lua
yue_compiled: {string: string}
```

### to_lua

**Tipo:** Função.

**Descrição:**

A função de compilação do YueScript. Compila o código YueScript para código Lua.

**Assinatura:**

```lua
to_lua: function(code: string, config?: Config):
    --[[codes]] string | nil,
    --[[error]] string | nil,
    --[[globals]] {{string, integer, integer}} | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| code      | string | O código YueScript.                 |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno                     | Descrição                                                                                                                        |
| ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| string \| nil                       | O código Lua compilado, ou nil se a compilação falhou.                                                                           |
| string \| nil                       | A mensagem de erro, ou nil se a compilação foi bem-sucedida.                                                                     |
| {{string, integer, integer}} \| nil | As variáveis globais que aparecem no código (com nome, linha e coluna), ou nil se a opção do compilador `lint_global` for false. |

### file_exist

**Tipo:** Função.

**Descrição:**

Função de verificação de existência do arquivo fonte. Pode ser sobrescrita para personalizar o comportamento.

**Assinatura:**

```lua
file_exist: function(filename: string): boolean
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição          |
| --------- | ------ | ------------------ |
| filename  | string | O nome do arquivo. |

**Retorna:**

| Tipo de Retorno | Descrição            |
| --------------- | -------------------- |
| boolean         | Se o arquivo existe. |

### read_file

**Tipo:** Função.

**Descrição:**

Função de leitura do arquivo fonte. Pode ser sobrescrita para personalizar o comportamento.

**Assinatura:**

```lua
read_file: function(filename: string): string
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição          |
| --------- | ------ | ------------------ |
| filename  | string | O nome do arquivo. |

**Retorna:**

| Tipo de Retorno | Descrição              |
| --------------- | ---------------------- |
| string          | O conteúdo do arquivo. |

### insert_loader

**Tipo:** Função.

**Descrição:**

Insere o carregador YueScript nos carregadores de pacote (searchers).

**Assinatura:**

```lua
insert_loader: function(pos?: integer): boolean
```

**Parâmetros:**

| Parâmetro | Tipo    | Descrição                                                   |
| --------- | ------- | ----------------------------------------------------------- |
| pos       | integer | [Opcional] A posição para inserir o carregador. Padrão é 3. |

**Retorna:**

| Tipo de Retorno | Descrição                                                                              |
| --------------- | -------------------------------------------------------------------------------------- |
| boolean         | Se o carregador foi inserido com sucesso. Falhará se o carregador já estiver inserido. |

### remove_loader

**Tipo:** Função.

**Descrição:**

Remove o carregador YueScript dos carregadores de pacote (searchers).

**Assinatura:**

```lua
remove_loader: function(): boolean
```

**Retorna:**

| Tipo de Retorno | Descrição                                                                               |
| --------------- | --------------------------------------------------------------------------------------- |
| boolean         | Se o carregador foi removido com sucesso. Falhará se o carregador não estiver inserido. |

### loadstring

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de uma string em uma função.

**Assinatura:**

```lua
loadstring: function(input: string, chunkname: string, env: table, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| input     | string | O código YueScript.                 |
| chunkname | string | O nome do chunk de código.          |
| env       | table  | A tabela de ambiente.               |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadstring

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de uma string em uma função.

**Assinatura:**

```lua
loadstring: function(input: string, chunkname: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| input     | string | O código YueScript.                 |
| chunkname | string | O nome do chunk de código.          |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadstring

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de uma string em uma função.

**Assinatura:**

```lua
loadstring: function(input: string, config?: Config):
    --[[loaded function]] nil | function(...: any): (any...),
    --[[error]] string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| input     | string | O código YueScript.                 |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadfile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função.

**Assinatura:**

```lua
loadfile: function(filename: string, env: table, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| env       | table  | A tabela de ambiente.               |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### loadfile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função.

**Assinatura:**

```lua
loadfile: function(filename: string, config?: Config):
    nil | function(...: any): (any...),
    string | nil
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| function \| nil | A função carregada, ou nil se o carregamento falhou.           |
| string \| nil   | A mensagem de erro, ou nil se o carregamento foi bem-sucedido. |

### dofile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função e o executa.

**Assinatura:**

```lua
dofile: function(filename: string, env: table, config?: Config): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| env       | table  | A tabela de ambiente.               |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                  |
| --------------- | ------------------------------------------ |
| any...          | Os valores de retorno da função carregada. |

### dofile

**Tipo:** Função.

**Descrição:**

Carrega código YueScript de um arquivo em uma função e o executa.

**Assinatura:**

```lua
dofile: function(filename: string, config?: Config): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                           |
| --------- | ------ | ----------------------------------- |
| filename  | string | O nome do arquivo.                  |
| config    | Config | [Opcional] As opções do compilador. |

**Retorna:**

| Tipo de Retorno | Descrição                                  |
| --------------- | ------------------------------------------ |
| any...          | Os valores de retorno da função carregada. |

### find_modulepath

**Tipo:** Função.

**Descrição:**

Resolve o nome do módulo YueScript para o caminho do arquivo.

**Assinatura:**

```lua
find_modulepath: function(name: string): string
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição         |
| --------- | ------ | ----------------- |
| name      | string | O nome do módulo. |

**Retorna:**

| Tipo de Retorno | Descrição             |
| --------------- | --------------------- |
| string          | O caminho do arquivo. |

### pcall

**Tipo:** Função.

**Descrição:**

Chama uma função em modo protegido.
Captura quaisquer erros e retorna um código de status e resultados ou objeto de erro.
Reescreve o número da linha do erro para o número da linha original no código YueScript quando ocorrem erros.

**Assinatura:**

```lua
pcall: function(f: function, ...: any): boolean, any...
```

**Parâmetros:**

| Parâmetro | Tipo     | Descrição                          |
| --------- | -------- | ---------------------------------- |
| f         | function | A função a chamar.                 |
| ...       | any      | Argumentos a passar para a função. |

**Retorna:**

| Tipo de Retorno | Descrição                                                  |
| --------------- | ---------------------------------------------------------- |
| boolean, ...    | Código de status e resultados da função ou objeto de erro. |

### require

**Tipo:** Função.

**Descrição:**

Carrega um módulo dado. Pode ser um módulo Lua ou um módulo YueScript.
Reescreve o número da linha do erro para o número da linha original no código YueScript se o módulo for um módulo YueScript e o carregamento falhar.

**Assinatura:**

```lua
require: function(name: string): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                    |
| --------- | ------ | ---------------------------- |
| modname   | string | O nome do módulo a carregar. |

**Retorna:**

| Tipo de Retorno | Descrição                                                                                                                                                                                                                         |
| --------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| any             | O valor armazenado em package.loaded[modname] se o módulo já estiver carregado. Caso contrário, tenta encontrar um carregador e retorna o valor final de package.loaded[modname] e os dados do carregador como segundo resultado. |

### p

**Tipo:** Função.

**Descrição:**

Inspeciona as estruturas dos valores passados e imprime representações em string.

**Assinatura:**

```lua
p: function(...: any)
```

**Parâmetros:**

| Parâmetro | Tipo | Descrição                 |
| --------- | ---- | ------------------------- |
| ...       | any  | Os valores a inspecionar. |

### options

**Tipo:** Campo.

**Descrição:**

As opções atuais do compilador.

**Assinatura:**

```lua
options: Config.Options
```

### traceback

**Tipo:** Função.

**Descrição:**

A função traceback que reescreve os números das linhas do stack trace para os números das linhas originais no código YueScript.

**Assinatura:**

```lua
traceback: function(message: string): string
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição                |
| --------- | ------ | ------------------------ |
| message   | string | A mensagem de traceback. |

**Retorna:**

| Tipo de Retorno | Descrição                          |
| --------------- | ---------------------------------- |
| string          | A mensagem de traceback reescrita. |

### is_ast

**Tipo:** Função.

**Descrição:**

Verifica se o código corresponde ao AST especificado.

**Assinatura:**

```lua
is_ast: function(astName: string, code: string): boolean
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição      |
| --------- | ------ | -------------- |
| astName   | string | O nome do AST. |
| code      | string | O código.      |

**Retorna:**

| Tipo de Retorno | Descrição                       |
| --------------- | ------------------------------- |
| boolean         | Se o código corresponde ao AST. |

### AST

**Tipo:** Campo.

**Descrição:**

A definição do tipo AST com nome, linha, coluna e subnós.

**Assinatura:**

```lua
type AST = {string, integer, integer, any}
```

### to_ast

**Tipo:** Função.

**Descrição:**

Converte o código para o AST.

**Assinatura:**

```lua
to_ast: function(code: string, flattenLevel?: number, astName?: string, reserveComment?: boolean):
    --[[AST]] AST | nil,
    --[[error]] nil | string
```

**Parâmetros:**

| Parâmetro      | Tipo    | Descrição                                                                                              |
| -------------- | ------- | ------------------------------------------------------------------------------------------------------ |
| code           | string  | O código.                                                                                              |
| flattenLevel   | integer | [Opcional] O nível de achatamento. Nível mais alto significa mais achatamento. Padrão é 0. Máximo é 2. |
| astName        | string  | [Opcional] O nome do AST. Padrão é "File".                                                             |
| reserveComment | boolean | [Opcional] Se deve preservar os comentários originais. Padrão é false.                                 |

**Retorna:**

| Tipo de Retorno | Descrição                                                   |
| --------------- | ----------------------------------------------------------- |
| AST \| nil      | O AST, ou nil se a conversão falhou.                        |
| string \| nil   | A mensagem de erro, ou nil se a conversão foi bem-sucedida. |

### format

**Tipo:** Função.

**Descrição:**

Formata o código YueScript.

**Assinatura:**

```lua
format: function(code: string, tabSize?: number, reserveComment?: boolean): string
```

**Parâmetros:**

| Parâmetro      | Tipo    | Descrição                                                             |
| -------------- | ------- | --------------------------------------------------------------------- |
| code           | string  | O código.                                                             |
| tabSize        | integer | [Opcional] O tamanho da tabulação. Padrão é 4.                        |
| reserveComment | boolean | [Opcional] Se deve preservar os comentários originais. Padrão é true. |

**Retorna:**

| Tipo de Retorno | Descrição           |
| --------------- | ------------------- |
| string          | O código formatado. |

### \_\_call

**Tipo:** Metamétodo.

**Descrição:**

Requer o módulo YueScript.
Reescreve o número da linha do erro para o número da linha original no código YueScript quando o carregamento falha.

**Assinatura:**

```lua
metamethod __call: function(self: yue, module: string): any...
```

**Parâmetros:**

| Parâmetro | Tipo   | Descrição         |
| --------- | ------ | ----------------- |
| module    | string | O nome do módulo. |

**Retorna:**

| Tipo de Retorno | Descrição          |
| --------------- | ------------------ |
| any             | O valor do módulo. |

## Config

**Descrição:**

As opções de compilação do compilador.

### lint_global

**Tipo:** Campo.

**Descrição:**

Se o compilador deve coletar as variáveis globais que aparecem no código.

**Assinatura:**

```lua
lint_global: boolean
```

### implicit_return_root

**Tipo:** Campo.

**Descrição:**

Se o compilador deve fazer retorno implícito para o bloco de código raiz.

**Assinatura:**

```lua
implicit_return_root: boolean
```

### reserve_line_number

**Tipo:** Campo.

**Descrição:**

Se o compilador deve preservar o número da linha original no código compilado.

**Assinatura:**

```lua
reserve_line_number: boolean
```

### reserve_comment

**Tipo:** Campo.

**Descrição:**

Se o compilador deve preservar os comentários originais no código compilado.

**Assinatura:**

```lua
reserve_comment: boolean
```

### space_over_tab

**Tipo:** Campo.

**Descrição:**

Se o compilador deve usar o caractere de espaço em vez do caractere de tabulação no código compilado.

**Assinatura:**

```lua
space_over_tab: boolean
```

### same_module

**Tipo:** Campo.

**Descrição:**

Se o compilador deve tratar o código a ser compilado como o mesmo módulo que está sendo compilado atualmente. Apenas para uso interno.

**Assinatura:**

```lua
same_module: boolean
```

### line_offset

**Tipo:** Campo.

**Descrição:**

Se a mensagem de erro do compilador deve incluir o deslocamento do número da linha. Apenas para uso interno.

**Assinatura:**

```lua
line_offset: integer
```

### yue.Config.LuaTarget

**Tipo:** Enumeração.

**Descrição:**

A enumeração da versão alvo do Lua.

**Assinatura:**

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

**Tipo:** Campo.

**Descrição:**

As opções extras a serem passadas para a função de compilação.

**Assinatura:**

```lua
options: Options
```

## Options

**Descrição:**

A definição das opções extras do compilador.

### target

**Tipo:** Campo.

**Descrição:**

A versão alvo do Lua para a compilação.

**Assinatura:**

```lua
target: LuaTarget
```

### path

**Tipo:** Campo.

**Descrição:**

O caminho de busca de módulo extra.

**Assinatura:**

```lua
path: string
```

### dump_locals

**Tipo:** Campo.

**Descrição:**

Se deve incluir as variáveis locais na mensagem de erro do traceback. Padrão é false.

**Assinatura:**

```lua
dump_locals: boolean
```

### simplified

**Tipo:** Campo.

**Descrição:**

Se deve simplificar a mensagem de erro. Padrão é true.

**Assinatura:**

```lua
simplified: boolean
```
