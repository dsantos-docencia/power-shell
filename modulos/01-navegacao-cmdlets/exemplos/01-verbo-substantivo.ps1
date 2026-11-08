<#
============================================================================
  Curso de PowerShell · Módulo 01 · Exemplo 01 — Verbo-Substantivo
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver como a convenção Verbo-Substantivo deixa você DEDUZIR cmdlets.
  EXECUTE   pwsh ./01-verbo-substantivo.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Get-Verb lista os verbos APROVADOS (uma amostra dos "Common"):'
Get-Verb |
    Where-Object Group -eq 'Common' |
    Select-Object -ExpandProperty Verb -First 8 |
    Sort-Object |
    ForEach-Object { "   $_" | Write-Output }

Write-Output ''
Write-Output '2) Conhecendo o substantivo, você DEDUZ as operações. Para "Item":'
Get-Command -Noun Item |
    Select-Object -ExpandProperty Name |
    Sort-Object |
    ForEach-Object { "   $_" | Write-Output }

Write-Output ''
Write-Output '3) O mesmo para "Content" (ler, definir, acrescentar, limpar):'
'   ' + ((Get-Command -Noun Content | Select-Object -ExpandProperty Name | Sort-Object) -join ', ') | Write-Output

Write-Output ''
Write-Output 'Moral: você não decora 10.000 cmdlets. Aprende a CONVENÇÃO e deduz.'
Write-Output 'Precisa confirmar? Get-Command <palpite> -ErrorAction SilentlyContinue.'
