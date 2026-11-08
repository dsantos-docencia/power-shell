#!/usr/bin/env pwsh
<#
============================================================================
  Curso de PowerShell · Módulo 11 · Módulos e Distribuição
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Cria um módulo de verdade (.psm1) numa pasta temporária, importa, usa a
  função pública e prova que a função privada NÃO vaza para fora.
============================================================================
#>
Set-StrictMode -Version Latest

$raiz  = Join-Path ([System.IO.Path]::GetTempPath()) ("MinhaFerramenta_" + [guid]::NewGuid().ToString('N').Substring(0, 6))
$pasta = Join-Path $raiz 'MinhaFerramenta'
New-Item -ItemType Directory -Path $pasta -Force | Out-Null

# O .psm1: duas funções, mas só uma é pública.
@'
function Get-Saudacao {
    param([string]$Nome)
    "Olá, $(Format-Nome $Nome)!"
}
function Format-Nome {          # ajudante PRIVADO (não exportado)
    param([string]$n)
    $n.Trim()
}
Export-ModuleMember -Function Get-Saudacao
'@ | Set-Content -Path (Join-Path $pasta 'MinhaFerramenta.psm1')

Import-Module (Join-Path $pasta 'MinhaFerramenta.psm1') -Force

Write-Host "== Chamando a função pública ==" -ForegroundColor Cyan
Get-Saudacao -Nome '  Daniel  '          # Olá, Daniel!

Write-Host ""
Write-Host "== O que o módulo exporta ==" -ForegroundColor Cyan
Get-Command -Module MinhaFerramenta | Select-Object -ExpandProperty Name

Write-Host ""
Write-Host "== A função privada está acessível de fora? ==" -ForegroundColor Cyan
if (Get-Command Format-Nome -ErrorAction SilentlyContinue) {
    Write-Host 'Sim (não deveria!)' -ForegroundColor Red
} else {
    Write-Host 'Não — Format-Nome ficou encapsulada. É assim que se faz.' -ForegroundColor Green
}

Remove-Module MinhaFerramenta -Force
Remove-Item $raiz -Recurse -Force
