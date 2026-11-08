function Teste-Valido   { Invoke-Alvo -Cep "01234-567"; Afirmar-Igual "valido" $global:SAIDA; Afirmar-Status 0 }
function Teste-Invalido { Invoke-Alvo -Cep "12345678";  Afirmar-Igual "invalido" $global:SAIDA; Afirmar-Status 1 }
