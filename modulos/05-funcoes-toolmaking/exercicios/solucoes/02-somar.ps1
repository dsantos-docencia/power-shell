#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 05.02 — ValueFromPipeline + begin/process/end.
[CmdletBinding()]
param([Parameter(ValueFromPipeline=$true)][double]$Numero)
begin   { $soma = 0.0 }
process { $soma += $Numero }
end     { Write-Output $soma }
