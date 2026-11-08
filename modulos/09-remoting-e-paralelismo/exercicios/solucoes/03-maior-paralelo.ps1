#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 09.03 — ValueFromRemainingArguments junta os números posicionais num array.
param([Parameter(ValueFromRemainingArguments = $true)][int[]]$Numeros)
$maior = ($Numeros | ForEach-Object -Parallel { $_ } | Measure-Object -Maximum).Maximum
Write-Output $maior
