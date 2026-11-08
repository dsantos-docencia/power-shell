function Teste-ParaF { Invoke-Alvo -Valor 100 -Para F; Afirmar-Igual "212" $global:SAIDA }
function Teste-ParaC { Invoke-Alvo -Valor 32  -Para C; Afirmar-Igual "0" $global:SAIDA }
