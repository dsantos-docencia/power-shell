# 🏋️ Exercícios — Módulo 05

Corrija com `./ferramentas/corrigir.ps1 05`. Soluções em [solucoes/](solucoes/).

### 01 — Conversor com ValidateSet · `01-converter-temp.ps1`
Recebe `[double]$Valor` e `$Para` (parâmetro com `[ValidateSet('C','F')]`). Converte **de** a outra escala **para** a indicada e imprime o número arredondado a 1 casa:
- `-Para C` → recebeu Fahrenheit, converte para Celsius: `(V - 32) * 5/9`
- `-Para F` → recebeu Celsius, converte para Fahrenheit: `V * 9/5 + 32`
```
PS> pwsh ./01-converter-temp.ps1 -Valor 100 -Para F   # -> 212
PS> pwsh ./01-converter-temp.ps1 -Valor 32  -Para C   # -> 0
```

### 02 — Soma pelo pipeline · `02-somar.ps1`
Função/script que aceita números **pelo pipeline** (`ValueFromPipeline`) e, no `end`, imprime a soma total. Use `begin/process/end`.
```
PS> 10, 20, 30 | pwsh ./02-somar.ps1   # -> 60
```

### 03 — Remoção segura com -WhatIf · `03-remover-seguro.ps1`
Recebe `[string]$Caminho` e remove o arquivo, mas com `SupportsShouldProcess`. Com `-WhatIf`, **não** pode remover. Sem `-WhatIf`, remove e imprime `removido`.
