<#
============================================================================
  Curso de PowerShell · Módulo 07 · Exemplo 03 — Erro estruturado e log
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Inspecionar o objeto de erro (ErrorRecord) e registrar um log
            estruturado — o que um script de produção faz.
  EXECUTE   pwsh ./03-erro-estruturado.ps1
  SEGURO    Escreve o log só numa pasta temporária.
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) O objeto de erro ($_) é rico — dá para inspecioná-lo com Get-Member:'
try {
    throw 'algo deu errado no passo 3'
}
catch {
    "   .Exception.Message     = $($_.Exception.Message)"           | Write-Output
    "   .Exception tipo        = $($_.Exception.GetType().Name)"    | Write-Output
    "   .InvocationInfo.Line   = $($_.InvocationInfo.ScriptLineNumber)" | Write-Output
}

Write-Output ''
Write-Output '2) Registrando um log de erro estruturado (como objeto, exportável):'
$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    $log = [System.Collections.Generic.List[object]]::new()
    foreach ($arquivo in 'ok1.txt', 'FALHA', 'ok2.txt') {
        try {
            if ($arquivo -eq 'FALHA') { throw "não consegui processar $arquivo" }
            $log.Add([pscustomobject]@{ Hora = (Get-Date -Format 'HH:mm:ss'); Item = $arquivo; Nivel = 'INFO'; Mensagem = 'processado' })
        }
        catch {
            $log.Add([pscustomobject]@{ Hora = (Get-Date -Format 'HH:mm:ss'); Item = $arquivo; Nivel = 'ERRO'; Mensagem = $_.Exception.Message })
        }
    }
    Write-Output '   log coletado:'
    $log | ForEach-Object { "      [$($_.Nivel)] $($_.Item): $($_.Mensagem)" | Write-Output }

    $csv = Join-Path $lab 'erros.csv'
    $log | Export-Csv -Path $csv -NoTypeInformation
    "   log salvo em CSV com $((Import-Csv $csv).Count) entradas (1 é ERRO)" | Write-Output
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}

Write-Output ''
Write-Output '3) $Error guarda o histórico da sessão; $? diz se o último comando deu certo:'
"   $('x' -eq 'x'); logo `$? = $?" | Write-Output
