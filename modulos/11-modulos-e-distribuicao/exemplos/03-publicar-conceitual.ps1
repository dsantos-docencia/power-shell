#!/usr/bin/env pwsh
<#
============================================================================
  Curso de PowerShell · Módulo 11 · Módulos e Distribuição
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Este exemplo NÃO publica nada: mostra, passo a passo, os comandos reais do
  PSResourceGet. Publicar de verdade exige conta na PowerShell Gallery e uma
  API key — por isso aqui apenas narramos o fluxo.
============================================================================
#>
Set-StrictMode -Version Latest

function Passo {
    param([string]$Titulo, [string]$Comando)
    Write-Host ""
    Write-Host "> $Titulo" -ForegroundColor Cyan
    Write-Host "    $Comando" -ForegroundColor Yellow
}

Write-Host "=== Fluxo de distribuição com PSResourceGet ===" -ForegroundColor Green

Passo 'Descobrir um módulo na Gallery'           'Find-PSResource -Name Pester'
Passo 'Instalar para o usuário atual'            'Install-PSResource -Name Pester -Scope CurrentUser'
Passo 'Atualizar'                                'Update-PSResource -Name Pester'
Passo 'Registrar um repositório privado (empresa)' 'Register-PSResourceRepository -Name Interno -Uri https://nuget.empresa.com/v3/index.json'
Passo 'Publicar o SEU módulo'                    'Publish-PSResource -Path ./MinhaFerramenta -ApiKey $env:NUGET_KEY'

Write-Host ""
Write-Host "== Checklist antes de publicar ==" -ForegroundColor Cyan
$check = @(
    'Test-ModuleManifest passou sem erros'
    'ModuleVersion seguiu SemVer e é maior que a publicada'
    'FunctionsToExport lista apenas o que é público'
    'README e licença incluídos na pasta'
    'Testes Pester verdes (Módulo 10)'
)
$check | ForEach-Object { Write-Host "  [ ] $_" }

Write-Host ""
Write-Host "Dica: valide o pacote num repositório local antes da Gallery pública." -ForegroundColor Green
