# 🏋️ Exercises — Module 06

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 06`. Solutions in [solucoes/](solucoes/).

### 01 — Build an object · `01-criar-objeto.ps1`
Receives `$Nome` and `[int]$Idade` and emits a `[PSCustomObject]` with the properties `Nome`, `Idade`, and `Maior` (`$true` if Idade ≥ 18). Print only the `Maior` property of the created object (`True`/`False`).
```
PS> pwsh ./01-criar-objeto.ps1 -Nome Ana -Idade 20   # -> True
```

### 02 — Reverse and join · `02-inverter-palavras.ps1`
Receives a sentence in `$Frase`, reverses the **word order**, and joins with a space. Use `-split` and `-join`.
```
PS> pwsh ./02-inverter-palavras.ps1 -Frase "o rato roeu"   # -> roeu rato o
```

### 03 — CSV total · `03-total-csv.ps1`
Receives a CSV path in `$Csv` (column `Valor`) and prints the **sum** of the values. Use `Import-Csv` and `Measure-Object -Sum`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
