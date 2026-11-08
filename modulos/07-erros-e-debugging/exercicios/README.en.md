# 🏋️ Exercises — Module 07

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 07`. Solutions in [solucoes/](solucoes/).

### 01 — Safe division · `01-divisao-segura.ps1`
Receives `[double]$A` and `[double]$B`. If `$B` is 0, print `erro: divisao por zero` and exit with code 1 (use `throw` + `try/catch`, or an `if`). Otherwise, print `$A / $B`.
```
PS> pwsh ./01-divisao-segura.ps1 -A 10 -B 2   # -> 5
PS> pwsh ./01-divisao-segura.ps1 -A 10 -B 0   # -> erro: divisao por zero (exit 1)
```

### 02 — Validate with throw · `02-validar-idade.ps1`
Receives `[int]$Idade`. Inside a `try`, `throw` if the age is < 0 or > 150. In the `catch`, print `invalida` and exit with code 1. If valid, print `ok`.

### 03 — Read a number with handling · `03-ler-numero.ps1`
Receives `$Texto`. Try to convert it to an integer with `[int]::Parse($Texto)` inside a `try`. If it works, print the double. If it fails (catch `[System.FormatException]`), print `nao-e-numero` and exit with 1.
```
PS> pwsh ./03-ler-numero.ps1 -Texto 21    # -> 42
PS> pwsh ./03-ler-numero.ps1 -Texto abc   # -> nao-e-numero (exit 1)
```

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
