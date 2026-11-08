function Teste-Ordena  { Invoke-Alvo -Lista "Get-B,Set-A,Get-A"; Afirmar-Igual "Get-A, Get-B, Set-A" $global:SAIDA }
function Teste-Espacos { Invoke-Alvo -Lista "Z-Fim, A-Ini"; Afirmar-Igual "A-Ini, Z-Fim" $global:SAIDA }
function Teste-Um      { Invoke-Alvo -Lista "Unica"; Afirmar-Igual "Unica" $global:SAIDA }
