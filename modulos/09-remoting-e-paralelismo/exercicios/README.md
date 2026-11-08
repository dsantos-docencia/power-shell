# 🏋️ Exercícios — Módulo 09

Corrija com `./ferramentas/corrigir.ps1 09`. Soluções em [solucoes/](solucoes/).

### 01 — Quadrados em paralelo · `01-quadrados-paralelo.ps1`
Recebe `[int]$N` e imprime a **soma** dos quadrados de 1 a N, calculando cada quadrado com `ForEach-Object -Parallel`. Ex.: `-N 3` → `14` (1+4+9).
> Dica: `1..$N | ForEach-Object -Parallel { $_ * $_ } | Measure-Object -Sum` e imprima a `.Sum`.

### 02 — Job com retorno · `02-job-resultado.ps1`
Recebe `[int]$N`, inicia um **Job** que calcula `$N * 10` (use `$using:N`), espera e imprime o resultado recebido. Ex.: `-N 4` → `40`.

### 03 — Maior em paralelo · `03-maior-paralelo.ps1`
Recebe vários números **posicionais** (`param([Parameter(ValueFromRemainingArguments)][int[]]$Numeros)`) e imprime o **maior**, processando com `ForEach-Object -Parallel` e `Measure-Object -Maximum`.
```
PS> pwsh ./03-maior-paralelo.ps1 3 9 2 7   # -> 9
```
