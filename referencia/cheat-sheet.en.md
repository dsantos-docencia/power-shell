# 🎴 PowerShell Cheat Sheet

**🌍 Idioma / Language:** [Português](cheat-sheet.md) · **English**

A quick pocket reference. For the why of each item, see the indicated module.

## Variables and types — Modules 03, 06

```powershell
$nome = "valor"            # string
[int]$n = 10               # strong typing
$lista = @(1, 2, 3)        # array
$mapa  = @{ a = 1; b = 2 } # hashtable
$obj = [pscustomobject]@{ Nome='Ana'; Idade=30 }   # structured object
$nome.GetType().Name       # discover the type
```

## Operators — [tabela-operadores.md](tabela-operadores.en.md)

```powershell
-eq -ne -gt -ge -lt -le          # comparison
-like -notlike                   # wildcard (*, ?)
-match -notmatch -replace        # regex
-contains -in                    # belongs to the collection
-and -or -not (!)                # logical
+ - * / %   [math]::Pow(b,e)     # arithmetic
```
Case-insensitive by default (use `-ceq`, `-cmatch` to tell case apart). `$null` on the left: `$null -eq $x`.

## Object pipeline — Module 02

```powershell
Get-Process | Where-Object CPU -gt 10 | Sort-Object CPU -Descending | Select-Object Name, CPU
... | Select-Object -First 5           # first 5
... | Select-Object -ExpandProperty Id # only the values
... | Group-Object Status              # groups
... | Measure-Object Length -Sum       # sum/average/max
... | ForEach-Object { $_.Name }       # transforms item by item
$obj | Get-Member                      # what the object has (THE MOST IMPORTANT)
```
> 🔴 **Golden rule:** the `Format-*` are always the **last** in the line.

## Conditionals and loops — Module 04

```powershell
if ($x -eq 1) { ... } elseif ($y) { ... } else { ... }
$r = $x -gt 0 ? 'pos' : 'neg'          # ternary (PS 7+)

switch ($v) { 1 { 'one' } 2 { 'two' } default { 'other' } }
switch -Wildcard ($arq) { '*.log' { 'log' } }
switch -Regex  ($t)   { '^\d+$' { 'number' } }

foreach ($i in 1..5) { ... }           # statement (collection in memory)
1..5 | ForEach-Object { ... }          # pipeline (streaming)
for ($i=0; $i -lt 5; $i++) { ... }
while ($cond) { ... }   do { ... } until ($cond)
```

## Functions and parameters — Module 05

```powershell
function Get-Dobro {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][int]$N,
        [ValidateSet('a','b')][string]$Modo = 'a'
    )
    $N * 2                              # emitting already "returns"
}
# pipeline + begin/process/end:
function Soma { param([Parameter(ValueFromPipeline)][int]$X)
    begin { $t = 0 } process { $t += $X } end { $t } }
# -WhatIf / -Confirm:
function Remove-Log { [CmdletBinding(SupportsShouldProcess)] param([string]$P)
    if ($PSCmdlet.ShouldProcess($P)) { Remove-Item $P } }
```

## Strings — Modules 03, 06

```powershell
"Hello, $nome and $($obj.Prop)"        # interpolation ($( ) for expressions)
'literal $noExpansion'                 # single quotes don't expand
'{0,-10} {1:N2}' -f 'café', 4.5        # format operator
"a,b,c" -split ','                     # splits (regex)
@('a','b') -join '-'                   # joins
$t.Trim()  $t.ToUpper()  $t.Substring(0,3)   # .NET methods
"${arq}".Length                        # length
```

## Errors — Module 07

```powershell
$ErrorActionPreference = 'Stop'        # at the top of serious scripts
try { Get-Item x -ErrorAction Stop }
catch { Write-Warning $_.Exception.Message; exit 1 }
finally { <# cleanup #> }
throw "message"                        # terminating error
$Error[0]                              # last session error
```

## Files and data — Modules 02, 06

```powershell
Get-ChildItem -Recurse -Filter *.log
Get-Content arq.txt                    # reads (array of lines)
Set-Content arq.txt -Value $x -Encoding utf8
$dados | Export-Csv saida.csv -NoTypeInformation
Import-Csv saida.csv                   # becomes objects
$obj | ConvertTo-Json -Depth 5
Get-Content c.json -Raw | ConvertFrom-Json
Test-Path caminho                      # exists?
Split-Path $p -Leaf / -Parent          # basename / dirname
Join-Path $a $b
```

## .NET and objects — Module 08

```powershell
[Math]::Round(3.14159, 2)   [Math]::Sqrt(144)
[Guid]::NewGuid()           [DateTime]::Now
[IO.Path]::GetExtension($p)
class Ponto { [int]$X; Ponto([int]$x){ $this.X = $x } }
[Ponto]::new(5)
```

## Advanced — Modules 09, 11

```powershell
Start-Job { ... }; Receive-Job        # background job
1..10 | ForEach-Object -Parallel { $_ } -ThrottleLimit 5   # parallel (PS7+)
Invoke-Command -ComputerName srv { Get-Service }           # remoting
"$using:var"                          # pass a variable to a parallel/remote block
Import-Module ./Mod/Mod.psd1          # load a module
New-ModuleManifest ...; Test-ModuleManifest ...            # manifest
```

---
See also: [tabela-operadores.md](tabela-operadores.en.md) · [variaveis-automaticas.md](variaveis-automaticas.en.md) · [bash-para-powershell.md](bash-para-powershell.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
