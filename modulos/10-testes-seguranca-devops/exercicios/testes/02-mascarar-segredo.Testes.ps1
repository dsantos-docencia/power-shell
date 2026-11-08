function Teste-Longo  { Invoke-Alvo -Texto "token12345"; Afirmar-Igual "******2345" $global:SAIDA }
function Teste-Curto  { Invoke-Alvo -Texto "abc";        Afirmar-Igual "abc" $global:SAIDA }
function Teste-Exato  { Invoke-Alvo -Texto "wxyz";       Afirmar-Igual "wxyz" $global:SAIDA }
