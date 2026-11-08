# 🏋️ Exercises — Module 09

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Grade with `./ferramentas/corrigir.ps1 09`. Solutions in [solucoes/](solucoes/).

### 01 — Squares in parallel · `01-quadrados-paralelo.ps1`
Receives `[int]$N` and prints the **sum** of the squares from 1 to N, computing each square with `ForEach-Object -Parallel`. E.g.: `-N 3` → `14` (1+4+9).
> Hint: `1..$N | ForEach-Object -Parallel { $_ * $_ } | Measure-Object -Sum` and print the `.Sum`.

### 02 — Job with return · `02-job-resultado.ps1`
Receives `[int]$N`, starts a **Job** that computes `$N * 10` (use `$using:N`), waits, and prints the received result. E.g.: `-N 4` → `40`.

### 03 — Max in parallel · `03-maior-paralelo.ps1`
Receives several **positional** numbers (`param([Parameter(ValueFromRemainingArguments)][int[]]$Numeros)`) and prints the **largest**, processing with `ForEach-Object -Parallel` and `Measure-Object -Maximum`.
```
PS> pwsh ./03-maior-paralelo.ps1 3 9 2 7   # -> 9
```

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
