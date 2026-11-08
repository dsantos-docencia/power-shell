#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 08.03 — GetExtension devolve ".jpg"; tiramos o ponto e minusculizamos.
param([string]$Caminho)
$ext = [System.IO.Path]::GetExtension($Caminho).TrimStart('.').ToLower()
Write-Output $ext
