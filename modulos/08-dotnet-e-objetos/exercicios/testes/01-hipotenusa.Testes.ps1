function Teste-345 { Invoke-Alvo -A 3 -B 4; Afirmar-Igual "5" $global:SAIDA }
function Teste-Outro { Invoke-Alvo -A 5 -B 12; Afirmar-Igual "13" $global:SAIDA }
