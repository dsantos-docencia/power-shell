<#
============================================================================
  Curso de PowerShell · Módulo 05 · Exemplo 02 — Função que aceita pipeline
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Fazer uma função se comportar como um cmdlet nativo: aceitar objetos
            pelo pipeline com ValueFromPipeline + begin/process/end.
  EXECUTE   pwsh ./02-pipeline-input.ps1
============================================================================
#>
Set-StrictMode -Version Latest

function Get-Estatistica {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [double]$Numero
    )
    begin {
        # roda UMA vez, antes de tudo: inicializa os acumuladores.
        $soma = 0.0; $qtd = 0; $maior = [double]::MinValue
    }
    process {
        # roda PARA CADA item que chega pelo pipeline.
        $soma += $Numero
        $qtd++
        if ($Numero -gt $maior) { $maior = $Numero }
    }
    end {
        # roda UMA vez, no fim: emite o resultado como um OBJETO.
        [pscustomobject]@{
            Quantidade = $qtd
            Soma       = $soma
            Media      = if ($qtd) { [math]::Round($soma / $qtd, 2) } else { 0 }
            Maior      = $maior
        }
    }
}

Write-Output '1) Passando números pelo pipeline (como um cmdlet de verdade):'
$r = 10, 20, 30, 5 | Get-Estatistica
"   quantidade=$($r.Quantidade)  soma=$($r.Soma)  média=$($r.Media)  maior=$($r.Maior)" | Write-Output

Write-Output ''
Write-Output '2) O retorno é um OBJETO, então encadeia com o pipeline:'
$media = (1..100 | Get-Estatistica).Media
"   média de 1..100 = $media" | Write-Output

Write-Output ''
Write-Output '3) Sem o bloco process, só o ÚLTIMO item seria processado.'
Write-Output '   Com process, TODOS os itens do pipeline são tratados — a diferença'
Write-Output '   entre uma função amadora e uma que se comporta como cmdlet nativo.'
