#!/usr/bin/env pwsh
<#
============================================================================
  Curso de PowerShell · Módulo 11 · Módulos e Distribuição
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Gera um manifesto (.psd1) com New-ModuleManifest e valida com
  Test-ModuleManifest — o contrato que a Gallery lê antes de publicar.
============================================================================
#>
Set-StrictMode -Version Latest

$raiz  = Join-Path ([System.IO.Path]::GetTempPath()) ("Mod_" + [guid]::NewGuid().ToString('N').Substring(0, 6))
$pasta = Join-Path $raiz 'MinhaFerramenta'
New-Item -ItemType Directory -Path $pasta -Force | Out-Null
'function Get-Saudacao { param([string]$Nome) "Olá, $Nome!" }' |
    Set-Content -Path (Join-Path $pasta 'MinhaFerramenta.psm1')

$psd1 = Join-Path $pasta 'MinhaFerramenta.psd1'

Write-Host "== Gerando o manifesto com New-ModuleManifest ==" -ForegroundColor Cyan
New-ModuleManifest -Path $psd1 `
    -RootModule        'MinhaFerramenta.psm1' `
    -ModuleVersion     '1.0.0' `
    -Author            'Daniel Santos' `
    -Description       'Ferramentas de saudação da comunidade' `
    -FunctionsToExport @('Get-Saudacao') `
    -PowerShellVersion '7.0' `
    -Tags              @('exemplo', 'curso', 'saudacao')

Write-Host ""
Write-Host "== Validando com Test-ModuleManifest ==" -ForegroundColor Cyan
$info = Test-ModuleManifest -Path $psd1
Write-Host ("  Nome    : " + $info.Name)
Write-Host ("  Versão  : " + $info.Version)
Write-Host ("  Autor   : " + $info.Author)
Write-Host ("  Exports : " + ($info.ExportedFunctions.Keys -join ', '))

Write-Host "Manifesto válido. Pronto para Publish-PSResource." -ForegroundColor Green
Remove-Item $raiz -Recurse -Force
