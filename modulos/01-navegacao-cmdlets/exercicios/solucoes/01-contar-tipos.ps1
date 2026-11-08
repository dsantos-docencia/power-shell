#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 01.01
param([string]$Caminho)
$arqs = @(Get-ChildItem -Path $Caminho -Recurse -File)
$dirs = @(Get-ChildItem -Path $Caminho -Recurse -Directory)
Write-Output "arquivos: $($arqs.Count)"
Write-Output "diretorios: $($dirs.Count)"
