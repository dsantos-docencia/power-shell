<#
============================================================================
  Curso de PowerShell · Módulo 07 · Exemplo 02 — Terminante vs não-terminante
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver, ao vivo, por que um try/catch às vezes NÃO pega o erro, e
            como -ErrorAction Stop resolve.
  EXECUTE   pwsh ./02-terminante-vs-nao.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) A PEGADINHA: erro NÃO-terminante NÃO cai no catch.'
$pego = $false
try {
    # 2>$null só esconde a mensagem vermelha na tela; o comportamento é o mesmo:
    # o erro é não-terminante, então a execução NÃO desvia para o catch.
    Get-Item 'arquivo_que_nao_existe_xyz' 2>$null | Out-Null
    Write-Output '   (o comando falhou, mas a execução CONTINUOU aqui)'
}
catch {
    $pego = $true
}
"   o catch pegou o erro? $pego   <- FALSE! era não-terminante" | Write-Output

Write-Output ''
Write-Output '2) A SOLUÇÃO: -ErrorAction Stop torna o erro terminante -> cai no catch.'
$pego = $false
try {
    Get-Item 'arquivo_que_nao_existe_xyz' -ErrorAction Stop | Out-Null
}
catch {
    $pego = $true
    "   ✔ agora o catch pegou: $($_.Exception.GetType().Name)" | Write-Output
}
"   o catch pegou? $pego" | Write-Output

Write-Output ''
Write-Output '3) O MESMO efeito globalmente com $ErrorActionPreference = Stop:'
$ErrorActionPreference = 'Stop'
$pego = $false
try { Get-Item 'outro_inexistente_zzz' | Out-Null }
catch { $pego = $true }
"   com a preferência global Stop, o catch pegou? $pego" | Write-Output
$ErrorActionPreference = 'Continue'

Write-Output ''
Write-Output 'Regra: para tratar erros de cmdlets com try/catch, torne-os terminantes'
Write-Output '(-ErrorAction Stop no comando, ou \$ErrorActionPreference = Stop no topo).'
