# 🩺 Project 03 — System Health-Check

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Runs a battery of checks (disk, processes, uptime) and returns **one object per check** with status `OK` / `ATENCAO` / `FALHA`, plus an overall status. Because they're objects and not text ([Modules 02](../../modulos/02-pipeline-objetos/README.en.md) and [06](../../modulos/06-dados-e-objetos/README.en.md)), you can filter, export to JSON, and plug into an alert. (The status labels stay in Portuguese — they're what the tests check.)

## How to use

```powershell
pwsh ./health-check.ps1                    # table + overall status
pwsh ./health-check.ps1 -Json              # JSON for monitoring
pwsh ./health-check.ps1 -LimiteDiscoPct 85 # adjusts the disk threshold
```

## Concepts applied

- The **"each check is a `[PSCustomObject]`"** pattern with a status
- `Get-PSDrive`, `Get-Process`, aggregation, and "the worst status wins"
- `ConvertTo-Json -Depth` for integration with alerting tools
- Portable: uses only cross-platform cmdlets (runs on Linux, macOS, and Windows)

## Tests

```powershell
pwsh ./ferramentas/verificar-tudo.ps1
```

<sub>© 2026 Prof. Daniel Santos and translators · Code [PolyForm NC](../../LICENSE) · Content [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
