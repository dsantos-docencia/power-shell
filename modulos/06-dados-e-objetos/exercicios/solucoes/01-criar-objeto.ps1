#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 06.01
param([string]$Nome, [int]$Idade)
$obj = [pscustomobject]@{
    Nome  = $Nome
    Idade = $Idade
    Maior = $Idade -ge 18
}
Write-Output $obj.Maior
