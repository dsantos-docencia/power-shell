#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 09.02 — $using:N leva o valor para dentro do job.
# $N é usado via $using:N dentro do Start-Job; o analisador não rastreia isso.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'N', Justification = 'usado via $using:N')]
param([int]$N)
$job = Start-Job -ScriptBlock { $using:N * 10 }
Wait-Job $job | Out-Null
Write-Output (Receive-Job $job)
Remove-Job $job
