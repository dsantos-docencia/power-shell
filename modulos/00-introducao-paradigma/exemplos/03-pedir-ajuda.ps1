<#
============================================================================
  Curso de PowerShell · Módulo 00 · Exemplo 03 — Descobrir e inspecionar
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Usar Get-Command para DESCOBRIR cmdlets e Get-Member para
            INSPECIONAR objetos — as duas habilidades que substituem "decorar".
  EXECUTE   pwsh ./03-pedir-ajuda.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Get-Command descobre cmdlets pela convenção Verbo-Substantivo.'
Write-Output '   Todos os cmdlets com o substantivo "Item" (Get/Set/New/Remove/Copy...):'
Get-Command -Noun Item |
    Select-Object -ExpandProperty Name |
    Sort-Object |
    ForEach-Object { "   $_" | Write-Output }

Write-Output ''
Write-Output '2) Isso te deixa ADIVINHAR comandos: se existe Get-Process, deve existir...'
'   ' + ((Get-Command -Noun Process -Verb Get, Start, Stop -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Name | Sort-Object) -join ', ') | Write-Output

Write-Output ''
Write-Output '3) Get-Member é o SEGREDO: mostra as propriedades e métodos de um objeto.'
Write-Output '   O que um objeto "data/hora" (Get-Date) tem de propriedades?'
Get-Date | Get-Member -MemberType Property |
    Select-Object -ExpandProperty Name -First 8 |
    ForEach-Object { "   .$_" | Write-Output }

Write-Output ''
Write-Output '   ...e por isso podemos acessar qualquer uma delas diretamente:'
$agora = Get-Date
'   Ano: {0} | Mês: {1} | Dia da semana: {2}' -f $agora.Year, $agora.Month, $agora.DayOfWeek | Write-Output

Write-Output ''
Write-Output 'Resumo: Get-Command para DESCOBRIR, Get-Help para APRENDER,'
Write-Output 'Get-Member para INSPECIONAR. Com esses três, você nunca fica preso.'
