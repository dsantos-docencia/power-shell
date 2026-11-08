<#
============================================================================
  Curso de PowerShell · Módulo 06 · Exemplo 01 — Coleções
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Arrays, a armadilha do += (O(n²)) vs List[T], e hashtables.
  EXECUTE   pwsh ./01-colecoes.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Arrays — acesso por índice:'
$arr = @('a', 'b', 'c', 'd')
"   arr[0]=$($arr[0])  arr[-1]=$($arr[-1])  fatia[1..2]=$($arr[1..2] -join ',')  total=$($arr.Count)" | Write-Output

Write-Output ''
Write-Output '2) A ARMADILHA do += : array tem tamanho fixo, += COPIA tudo a cada vez.'
$n = 20000
$t1 = Measure-Command {
    $lento = @()
    foreach ($i in 1..$n) { $lento += $i }    # cria um array novo a cada iteração
}
$t2 = Measure-Command {
    $lista = [System.Collections.Generic.List[int]]::new()
    foreach ($i in 1..$n) { $lista.Add($i) }  # adiciona no lugar
}
"   com += (array)   : $([math]::Round($t1.TotalMilliseconds)) ms" | Write-Output
"   com List[int]    : $([math]::Round($t2.TotalMilliseconds)) ms" | Write-Output
Write-Output '   → para acumular em laços, use List[T] (ou colete pelo pipeline).'

Write-Output ''
Write-Output '3) Coletar pelo PIPELINE é idiomático e rápido:'
$quadrados = 1..5 | ForEach-Object { $_ * $_ }
"   quadrados de 1..5: $($quadrados -join ', ')" | Write-Output

Write-Output ''
Write-Output '4) Hashtables (dicionário) — lookup instantâneo pela chave:'
$estoque = @{ teclado = 12; mouse = 30; monitor = 5 }
$estoque['webcam'] = 8                 # adicionar é barato (diferente do array)
"   mouse = $($estoque['mouse'])  | tem 'webcam'? $($estoque.ContainsKey('webcam'))" | Write-Output

Write-Output ''
Write-Output '5) Hashtable para CONTAR (histograma):'
$contagem = @{}
foreach ($p in 'sol', 'mar', 'sol', 'praia', 'mar', 'sol') {
    if ($contagem.ContainsKey($p)) { $contagem[$p]++ } else { $contagem[$p] = 1 }
}
$contagem.GetEnumerator() | Sort-Object Name | ForEach-Object { "   $($_.Key): $($_.Value)" | Write-Output }
