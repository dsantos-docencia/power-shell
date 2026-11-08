#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 01.03
param([string]$Caminho)
Get-ChildItem -Path $Caminho -Recurse -File |
    Sort-Object -Property Length -Descending |
    Select-Object -First 1 -ExpandProperty Name |
    Write-Output
