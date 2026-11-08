#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 00.02 — $PSVersionTable é um objeto; .PSVersion tem .Major e .Minor.
$v = $PSVersionTable.PSVersion
Write-Output "PowerShell $($v.Major).$($v.Minor)"
