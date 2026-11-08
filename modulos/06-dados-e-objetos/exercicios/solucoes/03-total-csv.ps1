#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 06.03
param([string]$Csv)
$soma = (Import-Csv -Path $Csv | Measure-Object -Property Valor -Sum).Sum
Write-Output $soma
