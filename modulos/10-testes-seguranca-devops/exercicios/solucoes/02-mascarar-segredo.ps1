#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 10.02 — nunca exponha o segredo inteiro em log
param([string]$Texto)
if ($Texto.Length -le 4) { Write-Output $Texto; return }
$visiveis = $Texto.Substring($Texto.Length - 4)
$mascara  = '*' * ($Texto.Length - 4)
Write-Output ($mascara + $visiveis)
