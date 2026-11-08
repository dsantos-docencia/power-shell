#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 11.03 — exports ordenados facilitam a revisão do manifesto
param([string]$Lista)
$nomes = $Lista.Split(',') | ForEach-Object { $_.Trim() } | Sort-Object
Write-Output ($nomes -join ', ')
