<#
============================================================================
  Curso de PowerShell · Módulo 03 · Exemplo 03 — Operadores de comparação
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Praticar -eq/-like/-match, case-sensitivity e as armadilhas de
            arrays e de $null.
  EXECUTE   pwsh ./03-operadores.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Comparações básicas (lembre: -eq, não ==):'
"   10 -gt 5      -> $(10 -gt 5)"          | Write-Output
"   'a' -lt 'b'   -> $('a' -lt 'b')"        | Write-Output

Write-Output ''
Write-Output '2) -like usa curingas; -match usa regex:'
"   'Daniel' -like 'Dan*'        -> $('Daniel' -like 'Dan*')"             | Write-Output
"   '01234-567' -match '^\d{5}-\d{3}$' -> $('01234-567' -match '^\d{5}-\d{3}$')" | Write-Output

Write-Output ''
Write-Output '3) ARMADILHA 1: comparações são case-insensitive por padrão.'
"   'ABC' -eq 'abc'   -> $('ABC' -eq 'abc')   (igual!)"      | Write-Output
"   'ABC' -ceq 'abc'  -> $('ABC' -ceq 'abc')  (-c = case-sensitive)" | Write-Output

Write-Output ''
Write-Output '4) ARMADILHA 2: -eq com ARRAY filtra, não dá true/false.'
$numeros = @(1, 2, 3, 2, 1)
$iguais = $numeros -eq 2
"   @(1,2,3,2,1) -eq 2  -> [$($iguais -join ', ')]  (os ELEMENTOS iguais a 2)" | Write-Output
"   para testar pertencimento use -contains: (@(1,2,3) -contains 2) = $(@(1,2,3) -contains 2)" | Write-Output

Write-Output ''
Write-Output '5) ARMADILHA 3: compare com $null pondo o $null à ESQUERDA.'
$talvez = @()        # um array vazio
"   (`$null -eq `$talvez) = $($null -eq $talvez)   <- forma correta e previsível" | Write-Output
Write-Output '   (o contrário, $talvez -eq $null, se comporta mal quando $talvez é array)'
