function Teste-Simples { Invoke-Alvo -Versao "1.2.3";   Afirmar-Igual "1.2.4" $global:SAIDA }
function Teste-Nove    { Invoke-Alvo -Versao "0.0.9";   Afirmar-Igual "0.0.10" $global:SAIDA }
function Teste-Grande  { Invoke-Alvo -Versao "10.4.99"; Afirmar-Igual "10.4.100" $global:SAIDA }
