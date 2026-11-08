# Module 11 — Modules and Distribution

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"A script solves your problem today. A module solves everyone's problem, forever."*

**Suggested load:** 6–8 h · **Level:** advanced · **Prerequisite:** [Module 10](../10-testes-seguranca-devops/README.en.md)

## 🎯 Objectives

- Turn a set of functions into a **module** (`.psm1`)
- Write a **manifest** (`.psd1`) with version, author, dependencies, and exports
- Understand `Export-ModuleMember` and why to **export only what's public**
- Learn **PSResourceGet** (`Find`/`Install`/`Publish-PSResource`) and the **PowerShell Gallery**
- Version with **SemVer** and organize the repository for publishing

---

## 1. From script to module

A **module** is just a folder with a `.psm1` file (the code) and, ideally, a `.psd1` (the manifest, the "metadata"). The folder, `.psm1`, and `.psd1` names must be **the same**:

```
MinhaFerramenta/
├── MinhaFerramenta.psm1     # the functions
└── MinhaFerramenta.psd1     # the manifest (version, author, exports...)
```

Inside the `.psm1`, you define functions normally and at the end decide what stays **public**:

```powershell
function Get-Saudacao { param([string]$Nome) "Hello, $Nome!" }
function Format-Interno { param($x) $x }   # private helper

Export-ModuleMember -Function Get-Saudacao   # only this one becomes public
```

> 💡 **Golden rule of toolmaking:** export the minimum. Helper functions (`Format-Interno`) stay out. Whoever installs your module sees a clean interface — and you can refactor the rest without breaking anyone.

To load it:

```powershell
Import-Module ./MinhaFerramenta/MinhaFerramenta.psd1
Get-Saudacao -Nome "Daniel"     # Hello, Daniel!
Get-Command -Module MinhaFerramenta   # lists only what was exported
```

---

## 2. The manifest (`.psd1`)

The manifest is a **hashtable** with the module's metadata. You don't write it by hand — you generate it with `New-ModuleManifest`:

```powershell
New-ModuleManifest -Path ./MinhaFerramenta/MinhaFerramenta.psd1 `
    -RootModule       'MinhaFerramenta.psm1' `
    -ModuleVersion    '1.0.0' `
    -Author           'Daniel Santos' `
    -Description      'Greeting tools' `
    -FunctionsToExport @('Get-Saudacao') `
    -PowerShellVersion '7.0'
```

| Field | What it's for |
|---|---|
| `RootModule` | which `.psm1` to load |
| `ModuleVersion` | the **SemVer** version (see section 4) |
| `FunctionsToExport` | **explicit** list of what's public (no `'*'`) |
| `RequiredModules` | dependencies the engine installs/loads alongside |
| `PowerShellVersion` | minimum required version |
| `PrivateData.PSData.Tags` | keywords for the Gallery to find it |

Always validate before publishing:

```powershell
Test-ModuleManifest ./MinhaFerramenta/MinhaFerramenta.psd1
```

> ⚠️ `FunctionsToExport = '*'` looks handy, but it disables the command-discovery optimization and **leaks** private helpers. List the names, one by one. The manifest is a **contract** with whoever uses your module.

---

## 3. Publishing: PSResourceGet and the PowerShell Gallery

The **PowerShell Gallery** (`powershellgallery.com`) is the public repository — the "npm/PyPI" of PowerShell. The modern module for talking to it is **`Microsoft.PowerShell.PSResourceGet`** (successor to the old `PowerShellGet`):

```powershell
# discover and install
Find-PSResource Pester                     # searches the Gallery
Install-PSResource Pester -Scope CurrentUser

# publish (needs an API key from your Gallery account)
Publish-PSResource -Path ./MinhaFerramenta -ApiKey $env:NUGET_KEY
```

| Old verb (`PowerShellGet`) | New verb (`PSResourceGet`) |
|---|---|
| `Find-Module` | `Find-PSResource` |
| `Install-Module` | `Install-PSResource` |
| `Publish-Module` | `Publish-PSResource` |
| `Update-Module` | `Update-PSResource` |

> 💡 You can also host a **private repository** (NuGet, Azure Artifacts, GitHub Packages) and register it with `Register-PSResourceRepository` — useful for internal company modules that don't go to the public Gallery.

---

## 4. Versioning (SemVer)

The Gallery and `Update-PSResource` depend on well-behaved versions. Use **SemVer** `MAJOR.MINOR.PATCH`:

| Change | What to increment |
|---|---|
| Compatible fix (bug fix) | **PATCH** → `1.2.3` → `1.2.4` |
| Compatible new feature | **MINOR** → `1.2.3` → `1.3.0` (resets the patch) |
| Breaking change | **MAJOR** → `1.2.3` → `2.0.0` (resets minor and patch) |

> In [Module 10](../10-testes-seguranca-devops/README.en.md) you automated the **patch** bump in a release step. Here the discipline completes: **bumping minor resets the patch**, bumping major resets both. Predictability is what lets your users update with confidence.

---

## 🧪 Examples

Run each one with `pwsh ./exemplos/<file>.ps1`:

1. **`01-construir-modulo.ps1`** — creates a module folder with a `.psm1`, imports it, and calls the public function (and shows that the private one does **not** appear).
2. **`02-manifesto.ps1`** — generates a `.psd1` with `New-ModuleManifest` and validates it with `Test-ModuleManifest`.
3. **`03-publicar-conceitual.ps1`** — narrated walkthrough of `Find`/`Install`/`Publish-PSResource` (without actually publishing — you see the exact commands).

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 11`.

## ✅ Mastery checklist

- [ ] I turn a set of functions into a `.psm1` and import it
- [ ] I export **only what's public** with `Export-ModuleMember`/`FunctionsToExport`
- [ ] I generate and validate a manifest with `New-ModuleManifest` + `Test-ModuleManifest`
- [ ] I know how to use `Find`/`Install`/`Publish-PSResource` (PSResourceGet)
- [ ] I apply SemVer correctly (patch, minor resets patch, major resets both)

---

🎓 **You've reached the end of the track.** From the first `Get-Command` to the published module, you've been through all of PowerShell. The next step is the best of all: **build something**, share it with the community, and [contribute to the course](../../CONTRIBUTING.en.md). *Don't let the knowledge die with you.*

---

⬅️ [Module 10](../10-testes-seguranca-devops/README.en.md) · 🏠 [Home](../../README.en.md) · 🚀 [Projects](../../projetos/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
