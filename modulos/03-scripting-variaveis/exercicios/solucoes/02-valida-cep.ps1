#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 03.02 — -match aplica a regex; âncoras ^ e $ garantem o formato exato.
param([string]$Cep)
if ($Cep -match '^\d{5}-\d{3}$') {
    Write-Output "valido"
} else {
    Write-Output "invalido"
    exit 1
}
