#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 05.03 — ShouldProcess pula a ação quando há -WhatIf.
[CmdletBinding(SupportsShouldProcess=$true)]
param([Parameter(Mandatory)][string]$Caminho)
if ($PSCmdlet.ShouldProcess($Caminho, 'Remover')) {
    Remove-Item -LiteralPath $Caminho
    Write-Output "removido"
}
