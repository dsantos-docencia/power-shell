#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 04.03 — -Begin inicia o acumulador, -Process soma, -End emite.
param([int]$N)
1..$N | ForEach-Object -Begin { $soma = 0 } -Process { $soma += $_ } -End { Write-Output $soma }
