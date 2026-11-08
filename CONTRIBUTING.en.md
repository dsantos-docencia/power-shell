# 🤝 Contribution Guide

**Join me and leave something useful for the next person.** 🌱 Knowledge that isn't shared dies with whoever keeps it. Bug fixes, new examples, exercises, translations, community scripts, and text improvements are all welcome.

*(Português: [CONTRIBUTING.md](CONTRIBUTING.md))*

## Ways to contribute

| I want to… | How |
|---|---|
| **Fix a bug** | ["🐛 Bug" issue](https://github.com/dsantos-docencia/power-shell/issues/new/choose) or a direct PR |
| **Suggest an example/exercise** | ["💡 Suggestion" issue](https://github.com/dsantos-docencia/power-shell/issues/new/choose) |
| **Share a script of mine** | ["📜 Submit a script" issue](https://github.com/dsantos-docencia/power-shell/issues/new/choose) → goes into [`scripts/comunidade/`](scripts/comunidade/) with your credit |
| **Translate** | see the [translation guide](traducoes/README.md) |

> **On the license:** by contributing, you agree your contribution is published under the project's licenses (**noncommercial** — PolyForm Noncommercial for code, CC BY-NC-SA for content; see the [NOTICE](NOTICE.md)), keeping your credit.

## Before you start

This repo has a promise: **all code here works**. Run the check locally before opening a PR:

```powershell
./ferramentas/verificar-tudo.ps1
```

It runs, for every `.ps1`/`.psm1` (outside `scripts/`): **syntax** (parser), **PSScriptAnalyzer**, **execution** of examples, **official solutions** against the tests, **Pester** (if present), and **project tests**. Install the tools once:

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
Install-Module Pester -Scope CurrentUser -SkipPublisherCheck
```

## File conventions

Mirror the existing structure (modules have `README.md` + `exemplos/` + `exercicios/` with `solucoes/` and `testes/`). Every `.ps1` carries the standard comment-based header, examples must **run without arguments and without hanging** and must **not alter the system** (use `New-TemporaryFile` + `try/finally`), comments explain the **why**, and there should be **zero PSScriptAnalyzer warnings**. Prefer `Write-Output` for data; `Write-Host` only for console UI (the "Write-Host rule" is covered in Module 03).

### Writing a test
Every `Teste-*` function in a `.Testes.ps1` file is discovered and run in isolation. Assertions are documented in [`ferramentas/lib/Teste.psm1`](ferramentas/lib/Teste.psm1):

```powershell
function Teste-ShortDescription {
    Invoke-Alvo arg1 arg2
    Afirmar-Status 0
    Afirmar-Igual "expected" $global:SAIDA
}
```

We use our own mini-framework for grading (zero install). **Pester** — the industry standard — is taught in [Module 10](modulos/10-testes-seguranca-devops/).

## PowerShell style

Full cmdlet names (no aliases in scripts) · Verb-Noun · `Set-StrictMode -Version Latest` and `$ErrorActionPreference = 'Stop'` in serious scripts · `[CmdletBinding()]` with typed parameters · `Write-Output`/`Write-Verbose` for data, `Write-Host` only for UI · `-WhatIf`/`-Confirm` on anything that changes state.

## Code of conduct

Be kind. See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

<sub>© 2026 Prof. Daniel Santos</sub>
