# 🎴 Cheat Sheet de PowerShell

**🌍 Idioma / Language:** **Português** · [English](cheat-sheet.en.md)

Referência rápida de bolso. Para o porquê de cada item, veja o módulo indicado.

## Variáveis e tipos — Módulos 03, 06

```powershell
$nome = "valor"            # string
[int]$n = 10               # tipagem forte
$lista = @(1, 2, 3)        # array
$mapa  = @{ a = 1; b = 2 } # hashtable
$obj = [pscustomobject]@{ Nome='Ana'; Idade=30 }   # objeto estruturado
$nome.GetType().Name       # descobrir o tipo
```

## Operadores — [tabela-operadores.md](tabela-operadores.md)

```powershell
-eq -ne -gt -ge -lt -le          # comparação
-like -notlike                   # curinga (*, ?)
-match -notmatch -replace        # regex
-contains -in                    # pertence à coleção
-and -or -not (!)                # lógicos
+ - * / %   [math]::Pow(b,e)     # aritméticos
```
Case-insensitive por padrão (use `-ceq`, `-cmatch` para diferenciar). `$null` à esquerda: `$null -eq $x`.

## Pipeline de objetos — Módulo 02

```powershell
Get-Process | Where-Object CPU -gt 10 | Sort-Object CPU -Descending | Select-Object Name, CPU
... | Select-Object -First 5           # primeiros 5
... | Select-Object -ExpandProperty Id # só os valores
... | Group-Object Status              # agrupa
... | Measure-Object Length -Sum       # soma/média/máx
... | ForEach-Object { $_.Name }       # transforma item a item
$obj | Get-Member                      # o que o objeto tem (O MAIS IMPORTANTE)
```
> 🔴 **Regra de ouro:** os `Format-*` são sempre os **últimos** da linha.

## Condicionais e laços — Módulo 04

```powershell
if ($x -eq 1) { ... } elseif ($y) { ... } else { ... }
$r = $x -gt 0 ? 'pos' : 'neg'          # ternário (PS 7+)

switch ($v) { 1 { 'um' } 2 { 'dois' } default { 'outro' } }
switch -Wildcard ($arq) { '*.log' { 'registro' } }
switch -Regex  ($t)   { '^\d+$' { 'número' } }

foreach ($i in 1..5) { ... }           # instrução (coleção na memória)
1..5 | ForEach-Object { ... }          # pipeline (streaming)
for ($i=0; $i -lt 5; $i++) { ... }
while ($cond) { ... }   do { ... } until ($cond)
```

## Funções e parâmetros — Módulo 05

```powershell
function Get-Dobro {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][int]$N,
        [ValidateSet('a','b')][string]$Modo = 'a'
    )
    $N * 2                              # emitir já "retorna"
}
# pipeline + begin/process/end:
function Soma { param([Parameter(ValueFromPipeline)][int]$X)
    begin { $t = 0 } process { $t += $X } end { $t } }
# -WhatIf / -Confirm:
function Remove-Log { [CmdletBinding(SupportsShouldProcess)] param([string]$P)
    if ($PSCmdlet.ShouldProcess($P)) { Remove-Item $P } }
```

## Strings — Módulos 03, 06

```powershell
"Olá, $nome e $($obj.Prop)"            # interpolação ($( ) para expressões)
'literal $semExpansão'                 # aspas simples não expandem
'{0,-10} {1:N2}' -f 'café', 4.5        # operador de formato
"a,b,c" -split ','                     # divide (regex)
@('a','b') -join '-'                   # junta
$t.Trim()  $t.ToUpper()  $t.Substring(0,3)   # métodos .NET
"${arq}".Length                        # comprimento
```

## Erros — Módulo 07

```powershell
$ErrorActionPreference = 'Stop'        # no topo de scripts sérios
try { Get-Item x -ErrorAction Stop }
catch { Write-Warning $_.Exception.Message; exit 1 }
finally { <# limpeza #> }
throw "mensagem"                       # erro terminante
$Error[0]                              # último erro da sessão
```

## Arquivos e dados — Módulos 02, 06

```powershell
Get-ChildItem -Recurse -Filter *.log
Get-Content arq.txt                    # lê (array de linhas)
Set-Content arq.txt -Value $x -Encoding utf8
$dados | Export-Csv saida.csv -NoTypeInformation
Import-Csv saida.csv                   # vira objetos
$obj | ConvertTo-Json -Depth 5
Get-Content c.json -Raw | ConvertFrom-Json
Test-Path caminho                      # existe?
Split-Path $p -Leaf / -Parent          # basename / dirname
Join-Path $a $b
```

## .NET e objetos — Módulo 08

```powershell
[Math]::Round(3.14159, 2)   [Math]::Sqrt(144)
[Guid]::NewGuid()           [DateTime]::Now
[IO.Path]::GetExtension($p)
class Ponto { [int]$X; Ponto([int]$x){ $this.X = $x } }
[Ponto]::new(5)
```

## Avançado — Módulos 09, 11

```powershell
Start-Job { ... }; Receive-Job        # job em background
1..10 | ForEach-Object -Parallel { $_ } -ThrottleLimit 5   # paralelo (PS7+)
Invoke-Command -ComputerName srv { Get-Service }           # remoting
"$using:var"                          # passar variável p/ bloco paralelo/remoto
Import-Module ./Mod/Mod.psd1          # carregar módulo
New-ModuleManifest ...; Test-ModuleManifest ...            # manifesto
```

---
Veja também: [tabela-operadores.md](tabela-operadores.md) · [variaveis-automaticas.md](variaveis-automaticas.md) · [bash-para-powershell.md](bash-para-powershell.md)

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
