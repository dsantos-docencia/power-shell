# Module 10 — Testing, Security, and Best Practices (DevOps)

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"Raising a script to production-code level: analyzed, tested, secure, and versioned."*

**Suggested load:** 8–10 h · **Level:** advanced · **Prerequisite:** [Module 09](../09-remoting-e-paralelismo/README.en.md)

## 🎯 Objectives

- Analyze code with **PSScriptAnalyzer** (the official linter)
- Write automated tests with **Pester** (the standard framework)
- Understand code signing, **Constrained Language Mode**, and **JEA**
- Handle credentials securely (`Get-Credential`, `SecureString`)
- Integrate with Git

---

## 1. PSScriptAnalyzer — the official linter

Analyzes your code statically and flags bugs and bad practices — without running anything. It's the equivalent of Bash's ShellCheck.

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser    # install (once)
Invoke-ScriptAnalyzer -Path .\meu-script.ps1          # analyze
Invoke-ScriptAnalyzer -Path . -Recurse                # the whole folder
Invoke-ScriptAnalyzer -Path .\x.ps1 -Fix              # auto-fixes what it can
```

Examples of what it catches:
| Rule | Catches |
|---|---|
| `PSAvoidUsingCmdletAliases` | `ls`/`gci` instead of `Get-ChildItem` |
| `PSUseDeclaredVarsMoreThanAssignments` | variable assigned and never used |
| `PSAvoidUsingPlainTextForPassword` | plain-text password |
| `PSUseShouldProcessForStateChangingFunctions` | `Remove-*`/`Set-*` without `-WhatIf` |
| `PSUseSingularNouns` | plural noun in the name |

> 💡 **This repository** runs PSScriptAnalyzer on **every** `.ps1` via CI, with a [settings file](../../PSScriptAnalyzerSettings.psd1) that documents which rules are excluded and why. Integrate it with **VS Code** (the PowerShell extension already uses the analyzer) to see the warnings as you type.

### Silencing a rule (with justification)
```powershell
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '',
    Justification = 'Colored console interface; not data output.')]
param()
```

---

## 2. Pester — automated tests

[Pester](https://pester.dev) is the standard **BDD** framework for testing PowerShell. Tests live in `*.Tests.ps1` files.

```powershell
Install-Module Pester -Scope CurrentUser -SkipPublisherCheck   # install
Invoke-Pester                                                  # runs the *.Tests.ps1
```

Anatomy of a test:
```powershell
BeforeAll {
    . $PSScriptRoot/calculadora.ps1    # loads what you're going to test
}

Describe 'Somar' {
    It 'adds two positives' {
        Somar -A 2 -B 3 | Should -Be 5
    }
    It 'throws on invalid input' {
        { Somar -A 'x' -B 3 } | Should -Throw
    }
}
```

| Block / command | Does |
|---|---|
| `Describe` / `Context` | groups tests |
| `It` | one test case |
| `Should -Be` / `-BeExactly` | equality assertion |
| `Should -Throw` | expects an exception |
| `Should -Contain` / `-Match` | collection / regex |
| `BeforeAll` / `BeforeEach` | setup |
| `Mock` | replaces a cmdlet (isolates dependencies) |

> 💡 **Mock** is Pester's superpower: you replace `Get-Service`, `Invoke-RestMethod`, etc. with a fake version, to test your logic **without** depending on real services. Tests become fast and deterministic. See [`exemplos/calculadora.Tests.ps1`](exemplos/calculadora.Tests.ps1) — it runs in this repository's verification.

> This course uses its own mini-framework to grade the exercises (zero install), but **Pester is what you use at work** — and it's genuinely tested here.

---

## 3. Security and hardening

### Code signing
```powershell
# Signs a script with a certificate (guarantees authorship and integrity):
Set-AuthenticodeSignature -FilePath .\x.ps1 -Certificate $cert
```
Combined with the ExecutionPolicy `AllSigned`/`RemoteSigned` (Module 00), it prevents tampered scripts from running.

### Constrained Language Mode (CLM)
Restricts PowerShell to a safe subset (blocks arbitrary .NET calls, `Add-Type`, etc.). Used in locked-down environments, together with AppLocker/WDAC. It's a **real** barrier — unlike the ExecutionPolicy.

### JEA — Just Enough Administration
Lets you delegate administrative tasks **without** granting full access. An operator can restart a specific service via a JEA session, without being a machine admin. Least-privilege principle applied to remoting.

### Credentials — never in plain text
```powershell
$cred = Get-Credential                          # securely asks for username/password
$cred.UserName                                  # the user
# $cred.Password is a SecureString (not plain text in ordinary memory)

# NEVER do: $senha = 'MyPassword123'   (plain text in the script = a leak)
```

> ⚠️ **`SecureString` is not strong encryption** — it's in-memory obfuscation, reversible by anyone with access to the process. For real secrets, use a vault: the **`Microsoft.PowerShell.SecretManagement`** module + a backend (Azure Key Vault, etc.). Never commit passwords; this repository's secret scanning (see [`SECURITY.md`](../../SECURITY.md)) helps block that.

---

## 4. Git and DevOps

PowerShell fits into the DevOps flow: scripts versioned in Git, analyzed (PSScriptAnalyzer), and tested (Pester) by a CI pipeline — exactly as this repository does with [GitHub Actions](../../.github/workflows/verificar.yml).

```powershell
git add . ; git commit -m "feat: new inventory script"
# the CI runs PSScriptAnalyzer + Pester automatically on the PR
```

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [calculadora.ps1](exemplos/calculadora.ps1) | A tool with validation (the tests' target) |
| [calculadora.Tests.ps1](exemplos/calculadora.Tests.ps1) | **Real Pester tests** (they run in the verification) |
| [01-analise-estatica.ps1](exemplos/01-analise-estatica.ps1) | Running PSScriptAnalyzer and seeing what it catches |
| [02-credenciais.ps1](exemplos/02-credenciais.ps1) | `SecureString`/`PSCredential` without exposing secrets |

> Run the Pester tests with: `Invoke-Pester modulos/10-testes-seguranca-devops/exemplos`

## ⚠️ Module pitfalls

- Ignoring PSScriptAnalyzer warnings "because it works"
- Testing only the happy path (test errors and edges too)
- Plain-text password in the script (use `Get-Credential`/vault)
- Trusting `SecureString` as if it were strong encryption

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 10`.

## ✅ Mastery checklist

- [ ] I run PSScriptAnalyzer and understand/fix the warnings
- [ ] I write Pester tests with `Describe`/`It`/`Should`
- [ ] I know what code signing, CLM, and JEA are
- [ ] I handle credentials with `Get-Credential`/vault, never plain text
- [ ] I understand the Git + CI flow (analyzer + Pester)

---

⬅️ [Module 09](../09-remoting-e-paralelismo/README.en.md) · ➡️ [Module 11 — Modules and Distribution](../11-modulos-e-distribuicao/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
