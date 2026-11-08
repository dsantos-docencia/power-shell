# 🔁 Automatic variables

**🌍 Idioma / Language:** [Português](variaveis-automaticas.md) · **English**

These are variables that **PowerShell itself fills in** — you read them, you don't create them. See [Module 03](../modulos/03-scripting-variaveis/README.en.md).

## The most used day to day

| Variable | Is |
|---|---|
| `$_` / `$PSItem` | the **current** object in the pipeline (inside `Where-Object`/`ForEach-Object`) |
| `$?` | did the **last** command succeed? (`$true`/`$false`) |
| `$LASTEXITCODE` | exit code of the last **external program** (e.g., `git`) |
| `$Error` | array of the session's errors; `$Error[0]` is the most recent |
| `$matches` | the groups captured by the last `-match` |
| `$null` | the null value (compare it on the **left**: `$null -eq $x`) |
| `$true` / `$false` | the booleans |

```powershell
Get-Process | Where-Object { $_.CPU -gt 10 }   # $_ is each process
if ('abc123' -match '(\d+)') { $matches[1] }    # 123
Get-Item x; if (-not $?) { 'failed' }
```

## About arguments and functions

| Variable | Is |
|---|---|
| `$args` | **unnamed** arguments of a function/script |
| `$PSBoundParameters` | hashtable of the parameters that were passed |
| `$MyInvocation` | details of how the script/function was called |
| `$PSCmdlet` | the cmdlet object (in advanced functions): `$PSCmdlet.ShouldProcess(...)` |
| `$input` | enumerates the pipeline input (advanced use) |

## Environment and paths

| Variable | Is |
|---|---|
| `$PSVersionTable` | version, edition (`Core`=7+ / `Desktop`=5.1), platform |
| `$PROFILE` | path to your profile script |
| `$PSScriptRoot` | folder where the **current script** is (great for relative paths) |
| `$PSCommandPath` | full path of the current script |
| `$HOME` | your personal folder |
| `$PWD` | current directory (object) |
| `$PID` | PID of the PowerShell process |
| `$HOST` | the current host (console) |
| `$env:NAME` | environment variable (e.g., `$env:PATH`, `$env:USERNAME`) |

```powershell
$PSVersionTable.PSVersion              # 7.4.x
. "$PSScriptRoot/lib/helpers.ps1"      # loads a file next to the script
$env:PATH -split [IO.Path]::PathSeparator   # the PATH, item by item
```

## Preferences (they control behavior)

| Variable | Controls |
|---|---|
| `$ErrorActionPreference` | what to do on a non-terminating error (`Continue`/`Stop`/`SilentlyContinue`) |
| `$VerbosePreference` | whether `Write-Verbose` appears (`SilentlyContinue`/`Continue`) |
| `$WarningPreference` | same for `Write-Warning` |
| `$ProgressPreference` | the progress bar (`SilentlyContinue` speeds up downloads) |
| `$ConfirmPreference` | when to ask for confirmation |

```powershell
$ErrorActionPreference = 'Stop'    # at the top of serious scripts (like Bash's set -e)
```

> 💡 `$PSScriptRoot` is the **correct** way to build paths relative to the script, instead of depending on the current directory. And `$PSVersionTable.PSEdition` tells you whether you're on 7+ (`Core`) or 5.1 (`Desktop`).

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
