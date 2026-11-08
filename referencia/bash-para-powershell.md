# 🔄 Guia de tradução: Bash → PowerShell

**🌍 Idioma / Language:** **Português** · [English](bash-para-powershell.en.md)

Você já sabe Bash e quer o equivalente em PowerShell? Esta é a sua ponte. Mas lembre da ideia central ([Módulo 00](../modulos/00-introducao-paradigma/)): **Bash passa texto, PowerShell passa objetos.** A tradução literal funciona para comandos simples; para pipelines, pense em propriedades, não em colunas de texto.

> 💡 Muitos aliases do PowerShell **imitam** o Unix (`ls`, `cd`, `cat`, `pwd`, `rm`) para facilitar — ótimos no console, mas **não use aliases em scripts** ([Módulo 01](../modulos/01-navegacao-cmdlets/)). Abaixo, sempre o nome completo.

## Navegação e arquivos

| Bash | PowerShell | Observação |
|---|---|---|
| `pwd` | `Get-Location` | |
| `cd dir` | `Set-Location dir` | |
| `ls` | `Get-ChildItem` | devolve **objetos**, não texto |
| `ls -la` | `Get-ChildItem -Force` | `-Force` mostra ocultos |
| `cp a b` | `Copy-Item a b` | `-Recurse` para pastas |
| `mv a b` | `Move-Item a b` | também renomeia |
| `rm arq` | `Remove-Item arq` | **tem `-WhatIf`!** (o Bash não) |
| `rm -rf dir` | `Remove-Item dir -Recurse -Force` | teste com `-WhatIf` antes |
| `mkdir -p a/b` | `New-Item -ItemType Directory a/b -Force` | |
| `touch arq` | `New-Item -ItemType File arq` | |
| `cat arq` | `Get-Content arq` | |
| `find . -name '*.log'` | `Get-ChildItem -Recurse -Filter *.log` | |
| `which cmd` | `Get-Command cmd` | |

## Fluxo de texto e dados

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
| `tr a-z A-Z` | `... .ToUpper()` ou `$_.ToUpper()` |

> 💡 O salto mental: em vez de `ps aux | grep firefox | awk '{print $2}'` para pegar um PID, você faz `Get-Process firefox | Select-Object -ExpandProperty Id` — porque o processo **é um objeto** com uma propriedade `Id`. Nada de recortar colunas.

## Variáveis e expansões

| Bash | PowerShell |
|---|---|
| `nome="Ana"` | `$nome = "Ana"` |
| `echo "$nome"` | `Write-Output $nome` ou `"$nome"` |
| `${nome:-padrão}` | `if ($nome) { $nome } else { 'padrão' }` |
| `${#nome}` | `$nome.Length` |
| `${nome##*/}` (basename) | `Split-Path $nome -Leaf` |
| `${nome%/*}` (dirname) | `Split-Path $nome -Parent` |
| `${nome%.*}` (sem extensão) | `[IO.Path]::GetFileNameWithoutExtension($nome)` |
| `$(comando)` | `$(comando)` ou `(comando)` |
| `$1 $2 $@` | `$args[0] $args[1] $args` (ou `param()`) |
| `export VAR=x` | `$env:VAR = 'x'` |
| `$PATH` | `$env:PATH` |

## Condicionais e laços

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
| `cmd1 && cmd2` | `cmd1 && cmd2` (PS 7+) ou `if ($?) { cmd2 }` |

## Funções, erros, robustez

| Bash | PowerShell |
|---|---|
| `f() { ... }` | `function f { ... }` |
| `return 0/1` (código) | `return $valor` (devolve **valor**); o código vem de `exit`/exceção |
| `echo` para "retornar" valor | basta emitir o objeto |
| `local x` | variáveis já são locais à função |
| `set -euo pipefail` | `$ErrorActionPreference = 'Stop'` (+ `Set-StrictMode -Version Latest`) |
| `trap ... EXIT` | `try { } finally { }` |
| `exit 1` | `exit 1` |
| `cmd 2>/dev/null` | `cmd 2>$null` |
| `cmd > arq 2>&1` | `cmd *> arq` |

## Processos e sistema

| Bash | PowerShell |
|---|---|
| `ps aux` | `Get-Process` |
| `kill -9 PID` | `Stop-Process -Id PID -Force` |
| `pkill nome` | `Stop-Process -Name nome` |
| `cmd &` | `Start-Job { cmd }` ou `Start-Process` |
| `curl url` | `Invoke-RestMethod url` (devolve objeto!) ou `Invoke-WebRequest` |
| `wget url -O arq` | `Invoke-WebRequest url -OutFile arq` |
| `env` | `Get-ChildItem Env:` |
| `cat /etc/os-release` | `Get-ComputerInfo` (Win) / `$PSVersionTable` |

---

## A diferença que muda tudo

```bash
# Bash: recortar texto para achar os 3 maiores arquivos
ls -l | sort -k5 -rn | head -3 | awk '{print $9, $5}'   # frágil
```
```powershell
# PowerShell: acessar propriedades de objetos
Get-ChildItem | Sort-Object Length -Descending | Select-Object Name, Length -First 3
```

Não é "a mesma coisa com outra sintaxe": no PowerShell você nunca adivinha o formato da saída — você **pergunta ao objeto** com `Get-Member` ([Módulo 02](../modulos/02-pipeline-objetos/)). Esse é o clique.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
