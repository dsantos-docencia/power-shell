# 🏋️ Exercícios — Módulo 07

Corrija com `./ferramentas/corrigir.ps1 07`. Soluções em [solucoes/](solucoes/).

### 01 — Divisão segura · `01-divisao-segura.ps1`
Recebe `[double]$A` e `[double]$B`. Se `$B` for 0, imprima `erro: divisao por zero` e saia com código 1 (use `throw` + `try/catch`, ou um `if`). Senão, imprima `$A / $B`.
```
PS> pwsh ./01-divisao-segura.ps1 -A 10 -B 2   # -> 5
PS> pwsh ./01-divisao-segura.ps1 -A 10 -B 0   # -> erro: divisao por zero (exit 1)
```

### 02 — Validar com throw · `02-validar-idade.ps1`
Recebe `[int]$Idade`. Dentro de um `try`, lance (`throw`) se a idade for < 0 ou > 150. No `catch`, imprima `invalida` e saia com código 1. Se válida, imprima `ok`.

### 03 — Ler número com tratamento · `03-ler-numero.ps1`
Recebe `$Texto`. Tente converter para inteiro com `[int]::Parse($Texto)` dentro de um `try`. Se conseguir, imprima o dobro. Se falhar (capture `[System.FormatException]`), imprima `nao-e-numero` e saia com 1.
```
PS> pwsh ./03-ler-numero.ps1 -Texto 21    # -> 42
PS> pwsh ./03-ler-numero.ps1 -Texto abc   # -> nao-e-numero (exit 1)
```
