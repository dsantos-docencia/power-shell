<#
============================================================================
  Curso de PowerShell · Módulo 02 · Exemplo 03 — Agrupar, medir e exportar
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Group-Object e Measure-Object para relatórios, e exportar para
            JSON/CSV — tudo trivial porque os dados são OBJETOS.
  EXECUTE   pwsh ./03-agrupar-e-exportar.ps1
  SEGURO    Opera numa pasta temporária.
============================================================================
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    # Um "conjunto de dados" de vendas, como objetos (PSCustomObject, Módulo 06).
    $vendas = @(
        [pscustomobject]@{ Vendedor = 'Ana';  Produto = 'Notebook'; Valor = 3500 }
        [pscustomobject]@{ Vendedor = 'Bia';  Produto = 'Mouse';    Valor = 80 }
        [pscustomobject]@{ Vendedor = 'Ana';  Produto = 'Teclado';  Valor = 250 }
        [pscustomobject]@{ Vendedor = 'Caio'; Produto = 'Notebook'; Valor = 3500 }
        [pscustomobject]@{ Vendedor = 'Ana';  Produto = 'Mouse';    Valor = 80 }
    )

    Write-Output '1) Group-Object: agrupar as vendas por vendedor:'
    $vendas | Group-Object Vendedor |
        ForEach-Object { "   {0,-6} {1} venda(s)" -f $_.Name, $_.Count | Write-Output }

    Write-Output ''
    Write-Output '2) Measure-Object: estatística do valor (soma, média, máximo):'
    $m = $vendas | Measure-Object Valor -Sum -Average -Maximum
    "   total:  R$ $($m.Sum)"  | Write-Output
    "   médio:  R$ $([math]::Round($m.Average, 2))" | Write-Output
    "   maior:  R$ $($m.Maximum)" | Write-Output

    Write-Output ''
    Write-Output '3) Relatório: total por vendedor (agrupar + somar):'
    $vendas | Group-Object Vendedor | ForEach-Object {
        $soma = ($_.Group | Measure-Object Valor -Sum).Sum
        "   {0,-6} R$ {1}" -f $_.Name, $soma | Write-Output
    }

    Write-Output ''
    Write-Output '4) Exportar — porque são objetos, converter é trivial:'
    $csv = Join-Path $lab 'vendas.csv'
    $vendas | Export-Csv -Path $csv -NoTypeInformation
    "   CSV salvo com $((Import-Csv $csv).Count) linhas" | Write-Output
    Write-Output '   JSON (primeiras linhas):'
    ($vendas | Select-Object -First 1 | ConvertTo-Json) -split "`n" |
        Select-Object -First 4 | ForEach-Object { "   $_" | Write-Output }
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}
