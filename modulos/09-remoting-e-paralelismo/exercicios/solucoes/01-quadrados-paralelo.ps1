#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 09.01
param([int]$N)
$soma = (1..$N | ForEach-Object -Parallel { $_ * $_ } | Measure-Object -Sum).Sum
Write-Output $soma
