function Teste-Maior   { Invoke-Alvo -Nome Ana -Idade 20; Afirmar-Igual "True" $global:SAIDA }
function Teste-Menor   { Invoke-Alvo -Nome Bia -Idade 15; Afirmar-Igual "False" $global:SAIDA }
