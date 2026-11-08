#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 11.02 — subir minor zera o patch (disciplina de SemVer)
param([string]$Versao)
$p = $Versao.Split('.')
"$($p[0]).$([int]$p[1] + 1).0"
