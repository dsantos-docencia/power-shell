function Teste-Divide { Invoke-Alvo -A 10 -B 2; Afirmar-Igual "5" $global:SAIDA; Afirmar-Status 0 }
function Teste-Zero   { Invoke-Alvo -A 10 -B 0; Afirmar-Contem "divisao por zero" $global:SAIDA; Afirmar-Status 1 }
