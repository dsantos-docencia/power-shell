#!/usr/bin/env pwsh
<#
============================================================================
  Projeto 03 · Health-Check do Sistema
  Curso de PowerShell · Prof. Daniel Santos
  github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Roda uma bateria de verificações (disco, memória de processos, uptime) e
  devolve um OBJETO por verificação, com status OK / ATENCAO / FALHA. No fim,
  um status geral. Objetos em vez de texto (Módulo 02/06) = fácil de filtrar,
  exportar para JSON e plugar num alerta.

  Uso:
    pwsh ./health-check.ps1                       # tabela + status geral
    pwsh ./health-check.ps1 -Json                 # saída JSON p/ monitoramento
    pwsh ./health-check.ps1 -LimiteDiscoPct 85    # ajusta o limite de disco
============================================================================
#>
[CmdletBinding()]
param(
    [ValidateRange(1, 99)][int]$LimiteDiscoPct = 90,
    [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Verificacao {
    # Fábrica de objeto, como New-Object/New-TimeSpan: não altera estado do sistema.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Apenas constrói um PSCustomObject; não altera estado.')]
    param([string]$Nome, [string]$Status, [string]$Detalhe)
    [PSCustomObject]@{ Verificacao = $Nome; Status = $Status; Detalhe = $Detalhe }
}

$checks = [System.Collections.Generic.List[object]]::new()

# 1) Disco: maior uso entre os volumes (cross-platform via Get-PSDrive) --------
$discos = Get-PSDrive -PSProvider FileSystem |
    Where-Object { ($_.Used -gt 0) -and ($null -ne $_.Free) }
$pior = 0.0
foreach ($d in $discos) {
    $total = $d.Used + $d.Free
    if ($total -gt 0) {
        $pct = [math]::Round(($d.Used / $total) * 100, 0)
        if ($pct -gt $pior) { $pior = $pct }
    }
}
$statusDisco = if ($pior -ge $LimiteDiscoPct) { 'ATENCAO' } else { 'OK' }
$checks.Add((New-Verificacao 'Disco' $statusDisco ("uso máximo {0}% (limite {1}%)" -f $pior, $LimiteDiscoPct)))

# 2) Processos: quantos rodando e o mais "pesado" em memória -------------------
$procs = Get-Process
$top = $procs | Sort-Object WorkingSet64 -Descending | Select-Object -First 1
$topMB = [math]::Round($top.WorkingSet64 / 1MB, 0)
$checks.Add((New-Verificacao 'Processos' 'OK' ("{0} ativos; maior: {1} ({2} MB)" -f $procs.Count, $top.ProcessName, $topMB)))

# 3) Uptime do processo atual (prova de vida simples, sem APIs de SO) ----------
$inicio = (Get-Process -Id $PID).StartTime
$upSeg  = [int]((Get-Date) - $inicio).TotalSeconds
$checks.Add((New-Verificacao 'Sessao' 'OK' ("PowerShell de pé há {0}s" -f $upSeg)))

# 4) Status geral: pior status manda ------------------------------------------
$geral = if ($checks.Status -contains 'FALHA') { 'FALHA' }
         elseif ($checks.Status -contains 'ATENCAO') { 'ATENCAO' }
         else { 'OK' }

if ($Json) {
    [PSCustomObject]@{ StatusGeral = $geral; Verificacoes = $checks } | ConvertTo-Json -Depth 4
    return
}

Write-Host "== Health-Check ==" -ForegroundColor Cyan
Write-Host (($checks | Format-Table -AutoSize | Out-String -Width 120).TrimEnd())
$cor = switch ($geral) { 'OK' { 'Green' } 'ATENCAO' { 'Yellow' } default { 'Red' } }
Write-Host ("Status geral: {0}" -f $geral) -ForegroundColor $cor
Write-Output "geral=$geral"
