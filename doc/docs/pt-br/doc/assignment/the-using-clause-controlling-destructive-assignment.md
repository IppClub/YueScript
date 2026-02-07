# A cláusula Using; controlando atribuição destrutiva

Embora o escopo léxico possa ser uma grande ajuda na redução da complexidade do código que escrevemos, as coisas podem ficar difíceis de gerenciar conforme o tamanho do código aumenta. Considere o seguinte trecho:

```yuescript
i = 100

-- muitas linhas de código...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- vai imprimir 0
```

<YueDisplay>

```yue
i = 100

-- muitas linhas de código...

my_func = ->
  i = 10
  while i > 0
    print i
    i -= 1

my_func!

print i -- vai imprimir 0
```

</YueDisplay>

Em my_func, sobrescrevemos o valor de i por engano. Neste exemplo é bem óbvio, mas considere uma base de código grande ou estrangeira onde não está claro quais nomes já foram declarados.

Seria útil dizer quais variáveis do escopo envolvente pretendemos alterar, para evitar que alteremos outras por acidente.

A palavra-chave using nos permite fazer isso. using nil garante que nenhuma variável fechada seja sobrescrita na atribuição. A cláusula using é colocada após a lista de argumentos em uma função, ou no lugar dela se não houver argumentos.

```yuescript
i = 100

my_func = (using nil) ->
  i = "hello" -- uma nova variável local é criada aqui

my_func!
print i -- imprime 100, i não é afetado
```

<YueDisplay>

```yue
i = 100

my_func = (using nil) ->
  i = "hello" -- uma nova variável local é criada aqui

my_func!
print i -- imprime 100, i não é afetado
```

</YueDisplay>

Múltiplos nomes podem ser separados por vírgulas. Os valores do closure ainda podem ser acessados, apenas não podem ser modificados:

```yuescript
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- uma nova variável local tmp é criada
  i += tmp
  k += tmp

my_func(22)
print i, k -- estes foram atualizados
```

<YueDisplay>

```yue
tmp = 1213
i, k = 100, 50

my_func = (add using k, i) ->
  tmp = tmp + add -- uma nova variável local tmp é criada
  i += tmp
  k += tmp

my_func(22)
print i, k -- estes foram atualizados
```

</YueDisplay>
