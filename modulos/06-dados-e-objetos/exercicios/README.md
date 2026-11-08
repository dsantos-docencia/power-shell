# 🏋️ Exercícios — Módulo 06

Corrija com `./ferramentas/corrigir.ps1 06`. Soluções em [solucoes/](solucoes/).

### 01 — Montar objeto · `01-criar-objeto.ps1`
Recebe `$Nome` e `[int]$Idade` e emite um `[PSCustomObject]` com as propriedades `Nome`, `Idade` e `Maior` (`$true` se Idade ≥ 18). Imprima só a propriedade `Maior` do objeto criado (`True`/`False`).
```
PS> pwsh ./01-criar-objeto.ps1 -Nome Ana -Idade 20   # -> True
```

### 02 — Inverter e juntar · `02-inverter-palavras.ps1`
Recebe uma frase em `$Frase`, inverte a **ordem das palavras** e junta com espaço. Use `-split` e `-join`.
```
PS> pwsh ./02-inverter-palavras.ps1 -Frase "o rato roeu"   # -> roeu rato o
```

### 03 — Total do CSV · `03-total-csv.ps1`
Recebe o caminho de um CSV em `$Csv` (coluna `Valor`) e imprime a **soma** dos valores. Use `Import-Csv` e `Measure-Object -Sum`.
