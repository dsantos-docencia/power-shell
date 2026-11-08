function Teste-Tres { Invoke-Alvo -N 3; Afirmar-Igual "14" $global:SAIDA }
function Teste-Um   { Invoke-Alvo -N 1; Afirmar-Igual "1" $global:SAIDA }
