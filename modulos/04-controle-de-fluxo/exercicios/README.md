# 🏋️ Exercícios — Módulo 04

Corrija com `./ferramentas/corrigir.ps1 04`. Soluções em [solucoes/](solucoes/).

### 01 — FizzBuzz · `01-fizzbuzz.ps1`
Recebe `[int]$N` e imprime de 1 a N (um por linha). Múltiplos de 3 → `Fizz`, de 5 → `Buzz`, de ambos → `FizzBuzz`.
```
PS> pwsh ./01-fizzbuzz.ps1 -N 5
1
2
Fizz
4
Buzz
```

### 02 — Classificar com switch · `02-classificar-arquivo.ps1`
Recebe `$Arquivo` (um nome) e imprime a categoria via `switch -Wildcard`: `*.jpg`/`*.png` → `imagem`, `*.ps1` → `script`, `*.txt`/`*.md` → `texto`, qualquer outro → `outro`.

### 03 — Somar via pipeline · `03-somar-pipeline.ps1`
Recebe `[int]$N` e imprime a soma de 1 a N usando `1..N | ForEach-Object` com um acumulador (não use a fórmula de Gauss). Ex.: `-N 10` → `55`.
