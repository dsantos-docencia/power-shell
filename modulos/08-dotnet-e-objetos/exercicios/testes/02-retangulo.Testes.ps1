function Teste-Area { Invoke-Alvo -L 4 -H 5; Afirmar-Igual "20" $global:SAIDA }
function Teste-Area2 { Invoke-Alvo -L 2.5 -H 4; Afirmar-Igual "10" $global:SAIDA }
