#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 02.01
param([string]$Caminho)
Get-ChildItem -Path $Caminho -File |
    Where-Object Extension -eq '.log' |
    Sort-Object Length -Descending |
    Select-Object -ExpandProperty Name |
    Write-Output
