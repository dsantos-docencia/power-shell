# 🏋️ Exercises — Module 05

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 05`. Solutions in [solucoes/](solucoes/).

### 01 — Converter with ValidateSet · `01-converter-temp.ps1`
Receives `[double]$Valor` and `$Para` (a parameter with `[ValidateSet('C','F')]`). Converts **from** one scale **to** the one given and prints the number rounded to 1 decimal:
- `-Para C` → received Fahrenheit, converts to Celsius: `(V - 32) * 5/9`
- `-Para F` → received Celsius, converts to Fahrenheit: `V * 9/5 + 32`
```
PS> pwsh ./01-converter-temp.ps1 -Valor 100 -Para F   # -> 212
PS> pwsh ./01-converter-temp.ps1 -Valor 32  -Para C   # -> 0
```

### 02 — Sum through the pipeline · `02-somar.ps1`
A function/script that accepts numbers **through the pipeline** (`ValueFromPipeline`) and, in the `end` block, prints the total sum. Use `begin/process/end`.
```
PS> 10, 20, 30 | pwsh ./02-somar.ps1   # -> 60
```

### 03 — Safe removal with -WhatIf · `03-remover-seguro.ps1`
Receives `[string]$Caminho` and removes the file, but with `SupportsShouldProcess`. With `-WhatIf`, it **must not** remove. Without `-WhatIf`, it removes and prints `removido`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
