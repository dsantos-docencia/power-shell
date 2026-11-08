# 🏋️ Exercises — Module 01

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 01`. Solutions in [solucoes/](solucoes/).

### 01 — Count by type · `01-contar-tipos.ps1`
Receives a directory in `$Caminho` and prints **two lines**, exactly:
```
arquivos: N
diretorios: M
```
N = number of files and M = number of directories **inside** it (recursive). Hint: `Get-ChildItem -Recurse -File` and `-Directory`.

### 02 — Resolve alias · `02-resolver-alias.ps1`
Receives an alias in `$Alias` and prints the **cmdlet name** it points to (e.g., `gci` → `Get-ChildItem`). If it's not an alias, print `nao-e-alias` and exit with code 1. Hint: `Get-Alias`.

### 03 — Largest file · `03-maior-arquivo.ps1`
Receives a directory in `$Caminho` and prints **only the name** of the largest file (recursive). Hint: `Sort-Object Length -Descending | Select-Object -First 1`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
