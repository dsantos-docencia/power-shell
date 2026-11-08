# 🏋️ Exercises — Module 02

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs/formats below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 02`. Solutions in [solucoes/](solucoes/).

### 01 — Largest by extension · `01-maiores-log.ps1`
Receives a directory in `$Caminho` and prints the **names** of its `.log` files, from **largest to smallest** (one per line, name only). Hint: `Where-Object`, `Sort-Object Length -Descending`, `Select-Object -ExpandProperty Name`.

### 02 — Sum by key · `02-total-por-vendedor.ps1`
Receives a CSV path in `$Csv` (columns `Vendedor,Valor`) and prints, **in alphabetical order of seller**, one line per seller in the format `NAME: TOTAL` (sum of the values). Hint: `Import-Csv`, `Group-Object`, `Measure-Object -Sum`.

### 03 — Calculated property · `03-tamanho-kb.ps1`
Receives a directory in `$Caminho` and prints the **name and the size in KB** (rounded to 1 decimal) of each file, in the format `name=KB`, sorted by descending size. Hint: calculated property `@{Name=...;Expression={...}}` and `[math]::Round(.../1kb,1)`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
