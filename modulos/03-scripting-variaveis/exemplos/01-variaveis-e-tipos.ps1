<#
============================================================================
  Curso de PowerShell · Módulo 03 · Exemplo 01 — Variáveis e tipos
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver a tipagem dinâmica, a tipagem forte e os tipos .NET por baixo.
  EXECUTE   pwsh ./01-variaveis-e-tipos.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Tipagem dinâmica: a variável assume o tipo do valor.'
$nome = "Daniel"; $idade = 38; $pi = 3.14; $ativo = $true
"   `$nome  = $nome  -> $($nome.GetType().Name)"   | Write-Output
"   `$idade = $idade -> $($idade.GetType().Name)"  | Write-Output
"   `$pi    = $pi    -> $($pi.GetType().Name)"      | Write-Output
"   `$ativo = $ativo -> $($ativo.GetType().Name)"   | Write-Output

Write-Output ''
Write-Output '2) Tipagem FORTE: [int], [datetime] validam e convertem a entrada.'
[datetime]$nascimento = "1986-05-20"   # texto vira um objeto DateTime de verdade
"   nascimento.Year     = $($nascimento.Year)"          | Write-Output
"   nascimento.DayOfWeek= $($nascimento.DayOfWeek)"      | Write-Output

Write-Output ''
Write-Output '3) Como é um OBJETO, tem métodos (lembra do Get-Member?):'
"   em maiúsculas: $($nome.ToUpper())"                   | Write-Output
"   daqui a 1000 dias: $((Get-Date).AddDays(1000).ToString('yyyy-MM-dd'))" | Write-Output

Write-Output ''
Write-Output '4) Coleções: array @() e hashtable @{}:'
$lista = @('a', 'b', 'c')
$mapa  = @{ Nome = 'Ana'; Idade = 30 }
"   lista[1]      = $($lista[1])  | total: $($lista.Count)"   | Write-Output
"   mapa['Nome']  = $($mapa['Nome'])  | mapa.Idade: $($mapa.Idade)" | Write-Output

Write-Output ''
Write-Output '5) A tipagem forte PROTEGE: atribuir texto a um [int] falha de forma clara.'
try {
    [int]$numero = "abc"
    "   (não deveria chegar aqui)" | Write-Output
}
catch {
    "   ✔ [int]`$numero = 'abc' foi rejeitado (conversão inválida)" | Write-Output
}
