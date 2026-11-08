#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 07.02 — throw gera erro terminante; o catch o intercepta.
param([int]$Idade)
try {
    if ($Idade -lt 0 -or $Idade -gt 150) { throw "idade fora da faixa" }
    Write-Output "ok"
}
catch {
    Write-Output "invalida"
    exit 1
}
