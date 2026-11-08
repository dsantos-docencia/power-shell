# 🏢 Project 05 — Corporate Module

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

The capstone of [Module 11](../../modulos/11-modulos-e-distribuicao/README.en.md): a **truly packaged** module — `Iconne.Infra` — with a `.psm1`, a `.psd1` manifest, public functions, and one encapsulated private function, ready for `Import-Module` in any in-house script. It ships with complete **Pester** tests.

## Structure

```
05-modulo-corporativo/
├── Iconne.Infra/
│   ├── Iconne.Infra.psm1    # code: 3 public functions + 1 private
│   └── Iconne.Infra.psd1    # manifest (version, author, exports)
├── demo.ps1                 # imports and uses the module
└── Iconne.Infra.Tests.ps1   # Pester tests (10 cases)
```

## How to use

```powershell
Import-Module ./Iconne.Infra/Iconne.Infra.psd1
Convert-ParaTamanhoLegivel -Bytes 1048576   # "1.0 MB"
Test-NomeRecurso -Nome 'srv-web01'          # True
New-IdRecurso -Prefixo 'vm'                 # "vm-a1b2c3"

pwsh ./demo.ps1                              # full demonstration
Invoke-Pester ./Iconne.Infra.Tests.ps1       # runs the module's tests
```

## Concepts applied

- `.psm1` module + `.psd1` manifest generated with `New-ModuleManifest`
- `Export-ModuleMember` exposing **only** what's public (the helper stays private)
- `[OutputType]`, comment-based help (`.SYNOPSIS`/`.EXAMPLE`) on each function
- **Pester** suite covering success, error, and encapsulation

## Tests

```powershell
pwsh ./ferramentas/verificar-tudo.ps1   # Pester + the course grader
```

<sub>© 2026 Prof. Daniel Santos and translators · Code [PolyForm NC](../../LICENSE) · Content [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
