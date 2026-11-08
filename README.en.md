<div align="center">

# 🪟 PowerShell from Zero to Enterprise Automation

### An open, practical, verifiable PowerShell course — from the terminal to DevOps, on Windows and cross-platform

*Free and open educational material — for noncommercial use.*

**🌍 Idioma / Language:** [Português](README.md) · **English**

[![Code license: PolyForm NC](https://img.shields.io/badge/code-PolyForm%20NC-orange.svg)](LICENSE)
[![Content license: CC BY-NC-SA 4.0](https://img.shields.io/badge/content-CC%20BY--NC--SA%204.0-lightgrey.svg)](LICENSE-CONTEUDO.md)
[![Checks](https://github.com/dsantos-docencia/power-shell/actions/workflows/verificar.yml/badge.svg)](https://github.com/dsantos-docencia/power-shell/actions)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## 👋 Welcome

Hi! I'm **Professor Daniel Santos** — developer, technology service provider, and teacher of technical IT and cybersecurity courses. I work with infrastructure, automation, and systems administration every day, and I teach what I do.

This repository is the sibling of my [Bash course](https://github.com/dsantos-docencia/Bash) — same philosophy, different world. Because PowerShell **is not "Bash for Windows"**: it's a paradigm shift. While Bash passes **text** between commands, PowerShell passes **.NET objects** — with properties and methods. Getting that is the "click" that separates people who memorize commands from people who truly automate.

The approach is the same as always: every concept comes with **the why**, every example **actually runs** (an automated pipeline verifies this on every change, with PSScriptAnalyzer and Pester), and every exercise has **automated grading**.

It's free and open (for noncommercial use). If it helps you, leave a ⭐ and, if you can, [contribute](CONTRIBUTING.md).

> *"In Bash you think in text. In PowerShell, you think in objects. Once that clicks, you never look at automation the same way again."* — Prof. Daniel

> **Note on this translation:** the course is being translated from Brazilian Portuguese. The landing page is in English; module content is being translated with community help — [come help translate!](traducoes/README.md)

---

## 🗺️ Learning path

Each module has **theory** (`README.md`), **runnable commented examples** (`exemplos/`), and **auto-graded exercises** (`exercicios/`).

| # | Module | What you master | Hours |
|---|---|---|---|
| 00 | [Intro & the New Paradigm](modulos/00-introducao-paradigma/) | Object vs. text, history (Monad), 5.1 vs. 7+, install, ExecutionPolicy | 4–6 |
| 01 | [Navigation & Cmdlets](modulos/01-navegacao-cmdlets/) | Verb-Noun, `Get-Help`, `Get-Command`, providers (PSDrives), aliases | 5–7 |
| 02 | [The Object Pipeline](modulos/02-pipeline-objetos/) | `Get-Member`, `Where/Select/Sort/Group`, formatting, export | 8–10 |
| 03 | [Scripting & Variables](modulos/03-scripting-variaveis/) | `$PROFILE`, types, operators, output streams (the "Write-Host rule") | 6–8 |
| 04 | [Control Flow](modulos/04-controle-de-fluxo/) | `if`, supercharged `switch`, loops, `foreach` vs. `ForEach-Object` | 8–10 |
| 05 | [Functions & Toolmaking](modulos/05-funcoes-toolmaking/) | `[CmdletBinding()]`, advanced parameters, `begin/process/end`, `-WhatIf` | 8–10 |
| 06 | [Data & Objects](modulos/06-dados-e-objetos/) | Arrays, hashtables, `[PSCustomObject]`, strings, JSON/CSV/XML | 8–10 |
| 07 | [Errors & Debugging](modulos/07-erros-e-debugging/) | Terminating vs. non-terminating, `try/catch`, `$ErrorActionPreference`, breakpoints | 6–8 |
| 08 | [Objects & .NET](modulos/08-dotnet-e-objetos/) | `[PSCustomObject]`, `class`/`enum`, calling .NET directly, `Add-Type` | 6–8 |
| 09 | [Remoting & Parallelism](modulos/09-remoting-e-paralelismo/) | Remoting (WinRM/SSH), jobs, `ForEach-Object -Parallel`, runspaces, scheduling | 8–12 |
| 10 | [Testing, Security & DevOps](modulos/10-testes-seguranca-devops/) | PSScriptAnalyzer, Pester, code signing, CLM, JEA, Git | 8–10 |
| 11 | [Modules & Distribution](modulos/11-modulos-e-distribuicao/) | `.psm1`/`.psd1`, PowerShell Gallery, PSResourceGet | 6–8 |

🚀 **Hands-on projects**: [projetos/](projetos/). 📚 **Quick reference**: [referencia/](referencia/) — including a **Bash → PowerShell translation guide**.

---

## 🚦 Getting started

```powershell
git clone https://github.com/dsantos-docencia/power-shell.git
cd power-shell
pwsh ./modulos/00-introducao-paradigma/exemplos/01-objeto-vs-texto.ps1
./ferramentas/corrigir.ps1 00        # grade module 00's exercises
```

---

## 🤝 Contributing & License

**Join me and leave something useful for the next person.** 🌱 See the [contribution guide](CONTRIBUTING.en.md), submit a script via the **"📜 Submit a script"** issue, or [help translate](traducoes/README.md).

Created and maintained by **Prof. Daniel Santos**. Open for **noncommercial use**: code under [PolyForm Noncommercial 1.0.0](LICENSE), content under [CC BY-NC-SA 4.0](LICENSE-CONTEUDO.md). Commercial use requires the author's permission — see the [NOTICE](NOTICE.md).

<div align="center">
<sub>Made with care for those who want to <b>understand</b>, not just copy. · © 2026 Daniel Santos</sub>
</div>
