<#
============================================================================
  Curso de PowerShell · Módulo 06 · Exemplo 03 — Strings, JSON e CSV
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Operadores de string (-split/-join/-replace/-f) e conversão
            de/para JSON e CSV — trivial porque tudo são objetos.
  EXECUTE   pwsh ./03-strings-e-formatos.ps1
  SEGURO    Escreve CSV só numa pasta temporária.
============================================================================
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Output '1) Operadores de string:'
"   -split: $(('a,b,c' -split ',') -join ' | ')"            | Write-Output
"   -join:  $(@('x','y','z') -join '-')"                     | Write-Output
"   -replace (regex): $('abc123def' -replace '\d', '#')"     | Write-Output
"   -f (formato): $('{0} custa R$ {1,7:N2}' -f 'Café', 4.5)" | Write-Output

Write-Output ''
Write-Output '2) Métodos .NET da string (ela é um objeto):'
$t = '  Daniel Santos  '
"   .Trim()    = [$($t.Trim())]"                 | Write-Output
"   .ToUpper() = [$($t.Trim().ToUpper())]"        | Write-Output
"   .Substring(0,6) = [$($t.Trim().Substring(0,6))]" | Write-Output

Write-Output ''
Write-Output '3) JSON: objeto -> texto -> objeto de volta:'
$obj = [pscustomobject]@{ Nome = 'Ana'; Idade = 30; Tags = @('a', 'b') }
$json = $obj | ConvertTo-Json -Compress
"   ConvertTo-Json: $json" | Write-Output
$voltou = $json | ConvertFrom-Json
"   ConvertFrom-Json -> navegável: `$voltou.Nome = $($voltou.Nome)" | Write-Output

Write-Output ''
Write-Output '4) CSV: coleção de objetos <-> arquivo:'
$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    $pessoas = @(
        [pscustomobject]@{ Nome = 'Ana'; Cidade = 'SP' }
        [pscustomobject]@{ Nome = 'Bia'; Cidade = 'RJ' }
    )
    $csv = Join-Path $lab 'p.csv'
    $pessoas | Export-Csv -Path $csv -NoTypeInformation
    $lidos = Import-Csv -Path $csv
    "   exportei e reli: $($lidos.Count) pessoas; a 1ª é $($lidos[0].Nome)" | Write-Output
    "   e já saio filtrando: $(($lidos | Where-Object Cidade -eq 'RJ').Nome) mora no RJ" | Write-Output
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}
