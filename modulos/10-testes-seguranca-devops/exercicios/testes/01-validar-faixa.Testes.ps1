function Teste-Valido     { Invoke-Alvo -N 5;   Afirmar-Igual "10" $global:SAIDA }
function Teste-Limite     { Invoke-Alvo -N 100; Afirmar-Igual "200" $global:SAIDA }
function Teste-Invalido   { Invoke-Alvo -N 999; Afirmar-StatusDiferenteDeZero }
