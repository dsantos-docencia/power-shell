#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 10.01 — deixar o motor de validação barrar a entrada inválida
param([ValidateRange(1, 100)][int]$N)
Write-Output ($N * 2)
