function Teste-Ate5 {
    Invoke-Alvo -N 5
    Afirmar-Igual "1`n2`nFizz`n4`nBuzz" $global:SAIDA
}
function Teste-FizzBuzzNo15 {
    Invoke-Alvo -N 15
    Afirmar-Contem "FizzBuzz" $global:SAIDA
}
