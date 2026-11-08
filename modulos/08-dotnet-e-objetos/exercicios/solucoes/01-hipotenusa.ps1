#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 08.01
param([double]$A, [double]$B)
Write-Output ([Math]::Round([Math]::Sqrt($A * $A + $B * $B), 2))
