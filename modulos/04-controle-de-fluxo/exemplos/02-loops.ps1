<#
============================================================================
  Curso de PowerShell · Módulo 04 · Exemplo 02 — Laços
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  for, foreach, while, do-until, break/continue e o operador 1..N.
  EXECUTE   pwsh ./02-loops.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) for (contador clássico):'
$saida = for ($i = 1; $i -le 3; $i++) { "i=$i" }
"   $($saida -join '  ')" | Write-Output

Write-Output ''
Write-Output '2) foreach (instrução) sobre uma lista e o operador de intervalo 1..5:'
$dobros = foreach ($n in 1..5) { $n * 2 }
"   dobros de 1..5: $($dobros -join ', ')" | Write-Output

Write-Output ''
Write-Output '3) while e do-until:'
$i = 0
while ($i -lt 3) { $i++ }
"   while parou em: $i" | Write-Output
$j = 0
do { $j++ } until ($j -ge 5)
"   do-until parou em: $j" | Write-Output

Write-Output ''
Write-Output '4) break e continue (ímpares de 1 a 10, parando após o 7):'
$resultado = foreach ($n in 1..10) {
    if ($n % 2 -eq 0) { continue }   # pula pares
    if ($n -gt 7) { break }          # para depois do 7
    $n
}
"   $($resultado -join ', ')" | Write-Output

Write-Output ''
Write-Output '5) Contagem regressiva com 5..1:'
"   $((5..1) -join ' ... ')" | Write-Output
