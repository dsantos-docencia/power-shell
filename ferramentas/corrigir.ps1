<#
============================================================================
  Curso de PowerShell · ferramentas/corrigir.ps1 — Corretor automático
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  USO
    ./ferramentas/corrigir.ps1 04 02          # corrige o exercício 02 do módulo 04
    ./ferramentas/corrigir.ps1 04             # corrige todos do módulo 04
    ./ferramentas/corrigir.ps1 -Todos         # corrige tudo
    ./ferramentas/corrigir.ps1 04 02 -Solucao # roda os testes contra a solução oficial

  O QUE FAZ
    1. Localiza o exercício  (modulos/04-*/exercicios/02-*.ps1)
    2. Localiza o teste      (modulos/04-*/exercicios/testes/02-*.Testes.ps1)
    3. Roda cada caso num diretório temporário isolado, mostrando ✔/✘.
============================================================================
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)] [string]$Modulo,
    [Parameter(Position = 1)] [string]$Exercicio,
    [switch]$Solucao,
    [switch]$Todos
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$raiz = Split-Path -Parent $PSScriptRoot
Import-Module (Join-Path $PSScriptRoot 'lib/Teste.psm1') -Force -DisableNameChecking

function Normalizar([string]$v) {
    if ([string]::IsNullOrEmpty($v) -or $v -eq '*') { return '*' }
    return '{0:D2}' -f [int]$v
}

if (-not $Todos -and [string]::IsNullOrEmpty($Modulo)) {
    Write-Host 'uso: ./ferramentas/corrigir.ps1 <modulo> [exercicio] [-Solucao] | -Todos'
    exit 2
}

$mod = if ($Todos) { '*' } else { Normalizar $Modulo }
$exe = Normalizar $Exercicio

$testes = Get-ChildItem -Path $raiz -Recurse -Filter '*.Testes.ps1' -ErrorAction SilentlyContinue |
          Where-Object { $_.FullName -match [regex]::Escape((Join-Path 'modulos' '')) -or $_.DirectoryName -like '*modulos*' } |
          Where-Object {
              $m = [regex]::Match($_.FullName, 'modulos[\\/](\d{2})-')
              $e = [regex]::Match($_.Name, '^(\d{2})-')
              ($mod -eq '*' -or ($m.Success -and $m.Groups[1].Value -eq $mod)) -and
              ($exe -eq '*' -or ($e.Success -and $e.Groups[1].Value -eq $exe))
          } | Sort-Object FullName

if (-not $testes) {
    Write-Host "Nenhum exercício encontrado para módulo $mod, exercício $exe." -ForegroundColor Yellow
    exit 2
}

$falhas = 0
foreach ($t in $testes) {
    $dirEx  = Split-Path -Parent (Split-Path -Parent $t.FullName)   # .../exercicios
    $base   = $t.Name -replace '\.Testes\.ps1$', ''
    $alvo   = if ($Solucao) { Join-Path $dirEx "solucoes/$base.ps1" } else { Join-Path $dirEx "$base.ps1" }
    $moduloNome = Split-Path -Leaf (Split-Path -Parent $dirEx)

    $rotulo = if ($Solucao) { ' (solução oficial)' } else { '' }
    Write-Host ("`n{0}▶ {1} · {2}{3}{4}" -f "`e[1m", $moduloNome, $base, $rotulo, "`e[0m")

    if (-not (Test-Path -LiteralPath $alvo)) {
        Write-Host ("    {0}✘ arquivo não encontrado: {1}{2}" -f "`e[31m", ($alvo -replace [regex]::Escape($raiz), '.'), "`e[0m")
        $falhas++; continue
    }
    # Checagem de sintaxe antes de rodar (erros de parse viram mensagem clara).
    $erros = $null
    [System.Management.Automation.Language.Parser]::ParseFile($alvo, [ref]$null, [ref]$erros) | Out-Null
    if ($erros) {
        Write-Host ("    {0}✘ erro de sintaxe em {1}{2}" -f "`e[31m", (Split-Path -Leaf $alvo), "`e[0m")
        $erros | ForEach-Object { Write-Host ("      {0}" -f $_.Message) }
        $falhas++; continue
    }

    if (-not (Invoke-Testes -ArquivoTeste $t.FullName -Alvo $alvo)) { $falhas++ }
}

Write-Host ''
if ($falhas -eq 0) {
    Write-Host ("{0}{1}Tudo certo!{2}" -f "`e[1m", "`e[32m", "`e[0m")
    exit 0
}
Write-Host ("{0}{1}{2} exercício(s) com pendências.{3}" -f "`e[1m", "`e[33m", $falhas, "`e[0m")
exit 1
