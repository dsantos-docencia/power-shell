function Teste-Numero { Invoke-Alvo -Texto 21;  Afirmar-Igual "42" $global:SAIDA; Afirmar-Status 0 }
function Teste-Texto  { Invoke-Alvo -Texto abc; Afirmar-Igual "nao-e-numero" $global:SAIDA; Afirmar-Status 1 }
