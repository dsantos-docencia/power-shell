<#
============================================================================
  Curso de PowerShell · Módulo 09 · Exemplo 01 — Jobs em segundo plano
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Start-Job / Wait-Job / Receive-Job e o ThreadJob (mais leve).
  EXECUTE   pwsh ./01-jobs.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Start-Job roda em segundo plano e libera o console:'
$job = Start-Job -ScriptBlock { Start-Sleep -Milliseconds 300; "resultado do job" }
"   estado logo após iniciar: $($job.State)" | Write-Output
Wait-Job $job | Out-Null
"   resultado (Receive-Job): $(Receive-Job $job)" | Write-Output
Remove-Job $job

Write-Output ''
Write-Output '2) Vários jobs em paralelo e esperando todos:'
$jobs = foreach ($n in 1..3) {
    # $using:n leva o valor atual de $n para dentro do job (o idioma moderno).
    Start-Job -ScriptBlock { Start-Sleep -Milliseconds 300; "job $using:n ok" }
}
Wait-Job $jobs | Out-Null
$resultados = $jobs | Receive-Job | Sort-Object
$jobs | Remove-Job
"   resultados: $($resultados -join ' | ')" | Write-Output
Write-Output '   os 3 jobs rodaram concorrentemente (cada um num processo). O startup'
Write-Output '   de processos tem custo; o ganho de paralelismo fica nítido no exemplo 02'
Write-Output '   (ForEach-Object -Parallel) e com Start-ThreadJob para muitas tarefas.'

Write-Output ''
Write-Output '3) Start-ThreadJob: mais leve (thread, não processo) — ideal para muitos.'
if (Get-Command Start-ThreadJob -ErrorAction SilentlyContinue) {
    $tj = Start-ThreadJob -ScriptBlock { 2 + 2 }
    Wait-Job $tj | Out-Null
    "   ThreadJob retornou: $(Receive-Job $tj)" | Write-Output
    Remove-Job $tj
} else {
    Write-Output '   (módulo ThreadJob não disponível nesta instalação)'
}

Write-Output ''
Write-Output 'Jobs liberam o console e paralelizam. ThreadJob escala melhor para dezenas.'
