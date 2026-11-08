# 🔄 Translation guide: Bash → PowerShell

**🌍 Idioma / Language:** [Português](bash-para-powershell.md) · **English**

You already know Bash and want the PowerShell equivalent? This is your bridge. But remember the core idea ([Module 00](../modulos/00-introducao-paradigma/README.en.md)): **Bash passes text, PowerShell passes objects.** A literal translation works for simple commands; for pipelines, think in properties, not columns of text.

> 💡 Many PowerShell aliases **mimic** Unix (`ls`, `cd`, `cat`, `pwd`, `rm`) for convenience — great in the console, but **don't use aliases in scripts** ([Module 01](../modulos/01-navegacao-cmdlets/README.en.md)). Below, always the full name.

## Navigation and files

| Bash | PowerShell | Note |
|---|---|---|
| `pwd` | `Get-Location` | |
| `cd dir` | `Set-Location dir` | |
| `ls` | `Get-ChildItem` | returns **objects**, not text |
| `ls -la` | `Get-ChildItem -Force` | `-Force` shows hidden items |
| `cp a b` | `Copy-Item a b` | `-Recurse` for folders |
| `mv a b` | `Move-Item a b` | also renames |
| `rm arq` | `Remove-Item arq` | **has `-WhatIf`!** (Bash doesn't) |
| `rm -rf dir` | `Remove-Item dir -Recurse -Force` | test with `-WhatIf` first |
| `mkdir -p a/b` | `New-Item -ItemType Directory a/b -Force` | |
| `touch arq` | `New-Item -ItemType File arq` | |
| `cat arq` | `Get-Content arq` | |
| `find . -name '*.log'` | `Get-ChildItem -Recurse -Filter *.log` | |
| `which cmd` | `Get-Command cmd` | |

## Text and data flow

| Bash | PowerShell |
|---|---|
| `grep padrão arq` | `Select-String padrão arq` |
| `cmd \| grep x` | `cmd \| Where-Object { $_ -match 'x' }` |
| `wc -l arq` | `(Get-Content arq).Count` |
| `head -n 5` | `Select-Object -First 5` |
| `tail -n 5` | `Select-Object -Last 5` |
| `sort` | `Sort-Object` |
| `sort -u` / `uniq` | `Sort-Object -Unique` |
| `cut -d: -f1` | `... \| ForEach-Object { ($_ -split ':')[0] }` |
| `sed 's/a/b/g'` | `... -replace 'a','b'` |
| `awk '{print $2}'` | `... \| ForEach-Object { ($_ -split '\s+')[1] }` |
| `tr a-z A-Z` | `... .ToUpper()` or `$_.ToUpper()` |

> 💡 The mental leap: instead of `ps aux | grep firefox | awk '{print $2}'` to get a PID, you do `Get-Process firefox | Select-Object -ExpandProperty Id` — because the process **is an object** with an `Id` property. No column slicing.

## Variables and expansions

| Bash | PowerShell |
|---|---|
| `nome="Ana"` | `$nome = "Ana"` |
| `echo "$nome"` | `Write-Output $nome` or `"$nome"` |
| `${nome:-padrão}` | `if ($nome) { $nome } else { 'padrão' }` |
| `${#nome}` | `$nome.Length` |
| `${nome##*/}` (basename) | `Split-Path $nome -Leaf` |
| `${nome%/*}` (dirname) | `Split-Path $nome -Parent` |
| `${nome%.*}` (no extension) | `[IO.Path]::GetFileNameWithoutExtension($nome)` |
| `$(comando)` | `$(comando)` or `(comando)` |
| `$1 $2 $@` | `$args[0] $args[1] $args` (or `param()`) |
| `export VAR=x` | `$env:VAR = 'x'` |
| `$PATH` | `$env:PATH` |

## Conditionals and loops

| Bash | PowerShell |
|---|---|
| `if [[ $x -eq 1 ]]; then` | `if ($x -eq 1) {` |
| `[[ -f arq ]]` | `Test-Path arq -PathType Leaf` |
| `[[ -d dir ]]` | `Test-Path dir -PathType Container` |
| `[[ -z "$s" ]]` | `[string]::IsNullOrEmpty($s)` |
| `for x in a b c; do` | `foreach ($x in 'a','b','c') {` |
| `for i in {1..5}; do` | `foreach ($i in 1..5) {` |
| `while cond; do` | `while (cond) {` |
| `case $x in ...` | `switch ($x) { ... }` |
| `cmd1 && cmd2` | `cmd1 && cmd2` (PS 7+) or `if ($?) { cmd2 }` |

## Functions, errors, robustness

| Bash | PowerShell |
|---|---|
| `f() { ... }` | `function f { ... }` |
| `return 0/1` (code) | `return $valor` (returns a **value**); the code comes from `exit`/an exception |
| `echo` to "return" a value | just emit the object |
| `local x` | variables are already local to the function |
| `set -euo pipefail` | `$ErrorActionPreference = 'Stop'` (+ `Set-StrictMode -Version Latest`) |
| `trap ... EXIT` | `try { } finally { }` |
| `exit 1` | `exit 1` |
| `cmd 2>/dev/null` | `cmd 2>$null` |
| `cmd > arq 2>&1` | `cmd *> arq` |

## Processes and system

| Bash | PowerShell |
|---|---|
| `ps aux` | `Get-Process` |
| `kill -9 PID` | `Stop-Process -Id PID -Force` |
| `pkill nome` | `Stop-Process -Name nome` |
| `cmd &` | `Start-Job { cmd }` or `Start-Process` |
| `curl url` | `Invoke-RestMethod url` (returns an object!) or `Invoke-WebRequest` |
| `wget url -O arq` | `Invoke-WebRequest url -OutFile arq` |
| `env` | `Get-ChildItem Env:` |
| `cat /etc/os-release` | `Get-ComputerInfo` (Win) / `$PSVersionTable` |

---

## The difference that changes everything

```bash
# Bash: slice text to find the 3 biggest files
ls -l | sort -k5 -rn | head -3 | awk '{print $9, $5}'   # fragile
```
```powershell
# PowerShell: access object properties
Get-ChildItem | Sort-Object Length -Descending | Select-Object Name, Length -First 3
```

It's not "the same thing with different syntax": in PowerShell you never guess the output format — you **ask the object** with `Get-Member` ([Module 02](../modulos/02-pipeline-objetos/README.en.md)). That's the click.

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
