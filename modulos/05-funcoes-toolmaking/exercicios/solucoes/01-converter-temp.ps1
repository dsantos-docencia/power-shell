#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 05.01 — ValidateSet restringe $Para a 'C' ou 'F'.
param([double]$Valor, [ValidateSet('C','F')][string]$Para)
$r = switch ($Para) {
    'C' { ($Valor - 32) * 5 / 9 }
    'F' { $Valor * 9 / 5 + 32 }
}
Write-Output ([math]::Round($r, 1))
