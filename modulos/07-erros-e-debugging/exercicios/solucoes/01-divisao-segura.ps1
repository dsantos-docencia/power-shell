#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 07.01
param([double]$A, [double]$B)
if ($B -eq 0) {
    Write-Output "erro: divisao por zero"
    exit 1
}
Write-Output ($A / $B)
