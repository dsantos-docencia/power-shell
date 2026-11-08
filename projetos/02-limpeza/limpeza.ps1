#!/usr/bin/env pwsh
<#
============================================================================
  Projeto 02 · Limpeza de Arquivos Antigos
  Curso de PowerShell · Prof. Daniel Santos
  github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Remove arquivos mais velhos que N dias de uma pasta — com rede de segurança:
  SupportsShouldProcess (-WhatIf / -Confirm) do Módulo 05 e idempotência do 04.
  Sem -Executar, ele só MOSTRA o que faria. Nada some por acidente.

  Uso:
    pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30             # simula (padrão)
    pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30 -Executar   # remove de verdade
    pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30 -WhatIf     # simulação do engine
============================================================================
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$Caminho,
    [ValidateRange(0, 3650)][int]$Dias = 30,
    [string]$Filtro = '*',
    [switch]$Executar
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Caminho)) {
    Write-Error "Caminho não encontrado: $Caminho"
    exit 1
}

$limite = (Get-Date).AddDays(-$Dias)
$alvos  = @(Get-ChildItem -LiteralPath $Caminho -Recurse -File -Filter $Filtro |
    Where-Object { $_.LastWriteTime -lt $limite })

Write-Host ("Pasta : {0}" -f $Caminho) -ForegroundColor Cyan
Write-Host ("Regra : mais velhos que {0} dias (antes de {1:yyyy-MM-dd})" -f $Dias, $limite)
Write-Host ("Achei : {0} arquivo(s)" -f $alvos.Count)

$removidos = 0
foreach ($a in $alvos) {
    # Sem -Executar, nunca age: é um ensaio. Com -Executar, ainda respeita -WhatIf.
    if ($Executar) {
        if ($PSCmdlet.ShouldProcess($a.FullName, 'Remover')) {
            Remove-Item -LiteralPath $a.FullName -Force
            $removidos++
            Write-Host ("  removido: {0}" -f $a.Name) -ForegroundColor Yellow
        }
    } else {
        Write-Host ("  [simulado] removeria: {0}" -f $a.Name) -ForegroundColor DarkGray
    }
}

if ($Executar) {
    Write-Host ("Pronto: {0} removido(s)." -f $removidos) -ForegroundColor Green
    Write-Output "removidos=$removidos"
} else {
    Write-Host "Ensaio: nada foi tocado. Use -Executar para valer." -ForegroundColor Green
    Write-Output "simulados=$($alvos.Count)"
}
