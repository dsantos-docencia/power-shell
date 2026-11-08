# 🪟 Windows PowerShell 5.1 vs. PowerShell 7+

**🌍 Idioma / Language:** [Português](ps5-vs-ps7.md) · **English**

The #1 confusion for beginners. They're **two different families**. See [Module 00](../modulos/00-introducao-paradigma/README.en.md).

## The essentials

| | **Windows PowerShell 5.1** | **PowerShell 7+** |
|---|---|---|
| Base | .NET Framework (Windows only) | .NET (Core) — cross-platform |
| Where it runs | Windows only | Windows, Linux, macOS |
| Executable | `powershell.exe` | `pwsh` |
| Pre-installed? | yes, on every Windows | no — installed separately |
| `$PSVersionTable.PSEdition` | `Desktop` | `Core` |
| Future | **in maintenance** (no new features) | **the present and the future** |

> 👉 **Learn and use 7+ (`pwsh`).** 5.1 still exists on older Windows servers; the course flags the differences where they matter.

## Features that exist only in 7+

| Feature | Note |
|---|---|
| `ForEach-Object -Parallel` | pipeline parallelism ([Module 09](../modulos/09-remoting-e-paralelismo/README.en.md)) |
| Ternary operator `? :` | `$x -gt 0 ? 'pos' : 'neg'` |
| `&&` and `\|\|` operators between commands | chain by success/failure, as in Bash |
| `??` and `??=` | null coalescing |
| Remoting over **SSH** | cross-platform, not just WinRM |
| `-Parallel`, `Test-Json`, `ConvertFrom-Json -AsHashtable` | various improvements |

## Differences that catch you

| Topic | 5.1 | 7+ |
|---|---|---|
| Default file encoding | UTF-16/ANSI (varies) | **UTF-8 (no BOM)** |
| `Get-WmiObject` | exists | **removed** → use `Get-CimInstance` ([Module 08](../modulos/08-dotnet-e-objetos/README.en.md)) |
| `Invoke-WebRequest` | uses the Internet Explorer engine | its own engine, faster |
| Windows modules (AD, etc.) | native | via a **compatibility** layer (`WindowsCompatibility`) |

> ⚠️ **Encoding is the classic gotcha.** In 5.1, `Out-File`/`>` write in UTF-16 by default, which breaks scripts on other systems. In 7+ the default is UTF-8 without BOM. When moving scripts between versions, declare the encoding explicitly: `Set-Content -Encoding utf8`.

## Running both side by side

You can have 5.1 and 7+ on the same Windows machine — they **coexist**. Open `powershell.exe` for 5.1 and `pwsh.exe` for 7+. To find out where you are:

```powershell
$PSVersionTable.PSVersion     # the number
$PSVersionTable.PSEdition     # Core (7+) or Desktop (5.1)
```

## And on Linux/macOS?

Only **7+** (`pwsh`) exists. There's no 5.1 outside Windows, and no `powershell.exe`. Providers like `HKLM:` (Registry) and `Cert:` also don't exist outside Windows ([Module 01](../modulos/01-navegacao-cmdlets/README.en.md)).

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
