# 📦 Project 01 — File Inventory

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Scans a folder and turns each file into an **object** (name, extension, size, date), producing a report on screen, in **CSV**, or **JSON**. It's the object pipeline of [Modules 02](../../modulos/02-pipeline-objetos/README.en.md) and [06](../../modulos/06-dados-e-objetos/README.en.md) solving a real administration problem.

## How to use

```powershell
pwsh ./inventario.ps1 -Caminho ./alvo                      # table + summary
pwsh ./inventario.ps1 -Caminho ./alvo -Formato csv  -Saida relatorio.csv
pwsh ./inventario.ps1 -Caminho ./alvo -Formato json -Saida relatorio.json
pwsh ./inventario.ps1 -Caminho ./alvo -Resumo              # one line, for CI
```

## Concepts applied

- `Get-ChildItem -Recurse -File` and projection into `[PSCustomObject]`
- `Measure-Object -Sum`, `Group-Object`, `Sort-Object`
- Export with `Export-Csv` and `ConvertTo-Json`
- Validated parameters (`[ValidateSet]`), `-Resumo` as a switch

## Tests

```powershell
pwsh ./ferramentas/verificar-tudo.ps1   # includes the project tests
```

<sub>© 2026 Prof. Daniel Santos and translators · Code [PolyForm NC](../../LICENSE) · Content [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
