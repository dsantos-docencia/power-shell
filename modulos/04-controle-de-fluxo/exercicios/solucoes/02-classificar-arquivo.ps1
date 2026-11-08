#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 04.02
param([string]$Arquivo)
switch -Wildcard ($Arquivo) {
    '*.jpg' { Write-Output 'imagem'; break }
    '*.png' { Write-Output 'imagem'; break }
    '*.ps1' { Write-Output 'script'; break }
    '*.txt' { Write-Output 'texto';  break }
    '*.md'  { Write-Output 'texto';  break }
    default { Write-Output 'outro' }
}
