function Teste-Inverte { Invoke-Alvo -Frase "o rato roeu"; Afirmar-Igual "roeu rato o" $global:SAIDA }
function Teste-Uma     { Invoke-Alvo -Frase "palavra";     Afirmar-Igual "palavra" $global:SAIDA }
