<#
============================================================================
  Curso de PowerShell · Módulo 03 · Exemplo 02 — Streams de saída
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Entender, na prática, a "regra do Write-Host": Write-Output é DADO
            (vai pelo pipeline); Write-Host é mensagem para o humano.
  EXECUTE   pwsh ./02-streams-de-saida.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Uma função retorna o que EMITE. Write-Output é o dado:'
function Get-Dobro {
    param([int]$N)
    Write-Verbose "calculando o dobro de $N"   # só aparece com -Verbose; não é dado
    Write-Output ($N * 2)                        # ISTO é o que a função retorna
}
$resultado = Get-Dobro -N 21
"   `$resultado capturou: $resultado  (tipo $($resultado.GetType().Name))" | Write-Output

Write-Output ''
Write-Output '2) O PERIGO: Write-Host NÃO é um dado capturável do jeito normal.'
function Get-DobroErrado {
    param([int]$N)
    Write-Host "Resultado: $($N * 2)"   # ❌ "retorna" via Write-Host
}
$capturado = Get-DobroErrado -N 21 2>$null      # tenta capturar pelo caminho normal
"   `$capturado (do Write-Host) é: [$capturado]  <- vazio! o valor foi para a tela, não para a variável" | Write-Output

Write-Output ''
Write-Output '3) Cada stream tem um propósito:'
Write-Output   '   Write-Output  -> DADOS (pipeline)'
Write-Warning  'Write-Warning -> avisos (stream 3)'
Write-Verbose  'Write-Verbose -> detalhes (só com -Verbose)'
Write-Output ''
Write-Output 'Regra: Write-Output (ou só emitir o objeto) para DADOS; Write-Host'
Write-Output 'apenas para falar com o usuário no console (menu, cores, progresso).'
