function Teste-Ok       { Invoke-Alvo -Idade 30;  Afirmar-Igual "ok" $global:SAIDA; Afirmar-Status 0 }
function Teste-Negativa { Invoke-Alvo -Idade -5;  Afirmar-Igual "invalida" $global:SAIDA; Afirmar-Status 1 }
function Teste-Alta     { Invoke-Alvo -Idade 200; Afirmar-Igual "invalida" $global:SAIDA; Afirmar-Status 1 }
