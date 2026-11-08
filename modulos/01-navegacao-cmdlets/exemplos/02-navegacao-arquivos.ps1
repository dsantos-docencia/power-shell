<#
============================================================================
  Curso de PowerShell · Módulo 01 · Exemplo 02 — Navegação e arquivos
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Criar, listar, copiar, mover e remover com os cmdlets *-Item,
            e ver o poder do -WhatIf (simular antes de apagar).
  EXECUTE   pwsh ./02-navegacao-arquivos.ps1
  SEGURO    Tudo acontece numa pasta temporária, removida no fim.
============================================================================
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    Push-Location $lab

    Write-Output "1) Onde estou? (Get-Location):"
    "   $((Get-Location).Path)" | Write-Output

    Write-Output ''
    Write-Output '2) Criar uma estrutura de pastas e arquivos (New-Item):'
    New-Item -ItemType Directory -Path 'projeto/src', 'projeto/docs' -Force | Out-Null
    New-Item -ItemType File -Path 'projeto/src/app.ps1', 'projeto/README.md' | Out-Null
    Get-ChildItem -Path projeto -Recurse |
        ForEach-Object { "   " + ($_.FullName.Replace($lab, '.')) | Write-Output }

    Write-Output ''
    Write-Output '3) Copiar e renomear (Copy-Item / Rename-Item):'
    Copy-Item -Path 'projeto/README.md' -Destination 'projeto/README.bak'
    Rename-Item -Path 'projeto/README.bak' -NewName 'LEIAME.txt'
    Get-ChildItem -Path projeto -Filter '*.txt' |
        ForEach-Object { "   criado: $($_.Name)" | Write-Output }

    Write-Output ''
    Write-Output '4) -WhatIf: SIMULA a remoção sem apagar nada (a rede de segurança):'
    Remove-Item -Path 'projeto' -Recurse -WhatIf 2>&1 |
        Select-Object -First 2 |
        ForEach-Object { "   [simulação] $_" | Write-Output }
    Write-Output "   (a pasta 'projeto' ainda existe? $([bool](Test-Path projeto)))"

    Write-Output ''
    Write-Output '5) Agora removendo de verdade (estamos no lab):'
    Remove-Item -Path 'projeto' -Recurse -Force
    Write-Output "   existe depois do Remove-Item? $([bool](Test-Path projeto))"

    Pop-Location
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}
