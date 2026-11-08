# 🏋️ Exercises — Module 11

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Grade with `./ferramentas/corrigir.ps1 11`. Solutions in [solucoes/](solucoes/).
Theme: the details that separate "a script" from **a distributable package**.

### 01 — Qualified command · `01-comando-qualificado.ps1`
Receives `[string]$Modulo` and `[string]$Comando` and prints the fully qualified name `Modulo\Comando` — the way to disambiguate when two modules export the same command. E.g.: `Pester` + `Invoke-Pester` → `Pester\Invoke-Pester`.
> Hint: the backslash `\` in a double-quoted string needs care; remember that `$` interpolates.

### 02 — Next minor · `02-proxima-minor.ps1`
Receives a semver `"MAJOR.MINOR.PATCH"` and returns the **next MINOR, resetting the patch**. E.g.: `"1.4.7"` → `"1.5.0"`.
> Hint: `Split('.')`, increment index 1, and force the patch to `0`. Bumping minor **always** resets the patch — that's what makes updates predictable.

### 03 — Sorted exports · `03-ordenar-exports.ps1`
Receives comma-separated function names and prints them **sorted** alphabetically, joined by `", "` — a readable, review-friendly `FunctionsToExport`. E.g.: `"Get-B,Set-A,Get-A"` → `"Get-A, Get-B, Set-A"`.
> Hint: `Split(',')`, `Trim()` each, `Sort-Object`, and `-join ', '`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
