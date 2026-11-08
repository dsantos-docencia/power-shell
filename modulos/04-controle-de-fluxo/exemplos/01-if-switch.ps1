<#
============================================================================
  Curso de PowerShell · Módulo 04 · Exemplo 01 — if e switch
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  if/elseif, operador ternário e o switch turbinado (-Wildcard/-Regex).
  EXECUTE   pwsh ./01-if-switch.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) if / elseif / else:'
foreach ($idade in 20, 15, 8) {
    $faixa = if ($idade -ge 18) { 'adulto' } elseif ($idade -ge 12) { 'adolescente' } else { 'criança' }
    "   idade $idade -> $faixa" | Write-Output
}

Write-Output ''
Write-Output '2) Operador ternário (PowerShell 7+):'
$n = 7
"   $n é $($n % 2 -eq 0 ? 'par' : 'ímpar')" | Write-Output

Write-Output ''
Write-Output '3) switch -Wildcard (classifica por extensão):'
function Get-Tipo($arquivo) {
    switch -Wildcard ($arquivo) {
        '*.jpg' { 'imagem'; break }
        '*.png' { 'imagem'; break }
        '*.log' { 'registro'; break }
        '*.ps1' { 'script'; break }
        default { 'desconhecido' }
    }
}
foreach ($f in 'foto.jpg', 'app.ps1', 'dados.xyz') {
    "   $f -> $(Get-Tipo $f)" | Write-Output
}

Write-Output ''
Write-Output '4) switch SEM break testa TODOS os padrões (pode casar vários):'
Write-Output '   classificando "abc123":'
switch -Regex ('abc123') {
    '[a-z]' { '   - tem letra minúscula' | Write-Output }
    '\d'    { '   - tem dígito' | Write-Output }
    '[A-Z]' { '   - tem maiúscula' | Write-Output }
}
Write-Output '   (casou dois padrões, porque não há break automático)'
