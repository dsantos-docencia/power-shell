function Teste-Comum  { Invoke-Alvo -Versao "1.4.7";  Afirmar-Igual "1.5.0" $global:SAIDA }
function Teste-Zero   { Invoke-Alvo -Versao "2.0.0";  Afirmar-Igual "2.1.0" $global:SAIDA }
function Teste-Grande { Invoke-Alvo -Versao "0.9.3";  Afirmar-Igual "0.10.0" $global:SAIDA }
