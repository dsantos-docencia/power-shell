#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 01.02 — Get-Alias resolve; .Definition tem o cmdlet de destino.
param([string]$Alias)
$a = Get-Alias -Name $Alias -ErrorAction SilentlyContinue
if ($a) {
    Write-Output $a.Definition
} else {
    Write-Output "nao-e-alias"
    exit 1
}
