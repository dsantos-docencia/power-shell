<#
============================================================================
  Curso de PowerShell · Módulo 09 · Exemplo 02 — ForEach-Object -Parallel
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Paralelizar com -Parallel/-ThrottleLimit, usar $using: e medir o ganho.
  EXECUTE   pwsh ./02-paralelo.ps1
  NOTA      Requer PowerShell 7+ (o -Parallel não existe no 5.1).
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Sequencial vs paralelo (cada item "demora" 300ms):'
$ini = [datetime]::Now
1..4 | ForEach-Object { Start-Sleep -Milliseconds 300 }
$seq = [int]([datetime]::Now - $ini).TotalMilliseconds
"   sequencial (4 x 300ms): ${seq}ms" | Write-Output

$ini = [datetime]::Now
1..4 | ForEach-Object -Parallel { Start-Sleep -Milliseconds 300 } -ThrottleLimit 4
$par = [int]([datetime]::Now - $ini).TotalMilliseconds
"   paralelo (4 ao mesmo tempo): ${par}ms  <- perto de 300ms, não 1200ms" | Write-Output

Write-Output ''
Write-Output '2) $using: leva uma variável externa para dentro do bloco paralelo:'
$prefixo = 'srv-'
$nomes = 1..3 | ForEach-Object -Parallel { "$using:prefixo$_" } | Sort-Object
"   gerados em paralelo: $($nomes -join ', ')" | Write-Output

Write-Output ''
Write-Output '3) -ThrottleLimit controla quantos rodam ao mesmo tempo:'
Write-Output '   (ex.: 100 URLs com -ThrottleLimit 10 = no máx 10 downloads simultâneos,'
Write-Output '    evitando sobrecarregar a rede ou o servidor remoto).'

Write-Output ''
Write-Output 'Regra: paralelismo compensa quando cada item ESPERA (I/O, rede).'
Write-Output 'Para contas triviais, o custo de criar runspaces pode não valer a pena.'
