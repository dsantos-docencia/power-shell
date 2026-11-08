#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 02.02
param([string]$Csv)
Import-Csv -Path $Csv |
    Group-Object Vendedor |
    Sort-Object Name |
    ForEach-Object {
        $total = ($_.Group | Measure-Object Valor -Sum).Sum
        Write-Output "$($_.Name): $total"
    }
