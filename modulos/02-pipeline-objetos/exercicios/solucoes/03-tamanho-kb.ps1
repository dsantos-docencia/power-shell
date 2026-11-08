#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 02.03
param([string]$Caminho)
Get-ChildItem -Path $Caminho -File |
    Sort-Object Length -Descending |
    Select-Object Name, @{ Name = 'KB'; Expression = { [math]::Round($_.Length / 1kb, 1) } } |
    ForEach-Object { Write-Output "$($_.Name)=$($_.KB)" }
