# 🏋️ Exercícios — Módulo 03

Corrija com `./ferramentas/corrigir.ps1 03`. Soluções em [solucoes/](solucoes/).

### 01 — Saudação interpolada · `01-saudacao.ps1`
Recebe `$Nome` e imprime exatamente `Olá, NOME! (N letras)`, onde N é o número de caracteres do nome. Use interpolação com `$( )`.
```
PS> pwsh ./01-saudacao.ps1 -Nome Ana   # -> Olá, Ana! (3 letras)
```

### 02 — Validar CEP · `02-valida-cep.ps1`
Recebe `$Cep` e imprime `valido` se casar o formato `00000-000`, senão `invalido` (exit 1). Use `-match` com a regex `^\d{5}-\d{3}$`.

### 03 — Formatar preço · `03-formatar-preco.ps1`
Recebe `$Produto` e `[double]$Preco` e imprime, com o operador `-f`, uma linha: o produto alinhado à esquerda em 12 colunas, depois `R$ ` e o preço com 2 casas. Formato: `'{0,-12} R$ {1,8:N2}'`.
```
PS> pwsh ./03-formatar-preco.ps1 -Produto Mouse -Preco 79.9   # -> Mouse        R$    79,90
```
