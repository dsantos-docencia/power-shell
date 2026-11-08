<#
============================================================================
  Curso de PowerShell · Módulo 02 · Exemplo 02 — Where / Select / Sort
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Encadear filtro, ordenação e seleção sobre objetos reais, e criar
            uma propriedade calculada.
  EXECUTE   pwsh ./02-filtrar-selecionar-ordenar.ps1
  SEGURO    Opera sobre arquivos criados numa pasta temporária.
============================================================================
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    # Cria arquivos de vários tamanhos e extensões.
    Set-Content (Join-Path $lab 'relatorio.log') -Value ('x' * 3000)
    Set-Content (Join-Path $lab 'debug.log')     -Value ('x' * 200)
    Set-Content (Join-Path $lab 'notas.txt')     -Value ('x' * 1500)
    Set-Content (Join-Path $lab 'config.json')   -Value ('x' * 800)

    Write-Output '1) Where-Object: só os arquivos .log (filtro pela propriedade):'
    Get-ChildItem -Path $lab | Where-Object Extension -eq '.log' |
        ForEach-Object { "   $($_.Name)" | Write-Output }

    Write-Output ''
    Write-Output '2) Encadeando: .log, do maior para o menor, só nome e tamanho:'
    Get-ChildItem -Path $lab |
        Where-Object Extension -eq '.log' |
        Sort-Object Length -Descending |
        Select-Object Name, Length |
        ForEach-Object { "   {0,-14} {1} bytes" -f $_.Name, $_.Length | Write-Output }

    Write-Output ''
    Write-Output '3) Propriedade CALCULADA (tamanho em KB, arredondado):'
    Get-ChildItem -Path $lab |
        Sort-Object Length -Descending |
        Select-Object Name, @{ Name = 'KB'; Expression = { [math]::Round($_.Length / 1kb, 2) } } |
        ForEach-Object { "   {0,-14} {1} KB" -f $_.Name, $_.KB | Write-Output }

    Write-Output ''
    Write-Output '4) Condição complexa com bloco { } e $_ (o objeto atual):'
    $grandes = Get-ChildItem -Path $lab | Where-Object { $_.Length -gt 1kb -and $_.Extension -ne '.json' }
    "   arquivos > 1KB e não-json: $($grandes.Count)" | Write-Output
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}
