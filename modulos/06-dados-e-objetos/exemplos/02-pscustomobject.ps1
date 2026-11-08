<#
============================================================================
  Curso de PowerShell · Módulo 06 · Exemplo 02 — PSCustomObject
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Construir objetos estruturados e relatórios tabulares com
            [PSCustomObject] — a base de todo relatório moderno.
  EXECUTE   pwsh ./02-pscustomobject.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Um objeto com propriedades nomeadas:'
$usuario = [pscustomobject]@{
    Nome  = 'Daniel'
    Papel = 'admin'
    Ativo = $true
}
"   $($usuario.Nome) é $($usuario.Papel) (ativo=$($usuario.Ativo))" | Write-Output

Write-Output ''
Write-Output '2) Uma COLEÇÃO de PSCustomObject é uma "tabela" para o pipeline:'
$servicos = @(
    [pscustomobject]@{ Servico = 'web';   CPU = 12; Status = 'ok' }
    [pscustomobject]@{ Servico = 'db';    CPU = 88; Status = 'ok' }
    [pscustomobject]@{ Servico = 'cache'; CPU = 3;  Status = 'parado' }
)

Write-Output '   filtrando os que estão parados:'
$servicos | Where-Object Status -eq 'parado' |
    ForEach-Object { "      $($_.Servico)" | Write-Output }

Write-Output '   ordenando por CPU (decrescente) e mostrando os 2 maiores:'
$servicos | Sort-Object CPU -Descending | Select-Object -First 2 |
    ForEach-Object { "      $($_.Servico): CPU $($_.CPU)" | Write-Output }

Write-Output ''
Write-Output '3) Gerando um objeto a partir de cálculo (relatório):'
$relatorio = $servicos | ForEach-Object {
    [pscustomobject]@{
        Servico = $_.Servico
        CPU     = $_.CPU
        Alerta  = if ($_.CPU -gt 80) { 'ALTA' } else { 'ok' }
    }
}
$relatorio | ForEach-Object { "   {0,-6} CPU {1,3}  [{2}]" -f $_.Servico, $_.CPU, $_.Alerta | Write-Output }

Write-Output ''
Write-Output 'É assim que toda ferramenta PowerShell devolve dados: objetos, não texto.'
