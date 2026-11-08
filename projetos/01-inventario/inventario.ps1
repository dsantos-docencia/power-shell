#!/usr/bin/env pwsh
<#
============================================================================
  Projeto 01 · Inventário de Arquivos
  Curso de PowerShell · Prof. Daniel Santos
  github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Varre uma pasta, transforma cada arquivo em um OBJETO (nome, tamanho,
  extensão, data) e produz um relatório — na tela, em CSV ou em JSON.
  É o pipeline de objetos (Módulos 02 e 06) resolvendo um problema real.

  Uso:
    pwsh ./inventario.ps1 -Caminho ./alvo
    pwsh ./inventario.ps1 -Caminho ./alvo -Formato csv  -Saida relatorio.csv
    pwsh ./inventario.ps1 -Caminho ./alvo -Formato json -Saida relatorio.json
    pwsh ./inventario.ps1 -Caminho ./alvo -Resumo            # uma linha, p/ scripts
============================================================================
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Caminho,
    [ValidateSet('tabela', 'csv', 'json')][string]$Formato = 'tabela',
    [string]$Saida,
    [switch]$Resumo
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Caminho)) {
    Write-Error "Caminho não encontrado: $Caminho"
    exit 1
}

# 1) Coleta: cada arquivo vira um objeto rico ----------------------------------
$itens = Get-ChildItem -LiteralPath $Caminho -Recurse -File | ForEach-Object {
    [PSCustomObject]@{
        Nome      = $_.Name
        Extensao  = if ($_.Extension) { $_.Extension } else { '(sem)' }
        Bytes     = $_.Length
        KB        = [math]::Round($_.Length / 1KB, 1)
        Modificado = $_.LastWriteTime.ToString('yyyy-MM-dd')
    }
}

$total = @($itens).Count
$bytes = ($itens | Measure-Object -Property Bytes -Sum).Sum
if ($null -eq $bytes) { $bytes = 0 }
$porExt = $itens | Group-Object Extensao | Sort-Object Count -Descending

# 2) Modo resumo: uma linha determinística (ótimo para pipes/CI) ---------------
if ($Resumo) {
    Write-Output "arquivos=$total extensoes=$($porExt.Count) bytes=$bytes"
    return
}

# 3) Saída conforme o formato --------------------------------------------------
switch ($Formato) {
    'csv' {
        if ($Saida) { $itens | Export-Csv -Path $Saida -NoTypeInformation -Encoding UTF8; Write-Host "CSV salvo em $Saida" -ForegroundColor Green }
        else { $itens | ConvertTo-Csv -NoTypeInformation }
    }
    'json' {
        $json = $itens | ConvertTo-Json -Depth 3
        if ($Saida) { $json | Set-Content -Path $Saida -Encoding UTF8; Write-Host "JSON salvo em $Saida" -ForegroundColor Green }
        else { $json }
    }
    default {
        Write-Host (($itens | Format-Table | Out-String -Width 120).TrimEnd())
        Write-Host ''
        Write-Host "== Resumo ==" -ForegroundColor Cyan
        Write-Host ("  $total arquivos · {0:N1} KB no total" -f ($bytes / 1KB))
        foreach ($g in $porExt) { Write-Host ("  {0,-8} {1}" -f $g.Name, $g.Count) }
    }
}
