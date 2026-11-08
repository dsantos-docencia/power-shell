# 🚀 Practical Projects

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Here theory becomes a tool. Each project is a **complete, working** script, with commented code, error handling, and **automated tests** — exactly as you'd write it at work.

> Unlike the examples (which illustrate a concept), the projects solve a real problem end to end. Read the code, run it, break it, improve it.

## The projects

| # | Project | Concepts applied | Modules |
|---|---|---|---|
| 1 | [File inventory](01-inventario/README.en.md) | object pipeline, `Group-Object`, CSV/JSON | 02, 06 |
| 2 | [Cleanup of old files](02-limpeza/README.en.md) | `SupportsShouldProcess`, `-WhatIf`, idempotency | 04, 05 |
| 3 | [System health-check](03-health-check/README.en.md) | one object per check, overall status, JSON | 02, 06 |
| 4 | [Professional CLI](04-cli/README.en.md) | subcommands, `[ValidateSet]`, JSON persistence | 05, 06 |
| 5 | [Corporate module](05-modulo-corporativo/README.en.md) | `.psm1`/`.psd1`, `Export-ModuleMember`, Pester | 11 |

## Running and testing

Each project has its `README`, the main script, and a `testes/` folder with tests in the course's mini-framework (project 05 also ships **Pester** tests):

```powershell
# run a project
pwsh ./projetos/01-inventario/inventario.ps1 -Caminho ./alvo

# run all tests (includes projects and Pester)
pwsh ./ferramentas/verificar-tudo.ps1
```

All projects are **safe to run**: they operate in temporary directories or require you to point explicitly at the target, nothing deletes without explicit confirmation, and none touches the real network in the tests.

<sub>© 2026 Prof. Daniel Santos and translators · Code [PolyForm NC](../LICENSE) · Content [CC BY-NC-SA 4.0](../LICENSE-CONTEUDO.md)</sub>
