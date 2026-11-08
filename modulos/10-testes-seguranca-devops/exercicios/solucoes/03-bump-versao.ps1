#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 10.03 — incrementa o patch de forma determinística para o pipeline
param([string]$Versao)
$p = $Versao.Split('.')
$p[2] = [string]([int]$p[2] + 1)
Write-Output ($p -join '.')
