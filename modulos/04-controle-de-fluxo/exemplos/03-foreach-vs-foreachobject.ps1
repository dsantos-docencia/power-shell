<#
============================================================================
  Curso de PowerShell · Módulo 04 · Exemplo 03 — foreach vs ForEach-Object
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver a diferença entre a INSTRUÇÃO foreach (coleção na memória) e o
            CMDLET ForEach-Object (pipeline/streaming), e medir com Measure-Command.
  EXECUTE   pwsh ./03-foreach-vs-foreachobject.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Mesma tarefa, duas formas:'
$numeros = 1..5

Write-Output '   instrução foreach (a variável é a que você nomeia, $n):'
$a = foreach ($n in $numeros) { $n * $n }
"      quadrados: $($a -join ', ')" | Write-Output

Write-Output '   cmdlet ForEach-Object (a variável é $_):'
$b = $numeros | ForEach-Object { $_ * $_ }
"      quadrados: $($b -join ', ')" | Write-Output

Write-Output ''
Write-Output '2) ForEach-Object tem blocos -Begin / -Process / -End (útil em pipeline):'
$numeros | ForEach-Object -Begin { $soma = 0 } -Process { $soma += $_ } -End { "      soma total: $soma" | Write-Output }

Write-Output ''
Write-Output '3) Medindo a diferença com Measure-Command (dados JÁ na memória):'
$grande = 1..50000
$t1 = Measure-Command { $x = foreach ($n in $grande) { $n * 2 } }
$t2 = Measure-Command { $y = $grande | ForEach-Object { $_ * 2 } }
"      instrução foreach : $([math]::Round($t1.TotalMilliseconds)) ms" | Write-Output
"      ForEach-Object     : $([math]::Round($t2.TotalMilliseconds)) ms" | Write-Output
Write-Output '   Para dados já na memória, a instrução foreach costuma vencer.'
Write-Output '   Mas em pipeline/streaming (volume grande e contínuo), ForEach-Object'
Write-Output '   processa um a um sem carregar tudo na memória. Escolha pela situação.'
