#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 03.03 — -f formata: {0,-12} alinha à esquerda; {1,8:N2} = 2 casas.
param([string]$Produto, [double]$Preco)
Write-Output ('{0,-12} R$ {1,8:N2}' -f $Produto, $Preco)
