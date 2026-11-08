#!/usr/bin/env pwsh
<#
============================================================================
  Projeto 05 · Demo do módulo Iconne.Infra
  Curso de PowerShell · Prof. Daniel Santos
  github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Importa o módulo empacotado e exercita suas funções públicas. Saída
  determinística para o corretor do curso.
============================================================================
#>
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$modulo = Join-Path $PSScriptRoot 'Iconne.Infra/Iconne.Infra.psd1'
Import-Module $modulo -Force

Write-Host "== Iconne.Infra em ação ==" -ForegroundColor Cyan
Write-Output ("tamanho=" + (Convert-ParaTamanhoLegivel -Bytes 1048576))   # 1.0 MB
Write-Output ("valido=" + (Test-NomeRecurso -Nome 'db-vendas'))           # True
Write-Output ("invalido=" + (Test-NomeRecurso -Nome 'DB Vendas'))         # False

$id = New-IdRecurso -Prefixo 'srv'
Write-Output ("id_ok=" + ($id -match '^srv-[0-9a-f]{6}$'))                 # True

Remove-Module Iconne.Infra -Force
