#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 04.03 — ForEach-Object enxerga o escopo externo, então um
# acumulador declarado antes do pipeline funciona.
param([int]$N)
$soma = 0
1..$N | ForEach-Object { $soma += $_ }
Write-Output $soma
