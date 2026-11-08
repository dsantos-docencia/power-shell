#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 06.02 — -split quebra por espaço; [array]::Reverse inverte; -join une.
param([string]$Frase)
$palavras = $Frase -split ' '
[array]::Reverse($palavras)
Write-Output ($palavras -join ' ')
