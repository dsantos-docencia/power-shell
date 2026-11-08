#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 07.03 — captura o tipo específico FormatException.
param([string]$Texto)
try {
    $n = [int]::Parse($Texto)
    Write-Output ($n * 2)
}
catch [System.FormatException] {
    Write-Output "nao-e-numero"
    exit 1
}
