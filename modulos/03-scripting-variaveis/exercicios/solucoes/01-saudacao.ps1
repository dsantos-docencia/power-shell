#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 03.01 — $( ) permite acessar a propriedade .Length dentro da string.
param([string]$Nome)
Write-Output "Olá, $Nome! ($($Nome.Length) letras)"
