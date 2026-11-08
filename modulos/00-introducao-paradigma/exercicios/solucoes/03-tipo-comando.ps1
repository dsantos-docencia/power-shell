#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 00.03
param([string]$Nome)
# -ErrorAction SilentlyContinue evita o erro quando o comando não existe.
$c = Get-Command -Name $Nome -ErrorAction SilentlyContinue | Select-Object -First 1
if ($c) {
    Write-Output $c.CommandType.ToString()
} else {
    Write-Output "desconhecido"
    exit 1
}
